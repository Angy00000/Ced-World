-- CED WORLD — mise en place Supabase (à exécuter une fois le projet créé)

create table if not exists pole_images (
  slot text primary key,
  image_url text,
  updated_at timestamptz default now()
);

insert into pole_images (slot) values
  ('technologie'), ('immobilier'), ('auto_moto'), ('agriculture'), ('elevage')
on conflict (slot) do nothing;

create table if not exists gallery (
  id uuid primary key default gen_random_uuid(),
  image_url text not null,
  caption text,
  sort_order int default 0,
  created_at timestamptz default now()
);

alter table pole_images enable row level security;
alter table gallery enable row level security;

create policy "public read pole_images" on pole_images for select using (true);
create policy "public write pole_images" on pole_images for all using (true) with check (true);

create policy "public read gallery" on gallery for select using (true);
create policy "public write gallery" on gallery for all using (true) with check (true);

-- Stockage des fichiers images
insert into storage.buckets (id, name, public)
values ('ced-world', 'ced-world', true)
on conflict (id) do nothing;

create policy "public read ced-world bucket" on storage.objects
  for select using (bucket_id = 'ced-world');

create policy "public upload ced-world bucket" on storage.objects
  for insert with check (bucket_id = 'ced-world');

create policy "public delete ced-world bucket" on storage.objects
  for delete using (bucket_id = 'ced-world');
