-- =====================================================================
-- AGRINEXA — HARGA NYATA DARI SUMBER RESMI, OTOMATIS 1x/24 JAM
-- =====================================================================
-- VERSI 2 (2026-10-26). Perubahan penting dari versi pertama:
--   Versi 1 selalu menghasilkan "0 harga diperbarui". Penyebabnya bukan
--   server sumber dan bukan timeout: pg_net mengirim permintaan lewat
--   background worker yang HANYA melihat antrean setelah transaksi tempat
--   http_get() dipanggil COMMIT. Versi 1 memanggil http_get() lalu menunggu
--   jawabannya di dalam transaksi yang sama, jadi permintaannya tidak pernah
--   benar-benar berangkat.
--   Karena itu sekarang ada DUA tahap yang wajib dua transaksi berbeda:
--     harga_kirim()  -> hanya mengirim, langsung selesai
--     harga_serap()  -> membaca jawaban yang sudah masuk, ~1 menit kemudian
--   Cron yang mengatur jedanya; Anda tidak perlu apa-apa setiap hari.
--
-- Isi berkas ini:
--   1. Dua sumber resmi dibaca OLEH BASIS DATA Supabase (pg_net + pg_cron):
--        a. Kemendag SP2KP       — harga rata-rata NASIONAL, harian
--        b. Bank Indonesia PIHPS — harga PROVINSI (bawaan Jawa Timur), harian
--   2. Angka yang masuk ke `harga` membawa sumber, tanggal, tautan, jam
--      pengambilan, satuan — jadi layar Pasar bisa menulis
--      "Bank Indonesia — PIHPS · 26 Okt 2026".
--   3. Jadwal otomatis: kirim 08:30 WIB, serap 08:40 WIB.
--   4. Nama komoditas yang tidak bisa dipetakan ke 69 tanaman aplikasi
--      dicatat di harga_nama_asing — dilihat dan ditambah pemetaannya,
--      bukan dikarang angkanya.
--
-- SIFAT   : aman dijalankan berulang, tidak ada data harga yang hilang.
-- CARA    : Supabase -> SQL Editor -> Ctrl+A -> Delete -> tempel SEMUA isi
--           berkas ini -> Run. Hasil terakhir: daftar fungsi + jadwal.
-- BIAYA   : tanpa API key, tanpa kartu, tanpa layanan tambahan.
-- KEAMANAN: tabel `harga` tetap hanya-baca bagi aplikasi (kunci_harga.sql).
-- =====================================================================

set search_path = public, net, extensions;

-- ---------------------------------------------------------------------
-- 0. Bersihkan sisa VERSI 1 supaya tidak ada dua mekanisme yang bentrok
--    dan tidak ada jadwal yang memanggil fungsi yang sudah tidak ada.
-- ---------------------------------------------------------------------
select cron.unschedule(j.jobname)
from cron.job j
where j.jobname in ('harga-harian', 'harga-kirim', 'harga-serap',
                    'harga-simulasi', 'bersihkan-antrean-http');

drop function if exists public.harga_segarkan();
drop function if exists public.harga_ambil_sp2kp();
drop function if exists public.harga_ambil_bi();
drop function if exists public.harga_tunggu(bigint);
-- Versi lama tanpa kunci; diganti versi 2 argumen di bawah.
drop function if exists public.harga_serap_bi(text);

-- ---------------------------------------------------------------------
-- 1. Kolom asal-usul tambahan pada tabel harga yang sudah ada.
-- ---------------------------------------------------------------------
alter table public.harga add column if not exists sumber_url   text;
alter table public.harga add column if not exists diambil_pada timestamptz;
alter table public.harga add column if not exists satuan       text;

-- ---------------------------------------------------------------------
-- 2. Daftar sumber — dibaca layar "Sumber" di aplikasi.
-- ---------------------------------------------------------------------
create table if not exists public.sumber_harga (
  kode       text primary key,
  nama       text not null,
  url        text not null,
  keterangan text,
  frekuensi  text,
  urutan     int default 1
);

insert into public.sumber_harga (kode, nama, url, keterangan, frekuensi, urutan) values
  ('bi',
   'Bank Indonesia — PIHPS',
   'https://www.bi.go.id/hargapangan',
   'Harga pangan pantauan Bank Indonesia per provinsi, dari pasar yang benar-benar dipantau. Sumber resmi yang sama dipakai berita ekonomi.',
   'harian', 1),
  ('sp2kp',
   'Kemendag — SP2KP',
   'https://api-sp2kp.kemendag.go.id',
   'Sistem Pemantauan Harga dan Pasokan Pangan, Kementerian Perdagangan. Rata-rata harga tingkat nasional.',
   'harian', 2),
  ('manual',
   'Catatan Anda sendiri',
   'https://agrinexa.app',
   'Harga yang Anda ketuk di layar Pasar ("Atur harga sendiri"). Paling dipercaya dan tidak pernah ditimpa oleh sumber otomatis.',
   'manual', 0),
  ('hpp',
   'HPP pemerintah — acuan gabah',
   'https://kemenkopangan.go.id',
   'Harga Pembelian Pemerintah untuk gabah kering panen (GKP). Kebijakan, bukan harga pasar harian: dipakai hanya untuk padi karena tidak ada sumber harga gabah harian.',
   'kebijakan', 3)
