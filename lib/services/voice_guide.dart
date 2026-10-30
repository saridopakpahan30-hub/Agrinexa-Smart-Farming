import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/i18n.dart';

enum VoiceStatus { menunggu, siap, tidakAdaSuaraBahasa, tidakAdaEngine }

/// Pembaca teks kerja ladang dalam bahasa aplikasi.
///
/// Suara memakai engine bawaan perangkat (Android) atau SpeechSynthesis
/// peramban (web), sehingga tidak memerlukan layanan eksternal, API key,
/// maupun biaya langganan.
///
/// [setLanguage] gagal secara senyap: bila perangkat tidak memiliki suara
/// untuk bahasa yang dipilih, teks tetap dibacakan dengan logat bahasa lain.
/// Karena itu daftar suara diperiksa lebih dulu melalui [siapkan].
class VoiceGuide {
  VoiceGuide();

  /// Dibuat malas: konstruktor [FlutterTts] menyentuh binary messenger, sehingga
  /// pemanggilan sebelum binding siap akan melempar exception.
  FlutterTts? _tts;

  VoiceStatus status = VoiceStatus.menunggu;
  String voiceName = '';
  bool speaking = false;

  bool _sedangMemeriksa = false;
  Completer<void>? _selesaiMemeriksa;

  bool get siap => status == VoiceStatus.siap;

  FlutterTts get _engine => _tts ??= FlutterTts();

  /// Periksa ulang — berguna di web, karena daftar suara sering baru terisi
  /// beberapa saat setelah halaman dibuka.
  void ulangi() {
    if (_sedangMemeriksa) return;
    status = VoiceStatus.menunggu;
    voiceName = '';
  }

  /// Dipanggil sekali per sesi: cari suara untuk bahasa aktif, lalu gunakan.
  Future<void> siapkan() async {
    if (status != VoiceStatus.menunggu) return;
    if (_sedangMemeriksa) return _selesaiMemeriksa!.future;
    _sedangMemeriksa = true;
    _selesaiMemeriksa = Completer<void>();
    final target = Lang.inggris ? 'en' : 'id';
    try {
      // Sebagian engine tidak pernah menjawab, sehingga pencarian diberi batas
      // waktu agar status tidak tertahan pada "Menyiapkan suara…".
      final semua = await _daftarSuara()
          .timeout(const Duration(seconds: 2), onTimeout: () => const []);
      final cocok = semua
          .where((v) => (v['locale'] ?? '').toLowerCase().startsWith(target))
          .toList()
        ..sort((a, b) => _mutu(b, target).compareTo(_mutu(a, target)));
      if (cocok.isEmpty) {
        status = semua.isEmpty
            ? VoiceStatus.tidakAdaEngine
            : VoiceStatus.tidakAdaSuaraBahasa;
      } else {
        final pilih = cocok.first;
        await _engine
            .setLanguage(pilih['locale'] ?? (Lang.inggris ? 'en-US' : 'id-ID'));
        await _engine.setSpeechRate(0.42);
        await _engine.setPitch(1.0);
        voiceName = pilih['name'] ?? '';
        status = VoiceStatus.siap;
      }
    } catch (_) {
      status = VoiceStatus.tidakAdaEngine;
    } finally {
      _sedangMemeriksa = false;
      _selesaiMemeriksa!.complete();
    }
  }

  /// Di Chrome daftar suara baru terisi beberapa saat setelah halaman dibuka,
  /// sehingga daftar yang kosong belum berarti suara tidak tersedia. Di
  /// Android/iOS daftar langsung siap dan tidak perlu menunggu.
  Future<List<Map<String, String>>> _daftarSuara() async {
    for (var percobaan = 0; percobaan < (kIsWeb ? 4 : 1); percobaan++) {
      final daftar = await _suara();
      if (daftar.isNotEmpty) return daftar;
      if (!kIsWeb) break;
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    return const [];
  }

  Future<List<Map<String, String>>> _suara() async {
    final hasil = await _engine.getVoices;
    return [
      for (final v in (hasil as List? ?? const []))
        Map<String, String>.from(v as Map)
    ];
  }

  static int _mutu(Map<String, String> v, String target) {
    var skor = 0;
    if ((v['locale'] ?? '').toLowerCase() ==
        (target == 'en' ? 'en-us' : 'id-id')) {
      skor += 4;
    }
    final kualitas = (v['quality'] ?? '').toLowerCase();
    if (kualitas.contains('very high')) skor += 3;
    if (kualitas == 'high') skor += 2;
    if (v['network_required'] == '0') skor += 1;
    return skor;
  }

  Future<void> speak(String teks) async {
    await siapkan();
    if (!siap || teks.isEmpty) return;
    try {
      await _engine.stop();
      speaking = true;
      await _engine.speak(teks);
    } catch (_) {
      status = VoiceStatus.tidakAdaEngine;
    } finally {
      speaking = false;
    }
  }

  Future<void> stop() async {
    if (!siap) return;
    try {
      await _engine.stop();
    } catch (_) {
      status = VoiceStatus.tidakAdaEngine;
    }
  }
}
