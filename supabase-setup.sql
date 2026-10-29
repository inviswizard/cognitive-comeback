-- Run in Supabase Dashboard → SQL Editor → New query → Run.
-- Stores one JSON progress document per authenticated user.
create table if not exists public.tracker_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.tracker_progress enable row level security;
revoke all on public.tracker_progress from anon;
grant select, insert, update, delete on public.tracker_progress to authenticated;
drop policy if exists "Users can read own tracker" on public.tracker_progress;
drop policy if exists "Users can insert own tracker" on public.tracker_progress;
drop policy if exists "Users can update own tracker" on public.tracker_progress;
drop policy if exists "Users can delete own tracker" on public.tracker_progress;
create policy "Users can read own tracker" on public.tracker_progress for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users can insert own tracker" on public.tracker_progress for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Users can update own tracker" on public.tracker_progress for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Users can delete own tracker" on public.tracker_progress for delete to authenticated using ((select auth.uid()) = user_id);
