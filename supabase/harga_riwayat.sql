-- ARSIP HARGA. Setiap kali sebuah baris di public.harga diganti angkanya,
-- nilai LAMAnya disimpan ke public.harga_riwayat. Dari situlah aplikasi
-- menggambar grafik naik-turun: titik-titiknya perubahan yang benar-benar
-- terjadi, bukan kurva yang dibangkitkan aplikasi.
--
-- Aman dijalankan berulang: semua langkah memakai if not exists /
-- create or replace / drop policy if exists, dan tidak ada data yang hilang.
-- Tempel SEMUA isi berkas ini di Supabase -> SQL Editor -> Run.
-- Hasil yang muncul cuma satu: jumlah baris arsip (nol pada jalankan pertama).

create table if not exists public.harga_riwayat (
  id           bigint generated always as identity primary key,
  commodity_id text        not null,
  harga_rp_kg  integer     not null,
  wilayah      text,
  sumber       text,
  tanggal      date,
  direkam_pada timestamptz not null default now()
);

create or replace function public.catat_harga_lama()
returns trigger
language plpgsql
set search_path = public
as $fn$
begin
  if (tg_op = 'UPDATE' and new.harga_rp_kg is distinct from old.harga_rp_kg)
    or tg_op = 'DELETE' then
    insert into public.harga_riwayat
      (commodity_id, harga_rp_kg, wilayah, sumber, tanggal)
    values
      (old.commodity_id, old.harga_rp_kg, old.wilayah, old.sumber, old.tanggal);
  end if;
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end
$fn$;

drop trigger if exists harga_riwayat_pada_berubah on public.harga;

create trigger harga_riwayat_pada_berubah
  after update or delete on public.harga
  for each row execute function public.catat_harga_lama();

create index if not exists harga_riwayat_by_commodity
  on public.harga_riwayat (commodity_id, direkam_pada);

-- Sama seperti tabel harga: publik hanya boleh membaca. Yang menulis ke arsip
-- hanyalah trigger di atas, dan itu jalan sebagai pemilik basis data, bukan
-- sebagai aplikasi.
alter table public.harga_riwayat enable row level security;

drop policy if exists harga_riwayat_public_read on public.harga_riwayat;
create policy harga_riwayat_public_read on public.harga_riwayat
  for select to anon, authenticated using (true);

grant select on public.harga_riwayat to anon, authenticated;
revoke insert, update, delete, truncate
  on public.harga_riwayat from anon, authenticated;

select count(*) as baris_riwayat from public.harga_riwayat;
