-- ============================================================================
-- Free GST Billing Software — hosted schema + Row Level Security
-- Target: Supabase (Postgres 15+) or any Postgres with an `auth.users` table
-- and Supabase's `auth.uid()` / `storage` schema.
--
-- This file is a migration artifact for the hosted/multi-tenant build.
-- The local app does not use it. Apply it in a Supabase project's SQL editor
-- (or through `supabase db push`) as migration 0001.
--
-- Design rules enforced here:
--   1. Every tenant row carries org_id.
--   2. RLS is ENABLED and FORCED on every tenant table.
--   3. Deny by default: no policy means no access.
--   4. Membership helpers are SECURITY DEFINER with a pinned search_path.
--   5. Service-role keys never reach the browser; they are server-only.
--   6. audit_log is append-only (no UPDATE/DELETE policies).
-- ============================================================================

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- Users and organizations
-- ---------------------------------------------------------------------------

create table if not exists public.organizations (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (length(trim(name)) between 1 and 200),
  slug        text not null unique,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table if not exists public.app_users (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table if not exists public.memberships (
  org_id      uuid not null references public.organizations(id) on delete cascade,
  user_id     uuid not null references auth.users(id) on delete cascade,
  role        text not null default 'viewer'
              check (role in ('owner', 'admin', 'accountant', 'viewer')),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  primary key (org_id, user_id)
);

create index if not exists memberships_user_idx on public.memberships (user_id);

-- ---------------------------------------------------------------------------
-- Tenant data
-- ---------------------------------------------------------------------------

create table if not exists public.businesses (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references public.organizations(id) on delete cascade,
  legacy_id    text,
  business_name text not null default '',
  gstin        text,
  state        text,
  data         jsonb not null default '{}'::jsonb,
  created_by   uuid references auth.users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create unique index if not exists businesses_org_legacy_idx
  on public.businesses (org_id, legacy_id) where legacy_id is not null;
create index if not exists businesses_org_idx on public.businesses (org_id);

create table if not exists public.clients (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references public.organizations(id) on delete cascade,
  legacy_id    text,
  name         text not null default '',
  gstin        text,
  state        text,
  data         jsonb not null default '{}'::jsonb,
  created_by   uuid references auth.users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create unique index if not exists clients_org_legacy_idx
  on public.clients (org_id, legacy_id) where legacy_id is not null;
create index if not exists clients_org_name_idx on public.clients (org_id, lower(name));

create table if not exists public.products (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references public.organizations(id) on delete cascade,
  legacy_id    text,
  name         text not null default '',
  hsn          text,
  unit         text,
  stock        numeric(14,3) not null default 0,
  data         jsonb not null default '{}'::jsonb,
  created_by   uuid references auth.users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create unique index if not exists products_org_legacy_idx
  on public.products (org_id, legacy_id) where legacy_id is not null;
create index if not exists products_org_name_idx on public.products (org_id, lower(name));

create table if not exists public.bills (
  id              uuid primary key default gen_random_uuid(),
  org_id          uuid not null references public.organizations(id) on delete cascade,
  business_id     uuid references public.businesses(id) on delete set null,
  client_id       uuid references public.clients(id) on delete set null,
  legacy_id       text,
  invoice_number  text not null,
  invoice_date    date not null,
  invoice_type    text not null default 'tax-invoice',
  status          text not null default 'unpaid',
  currency        text not null default 'INR',
  total_amount    numeric(14,2) not null default 0,
  paid_amount     numeric(14,2) not null default 0,
  data            jsonb not null default '{}'::jsonb,
  created_by      uuid references auth.users(id),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
-- coalesce() keeps the number unique even when business_id is null.
create unique index if not exists bills_org_business_number_idx
  on public.bills (
    org_id,
    coalesce(business_id, '00000000-0000-0000-0000-000000000000'::uuid),
    invoice_number
  );
create index if not exists bills_org_date_idx on public.bills (org_id, invoice_date desc);
create index if not exists bills_org_status_idx on public.bills (org_id, status);
create index if not exists bills_org_client_idx on public.bills (org_id, client_id);
create unique index if not exists bills_org_legacy_idx
  on public.bills (org_id, legacy_id) where legacy_id is not null;

create table if not exists public.expenses (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references public.organizations(id) on delete cascade,
  legacy_id    text,
  expense_date date not null default current_date,
  category     text,
  amount       numeric(14,2) not null default 0,
  data         jsonb not null default '{}'::jsonb,
  created_by   uuid references auth.users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create unique index if not exists expenses_org_legacy_idx
  on public.expenses (org_id, legacy_id) where legacy_id is not null;
create index if not exists expenses_org_date_idx on public.expenses (org_id, expense_date desc);

create table if not exists public.purchases (
  id             uuid primary key default gen_random_uuid(),
  org_id         uuid not null references public.organizations(id) on delete cascade,
  legacy_id      text,
  supplier_gstin text,
  invoice_number text,
  purchase_date  date not null default current_date,
  total_amount   numeric(14,2) not null default 0,
  data           jsonb not null default '{}'::jsonb,
  created_by     uuid references auth.users(id),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);
create unique index if not exists purchases_org_legacy_idx
  on public.purchases (org_id, legacy_id) where legacy_id is not null;
create index if not exists purchases_org_date_idx on public.purchases (org_id, purchase_date desc);

create table if not exists public.recurring_invoices (
  id              uuid primary key default gen_random_uuid(),
  org_id          uuid not null references public.organizations(id) on delete cascade,
  legacy_id       text,
  business_id     uuid references public.businesses(id) on delete set null,
  client_id       uuid references public.clients(id) on delete set null,
  frequency       text not null default 'monthly',
  interval_count  integer not null default 1 check (interval_count > 0),
  next_run_at     date,
  active          boolean not null default true,
  data            jsonb not null default '{}'::jsonb,
  created_by      uuid references auth.users(id),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create unique index if not exists recurring_org_legacy_idx
  on public.recurring_invoices (org_id, legacy_id) where legacy_id is not null;
create index if not exists recurring_org_due_idx
  on public.recurring_invoices (org_id, next_run_at) where active;

create table if not exists public.receipts (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references public.organizations(id) on delete cascade,
  legacy_id    text,
  bill_id      uuid references public.bills(id) on delete set null,
  receipt_no   text,
  receipt_date date not null default current_date,
  amount       numeric(14,2) not null default 0,
  data         jsonb not null default '{}'::jsonb,
  created_by   uuid references auth.users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create unique index if not exists receipts_org_legacy_idx
  on public.receipts (org_id, legacy_id) where legacy_id is not null;
create index if not exists receipts_org_date_idx on public.receipts (org_id, receipt_date desc);

create table if not exists public.terms_templates (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references public.organizations(id) on delete cascade,
  legacy_id    text,
  name         text not null default '',
  content      text not null default '',
  created_by   uuid references auth.users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create unique index if not exists terms_templates_org_legacy_idx
  on public.terms_templates (org_id, legacy_id) where legacy_id is not null;
create index if not exists terms_templates_org_idx on public.terms_templates (org_id);

-- ---------------------------------------------------------------------------
-- Numbering, idempotency, audit
-- ---------------------------------------------------------------------------

create table if not exists public.document_sequences (
  org_id          uuid not null references public.organizations(id) on delete cascade,
  business_id     uuid not null references public.businesses(id) on delete cascade,
  doc_type        text not null,
  financial_year  text not null,
  next_value      bigint not null default 1 check (next_value > 0),
  updated_at      timestamptz not null default now(),
  primary key (org_id, business_id, doc_type, financial_year)
);

create table if not exists public.idempotency_keys (
  org_id        uuid not null references public.organizations(id) on delete cascade,
  key           text not null,
  request_hash  text not null,
  response      jsonb,
  created_at    timestamptz not null default now(),
  expires_at    timestamptz not null default now() + interval '24 hours',
  primary key (org_id, key)
);

create table if not exists public.audit_log (
  id          bigserial primary key,
  org_id      uuid not null references public.organizations(id) on delete cascade,
  actor_id    uuid references auth.users(id) on delete set null,
  action      text not null,
  entity      text not null,
  entity_id   text,
  before_hash text,
  after_hash  text,
  ip          inet,
  user_agent  text,
  created_at  timestamptz not null default now()
);
create index if not exists audit_log_org_time_idx
  on public.audit_log (org_id, created_at desc);

-- Optional: only if you implement custom auth instead of Supabase Auth.
-- Supabase Auth already manages its own sessions; do not use this table then.
create table if not exists public.sessions (
  id                    uuid primary key default gen_random_uuid(),
  user_id               uuid not null references auth.users(id) on delete cascade,
  org_id                uuid references public.organizations(id) on delete cascade,
  token_hash            text not null unique,
  expires_at            timestamptz not null,
  absolute_expires_at   timestamptz not null,
  revoked_at            timestamptz,
  ip                    inet,
  user_agent            text,
  created_at            timestamptz not null default now(),
  last_seen_at          timestamptz not null default now()
);
create index if not exists sessions_user_idx on public.sessions (user_id);
create index if not exists sessions_expiry_idx on public.sessions (expires_at);

-- ---------------------------------------------------------------------------
-- updated_at triggers
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

do $$
declare
  t text;
begin
  foreach t in array array[
    'organizations', 'app_users', 'memberships', 'businesses', 'clients',
    'products', 'bills', 'expenses', 'purchases', 'recurring_invoices',
    'receipts', 'terms_templates'
  ]
  loop
    execute format('drop trigger if exists set_updated_at on public.%I;', t);
    execute format(
      'create trigger set_updated_at before update on public.%I '
      'for each row execute function public.set_updated_at();',
      t
    );
  end loop;
end;
$$;

-- ---------------------------------------------------------------------------
-- Cross-tenant reference guard
--
-- A plain FK only proves the referenced row exists, not that it belongs to
-- the same organization. These triggers stop a bill/receipt from pointing at
-- another tenant's business, client or bill even if the API is bypassed.
-- ---------------------------------------------------------------------------

create or replace function public.assert_tenant_refs()
returns trigger
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
begin
  if tg_table_name in ('bills', 'recurring_invoices') then
    if new.business_id is not null and not exists (
      select 1 from public.businesses b
      where b.id = new.business_id and b.org_id = new.org_id
    ) then
      raise exception 'business does not belong to organization';
    end if;

    if new.client_id is not null and not exists (
      select 1 from public.clients c
      where c.id = new.client_id and c.org_id = new.org_id
    ) then
      raise exception 'client does not belong to organization';
    end if;
  elsif tg_table_name = 'receipts' then
    if new.bill_id is not null and not exists (
      select 1 from public.bills b
      where b.id = new.bill_id and b.org_id = new.org_id
    ) then
      raise exception 'bill does not belong to organization';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists assert_tenant_refs on public.bills;
create trigger assert_tenant_refs
  before insert or update on public.bills
  for each row execute function public.assert_tenant_refs();

drop trigger if exists assert_tenant_refs on public.recurring_invoices;
create trigger assert_tenant_refs
  before insert or update on public.recurring_invoices
  for each row execute function public.assert_tenant_refs();

drop trigger if exists assert_tenant_refs on public.receipts;
create trigger assert_tenant_refs
  before insert or update on public.receipts
  for each row execute function public.assert_tenant_refs();

-- An organization must never lose its last owner. This also stops an owner
-- from accidentally locking everyone out of the tenant.
create or replace function public.ensure_org_has_owner()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_org uuid := old.org_id;
  v_losing_owner boolean := false;
begin
  if old.role = 'owner' then
    if tg_op = 'DELETE' then
      v_losing_owner := true;
    elsif new.role <> 'owner' or new.org_id <> old.org_id then
      v_losing_owner := true;
    end if;
  end if;

  if v_losing_owner and not exists (
    select 1 from public.memberships m
    where m.org_id = v_org
      and m.role = 'owner'
      and not (m.org_id = old.org_id and m.user_id = old.user_id)
  ) then
    raise exception 'organization must keep at least one owner';
  end if;

  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

drop trigger if exists ensure_org_has_owner on public.memberships;
create trigger ensure_org_has_owner
  before update or delete on public.memberships
  for each row execute function public.ensure_org_has_owner();

-- ---------------------------------------------------------------------------
-- Membership helpers (SECURITY DEFINER to avoid recursive RLS)
-- ---------------------------------------------------------------------------

create or replace function public.is_org_member(target_org uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.memberships m
    where m.org_id = target_org
      and m.user_id = (select auth.uid())
  );
$$;

create or replace function public.is_org_admin(target_org uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.memberships m
    where m.org_id = target_org
      and m.user_id = (select auth.uid())
      and m.role in ('owner', 'admin')
  );
$$;

create or replace function public.is_org_owner(target_org uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.memberships m
    where m.org_id = target_org
      and m.user_id = (select auth.uid())
      and m.role = 'owner'
  );
$$;

create or replace function public.can_write_org(target_org uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.memberships m
    where m.org_id = target_org
      and m.user_id = (select auth.uid())
      and m.role in ('owner', 'admin', 'accountant')
  );
$$;

revoke all on function public.is_org_member(uuid) from public;
revoke all on function public.is_org_admin(uuid) from public;
revoke all on function public.is_org_owner(uuid) from public;
revoke all on function public.can_write_org(uuid) from public;
grant execute on function public.is_org_member(uuid) to authenticated;
grant execute on function public.is_org_admin(uuid) to authenticated;
grant execute on function public.is_org_owner(uuid) to authenticated;
grant execute on function public.can_write_org(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Organization creation (signup)
-- ---------------------------------------------------------------------------

create or replace function public.create_organization(
  p_name text,
  p_slug text default null
)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_org uuid;
  v_slug text;
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;
  if length(trim(coalesce(p_name, ''))) = 0 then
    raise exception 'organization name is required';
  end if;

  v_slug := coalesce(
    nullif(trim(p_slug), ''),
    coalesce(
      nullif(trim(both '-' from lower(regexp_replace(trim(p_name), '[^a-zA-Z0-9]+', '-', 'g'))), ''),
      'org'
    ) || '-' || substr(gen_random_uuid()::text, 1, 8)
  );

  insert into public.organizations (name, slug)
  values (trim(p_name), v_slug)
  returning id into v_org;

  insert into public.app_users (id)
  values (auth.uid())
  on conflict (id) do nothing;

  insert into public.memberships (org_id, user_id, role)
  values (v_org, auth.uid(), 'owner');

  return v_org;
end;
$$;

revoke all on function public.create_organization(text, text) from public;
grant execute on function public.create_organization(text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Atomic document numbering
-- ---------------------------------------------------------------------------

create or replace function public.reserve_document_number(
  p_org uuid,
  p_business uuid,
  p_doc_type text,
  p_financial_year text
)
returns bigint
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_value bigint;
begin
  if not public.can_write_org(p_org) then
    raise exception 'not allowed';
  end if;

  if not exists (
    select 1 from public.businesses b
    where b.id = p_business and b.org_id = p_org
  ) then
    raise exception 'business does not belong to organization';
  end if;

  insert into public.document_sequences
    (org_id, business_id, doc_type, financial_year, next_value)
  values
    (p_org, p_business, p_doc_type, p_financial_year, 2)
  on conflict (org_id, business_id, doc_type, financial_year)
  do update set
    next_value = document_sequences.next_value + 1,
    updated_at = now()
  returning next_value - 1 into v_value;

  return v_value;
end;
$$;

revoke all on function public.reserve_document_number(uuid, uuid, text, text) from public;
grant execute on function public.reserve_document_number(uuid, uuid, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Audit helper (call from the API, or from triggers)
-- ---------------------------------------------------------------------------

create or replace function public.write_audit(
  p_org uuid,
  p_action text,
  p_entity text,
  p_entity_id text default null,
  p_before_hash text default null,
  p_after_hash text default null,
  p_ip inet default null,
  p_user_agent text default null,
  p_actor uuid default null
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_actor uuid := coalesce(p_actor, auth.uid());
begin
  -- `auth.uid()` is null for the service role; that caller is already trusted.
  if auth.uid() is not null and not public.is_org_member(p_org) then
    raise exception 'not allowed';
  end if;

  insert into public.audit_log
    (org_id, actor_id, action, entity, entity_id, before_hash, after_hash, ip, user_agent)
  values
    (p_org, v_actor, p_action, p_entity, p_entity_id, p_before_hash, p_after_hash, p_ip, p_user_agent);
end;
$$;

-- Audit rows are written by the trusted server only, never by the browser:
-- otherwise a member could forge their own audit trail.
revoke all on function public.write_audit(uuid, text, text, text, text, text, inet, text, uuid) from public;
revoke all on function public.write_audit(uuid, text, text, text, text, text, inet, text, uuid) from authenticated;
grant execute on function public.write_audit(uuid, text, text, text, text, text, inet, text, uuid) to service_role;

-- ---------------------------------------------------------------------------
-- Enable + FORCE RLS on every tenant table
-- ---------------------------------------------------------------------------

alter table public.organizations        enable row level security;
alter table public.organizations        force  row level security;
alter table public.app_users            enable row level security;
alter table public.app_users            force  row level security;
alter table public.memberships          enable row level security;
alter table public.memberships          force  row level security;
alter table public.businesses           enable row level security;
alter table public.businesses           force  row level security;
alter table public.clients              enable row level security;
alter table public.clients              force  row level security;
alter table public.products             enable row level security;
alter table public.products             force  row level security;
alter table public.bills                enable row level security;
alter table public.bills                force  row level security;
alter table public.expenses             enable row level security;
alter table public.expenses             force  row level security;
alter table public.purchases            enable row level security;
alter table public.purchases            force  row level security;
alter table public.recurring_invoices   enable row level security;
alter table public.recurring_invoices   force  row level security;
alter table public.receipts             enable row level security;
alter table public.receipts             force  row level security;
alter table public.terms_templates      enable row level security;
alter table public.terms_templates      force  row level security;
alter table public.document_sequences   enable row level security;
alter table public.document_sequences   force  row level security;
alter table public.idempotency_keys     enable row level security;
alter table public.idempotency_keys     force  row level security;
alter table public.audit_log            enable row level security;
alter table public.audit_log            force  row level security;
alter table public.sessions             enable row level security;
alter table public.sessions             force  row level security;

-- ---------------------------------------------------------------------------
-- Grants: authenticated gets only the tables it needs. Sequences, sessions,
-- idempotency and audit inserts stay service-role-only.
-- ---------------------------------------------------------------------------

grant select, update on public.organizations to authenticated;
grant select, insert, update on public.app_users to authenticated;
grant select, insert, update, delete on public.memberships to authenticated;
grant select, insert, update, delete on public.businesses to authenticated;
grant select, insert, update, delete on public.clients to authenticated;
grant select, insert, update, delete on public.products to authenticated;
grant select, insert, update, delete on public.bills to authenticated;
grant select, insert, update, delete on public.expenses to authenticated;
grant select, insert, update, delete on public.purchases to authenticated;
grant select, insert, update, delete on public.recurring_invoices to authenticated;
grant select, insert, update, delete on public.receipts to authenticated;
grant select, insert, update, delete on public.terms_templates to authenticated;
grant select on public.audit_log to authenticated;

-- Document sequences are reserved through reserve_document_number().
-- sessions and idempotency_keys are service-role-only.

-- ---------------------------------------------------------------------------
-- Policies: organizations / users / memberships
-- ---------------------------------------------------------------------------

drop policy if exists org_select on public.organizations;
create policy org_select on public.organizations
  for select to authenticated
  using (public.is_org_member(id));

drop policy if exists org_update on public.organizations;
create policy org_update on public.organizations
  for update to authenticated
  using (public.is_org_admin(id))
  with check (public.is_org_admin(id));

drop policy if exists app_users_select on public.app_users;
create policy app_users_select on public.app_users
  for select to authenticated
  using (
    id = (select auth.uid())
    or exists (
      select 1 from public.memberships m
      where m.user_id = id
        and public.is_org_member(m.org_id)
    )
  );

drop policy if exists app_users_insert on public.app_users;
create policy app_users_insert on public.app_users
  for insert to authenticated
  with check (id = (select auth.uid()));

drop policy if exists app_users_update on public.app_users;
create policy app_users_update on public.app_users
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

drop policy if exists memberships_select on public.memberships;
create policy memberships_select on public.memberships
  for select to authenticated
  using (public.is_org_member(org_id));

-- Only an owner can create, change or remove an owner. Admins may manage
-- non-owner members, which stops an admin from promoting themselves.
drop policy if exists memberships_insert on public.memberships;
create policy memberships_insert on public.memberships
  for insert to authenticated
  with check (
    public.is_org_owner(org_id)
    or (public.is_org_admin(org_id) and role <> 'owner')
  );

drop policy if exists memberships_update on public.memberships;
create policy memberships_update on public.memberships
  for update to authenticated
  using (
    public.is_org_owner(org_id)
    or (public.is_org_admin(org_id) and role <> 'owner')
  )
  with check (
    public.is_org_owner(org_id)
    or (public.is_org_admin(org_id) and role <> 'owner')
  );

drop policy if exists memberships_delete on public.memberships;
create policy memberships_delete on public.memberships
  for delete to authenticated
  using (
    public.is_org_owner(org_id)
    or (public.is_org_admin(org_id) and role <> 'owner')
  );

-- ---------------------------------------------------------------------------
-- Policies: tenant data
--
-- Read: any member.
-- Write: owner/admin/accountant.
-- Delete: owner/admin.
-- The WITH CHECK repeats the org test so a row cannot be moved to another
-- tenant by changing org_id.
-- ---------------------------------------------------------------------------

do $$
declare
  t text;
begin
  foreach t in array array[
    'businesses', 'clients', 'products', 'bills', 'expenses', 'purchases',
    'recurring_invoices', 'receipts', 'terms_templates'
  ]
  loop
    execute format('drop policy if exists %I on public.%I;', t || '_select', t);
    execute format(
      'create policy %I on public.%I for select to authenticated using (public.is_org_member(org_id));',
      t || '_select', t
    );

    execute format('drop policy if exists %I on public.%I;', t || '_insert', t);
    execute format(
      'create policy %I on public.%I for insert to authenticated with check (public.can_write_org(org_id));',
      t || '_insert', t
    );

    execute format('drop policy if exists %I on public.%I;', t || '_update', t);
    execute format(
      'create policy %I on public.%I for update to authenticated '
      'using (public.can_write_org(org_id)) '
      'with check (public.can_write_org(org_id));',
      t || '_update', t
    );

    execute format('drop policy if exists %I on public.%I;', t || '_delete', t);
    execute format(
      'create policy %I on public.%I for delete to authenticated using (public.is_org_admin(org_id));',
      t || '_delete', t
    );
  end loop;
end;
$$;

-- Document sequences: read for members; writes only through the function.
drop policy if exists doc_seq_select on public.document_sequences;
create policy doc_seq_select on public.document_sequences
  for select to authenticated
  using (public.is_org_member(org_id));

-- Audit log: admins can read; nobody can update or delete.
drop policy if exists audit_select on public.audit_log;
create policy audit_select on public.audit_log
  for select to authenticated
  using (public.is_org_admin(org_id));

-- Sessions: no policies at all. Only the service role (server) can touch it.
-- Idempotency keys: same.
-- audit_log has no INSERT policy; writes go through write_audit() or the
-- service role. There is deliberately no UPDATE/DELETE policy.

-- ---------------------------------------------------------------------------
-- Storage: private bucket, path = <org_id>/<...>
-- ---------------------------------------------------------------------------

-- Safely parse the first path segment as the tenant id. A malformed path
-- returns null, so the policy simply denies instead of raising a cast error.
create or replace function public.storage_org_id(object_name text)
returns uuid
language sql
immutable
security invoker
set search_path = public, pg_temp
as $$
  select case
    when (storage.foldername(object_name))[1]
      ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
    then ((storage.foldername(object_name))[1])::uuid
  end;
$$;

revoke all on function public.storage_org_id(text) from public;
grant execute on function public.storage_org_id(text) to authenticated;

insert into storage.buckets (id, name, "public", file_size_limit, allowed_mime_types)
values (
  'tenant-files',
  'tenant-files',
  false,
  26214400,
  array['application/pdf', 'application/json', 'image/png', 'image/jpeg']
)
on conflict (id) do update
set "public" = false,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists tenant_files_select on storage.objects;
create policy tenant_files_select on storage.objects
  for select to authenticated
  using (
    bucket_id = 'tenant-files'
    and public.is_org_member(public.storage_org_id(name))
  );

drop policy if exists tenant_files_insert on storage.objects;
create policy tenant_files_insert on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'tenant-files'
    and public.can_write_org(public.storage_org_id(name))
  );

drop policy if exists tenant_files_update on storage.objects;
create policy tenant_files_update on storage.objects
  for update to authenticated
  using (
    bucket_id = 'tenant-files'
    and public.can_write_org(public.storage_org_id(name))
  )
  with check (
    bucket_id = 'tenant-files'
    and public.can_write_org(public.storage_org_id(name))
  );

drop policy if exists tenant_files_delete on storage.objects;
create policy tenant_files_delete on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'tenant-files'
    and public.is_org_admin(public.storage_org_id(name))
  );

-- ---------------------------------------------------------------------------
-- Verification queries (run manually after applying)
-- ---------------------------------------------------------------------------
--
-- select relname, relrowsecurity, relforcerowsecurity
-- from pg_class
-- where relnamespace = 'public'::regnamespace
--   and relname in (
--     'organizations','app_users','memberships','businesses','clients',
--     'products','bills','expenses','purchases','recurring_invoices',
--     'receipts','terms_templates','document_sequences',
--     'idempotency_keys','audit_log','sessions'
--   )
-- order by relname;
--
-- As user A, with a session JWT:
--   select count(*) from public.bills where org_id = '<tenant B>';
--   -- expected: 0
--   insert into public.bills (org_id, invoice_number, invoice_date)
--   values ('<tenant B>', 'TEST-1', current_date);
--   -- expected: new row violates row-level security policy
--
-- As anon:
--   select * from public.bills;
--   -- expected: permission denied