on conflict (kode) do update
  set nama = excluded.nama, url = excluded.url,
      keterangan = excluded.keterangan, frekuensi = excluded.frekuensi,
      urutan = excluded.urutan;

-- ---------------------------------------------------------------------
-- 3. Pengaturan yang boleh diubah sendiri, contoh:
--      update public.harga_atur set nilai = 'Bali' where kunci = 'provinsi';
-- ---------------------------------------------------------------------
create table if not exists public.harga_atur (
  kunci text primary key,
  nilai text not null
);

insert into public.harga_atur (kunci, nilai) values ('provinsi', 'Jawa Timur')
on conflict (kunci) do nothing;

-- Kode provinsi SP2KP sama dengan kode BPS: 35 Jawa Timur, 33 Jawa Tengah,
-- 32 Jawa Barat, 31 DKI Jakarta, 34 DIY, 36 Banten, 51 Bali, 11 Aceh.
insert into public.harga_atur (kunci, nilai) values ('provinsi_kode', '35')
on conflict (kunci) do nothing;

-- ---------------------------------------------------------------------
-- 3b. Harga dasar tiap tanaman = angka yang sekarang ada di aplikasi.
--     Dipakai sebagai titik tumpu simulasi harian, supaya angka simulasi
--     bergerak di sekitar harga yang wajar dan tidak menghanyut jauh
--     setelah berbulan-bulan. Diisi sekali; kalau nanti Anda ingin dasar
--     baru, hapus barisnya lalu jalankan berkas ini lagi.
-- ---------------------------------------------------------------------
create table if not exists public.harga_dasar (
  commodity_id text primary key,
  harga        int  not null
);

insert into public.harga_dasar (commodity_id, harga)
select commodity_id, harga_rp_kg from public.harga
on conflict (commodity_id) do nothing;

-- ---------------------------------------------------------------------
-- 4. Pemetaan: nama komoditas DI SUMBER -> commodity_id DI APLIKASI.
--    Kecocokan = potongan huruf kecil tanpa spasi (norm_teks), aturan
--    dengan `urutan` kecil dicoba lebih dulu. Menambah sumber = menambah
--    baris di sini, bukan mengubah kode aplikasi.
-- ---------------------------------------------------------------------
create table if not exists public.harga_peta (
  sumber       text not null,
  cocok        text not null,
  commodity_id text not null,
  urutan       int  not null default 1,
  primary key (sumber, cocok)
);

-- Aturan lama HARUS dibuang lebih dulu. Insert di bawah hanya menimpa aturan
-- dengan kunci yang sama; aturan usang dari versi sebelumnya (misalnya
-- "beras -> padi") akan tetap hidup dan mengotori harga.
delete from public.harga_peta where sumber in ('sp2kp', 'bi');

insert into public.harga_peta (sumber, cocok, commodity_id, urutan) values
  -- Varian SP2KP: nama paling spesifik lebih dulu (urutan kecil).
  -- "Beras" TIDAK dipetakan ke padi: padi di aplikasi = gabah, harganya
  -- kira-kira separuh beras. Rawit juga tidak dipetakan: cabai/cabai hijau
  -- di aplikasi adalah cabai besar, produknya berbeda.
  ('sp2kp', 'cabaimerahkeriting', 'cabai',        0),
  ('sp2kp', 'cabaimerahbesar',    'cabai',        1),
  ('sp2kp', 'cabaimerah',         'cabai',        2),
  ('sp2kp', 'cabai',              'cabai',        9),
  ('sp2kp', 'jagung',        'jagung',        1),
  ('sp2kp', 'kedelai',       'kedelai',       1),
  ('sp2kp', 'bawangmerah',   'bawangmerah',   1),
  ('sp2kp', 'bawangputih',   'bawangputih',   1),
  ('sp2kp', 'tomat',         'tomat',         1),
  ('sp2kp', 'kentang',       'kentang',       1),
  ('sp2kp', 'wortel',        'wortel',        1),
  ('sp2kp', 'kubis',         'kubis',         1),
  ('sp2kp', 'kacangpanjang', 'kacangpanjang', 1),
  ('sp2kp', 'kangkung',      'kangkung',      1),
  ('sp2kp', 'timun',         'timun',         1),
  ('sp2kp', 'terong',        'terong',        1),
  ('sp2kp', 'buncis',        'buncis',        1),
  ('sp2kp', 'sawi',          'sawi',          1),
  ('sp2kp', 'pisang',        'pisang',        1),
  ('sp2kp', 'apel',          'apel',          1),
  ('sp2kp', 'kacangtanah',   'kacangtanah',   1),
  ('sp2kp', 'kacanghijau',   'kacanghijau',   1),
  ('sp2kp', 'singkong',      'singkong',      1),
  ('sp2kp', 'ubijalar',      'ubijalar',      1),
  -- Nama varian SP2KP yang berbeda dari nama di aplikasi.
  ('sp2kp', 'ketimun',       'timun',         1),
  ('sp2kp', 'ketelapohon',   'singkong',      1),
  ('sp2kp', 'jeruk',         'jeruk',         1)
