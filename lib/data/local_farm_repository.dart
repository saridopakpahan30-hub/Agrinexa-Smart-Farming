import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/farm_activity.dart';
import '../models/farm_settings.dart';
import '../models/ledger.dart';
import '../models/optimization_run.dart';
import '../models/planting.dart';
import '../models/plot.dart';
import '../models/sim_record.dart';
import 'farm_repository.dart';

/// Penyimpanan kebun yang hanya ada di perangkat ini (SharedPreferences).
///
/// Kunci datanya `data_<email>` dengan isi persis seperti format yang
/// digunakan aplikasi sebelum lapisan repository ini ada, sehingga data
/// pengguna lama tetap terbaca tanpa migrasi.
class LocalFarmRepository implements FarmRepository {
  const LocalFarmRepository(this._p);

  static const _prefix = 'data_';
  final SharedPreferences _p;

  static List<Map<String, dynamic>> _list(dynamic v) =>
      [for (final e in (v as List? ?? [])) Map<String, dynamic>.from(e as Map)];

  @override
  Future<FarmSnapshot?> muat(PemilikData pemilik) async {
    final raw = _p.getString('$_prefix${pemilik.akun}');
    if (raw == null) return null;
    // Ikut berada di dalam try: field yang hilang pada data buatan versi lama
    // juga menyebabkan fromJson melempar error, dan kondisi itu harus berarti
    // "mulai dari kosong", bukan aplikasi berhenti saat dinyalakan.
    try {
      final m = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      return FarmSnapshot(
        settings: FarmSettings.fromJson(m),
        history: [for (final j in _list(m['history'])) SimRecord.fromJson(j)],
        ledger: [for (final j in _list(m['ledger'])) LedgerEntry.fromJson(j)],
        plantings: [
          for (final j in _list(m['plantings'])) Planting.fromJson(j)
        ],
        plots: [for (final j in _list(m['plots'])) Plot.fromJson(j)],
        activities: [
          for (final j in _list(m['activities'])) FarmActivity.fromJson(j)
        ],
        optimizations: [
          for (final j in _list(m['optimizations'])) OptimizationRun.fromJson(j)
        ],
        diubahMs: (m['diubahMs'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      debugPrint('[ kebun ] data tersimpan rusak, mulai dari kosong: $e');
      return null;
    }
  }

  @override
  Future<void> simpan(PemilikData pemilik, FarmSnapshot s) => _p.setString(
        '$_prefix${pemilik.akun}',
        jsonEncode({
          ...s.settings.toJson(),
          'history': [for (final h in s.history) h.toJson()],
          'ledger': [for (final l in s.ledger) l.toJson()],
          'plantings': [for (final p in s.plantings) p.toJson()],
          'plots': [for (final p in s.plots) p.toJson()],
          'activities': [for (final a in s.activities) a.toJson()],
          'optimizations': [for (final o in s.optimizations) o.toJson()],
          'diubahMs': s.diubahMs,
        }),
      );
}
