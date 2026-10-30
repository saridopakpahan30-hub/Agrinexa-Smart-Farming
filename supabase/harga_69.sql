-- 69 baris: satu baris untuk SETIAP tanaman yang ada di aplikasi.
-- Angka di bawah adalah angka simulasi aplikasi hari ini, jadi menjalankan
-- berkas ini tidak mengubah satu pun harga yang tampil di layar. Sumbernya
-- ditulis 'basis-simulasi' supaya aplikasi jujur melabelinya "masih simulasi".
--
-- CARA GANTI KE HARGA ASLI (lakukan per baris, tidak harus sekaligus):
--   ubah angkanya, dan ubah 'basis-simulasi' menjadi nama sumber aslinya,
--   mis. 'PIHPS' atau 'Pasar Induk Kediri'. Begitu sumber bukan bawaan,
--   label di layar Pasar otomatis berubah jadi hijau: nama sumber + tanggal.
--
-- Berkas ini menimpa 8 baris 'contoh' yang sekarang ada (tanggalnya ikut
-- menjadi hari ini). Tempel SEMUA isinya di Supabase -> SQL Editor -> Run.

create unique index if not exists harga_commodity_id_key
  on public.harga (commodity_id);

insert into public.harga (commodity_id, harga_rp_kg, wilayah, sumber, tanggal)
select v.id, v.harga, v.wilayah, v.sumber, v.tanggal
from (values
  ('cabai', 26000, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Cabai */
  ('tomat', 7450, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Tomat */
  ('bawangmerah', 30150, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Bawang Merah */
  ('kentang', 13300, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kentang */
  ('kubis', 6400, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kubis */
  ('wortel', 8950, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Wortel */
  ('sawi', 6450, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Sawi */
  ('terong', 8300, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Terong */
  ('timun', 5700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Timun */
  ('kacangpanjang', 10300, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kacang Panjang */
  ('jagung', 10100, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Jagung */
  ('padi', 6500, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Padi */
  ('kedelai', 10150, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kedelai */
  ('kacangtanah', 18250, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kacang Tanah */
  ('ubijalar', 4450, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Ubi Jalar */
  ('singkong', 2250, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Singkong */
  ('semangka', 4950, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Semangka */
  ('melon', 9000, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Melon */
  ('pepaya', 4550, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Pepaya */
  ('pisang', 6000, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Pisang */
  ('nanas', 4000, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Nanas */
  ('kopi', 72100, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kopi */
  ('kakao', 32700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kakao */
  ('karet', 12300, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Karet */
  ('sawit', 2700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kelapa Sawit */
  ('tebu', 700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Tebu */
  ('jahe', 18700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Jahe */
  ('kunyit', 6650, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kunyit */
  ('lada', 90400, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Lada */
  ('serai', 3450, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Serai */
  ('bawangputih', 31550, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Bawang Putih */
  ('kangkung', 5950, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kangkung */
  ('buncis', 11800, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Buncis */
  ('mangga', 14750, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Mangga */
  ('alpukat', 26000, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Alpukat */
  ('durian', 45500, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Durian */
  ('vanili', 343650, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Vanili */
  ('kayumanis', 59700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kayu Manis */
  ('labu', 7350, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Labu */
  ('paprika', 33750, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Paprika */
  ('sirsak', 15400, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Sirsak */
  ('manggis', 32300, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Manggis */
  ('kacangmerah', 21650, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kacang Merah */
  ('kacangpolong', 21500, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kacang Polong */
  ('belimbing', 12200, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Belimbing */
  ('apel', 28400, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Apel */
  ('daunpandan', 14850, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Daun Pandan */
  ('tembakau', 42750, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Tembakau */
  ('kemiri', 36550, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kemiri */
  ('anggur', 40250, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Anggur */
  ('rambutan', 15200, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Rambutan */
  ('kacanghijau', 22950, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kacang Hijau */
  ('ketumbar', 55400, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Ketumbar */
  ('cengkeh', 97900, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Cengkeh */
  ('stroberi', 52950, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Stroberi */
  ('lemon', 24950, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Lemon */
  ('kapulaga', 107700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kapulaga */
  ('teh', 11350, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Teh */
  ('jeruk', 19900, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Jeruk */
  ('buahnaga', 25450, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Buah Naga */
  ('seledri', 19600, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Seledri */
  ('brokoli', 15200, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Brokoli */
  ('pala', 149700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Pala */
  ('kelapa', 12700, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Kelapa */
  ('salak', 20200, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Salak */
  ('markisa', 27050, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Markisa */
  ('jambubiji', 9400, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Jambu Biji */
  ('pare', 8250, 'Nasional', 'basis-simulasi', date '2026-10-25'),  /* Pare */
  ('cabaihijau', 23550, 'Nasional', 'basis-simulasi', date '2026-10-25')  /* Cabai Hijau */
) as v(id, harga, wilayah, sumber, tanggal)
on conflict (commodity_id) do update
  set harga_rp_kg = excluded.harga_rp_kg,
      wilayah     = excluded.wilayah,
      sumber      = excluded.sumber,
      tanggal     = excluded.tanggal;

select count(*) as jumlah_komoditas_terisi from public.harga;
