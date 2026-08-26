-- Execute no SQL Editor do Supabase
create table if not exists public.app_state (
  id text primary key, payload jsonb not null default '{}'::jsonb, updated_at timestamptz not null default now()
);
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text, role text not null default 'operador' check (role in ('admin','operador')),
  created_at timestamptz not null default now()
);
alter table public.app_state enable row level security;
alter table public.profiles enable row level security;
drop policy if exists "usuários autenticados podem ler o estado" on public.app_state;
drop policy if exists "usuários autenticados podem inserir o estado" on public.app_state;
drop policy if exists "usuários autenticados podem atualizar o estado" on public.app_state;
create policy "usuários autenticados podem ler o estado" on public.app_state for select to authenticated using (true);
create policy "usuários autenticados podem inserir o estado" on public.app_state for insert to authenticated with check (true);
create policy "usuários autenticados podem atualizar o estado" on public.app_state for update to authenticated using (true) with check (true);
create policy "usuário pode ler próprio perfil" on public.profiles for select to authenticated using (auth.uid()=id);
-- Crie no Auth somente o usuário estoquefirmafloor@gmail.com e promova-o com:
-- update public.profiles set role='admin' where id='UUID_DO_USUARIO';
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into public.profiles(id,full_name) values(new.id, coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email,'@',1))); return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
alter publication supabase_realtime add table public.app_state;