on conflict (sumber, cocok) do update
  set commodity_id = excluded.commodity_id, urutan = excluded.urutan;

insert into public.harga_peta (sumber, cocok, commodity_id, urutan) values
  ('bi', 'bawangmerah',   'bawangmerah',   1),
  ('bi', 'bawangputih',   'bawangputih',   1),
  ('bi', 'cabaimerah',    'cabai',         1),
  ('bi', 'gabah',         'padi',          1),
  ('bi', 'padi',          'padi',          2),
  ('bi', 'jagung',        'jagung',        1),
  ('bi', 'kedelai',       'kedelai',       1),
  ('bi', 'tomat',         'tomat',         1),
  ('bi', 'kentang',       'kentang',       1),
  ('bi', 'wortel',        'wortel',        1),
  ('bi', 'kacangpanjang', 'kacangpanjang', 1)
on conflict (sumber, cocok) do update
  set commodity_id = excluded.commodity_id, urutan = excluded.urutan;

-- ---------------------------------------------------------------------
-- 5. Buku catatan, nama asing, isi mentah respons, dan antrean.
-- ---------------------------------------------------------------------
create table if not exists public.harga_job_log (
  id              bigint generated always as identity primary key,
  dijalankan_pada timestamptz not null default now(),
  sumber          text not null,
  status          text not null,
  jumlah_baris    int  not null default 0,
  pesan           text
);

create table if not exists public.harga_nama_asing (
  sumber        text not null,
  nama          text not null,
  terlihat_pada timestamptz not null default now(),
  primary key (sumber, nama)
);

create table if not exists public.harga_mentah (
  sumber       text not null,
  kunci        text not null,
  diambil_pada timestamptz not null default now(),
  content      text,
  primary key (sumber, kunci)
);

-- Nomor permintaan pg_net yang sudah dikirim tapi belum diserap.
create table if not exists public.harga_antrean (
  id           bigint generated always as identity primary key,
  sumber       text not null,
  kunci        text not null,
  request_id   bigint not null,
  dikirim_pada timestamptz not null default now()
);

grant select on public.sumber_harga, public.harga_atur, public.harga_peta,
  public.harga_job_log, public.harga_nama_asing, public.harga_antrean,
  public.harga_dasar to anon, authenticated;
revoke insert, update, delete, truncate
  on public.sumber_harga, public.harga_atur, public.harga_peta,
     public.harga_job_log, public.harga_nama_asing, public.harga_mentah,
     public.harga_antrean, public.harga_dasar
  from anon, authenticated;

alter table public.sumber_harga     enable row level security;
alter table public.harga_atur       enable row level security;
alter table public.harga_peta       enable row level security;
alter table public.harga_job_log    enable row level security;
alter table public.harga_nama_asing enable row level security;
alter table public.harga_antrean    enable row level security;
alter table public.harga_dasar      enable row level security;
alter table public.harga_mentah     enable row level security;

drop policy if exists sumber_harga_baca on public.sumber_harga;
create policy sumber_harga_baca on public.sumber_harga
  for select to anon, authenticated using (true);

drop policy if exists harga_atur_baca on public.harga_atur;
create policy harga_atur_baca on public.harga_atur
  for select to anon, authenticated using (true);

drop policy if exists harga_peta_baca on public.harga_peta;
create policy harga_peta_baca on public.harga_peta
  for select to anon, authenticated using (true);

drop policy if exists harga_job_log_baca on public.harga_job_log;
create policy harga_job_log_baca on public.harga_job_log
  for select to anon, authenticated using (true);

drop policy if exists harga_nama_asing_baca on public.harga_nama_asing;
create policy harga_nama_asing_baca on public.harga_nama_asing
  for select to anon, authenticated using (true);

drop policy if exists harga_antrean_baca on public.harga_antrean;
create policy harga_antrean_baca on public.harga_antrean
  for select to anon, authenticated using (true);

drop policy if exists harga_dasar_baca on public.harga_dasar;
create policy harga_dasar_baca on public.harga_dasar
  for select to anon, authenticated using (true);

-- ---------------------------------------------------------------------
-- 6. Alat bantu kecil.
-- ---------------------------------------------------------------------

-- 'Bawang Merah Ukuran Sedang' -> 'bawangmerahukuransedang'
create or replace function public.norm_teks(t text)
returns text
language sql immutable
set search_path = public
as $fn$
  select regexp_replace(lower(coalesce(t, '')), '[^a-z0-9]', '', 'g');
