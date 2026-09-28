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
