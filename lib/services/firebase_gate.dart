import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

/// Konfigurasi proyek Firebase, salinan dari setiap aplikasi yang terdaftar di
/// konsol (Project settings → Your apps). API key dan App ID berbeda antar
/// platform, sehingga keduanya dipilih sesuai platform yang sedang berjalan.
/// Nilai-nilai ini memang dirancang publik oleh Firebase; rahasia
/// sesungguhnya tidak pernah dikirim ke klien. Aplikasi iOS belum didaftarkan
/// di konsol, sehingga platform tersebut menggunakan konfigurasi Android dan
/// inisialisasinya akan gagal tanpa dilaporkan. Bila nilai di bawah
/// dikosongkan kembali, [FirebaseGate.aktif] bernilai `false` dan aplikasi
/// berjalan seperti sebelum Firebase ada: tanpa jaringan, tanpa kuota, tanpa
/// biaya.
class FirebaseSetup {
  static const _apiKeyWeb = 'AIzaSyB7NWK2f8Og4f6jPji9YC98URD5Imp7nr8';
  static const _apiKeyAndroid = 'AIzaSyDTyFYoLwaCspglnffgkOyQ6DMgoF25-eo';
  static const _appIdWeb = '1:599139763424:web:31451bc5508eea2569bc85';
  static const _appIdAndroid = '1:599139763424:android:779c8f045050aa9369bc85';
  static const authDomain = 'agrinexa-5082d.firebaseapp.com';
  static const projectId = 'agrinexa-5082d';
  static const storageBucket = 'agrinexa-5082d.firebasestorage.app';
  static const messagingSenderId = '599139763424';

  static bool get diisi => !_apiKeyWeb.startsWith('GANTI');

  static FirebaseOptions get options => const FirebaseOptions(
        apiKey: kIsWeb ? _apiKeyWeb : _apiKeyAndroid,
        appId: kIsWeb ? _appIdWeb : _appIdAndroid,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        authDomain: authDomain,
        storageBucket: storageBucket,
      );
}

/// Pintu masuk tunggal ke Firebase. Inisialisasi boleh gagal (misalnya
/// aplikasi dibuka tanpa koneksi internet) sementara aplikasi harus tetap
/// berjalan, sehingga seluruh kegagalan ditangani di sini dan dilaporkan
/// sebagai `false`.
class FirebaseGate {
  static bool _siap = false;

  /// Inisialisasi memerlukan batas waktu. [main] menunggu gerbang ini sebelum
  /// `runApp`, sehingga satu panggilan yang menggantung di jaringan membuat
  /// aplikasi berhenti pada layar putih Android dan tidak pernah tampil.
  static const _batas = Duration(seconds: 8);

  static bool get aktif => FirebaseSetup.diisi;
  static bool get siap => _siap;

  static Future<bool> mulai() async {
    if (!aktif) return false;
    if (_siap) return true;
    try {
      await Firebase.initializeApp(options: FirebaseSetup.options)
          .timeout(_batas);
      _siap = true;
      debugPrint('[firebase] siap');
      return true;
    } catch (e) {
      debugPrint('[firebase] tidak siap, aplikasi jalan lokal saja: $e');
      return false;
    }
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;
}

/// Terjemahan kode kesalahan Firebase menjadi kalimat yang ramah petani.
/// String kosong berarti pengguna sendiri yang membatalkan, bukan kesalahan.
String pesanAuth(Object e) {
  if (e is! FirebaseAuthException) return '';
  switch (e.code) {
    case 'popup-closed-by-user':
    case 'cancelled-popup-request':
    case 'popup-blocked':
      return '';
    case 'network-request-failed':
      return 'Tidak ada koneksi internet.';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'wrong-password':
    case 'user-not-found':
    case 'invalid-credential':
    case 'invalid-login-credentials':
      return 'Email atau password salah.';
    case 'email-already-in-use':
      return 'Email ini sudah terdaftar. Silakan masuk.';
    case 'weak-password':
      return 'Password terlalu pendek — minimal 6 huruf.';
    case 'missing-password':
    case 'missing-email':
      return 'Email dan password harus diisi.';
    case 'user-disabled':
      return 'Akun ini dinonaktifkan.';
    case 'operation-not-allowed':
      return 'Cara masuk ini belum diaktifkan di konsol Firebase.';
    case 'invalid-api-key':
    case 'invalid-api-domain':
      return 'Konfigurasi Firebase belum benar.';
    default:
      return 'Gagal masuk. Periksa koneksi internet lalu coba lagi.';
  }
}
