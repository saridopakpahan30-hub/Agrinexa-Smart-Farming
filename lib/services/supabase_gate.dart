import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Konfigurasi proyek Supabase, salinan dari konsol (Project Settings → API
/// Keys). URL dan *publishable/anon key* dirancang sebagai nilai publik:
/// keduanya aman disertakan dalam aplikasi karena aksesnya dibatasi Row Level
/// Security di server (tabel harga hanya dapat dibaca, tidak dapat ditulis dari
/// klien). Kunci rahasia (`service_role`/`secret`) tidak pernah ditempatkan di
/// sini.
class SupabaseSetup {
  static const url = 'https://juekbciirydznazzkayj.supabase.co';
  static const publishableKey =
      'sb_publishable_lXzZYIwlQzo90yhjpsS1Eg_jQRqbtU4';

  static bool get diisi =>
      !url.startsWith('GANTI') && !publishableKey.startsWith('GANTI');
}

/// Pintu masuk tunggal ke Supabase. Inisialisasi diperbolehkan gagal
/// (misalnya aplikasi dibuka tanpa koneksi internet) dan proses aplikasi harus
/// tetap berjalan, sehingga seluruh kegagalan ditangani di sini dan dilaporkan
/// melalui [siap] yang bernilai false.
class SupabaseGate {
  static bool _siap = false;

  /// [main] menunggu gerbang ini sebelum `runApp`. Tanpa batas waktu, satu
  /// koneksi yang menggantung sudah cukup untuk membekukan aplikasi pada layar
  /// putih Android, padahal kegagalan seharusnya hanya berarti "mode lokal".
  static const _batas = Duration(seconds: 8);

  static bool get aktif => SupabaseSetup.diisi;
  static bool get siap => _siap;

  static Future<bool> mulai() async {
    if (!aktif) {
      debugPrint('[supabase] lewat: konfigurasi belum diisi');
      return false;
    }
    if (_siap) return true;
    try {
      await Supabase.initialize(
              url: SupabaseSetup.url,
              publishableKey: SupabaseSetup.publishableKey)
          .timeout(_batas);
      _siap = true;
      debugPrint('[supabase] siap');
      return true;
    } catch (e) {
      debugPrint('[supabase] gagal inisialisasi: $e');
      return false;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}

/// Langganan perubahan tabel melalui websocket Supabase Realtime, sehingga
/// harga yang diperbarui di dashboard langsung terlihat pada aplikasi yang
/// sedang berjalan tanpa membuka ulang layar. Ini satu-satunya tempat kode
/// Supabase Realtime berada, sama seperti [SupabaseGate] yang menjadi satu-
/// satunya tempat SDK tersebut diinisialisasi.
///
/// Syaratnya ditegakkan di server, bukan di sini: tabel harus masuk publication
/// `supabase_realtime` (lihat `supabase/harga_realtime.sql`), dan hak
/// `select` menentukan event mana yang benar-benar dikirim.
class SupabaseLive {
  static final Map<String, RealtimeChannel> _kanal = {};

  /// Pantau [tabel]; [padaBerubah] dipanggil setiap ada baris yang berubah.
  /// Tidak melakukan apa pun tanpa jaringan/Supabase, dan aman dipanggil
  /// berulang untuk tabel yang sama (langganan kedua ditolak, bukan ditumpuk).
  static void langganan(String tabel, VoidCallback padaBerubah) {
    if (!SupabaseGate.siap || _kanal.containsKey(tabel)) return;
    try {
      final kanal = SupabaseGate.client
          .channel('perubahan-$tabel')
          .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: tabel,
              callback: (_) => padaBerubah())
          .subscribe();
      _kanal[tabel] = kanal;
      debugPrint('[supabase] langganan perubahan tabel $tabel');
    } catch (e) {
      debugPrint('[supabase] langganan $tabel gagal: $e');
    }
  }

  static Future<void> berhenti() async {
    for (final k in _kanal.values) {
      await k.unsubscribe();
    }
    _kanal.clear();
  }
}