$fn$;

-- Tanggal dari teks: bentuk aneh = tidak ada tanggal, bukan job gagal.
create or replace function public.tgl_aman(t text)
returns date
language plpgsql immutable
set search_path = public
as $fn$
begin
  return t::date;
exception when others then
  return null;
end
$fn$;

-- Angka dari teks. Sumber menulis desimal dengan TITIK ("28712.1209…")
-- dan ribuan dengan koma ("Rp38,750"), jadi titik tidak boleh dibuang:
-- membuang titik membuat 28712.12 jadi 2,8 triliun (integer out of range).
create or replace function public.num_aman(t text)
returns numeric
language plpgsql immutable
set search_path = public
as $fn$
declare
  v text;
begin
  v := regexp_replace(coalesce(t, ''), '[^0-9,.-]', '', 'g');
  if v = '' or v = '-' or v = '.' or v = ',' then
    return null;
  end if;

  if v like '%,%' and v like '%.%' then
    -- Dua jenis pemisah: yang muncul terakhir adalah desimal.
    if strpos(reverse(v), ',') < strpos(reverse(v), '.') then
      v := replace(replace(v, '.', ''), ',', '.');   -- 1.234,56
    else
      v := replace(v, ',', '');                      -- 1,234.56
    end if;
  elsif v like '%,%' then
    if v ~ '^-?[0-9]+,[0-9]{1,2}$' then
      v := replace(v, ',', '.');                     -- 1,5 = desimal
    else
      v := replace(v, ',', '');                      -- 38,750 = ribuan
    end if;
  end if;

  return v::numeric;
exception when others then
  return null;
end
$fn$;

-- Baca satu bidang dari baris JSON tanpa peduli bentuknya. Satu baris
-- aneh hanya dilewati, bukan membatalkan seluruh job.
create or replace function public.harga_aman(v_row jsonb, p_path text[])
returns text
language plpgsql immutable
set search_path = public
as $fn$
begin
  return v_row #>> p_path;
exception when others then
  return null;
end
$fn$;

-- Ambil daftar dari jawaban JSON; bukan JSON / kunci tidak ada = daftar kosong.
create or replace function public.json_array_aman(t text, p_kunci text)
returns jsonb
language plpgsql immutable
set search_path = public
as $fn$
declare
  v jsonb;
begin
  v := nullif(t, '')::jsonb -> p_kunci;
  if jsonb_typeof(v) = 'array' then
    return v;
  end if;
  return '[]'::jsonb;
exception when others then
  return '[]'::jsonb;
end
$fn$;

-- Nama komoditas dari satu baris JSON. SP2KP menaruh nama yang paling
-- spesifik di variant ("Cabai Rawit Hijau"), BI di Komoditas, sumber lain
-- di nama.
create or replace function public.harga_nama_baris(v_row jsonb)
returns text
language sql immutable
set search_path = public
as $fn$
  select coalesce(
    public.harga_aman(v_row, array['variant', 'nama']),
    public.harga_aman(v_row, array['komoditas', 'nama']),
    public.harga_aman(v_row, array['nama']),
    public.harga_aman(v_row, array['Komoditas']),
    '');
$fn$;

-- ---------------------------------------------------------------------
-- 7. Simpan satu angka ke tabel harga. Baris lama diarsipkan otomatis oleh
--    trigger harga_riwayat_pada_berubah. Aturan kejujuran: angka yang lebih
--    tua dari yang sudah ada tidak boleh menimpa yang lebih baru.
-- ---------------------------------------------------------------------
create or replace function public.harga_simpan(
  p_commodity text,
  p_harga     numeric,
  p_wilayah   text,
  p_sumber    text,
  p_tanggal   date,
  p_url       text,
  p_satuan    text
)
returns boolean
language plpgsql security definer
set search_path = public, net, extensions
as $fn$
declare
  v_lama date;
begin
  -- Batas atas menjaga-jaga: tidak ada harga per kg di atas Rp 10 juta.
  -- Angka di luar itu berarti pembacaan sumber salah, bukan harga.
  if p_commodity is null or p_harga is null
     or p_harga <= 0 or p_harga > 10000000 then
    return false;
  end if;

  select tanggal into v_lama
  from public.harga where commodity_id = p_commodity;

  if v_lama is not null and v_lama > p_tanggal then
    return false;
  end if;

  insert into public.harga
    (commodity_id, harga_rp_kg, wilayah, sumber, tanggal,
     sumber_url, diambil_pada, satuan)
  values
    (p_commodity, round(p_harga)::int, p_wilayah, p_sumber, p_tanggal,
     p_url, now(), p_satuan)
  on conflict (commodity_id) do update
    set harga_rp_kg  = excluded.harga_rp_kg,
        wilayah      = excluded.wilayah,
        sumber       = excluded.sumber,
        tanggal      = excluded.tanggal,
        sumber_url   = excluded.sumber_url,
        diambil_pada = excluded.diambil_pada,
        satuan       = excluded.satuan;

  return true;
