-- Aarogya account isolation. Enable RLS on every public table.
-- Use only the publishable/anon key from Flutter. Never ship service_role.

create table if not exists public.profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null,
  locale text not null default 'en',
  consent_sync boolean not null default true,
  consent_emergency_share boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.devices (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  label text not null default 'Aarogya device',
  platform text not null default 'web',
  last_seen_at timestamptz not null default now()
);

create table if not exists public.observations (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  device_id uuid,
  recorded_at timestamptz not null,
  heart_rate_bpm double precision,
  spo2_percent double precision,
  temperature_c double precision,
  movement text,
  battery_percent double precision,
  lat double precision,
  lon double precision,
  is_simulation boolean not null default true,
  source_id text,
  source_kind text,
  updated_at timestamptz not null default now()
);

create table if not exists public.baselines (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users (id) on delete cascade,
  version text not null,
  sample_count integer not null,
  computed_at timestamptz not null,
  hr_low double precision,
  hr_high double precision,
  hr_median double precision,
  spo2_low double precision,
  spo2_high double precision,
  spo2_median double precision,
  temp_low double precision,
  temp_high double precision,
  temp_median double precision,
  updated_at timestamptz not null default now()
);

create table if not exists public.emergency_snapshots (
  user_id uuid primary key references auth.users (id) on delete cascade,
  phase text not null,
  disaster_type text,
  activation_source text,
  stranded boolean not null default false,
  last_event_id text,
  updated_at timestamptz not null default now()
);

create table if not exists public.packets (
  event_id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  origin_device_id text not null,
  timestamp timestamptz not null,
  event_type text not null,
  risk_level text not null,
  fall_status text not null,
  state text not null,
  connectivity_at_creation text not null,
  movement text,
  heart_rate_bpm double precision,
  spo2_percent double precision,
  battery_percent double precision,
  lat double precision,
  lon double precision,
  hop_count integer not null default 0,
  expires_at timestamptz,
  model_version text,
  risk_score double precision,
  context_label text,
  context_confidence double precision,
  baseline_heart_rate double precision,
  baseline_spo2 double precision,
  window_heart_rate_mean double precision,
  rules_score double precision,
  model_contribution double precision,
  sensor_source_id text,
  sensor_source_kind text,
  fall_detection_mode text not null default 'simulated-sequence',
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.devices enable row level security;
alter table public.observations enable row level security;
alter table public.baselines enable row level security;
alter table public.emergency_snapshots enable row level security;
alter table public.packets enable row level security;

revoke all on public.profiles from anon, public;
revoke all on public.devices from anon, public;
revoke all on public.observations from anon, public;
revoke all on public.baselines from anon, public;
revoke all on public.emergency_snapshots from anon, public;
revoke all on public.packets from anon, public;

grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.devices to authenticated;
grant select, insert, update, delete on public.observations to authenticated;
grant select, insert, update, delete on public.baselines to authenticated;
grant select, insert, update, delete on public.emergency_snapshots to authenticated;
grant select, insert, update, delete on public.packets to authenticated;

create policy profiles_own on public.profiles
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy devices_own on public.devices
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy observations_own on public.observations
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy baselines_own on public.baselines
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy snapshots_own on public.emergency_snapshots
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy packets_own on public.packets
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
