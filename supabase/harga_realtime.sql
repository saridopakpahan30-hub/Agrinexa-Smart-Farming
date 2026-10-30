-- Menyalakan "harga berubah langsung" untuk tabel public.harga (Supabase "Agrinexa").
--
-- Supabase Realtime hanya mengirim berita perubahan untuk tabel yang masuk
-- publication `supabase_realtime`. Tanpa ini, aplikasi baru melihat editan Anda
-- setelah layar Pasar dibuka ulang.
--
-- Aman dijalankan berulang: kalau tabel sudah masuk, tidak ada yang diubah.
-- Hak baca yang sudah ada (satu policy SELECT untuk anon + authenticated) yang
-- menentukan event mana yang boleh dikirim ke aplikasi; menulis dari aplikasi
-- tetap tidak bisa.

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'harga'
  ) then
    execute 'alter publication supabase_realtime add table public.harga';
  end if;
end $$;

-- Query pertama: harus keluar satu baris berisi `harga`. Berarti tabelnya sudah
-- dipantau Realtime.
select tablename
from pg_publication_tables
where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'harga';

-- Query kedua: harus hanya satu baris `harga_hanya_dibaca` dengan cmd = SELECT.
select policyname, cmd, roles
from pg_policies
where schemaname = 'public' and tablename = 'harga';
