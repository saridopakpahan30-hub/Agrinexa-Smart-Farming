import 'farm_repository.dart';

/// Kontrak penyimpanan data kebun di sisi server.
///
/// Antarmuka sengaja dibuat minimal (baca dan tulis satu snapshot) agar
/// logika sinkronisasi dapat diuji dengan implementasi tiruan di memori,
/// tanpa memerlukan proyek Firebase.
abstract class FarmBackend {
  /// Bernilai `false` bila pengguna belum masuk dengan akun Firebase atau
  /// server tidak dapat dijangkau. Aplikasi tetap berjalan dengan data lokal.
  bool get tersedia;

  /// Mengambil snapshot milik [pemilik], atau `null` bila belum pernah ada
  /// data yang dikirim ke server.
  Future<FarmSnapshot?> baca(PemilikData pemilik);

  /// Menyimpan [snapshot] sebagai versi terbaru milik [pemilik].
  Future<void> tulis(PemilikData pemilik, FarmSnapshot snapshot);

  /// Mengarsipkan versi yang kalah ketika dua perangkat mengubah data secara
  /// bersamaan, sehingga tidak ada perubahan pengguna yang hilang tanpa jejak.
  Future<void> simpanKonflik(
    PemilikData pemilik,
    FarmSnapshot yangKalah,
    String penyebab,
  );
}