end
$fn$;

-- ---------------------------------------------------------------------
-- 8. TAHAP 1 — KIRIM. Tidak menunggu apa pun: hanya memasukkan permintaan
--    ke antrean pg_net, lalu transaksi ini di-commit oleh pemanggil. Setelah
--    commit, background worker pg_net baru bisa mengambil dan mengirimnya.
-- ---------------------------------------------------------------------
create or replace function public.harga_kirim()
returns text
language plpgsql security definer
set search_path = public, net, extensions
as $fn$
declare
  -- BI memakai nama bulan INGGRIS, bukan Indonesia.
  v_bulan text[] := array['Jan','Feb','Mar','Apr','May','Jun',
                           'Jul','Aug','Sep','Oct','Nov','Dec'];
  -- Kode komoditas BI (TreeID dari GetCommoditiesTree). commodity=0 kosong.
  v_bi    text[] := array['1_3','1_1','5_11','6_12','7_14','8_15','8_16'];
  v_url   text;
  v_kode  text;
  v_kd    text;
  v_n     int := 0;
begin
  -- Kalau tahap serap kemarin belum sempat jalan, antreannya kita buang:
  -- yang penting angka hari ini, bukan antrean lama.
  delete from public.harga_antrean;

  -- SP2KP: satu provinsi saja, disaring server lewat kode_provinsi.
  -- (Parameter filter= diabaikan server; inilah yang benar-benar bekerja.)
  select nilai into v_kode from public.harga_atur where kunci = 'provinsi_kode';
  if v_kode is null or v_kode = '' then
    v_kode := '35';
  end if;

  v_url := 'https://api-sp2kp.kemendag.go.id/report/api/average-price-public'
        || '?take=900&kode_provinsi=' || v_kode
        || '&sort=%5B%7B%22selector%22%3A%22tanggal%22%2C%22desc%22%3Atrue%7D%5D';
  insert into public.harga_antrean (sumber, kunci, request_id)
  values ('sp2kp', 'prov',
          http_get(v_url, '{}'::jsonb, '{}'::jsonb, 25000));
  v_n := v_n + 1;

  v_url := 'https://www.bi.go.id/hargapangan/WebSite/Home/GetGridData1'
        || '?tanggal=' || to_char(current_date, 'FMDD') || '%20'
        || v_bulan[extract(month from current_date)::int] || '%20'
        || to_char(current_date, 'YYYY');
  foreach v_kd in array v_bi loop
    insert into public.harga_antrean (sumber, kunci, request_id)
    values ('bi', 'grid_' || v_kd,
            http_get(v_url
                     || '&commodity=' || v_kd
                     || '&priceType=1&isPasokan=1&jenis=1&periode=1&provId=0',
                     '{}'::jsonb, '{}'::jsonb, 25000));
    v_n := v_n + 1;
  end loop;

  insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
  values ('kirim', 'ok', v_n,
          v_n || ' permintaan dikirim; serap dijalankan terpisah');

  return v_n || ' permintaan dikirim ke Kemendag SP2KP dan BI PIHPS. '
             || 'Jalankan public.harga_serap() setelah 1-2 menit.';
end
$fn$;

-- ---------------------------------------------------------------------
-- 9a. TAHAP 2 — serap satu jawaban SP2KP.
--     Bentuk data: {"data":[{"tanggal":"2026-10-26",
--       "nama_provinsi":"Jawa Timur",
--       "komoditas":{"nama":"Cabai"},
--       "variant":{"nama":"Cabai Merah Keriting"},
--       "level":1,"harga":35000,"harga_nasional":33000}]}
--     Hanya level 1 (pangan) dan provinsi di harga_atur yang dipakai.
--     Kalau provinsi diatur 'Nasional', dipakai harga_nasional.
-- ---------------------------------------------------------------------
create or replace function public.harga_serap_sp2kp(p_isi text, p_kunci text)
returns integer
language plpgsql security definer
set search_path = public, net, extensions
as $fn$
declare
  v_arr   jsonb;
  v_row   jsonb;
  v_nama  text;
  v_asal  text;
  v_tgl   date;
  v_sat   text;
  v_komod text;
  v_uru   int;
  v_prov  text;
  v_baris_prov text;
  v_lvl   numeric;
  -- Varian terbaik per komoditas yang sudah ditulis pada halaman ini.
  v_best  jsonb := '{}'::jsonb;
  v_cnt   int := 0;
