-- Kunci tabel harga: publik boleh MEMBACA, tidak boleh menulis.
--
-- Kenapa: URL proyek dan publishable/anon key ada di dalam berkas aplikasi
-- yang diunduh siapa pun. Selama tabel masih punya kebijakan UPDATE, orang
-- itu bisa mengubah harga nasional di aplikasi semua pengguna.
--
-- Cara pakai: Supabase console -> SQL Editor -> New query -> tempel semua ->
-- Run. Baris terakhir mencetak keadaan akhir supaya bisa dicocokkan.
-- Kunci service_role tidak terpengaruh: perannya bypassrls, jadi penulis
-- harga harian tetap bisa masuk.

-- 1. Buang semua kebijakan lama pada tabel harga (nama aslinya tidak tercatat
--    di repo, jadi dijelajahi lewat pg_policies).
do $$
declare p record;
begin
  for p in select policyname from pg_policies
            where schemaname = 'public' and tablename = 'harga'
  loop
    execute format('drop policy %I on public.harga', p.policyname);
  end loop;
end $$;

-- 2. Hanya satu kebijakan tersisa: baca.
create policy "harga_hanya_dibaca" on public.harga
  for select to anon, authenticated
  using (true);

-- 3. Hak tabelnya juga dicabut, supaya kebijakan saja tidak jadi satu-satunya
--    pagar. PostgREST memakai peran anon, jadi ini langsung terasa.
revoke insert, update, delete, truncate on public.harga from anon, authenticated;
grant select on public.harga to anon, authenticated;

-- 4. Keadaan akhir. Yang diharapkan: satu baris cmd = SELECT dan tidak ada
--    baris INSERT/UPDATE/DELETE.
select policyname, cmd, roles from pg_policies
 where schemaname = 'public' and tablename = 'harga';
