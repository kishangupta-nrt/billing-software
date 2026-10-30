import { spawn } from 'node:child_process';
import crypto from 'node:crypto';
import fs from 'node:fs';
import http from 'node:http';
import net from 'node:net';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const DATA_DIR = process.env.GST_DATA_DIR ? path.resolve(process.env.GST_DATA_DIR) : path.join(ROOT, 'data');
const PORT_FILE = path.join(DATA_DIR, 'port.txt');
const AUTH_FILE = path.join(DATA_DIR, 'tunnel-auth.json');
const URL_FILE = path.join(DATA_DIR, 'tunnel-url.txt');
const DEFAULT_APP_PORT = 47371;
const DEFAULT_PROXY_PORT = 47372;
const START_PORT_SCAN = 50;
const BASIC_REALM = 'Free GST Billing';

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const hash = (value) => crypto.createHash('sha256').update(String(value)).digest();
const equalSecret = (a, b) => crypto.timingSafeEqual(hash(a), hash(b));

function readAppPort() {
  try {
    const value = parseInt(fs.readFileSync(PORT_FILE, 'utf8').trim(), 10);
    return Number.isFinite(value) && value >= 1024 && value <= 65535 ? value : DEFAULT_APP_PORT;
  } catch {
    return DEFAULT_APP_PORT;
  }
}

function localGet(port, requestPath, headers = {}, timeout = 1500) {
  return new Promise((resolve) => {
    const req = http.get({
      host: '127.0.0.1',
      port,
      path: requestPath,
      headers: { host: `localhost:${port}`, ...headers },
      timeout,
    }, (res) => {
      res.resume();
      res.on('end', () => resolve(res.statusCode || 0));
    });
    req.on('timeout', () => req.destroy());
    req.on('error', () => resolve(0));
  });
}

async function appIsHealthy(port) {
  return (await localGet(port, '/api/health')) === 200;
}

async function waitForApp(port, child) {
  for (let i = 0; i < 120; i += 1) {
    if (child?.exitCode !== null && child?.exitCode !== undefined) return null;
    const current = readAppPort();
    if (await appIsHealthy(current)) return current;
    await sleep(500);
  }
  return null;
}

async function ensureApp() {
  const known = readAppPort();
  if (await appIsHealthy(known)) {
    console.log(`Using running app at http://localhost:${known}`);
    return { port: known, child: null };
  }

  console.log('Starting Express server...');
  const child = spawn(process.execPath, ['server.js'], {
    cwd: ROOT,
    env: { ...process.env, GST_DATA_DIR: DATA_DIR },
    stdio: ['ignore', 'inherit', 'inherit'],
  });
  const port = await waitForApp(known, child);
  if (!port) {
    child.kill();
    throw new Error('Express server did not become healthy. Run "npm start" and retry.');
  }
  console.log(`Express server ready at http://localhost:${port}`);
  return { port, child };
}

function existingCredentials() {
  try {
    const saved = JSON.parse(fs.readFileSync(AUTH_FILE, 'utf8'));
    if (saved.username && saved.password) return saved;
  } catch {
    // Generate a new credential below.
  }
  return null;
}

function ensureCredentials() {
  const username = process.env.TUNNEL_BASIC_USER || 'admin';
  const envPassword = process.env.TUNNEL_BASIC_PASS;
  const saved = existingCredentials();
  const password = envPassword || saved?.password || crypto.randomBytes(18).toString('base64url');
  const credentials = { username, password };

  if (!envPassword && (!saved || saved.username !== username)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
    fs.writeFileSync(AUTH_FILE, `${JSON.stringify(credentials, null, 2)}\n`, { mode: 0o600 });
  }
  return credentials;
}

function findCloudflared() {
  const candidates = [
    process.env.CLOUDFLARED_PATH,
    'C:\\Program Files (x86)\\cloudflared\\cloudflared.exe',
    'C:\\Program Files\\cloudflared\\cloudflared.exe',
    '/usr/local/bin/cloudflared',
    '/usr/bin/cloudflared',
  ].filter(Boolean);
  for (const candidate of candidates) {
    if (fs.existsSync(candidate)) return candidate;
  }
  return 'cloudflared';
}

function canListen(port) {
  return new Promise((resolve) => {
    const probe = net.createServer();
    probe.unref();
    probe.once('error', () => resolve(false));
    probe.listen(port, '127.0.0.1', () => {
      probe.close(() => resolve(true));
    });
  });
}

async function findProxyPort() {
  const start = Number(process.env.TUNNEL_PROXY_PORT) || DEFAULT_PROXY_PORT;
  for (let port = start; port < start + START_PORT_SCAN; port += 1) {
    if (await canListen(port)) return port;
  }
  throw new Error(`No free tunnel proxy port in ${start}-${start + START_PORT_SCAN - 1}`);
}

