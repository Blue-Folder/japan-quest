-- Spusť jednou v Supabase: SQL Editor → New query → vlož → Run

create table if not exists public.likes (
  key text not null,
  who text not null check (who in ('b','p')),
  created_at timestamptz not null default now(),
  primary key (key, who)
);

create table if not exists public.wish (
  id text primary key,
  who text not null check (who in ('b','p')),
  t text not null,
  c text not null default '⭐',
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.checks (
  k text primary key,
  created_at timestamptz not null default now()
);

alter table public.likes enable row level security;
alter table public.wish enable row level security;
alter table public.checks enable row level security;

create policy "trip likes" on public.likes for all to anon using (true) with check (true);
create policy "trip wish" on public.wish for all to anon using (true) with check (true);
create policy "trip checks" on public.checks for all to anon using (true) with check (true);

alter publication supabase_realtime add table public.likes, public.wish, public.checks;

-- ===== Krok 2: sdílená místa a úpravy itineráře (spusť jednou) =====
create table if not exists public.places (
  id text primary key,
  who text check (who in ('b','p')),
  city text,
  district text not null default '',
  day int,
  time text not null default '',
  emoji text not null default '⭐',
  name text not null,
  note text not null default '',
  created_at timestamptz not null default now()
);
create table if not exists public.hidden (
  k text primary key,
  created_at timestamptz not null default now()
);
alter table public.places enable row level security;
alter table public.hidden enable row level security;
create policy "trip places" on public.places for all to anon using (true) with check (true);
create policy "trip hidden" on public.hidden for all to anon using (true) with check (true);
alter publication supabase_realtime add table public.places, public.hidden;