begin
  v_arr := public.json_array_aman(p_isi, 'data');

  if jsonb_array_length(v_arr) = 0 then
    insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
    values ('sp2kp', 'kosong', 0, p_kunci || ': halaman tanpa data');
    return 0;
  end if;

  if p_kunci in ('hal1', 'prov') then
    insert into public.harga_mentah (sumber, kunci, content)
    values ('sp2kp', 'hal1', left(p_isi, 100000))
    on conflict (sumber, kunci)
      do update set diambil_pada = now(), content = excluded.content;
  end if;

  select nilai into v_prov from public.harga_atur where kunci = 'provinsi';
  if v_prov is null or v_prov = '' then
    v_prov := 'Jawa Timur';
  end if;

  for v_row in select * from jsonb_array_elements(v_arr) loop
    -- level 2-3 = bahan bangunan dan sarana produksi, bukan pangan.
    v_lvl := public.num_aman(public.harga_aman(v_row, array['level']));
    if v_lvl is not null and v_lvl <> 1 then
      continue;
    end if;

    v_baris_prov := public.harga_aman(v_row, array['nama_provinsi']);
    if v_prov <> 'Nasional' and v_baris_prov is distinct from v_prov then
      continue;
    end if;

    v_asal  := public.harga_nama_baris(v_row);
    v_nama  := public.norm_teks(v_asal);
    v_tgl   := coalesce(
      public.tgl_aman(public.harga_aman(v_row, array['tanggal'])),
      current_date);
    v_sat   := public.harga_aman(v_row, array['variant', 'satuan']);
    v_komod := null;
    v_uru   := 9999;

    select p.commodity_id, p.urutan into v_komod, v_uru
    from public.harga_peta p
    where p.sumber = 'sp2kp' and v_nama like '%' || p.cocok || '%'
    order by p.urutan, p.cocok desc
    limit 1;

    if v_komod is null then
      if v_nama <> '' then
        insert into public.harga_nama_asing (sumber, nama)
        values ('sp2kp', left(v_asal, 120))
        on conflict (sumber, nama) do update set terlihat_pada = now();
      end if;
      continue;
    end if;

    -- Satu komoditas bisa punya beberapa varian pada hari yang sama.
    -- Pakai varian dengan urutan peta terbaik, bukan yang terbaca terakhir.
    if v_uru >= coalesce((v_best ->> v_komod)::int, 9999) then
      continue;
    end if;

    if public.harga_simpan(v_komod,
         public.num_aman(
           case when v_prov = 'Nasional'
                then coalesce(
                       public.harga_aman(v_row, array['harga_nasional']),
                       public.harga_aman(v_row, array['harga']))
                else public.harga_aman(v_row, array['harga'])
           end),
         coalesce(nullif(v_baris_prov, ''), 'Nasional'),
         'Kemendag — SP2KP', v_tgl,
         'https://api-sp2kp.kemendag.go.id', v_sat) then
      v_best  := jsonb_set(v_best, array[v_komod], to_jsonb(v_uru));
      v_cnt   := v_cnt + 1;
    end if;
  end loop;

  insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
  values ('sp2kp', 'ok', v_cnt,
          p_kunci || ': ' || jsonb_array_length(v_arr) || ' baris, ' ||
          v_cnt || ' harga ditulis');
  return v_cnt;
end
$fn$;

-- ---------------------------------------------------------------------
-- 9b. TAHAP 2 — serap satu jawaban BI PIHPS.
--     Bentuk data: {"data":[{"ProvID":11,"Provinsi":"Banten",
--       "Tanggal":"26 Okt 26","Komoditas":"Bawang Merah Ukuran Sedang",
--       "Nilai":37150.00}]}
-- ---------------------------------------------------------------------
create or replace function public.harga_serap_bi(p_isi text, p_kunci text default 'grid')
returns integer
language plpgsql security definer
set search_path = public, net, extensions
as $fn$
declare
  v_prov   text;
  v_arr    jsonb;
  v_row    jsonb;
  v_nama   text;
  v_asal   text;
  v_komod  text;
  v_cnt    int := 0;
  v_terim  int := 0;
  v_sesuai int := 0;