function startProxy(appPort, proxyPort, credentials) {
  const expected = `Basic ${Buffer.from(`${credentials.username}:${credentials.password}`).toString('base64')}`;
  const server = http.createServer((req, res) => {
    if (!req.headers.authorization || !equalSecret(req.headers.authorization, expected)) {
      res.writeHead(401, {
        'WWW-Authenticate': `Basic realm="${BASIC_REALM}", charset="UTF-8"`,
        'Content-Type': 'text/plain; charset=utf-8',
        'Cache-Control': 'no-store',
      });
      res.end('Authentication required\n');
      return;
    }

    const headers = { ...req.headers };
    delete headers.authorization;
    delete headers.origin;
    headers.host = `localhost:${appPort}`;
    headers['x-forwarded-host'] = req.headers.host || '';
    headers['x-forwarded-proto'] = 'https';
    headers['x-forwarded-for'] = req.socket.remoteAddress || '';

    const upstream = http.request({
      host: '127.0.0.1',
      port: appPort,
      method: req.method,
      path: req.url,
      headers,
    }, (upstreamRes) => {
      res.writeHead(upstreamRes.statusCode || 502, upstreamRes.headers);
      upstreamRes.pipe(res);
    });

    upstream.on('error', () => {
      if (!res.headersSent) {
        res.writeHead(502, { 'Content-Type': 'text/plain; charset=utf-8' });
      }
      res.end('Bad gateway\n');
    });
    req.on('aborted', () => upstream.destroy());
    req.pipe(upstream);
  });

  return new Promise((resolve, reject) => {
    server.once('error', reject);
    server.listen(proxyPort, '127.0.0.1', () => {
      server.removeListener('error', reject);
      resolve(server);
    });
  });
}

function stripAnsi(value) {
  return value.replace(/\x1B\[[0-?]*[ -/]*[@-~]/g, '');
}

function startTunnel(cloudflaredPath, proxyPort, credentials) {
  const child = spawn(cloudflaredPath, [
    'tunnel',
    '--no-autoupdate',
    '--url',
    `http://127.0.0.1:${proxyPort}`,
  ], { stdio: ['ignore', 'pipe', 'pipe'] });

  return new Promise((resolve, reject) => {
    let output = '';
    let settled = false;

    const onData = (chunk) => {
      const text = stripAnsi(chunk.toString());
      output = `${output}${text}`.slice(-8000);
      process.stdout.write(text);

      const match = output.match(/https:\/\/[a-z0-9-]+\.trycloudflare\.com/i);
      if (match && !settled) {
        settled = true;
        const url = match[0];
        try {
          fs.mkdirSync(DATA_DIR, { recursive: true });
          fs.writeFileSync(URL_FILE, `${url}\n`);
        } catch {
          // The URL is still printed below.
        }
        console.log('\nTunnel ready');
        console.log(`URL:      ${url}`);
        console.log(`Username: ${credentials.username}`);
        console.log(`Password: ${credentials.password}`);
        console.log('Press Ctrl+C to stop.\n');
        resolve({ child, url });
      }
    };

    child.stdout.on('data', onData);
    child.stderr.on('data', onData);
    child.on('error', (err) => {
      if (!settled) {
        settled = true;
        reject(err);
      }
    });
    child.on('exit', (code) => {
      if (!settled) {
        settled = true;
        reject(new Error(`cloudflared exited before publishing a URL (code ${code}).\n${output}`));
      }
    });
  });
}

async function main() {
  const cloudflaredPath = findCloudflared();
  const credentials = ensureCredentials();
  const { port: appPort, child: appChild } = await ensureApp();
  const proxyPort = await findProxyPort();
  const proxy = await startProxy(appPort, proxyPort, credentials);
  console.log(`Basic Auth proxy listening at http://127.0.0.1:${proxyPort}`);

  let tunnelChild = null;
  let shuttingDown = false;
  const shutdown = (code = 0) => {
    if (shuttingDown) return;
    shuttingDown = true;
    console.log('\nStopping tunnel...');
    if (tunnelChild) tunnelChild.kill();
    proxy.close();
    if (appChild) appChild.kill();
    setTimeout(() => process.exit(code), 1000).unref();
  };

  process.on('SIGINT', () => shutdown(0));
  process.on('SIGTERM', () => shutdown(0));

  try {
    const tunnel = await startTunnel(cloudflaredPath, proxyPort, credentials);
    tunnelChild = tunnel.child;
    tunnelChild.on('exit', (code) => {
      if (!shuttingDown) {
        console.error(`\ncloudflared stopped (code ${code}).`);
        shutdown(code || 1);
      }
    });
  } catch (err) {
    console.error(err.message);
    shutdown(1);
  }
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
