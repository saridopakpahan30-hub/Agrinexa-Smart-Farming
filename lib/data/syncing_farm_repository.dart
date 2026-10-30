import 'dart:async';

import 'package:flutter/foundation.dart';

import 'farm_backend.dart';
import 'farm_repository.dart';

/// Pembacaan selalu diambil dari penyimpanan perangkat, sedangkan penulisan
/// dilakukan ke perangkat lebih dahulu lalu dikirim ke server beberapa saat
/// kemudian. Tanpa koneksi internet aplikasi tetap berjalan seperti biasa;
/// perubahan menyusul begitu koneksi tersedia.
class SyncingFarmRepository implements FarmRepository {
  SyncingFarmRepository({
    required FarmRepository lokal,
    required FarmBackend server,
    Duration jeda = const Duration(seconds: 3),
  })  : _lokal = lokal,
        _server = server,
        _jeda = jeda;

  final FarmRepository _lokal;
  final FarmBackend _server;
  final Duration _jeda;

  PemilikData? _pemilik;
  Timer? _jadwal;
  Future<void>? _sedang;
  int _gagalBeruntun = 0;

  final ValueNotifier<bool> _belumSelesai = ValueNotifier(false);

  /// Bernilai `true` selama masih ada perubahan di perangkat ini yang belum
  /// diterima server. Layar dapat menggunakannya untuk menandai status
  /// "belum tersinkron".
  ValueListenable<bool> get menungguSinkron => _belumSelesai;

  /// Dipanggil ketika versi dari perangkat lain ternyata lebih baru dan data
  /// di perangkat ini telah diganti dengan versi tersebut: layar perlu memuat
  /// ulang tampilannya.
  void Function(FarmSnapshot berlaku)? padaTarikUlang;

  bool _bisa(PemilikData p) => _server.tersedia && p.punyaUid;

  @override
  Future<FarmSnapshot?> muat(PemilikData pemilik) async {
    _pemilik = pemilik;
    final lokal = await _lokal.muat(pemilik);
    if (!_bisa(pemilik)) return lokal;
    try {
      final (berlaku, dariServer) = await _adu(pemilik, lokal);
      _gagalBeruntun = 0;
      _belumSelesai.value = false;
      if (dariServer) _jadwal?.cancel();
      return berlaku;
    } catch (e) {
      debugPrint('[ sinkron ] server belum terjangkau, pakai data lokal: $e');
      if (lokal != null) _jadwalkan();
      return lokal;
    }
  }

  @override
  Future<void> simpan(PemilikData pemilik, FarmSnapshot snapshot) async {
    await _lokal.simpan(pemilik, snapshot);
    if (!_bisa(pemilik)) return;
    _pemilik = pemilik;
    _jadwalkan();
  }

  /// Mengirim data saat itu juga tanpa menunggu jeda otomatis. Sekaligus
  /// menarik perubahan dari perangkat lain, sehingga cocok untuk tombol
  /// "Sinkronkan".
  Future<void> cobaSinkronLagi() async {
    final p = _pemilik;
    if (p == null || !_bisa(p)) return;
    _jadwal?.cancel();
    await _kirim();
    // Percobaan pertama dapat selesai dengan hanya menunggu antrean yang
    // sebelumnya gagal; pastikan perubahan benar-benar terkirim sebelum
    // mengembalikan kontrol.
    if (_belumSelesai.value) await _kirim();
  }

  void _jadwalkan() {
    _belumSelesai.value = true;
    _jadwal?.cancel();
    _jadwal = Timer(_tunggu, _kirim);
  }

  /// Kegagalan berulang (misalnya perangkat dalam mode pesawat) tidak boleh
  /// memicu pengiriman terus-menerus: jedanya membesar hingga paling lama
  /// satu menit.
  Duration get _tunggu {
    if (_gagalBeruntun == 0) return _jeda;
    return _jeda * (1 << (_gagalBeruntun > 4 ? 4 : _gagalBeruntun));
  }

  /// Hanya satu pengiriman pada satu waktu. Pemanggil lain ikut menunggu
  /// pengiriman yang sedang berjalan daripada menulis dua kali untuk data
  /// yang sama.
  Future<void> _kirim() async {
    final p = _pemilik;
    if (p == null || !_bisa(p)) return;
    final sedang = _sedang;
    if (sedang != null) return sedang;
    final jalan = _kirimSekarang(p);
    _sedang = jalan;
    try {
      await jalan;
    } finally {
      _sedang = null;
    }
  }

  Future<void> _kirimSekarang(PemilikData p) async {
    try {
      final lokal = await _lokal.muat(p);
      final (berlaku, dariServer) = await _adu(p, lokal);
      _gagalBeruntun = 0;
      _belumSelesai.value = false;
      if (dariServer && berlaku != null) padaTarikUlang?.call(berlaku);
    } catch (e) {
      _gagalBeruntun++;
      debugPrint('[ sinkron ] belum terkirim (percobaan $_gagalBeruntun): $e');
      _jadwalkan();
    }
  }

  /// Titik pertemuan dua versi. Versi yang lebih baru menang; versi yang kalah
  /// disimpan utuh di server sebelum tertimpa, sehingga tidak ada catatan
  /// pengguna yang hilang tanpa jejak. Mengembalikan pasangan
  /// (versi berlaku, apakah asalnya dari server).
  Future<(FarmSnapshot?, bool)> _adu(
    PemilikData p,
    FarmSnapshot? lokal,
  ) async {
    final server = await _server.baca(p);
    if (lokal == null) {
      if (server == null) return (null, false);
      await _lokal.simpan(p, server);
      return (server, true);
    }
    if (server == null || server.diubahMs <= lokal.diubahMs) {
      await _server.tulis(p, lokal);
      return (lokal, false);
    }
    await _server.simpanKonflik(
      p,
      lokal,
      'perubahan perangkat ini kalah saat sinkronisasi',
    );
    await _lokal.simpan(p, server);
    return (server, true);
  }

  void dispose() {
    _jadwal?.cancel();
    _belumSelesai.dispose();
  }
}