begin
  select nilai into v_prov from public.harga_atur where kunci = 'provinsi';
  if v_prov is null then
    v_prov := 'Jawa Timur';
  end if;

  insert into public.harga_mentah (sumber, kunci, content)
  values ('bi', left(p_kunci, 40), left(p_isi, 100000))
  on conflict (sumber, kunci)
    do update set diambil_pada = now(), content = excluded.content;

  v_arr := public.json_array_aman(p_isi, 'data');
  if jsonb_array_length(v_arr) = 0 then
    insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
    values ('bi', 'gagal', 0,
      'jawaban tidak berisi daftar "data" — periksa public.harga_mentah');
    return 0;
  end if;

  for v_row in select * from jsonb_array_elements(v_arr) loop
    v_terim := v_terim + 1;

    if public.norm_teks(public.harga_aman(v_row, array['Provinsi']))
       <> public.norm_teks(v_prov) then
      continue;
    end if;
    v_sesuai := v_sesuai + 1;

    v_asal  := public.harga_nama_baris(v_row);
    v_nama  := public.norm_teks(v_asal);
    v_komod := null;

    select p.commodity_id into v_komod
    from public.harga_peta p
    where p.sumber = 'bi' and v_nama like '%' || p.cocok || '%'
    order by p.urutan, p.cocok desc
    limit 1;

    if v_komod is null then
      if v_nama <> '' then
        insert into public.harga_nama_asing (sumber, nama)
        values ('bi', left(v_asal, 120))
        on conflict (sumber, nama) do update set terlihat_pada = now();
      end if;
      continue;
    end if;

    if public.harga_simpan(v_komod,
         public.num_aman(coalesce(
           public.harga_aman(v_row, array['Nilai']),
           public.harga_aman(v_row, array['nilai']),
           public.harga_aman(v_row, array['harga']))),
         v_prov, 'Bank Indonesia — PIHPS', current_date,
         'https://www.bi.go.id/hargapangan', 'kg') then
      v_cnt := v_cnt + 1;
    end if;
  end loop;

  insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
  values ('bi', 'ok', v_cnt, v_terim || ' baris diterima, ' || v_sesuai ||
    ' cocok dengan ' || v_prov || ', ' || v_cnt || ' harga ditulis');
  return v_cnt;
end
$fn$;

-- ---------------------------------------------------------------------
-- 10. TAHAP 2 — SERAP. Membaca jawaban yang sudah masuk ke antrean pg_net.
--     Jawaban yang belum datang dibiarkan di antrean (dicoba lagi pada
--     jadwal berikutnya); yang sudah lewat 5 menit dicatat gagal.
-- ---------------------------------------------------------------------
create or replace function public.harga_serap()
returns text
language plpgsql security definer
set search_path = public, net, extensions
as $fn$
declare
  a        record;
  v_kode   int;
  v_isi    text;
  v_galat  text;
  v_ada    boolean;
  v_jumlah int;
  v_n      int := 0;
  v_gagal  int := 0;
  v_tunggu int := 0;
begin
  for a in select * from public.harga_antrean order by id loop
    select h.status_code::int, h.content, h.error_msg
      into v_kode, v_isi, v_galat
    from _http_response h
    where h.id = a.request_id
    limit 1;
    v_ada := found;

    if not v_ada then
      if a.dikirim_pada > now() - interval '5 minutes' then
        v_tunggu := v_tunggu + 1;
        continue;
      end if;
      insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
      values (a.sumber, 'gagal', 0,
              a.kunci || ': tidak ada jawaban setelah 5 menit');
      v_gagal := v_gagal + 1;
      delete from public.harga_antrean where id = a.id;
      continue;
    end if;

    if v_kode is distinct from 200 then
      insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
      values (a.sumber, 'gagal', 0, a.kunci || ': ' ||
        coalesce(v_galat, 'HTTP ' || coalesce(v_kode::text, 'tanpa kode')));
      v_gagal := v_gagal + 1;
      delete from public.harga_antrean where id = a.id;
      continue;
    end if;

    if a.sumber = 'sp2kp' then
      v_jumlah := public.harga_serap_sp2kp(v_isi, a.kunci);
    else
      v_jumlah := public.harga_serap_bi(v_isi, a.kunci);
    end if;
    v_n := v_n + v_jumlah;

    delete from public.harga_antrean where id = a.id;
  end loop;

  return 'terserap ' || v_n || ' harga | gagal ' || v_gagal ||
         ' permintaan | menunggu ' || v_tunggu ||
         ' | total baris bersumber nyata: ' ||
         (select count(*) from public.harga
           where sumber <> ''
             and lower(sumber) not in ('basis-simulasi', 'contoh'));
end
$fn$;

-- Bersihkan antrean pg_net. Sendiri, karena cron tidak mewarisi
-- search_path dari berkas ini.
create or replace function public.harga_bersihkan()
returns integer
language plpgsql security definer
set search_path = public, net, extensions
as $fn$
declare
  v int;
begin
  delete from _http_response where created < now() - interval '2 days';
  get diagnostics v = row_count;
  return v;
end
$fn$;

-- ---------------------------------------------------------------------
-- 10b. SIMULASI HARIAN untuk tanaman yang tidak punya sumber resmi.
--      Tanaman yang sudah punya harga nyata (Kemendag / BI) TIDAK
--      disentuh di sini. Yang disentuh hanya baris yang sumbernya masih
--      basis simulasi, dan hasilnya diberi sumber 'simulasi-harian' —
--      jadi aplikasi tetap melabelinya simulasi, bukan harga pasar.
--      Angkanya bergerak ±5% dari harga dasar tiap hari, dengan pola yang
--      sama untuk semua perangkat (diturunkan dari tanggal), sehingga
--      tidak ada angka acak yang berubah setiap kali layar dibuka.
-- ---------------------------------------------------------------------
create or replace function public.harga_simulasi_harian()
returns integer
language plpgsql security definer
set search_path = public, net, extensions
as $fn$
declare
  r        record;
  v_acak   int;
  v_baru   int;
  v_n      int := 0;
