import 'package:geolocator/geolocator.dart';

/// Posisi asli dari GPS perangkat, bukan perkiraan berdasarkan alamat IP.
///
/// Pada web digunakan izin geolocation peramban (memerlukan HTTPS; Hosting
/// sudah melayani HTTPS). Pada Android diperlukan izin lokasi di manifest
/// beserta persetujuan pengguna saat tombol ditekan.
class GpsService {
  /// Batas 20 detik: di dalam ruangan, kunci GPS pertama dapat memakan waktu
  /// lama, tetapi setelah itu pengguna umumnya telah menutup aplikasi.
  static const batas = Duration(seconds: 20);

  static Future<({double lat, double lon})> ambil() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('GPS perangkat mati');
    }
    var izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
    }
    if (izin == LocationPermission.denied) {
      throw Exception('izin lokasi ditolak');
    }
    if (izin == LocationPermission.deniedForever) {
      throw Exception('izin lokasi dimatikan di setelan');
    }
    final p = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: batas,
      ),
    );
    return (lat: p.latitude, lon: p.longitude);
  }
}
