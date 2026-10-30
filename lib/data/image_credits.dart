/// Atribusi foto asli yang digunakan aplikasi.
///
/// Sebagian besar foto merupakan dokumentasi pribadi yang dibagikan langsung
/// ke Agrinexa; sebagian lain berasal dari Pexels dengan lisensi yang
/// mengizinkan pemakaian bebas. Daftar ini ditampilkan apa adanya di layar
/// Sumber Gambar.
class ImageCredit {
  final String crop, artist, license, page;
  const ImageCredit(this.crop, this.artist, this.license, this.page);
}

const _pribadi = 'Dokumentasi pribadi Agrinexa';
const _izin = 'Dokumentasi pribadi';
const _halaman = 'Dibagikan langsung ke Agrinexa oleh pemilik foto.';

const imageCredits = <ImageCredit>[
  ImageCredit('Alpukat', _pribadi, _izin, _halaman),
  ImageCredit('Apel', _pribadi, _izin, _halaman),
  ImageCredit('Anggur', _pribadi, _izin, _halaman),
  ImageCredit('Bawang Putih', _pribadi, _izin, _halaman),
  ImageCredit('Belimbing', _pribadi, _izin, _halaman),
  ImageCredit('Brokoli', _pribadi, _izin, _halaman),
  ImageCredit('Buah Naga', _pribadi, _izin, _halaman),
  ImageCredit('Buncis', _pribadi, _izin, _halaman),
  ImageCredit('Cabai Hijau', _pribadi, _izin, _halaman),
  ImageCredit('Cengkeh', _pribadi, _izin, _halaman),
  ImageCredit('Daun Pandan', _pribadi, _izin, _halaman),
  ImageCredit('Durian', _pribadi, _izin, _halaman),
  ImageCredit('Jambu Biji', _pribadi, _izin, _halaman),
  ImageCredit('Jeruk', _pribadi, _izin, _halaman),
  ImageCredit('Kacang Hijau', _pribadi, _izin, _halaman),
  ImageCredit('Kacang Merah', _pribadi, _izin, _halaman),
  ImageCredit('Kacang Polong', _pribadi, _izin, _halaman),
  ImageCredit('Kangkung', _pribadi, _izin, _halaman),
  ImageCredit('Kapulaga', 'Jahratreza', 'Lisensi Pexels',
      'https://www.pexels.com/photo/37568646/'),
  ImageCredit('Kayu Manis', _pribadi, _izin, _halaman),
  ImageCredit('Kelapa', _pribadi, _izin, _halaman),
  ImageCredit('Kemiri', _pribadi, _izin, _halaman),
  ImageCredit('Ketumbar', _pribadi, _izin, _halaman),
  ImageCredit('Labu', _pribadi, _izin, _halaman),
  ImageCredit('Lemon', _pribadi, _izin, _halaman),
  ImageCredit('Mangga', _pribadi, _izin, _halaman),
  ImageCredit('Manggis', _pribadi, _izin, _halaman),
  ImageCredit('Markisa', _pribadi, _izin, _halaman),
  ImageCredit('Pala', _pribadi, _izin, _halaman),
  ImageCredit('Paprika', _pribadi, _izin, _halaman),
  ImageCredit('Pare', _pribadi, _izin, _halaman),
  ImageCredit('Rambutan', _pribadi, _izin, _halaman),
  ImageCredit('Salak', _pribadi, _izin, _halaman),
  ImageCredit('Seledri', _pribadi, _izin, _halaman),
  ImageCredit('Sirsak', _pribadi, _izin, _halaman),
  ImageCredit('Stroberi', _pribadi, _izin, _halaman),
  ImageCredit('Teh', _pribadi, _izin, _halaman),
  ImageCredit('Tembakau', _pribadi, _izin, _halaman),
  ImageCredit('Vanili', _pribadi, _izin, _halaman),
];