begin
  for r in
    select h.commodity_id, d.harga as dasar
    from public.harga h
    join public.harga_dasar d on d.commodity_id = h.commodity_id
    where lower(coalesce(h.sumber, ''))
          in ('', 'contoh', 'basis-simulasi', 'simulasi-harian')
  loop
    v_acak := abs(hashtext(r.commodity_id || to_char(current_date, 'YYYYMMDD')))
              % 1001 - 500;                       -- -500 .. +500
    v_baru := greatest(500, round(r.dasar * (1 + v_acak::numeric / 10000))::int);

    if public.harga_simpan(r.commodity_id, v_baru, 'Simulasi',
                           'simulasi-harian', current_date, null, 'kg') then
      v_n := v_n + 1;
    end if;
  end loop;

  insert into public.harga_job_log (sumber, status, jumlah_baris, pesan)
  values ('simulasi', 'ok', v_n,
          v_n || ' harga simulasi diperbarui untuk hari ini');
  return v_n;
end
$fn$;

-- ---------------------------------------------------------------------
-- 10c. ACUAN PEMERINTAH untuk gabah. SP2KP dan BI hanya memuat BERAS,
--      tidak ada sumber harga gabah harian mana pun. Karena "padi" di
--      aplikasi berarti gabah, padi memakai HPP GKP Rp 6.500/kg
--      (Keputusan Kepala Bapanas No. 2/2025, berlaku 15 Januari 2025;
--      masih 6.500 per Oktober 2026).
--      Tanggalnya sengaja tanggal kebijakan, bukan hari ini, supaya
--      aplikasi menampilkan "HPP pemerintah (acuan) · 15 Jan 2025".
--      Simulasi harian tidak menyentuh baris ini karena sumbernya bukan
--      basis simulasi. Aman dijalankan berulang: hanya menimpa baris yang
--      masih simulasi.
-- ---------------------------------------------------------------------
insert into public.harga
  (commodity_id, harga_rp_kg, wilayah, sumber, tanggal,
   sumber_url, diambil_pada, satuan)
values
  ('padi', 6500, 'Nasional', 'HPP pemerintah (acuan)', '2025-01-15',
   'https://kemenkopangan.go.id', now(), 'kg')
on conflict (commodity_id) do update
  set harga_rp_kg  = excluded.harga_rp_kg,
      wilayah      = excluded.wilayah,
      sumber       = excluded.sumber,
      tanggal      = excluded.tanggal,
      sumber_url   = excluded.sumber_url,
      diambil_pada = excluded.diambil_pada,
      satuan       = excluded.satuan
  where lower(coalesce(public.harga.sumber, ''))
        in ('', 'contoh', 'basis-simulasi', 'simulasi-harian')
     -- Perbaikan sekali: versi lama sempat mengisi padi dari harga BERAS.
     or public.harga.sumber like 'Kemendag%'
     or public.harga.sumber like 'Bank Indonesia%';

-- ---------------------------------------------------------------------
-- 11. Jadwal 1x/24 jam. pg_cron memakai UTC: 01:30 UTC = 08:30 WIB kirim,
--     01:40 UTC = 08:40 WIB serap, 01:45 UTC = 08:45 WIB isi sisanya
--     dengan simulasi hari itu. Dua job pertama terpisah karena pg_net
--     baru mengirim setelah transaksi penitipan COMMIT.
-- ---------------------------------------------------------------------
select cron.schedule('harga-kirim', '30 1 * * *',
  $job$ select public.harga_kirim(); $job$);

select cron.schedule('harga-serap', '40 1 * * *',
  $job$ select public.harga_serap(); $job$);

select cron.schedule('harga-simulasi', '45 1 * * *',
  $job$ select public.harga_simulasi_harian(); $job$);

select cron.schedule('bersihkan-antrean-http', '45 2 * * *',
  $job$ select public.harga_bersihkan(); $job$);

-- ---------------------------------------------------------------------
-- 12. Bukti pemasangan.
-- ---------------------------------------------------------------------
select 'fungsi' as jenis, p.proname as nama
from pg_proc p join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname in ('harga_kirim', 'harga_serap', 'harga_serap_sp2kp',
                    'harga_serap_bi', 'harga_simpan', 'harga_bersihkan',
                    'harga_simulasi_harian')
union all
select 'jadwal', j.jobname || ' — ' || j.schedule || ' UTC'
from cron.job j
order by 1, 2;

-- -------------------------------------------------------------------------
-- LANGKAH BERIKUTNYA — dua tempelan terpisah, beri jarak 1-2 menit:
--   1) select public.harga_kirim();
--   2) select public.harga_serap();
--   3) select public.harga_simulasi_harian();   (isi sisanya, sekali saja)
-- Setelah itu cron yang mengurus setiap hari.
-- -------------------------------------------------------------------------
