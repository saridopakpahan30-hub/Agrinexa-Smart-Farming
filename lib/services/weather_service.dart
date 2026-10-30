import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:http/http.dart' as http;

import '../core/i18n.dart';
import 'gps_service.dart';

/// Prakiraan cuaca nyata dari Open-Meteo (gratis, tanpa API key).
/// Bila jaringan gagal, hasil terakhir dari cache dipakai; apabila belum ada
/// cache, digunakan simulasi pola musiman agar tampilan tetap terisi.
class WeatherDay {
  final DateTime date;
  final String condition; // cerah | berawan | hujan | hujan_lebat | panas
  final double minTemp, maxTemp, rainProb, humidity;

  const WeatherDay({
    required this.date,
    required this.condition,
    required this.minTemp,
    required this.maxTemp,
    required this.rainProb,
    required this.humidity,
  });

  String get label => switch (condition) {
        'cerah' => 'Cerah',
        'berawan' => 'Berawan',
        'hujan' => 'Hujan ringan',
        'hujan_lebat' => 'Hujan lebat',
        _ => 'Panas terik',
      };

  Map<String, dynamic> toJson() => {
        'd': date.toIso8601String(),
        'c': condition,
        'lo': minTemp,
        'hi': maxTemp,
        'p': rainProb,
        'h': humidity,
      };

  factory WeatherDay.fromJson(Map<String, dynamic> j) => WeatherDay(
        date: DateTime.parse(j['d'] as String),
        condition: j['c'] as String,
        minTemp: (j['lo'] as num).toDouble(),
        maxTemp: (j['hi'] as num).toDouble(),
        rainProb: (j['p'] as num).toDouble(),
        humidity: (j['h'] as num).toDouble(),
      );
}

class WeatherSnapshot {
  final List<WeatherDay> days;
  final DateTime fetchedAt;
  final bool live; // true = data Open-Meteo, false = cache/simulasi
  final String note;

  const WeatherSnapshot({
    required this.days,
    required this.fetchedAt,
    required this.live,
    this.note = '',
  });

  WeatherDay get today => days.first;

  Map<String, dynamic> toJson() => {
        'days': days.map((d) => d.toJson()).toList(),
        'at': fetchedAt.toIso8601String(),
      };

  factory WeatherSnapshot.fromJson(Map<String, dynamic> j) => WeatherSnapshot(
        days: [
          for (final d in j['days'] as List)
            WeatherDay.fromJson(Map<String, dynamic>.from(d as Map))
        ],
        fetchedAt: DateTime.parse(j['at'] as String),
        live: false,
        note: 'Ditampilkan dari cache terakhir',
      );
}

class Place {
  final String name;
  final String region;
  final String cc;
  final double lat;
  final double lon;

  const Place(
      {required this.name,
      required this.region,
      required this.lat,
      required this.lon,
      this.cc = ''});

  String get full => region.isEmpty ? name : '$name, $region';
}

class WeatherService {
  static const _forecastUrl = 'https://api.open-meteo.com/v1/forecast';
  static const _geocodeUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const _ipUrl = 'https://get.geojs.io/v1/ip/geo.json';
  static const _nominatimUrl = 'https://nominatim.openstreetmap.org';
  static const _ua = 'Agrinexa/1.0 (https://agrinexa-5082d.web.app)';

  static String liveNote(WeatherSnapshot w) => w.live
      ? tpl('Cuaca nyata dari Open-Meteo, diperbarui {0}.', [
          '${w.fetchedAt.hour.toString().padLeft(2, '0')}:'
              '${w.fetchedAt.minute.toString().padLeft(2, '0')}',
        ])
      : (w.note.isEmpty
          ? tr('Cuaca simulasi — periksa koneksi untuk data nyata.')
          : tpl('{0}. Periksa koneksi untuk memperbarui.', [tr(w.note)]));

  /// Lokasi kebun dari perangkat: GPS diprioritaskan, alamat jaringan menjadi
  /// cadangan. GPS memerlukan persetujuan pengguna dan dapat gagal (izin
  /// ditolak, GPS nonaktif, atau berada di dalam gedung), sehingga kegagalan
  /// tidak pernah menghentikan aplikasi — hanya kembali ke perkiraan lama.
  static Future<Place> lokasiPerangkat() async {
    try {
      final g = await GpsService.ambil();
      try {
        return await alamatDari(g.lat, g.lon);
      } catch (e) {
        debugPrint('[lokasi] posisi dapat, alamat tidak terdata: $e');
        return Place(
            name: tr('Lokasi GPS'), region: '', lat: g.lat, lon: g.lon);
      }
    } catch (e) {
      debugPrint('[lokasi] GPS gagal, kembali ke alamat IP: $e');
      return detectLocation();
    }
  }

  /// Perkiraan lokasi dari alamat IP perangkat, tanpa izin dan tanpa API key.
  static Future<Place> detectLocation() async {
    final res =
        await http.get(Uri.parse(_ipUrl)).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final lat = double.parse(j['latitude'] as String);
    final lon = double.parse(j['longitude'] as String);
    final city = (j['city'] as String?)?.trim() ?? '';
    if (city.isEmpty) throw Exception('kota tidak dikenali');
    return Place(
        name: city,
        region: (j['region'] as String?)?.trim() ?? '',
        lat: lat,
        lon: lon);
  }

  /// Alamat sesungguhnya dari satu koordinat: dusun/desa, kecamatan, kabupaten.
  static Future<Place> alamatDari(double lat, double lon) async {
    final uri = Uri.parse('$_nominatimUrl/reverse').replace(queryParameters: {
      'lat': lat.toStringAsFixed(6),
      'lon': lon.toStringAsFixed(6),
      'format': 'jsonv2',
      'zoom': '16',
      'addressdetails': '1',
      'accept-language': 'id',
    });
    return placeDariNominatim(
        Map<String, dynamic>.from(await _json(uri) as Map));
  }

  /// Petakan satu hasil OpenStreetMap menjadi [Place].
  ///
  /// Penamaannya tidak seragam antar daerah: bagian paling spesifik dapat
  /// berupa hamlet, village, suburb, atau quarter, sedangkan kecamatan muncul
  /// pada kolom municipality maupun county. Karena itu urutan dicari dari yang
  /// paling spesifik hingga yang paling luas, bukan dengan mengandaikan satu
  /// kolom tetap.
  static Place placeDariNominatim(Map<String, dynamic> j) {
    final a = (j['address'] as Map?)?.cast<String, dynamic>() ?? const {};
    String? bagian(String k) {
      final v = a[k];
      return v is String && v.trim().isNotEmpty ? v.trim() : null;
    }

    final urut = <String?>[
      bagian('hamlet'),
      bagian('village'),
      bagian('suburb'),
      bagian('neighbourhood'),
      bagian('quarter'),
      bagian('town'),
      bagian('municipality'),
      bagian('city_district'),
      bagian('county'),
      bagian('city'),
      bagian('state'),
      bagian('road'),
    ].whereType<String>().toList();
    final unik = <String>[];
    for (final b in urut) {
      if (!unik.contains(b)) unik.add(b);
    }
    // Nama tempat itu sendiri (mis. "Gunung Salak", "Kantor Kecamatan Cisoka")
    // lebih informatif sebagai baris pertama daripada nama kabupaten.
    final namaUmum = (j['name'] as String?)?.trim() ?? '';
    final sisanya = unik.where((b) => b != namaUmum).toList();
    final luas = namaUmum.isEmpty ? sisanya.skip(1) : sisanya;
    return Place(
      name: namaUmum.isEmpty
          ? (sisanya.isEmpty ? '' : sisanya.first)
          : namaUmum,
      // Dibatasi tiga bagian: cukup untuk "desa, kecamatan, kabupaten" dan
      // masih muat pada satu baris tampilan.
      region: luas.take(3).join(', '),
      lat: double.parse(j['lat'] as String),
      lon: double.parse(j['lon'] as String),
    );
  }

  /// GET yang mengembalikan JSON. Ketentuan penggunaan Nominatim mewajibkan
  /// User-Agent yang menyebutkan aplikasinya; peramban melarang header tersebut
  /// diisi secara manual, sehingga hanya dikirim pada Android.
  static Future<Object?> _json(Uri uri) async {
    final res = await http
        .get(uri, headers: kIsWeb ? null : const {'User-Agent': _ua})
        .timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    return jsonDecode(res.body);
  }

  /// Ambil prakiraan 7 hari. Melempar [Exception] bila jaringan/API gagal.
  static Future<WeatherSnapshot> fetch(double lat, double lon) async {
    final uri = Uri.parse(_forecastUrl).replace(queryParameters: {
      'latitude': lat.toStringAsFixed(4),
      'longitude': lon.toStringAsFixed(4),
      'current': 'relative_humidity_2m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max,precipitation_sum',
      'timezone': 'auto',
      'forecast_days': '7',
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final daily = j['daily'] as Map<String, dynamic>;
    final codes = (daily['weather_code'] as List).cast<num>();
    final hi = (daily['temperature_2m_max'] as List).cast<num>();
    final lo = (daily['temperature_2m_min'] as List).cast<num>();
    final prob =
        (daily['precipitation_probability_max'] as List?)?.cast<num?>();
    final rain = (daily['precipitation_sum'] as List?)?.cast<num?>();
    final dates = (daily['time'] as List).cast<String>();
    final nowHum =
        ((j['current'] as Map?)?['relative_humidity_2m'] as num?)?.toDouble();
    if (codes.isEmpty) throw Exception('data cuaca kosong');

    return WeatherSnapshot(
      fetchedAt: DateTime.now(),
      live: true,
      days: [
        for (var i = 0; i < dates.length; i++)
          WeatherDay(
            date: DateTime.parse(dates[i]),
            condition: _condition(codes[i].toInt(), hi[i].toDouble()),
            minTemp: lo[i].toDouble(),
            maxTemp: hi[i].toDouble(),
            rainProb: (prob?[i] ?? 0).toDouble() / 100,
            humidity: i == 0 && nowHum != null
                ? nowHum
                : (55 + (rain?[i] ?? 0).toDouble() * 6).clamp(45.0, 98.0),
          ),
      ],
    );
  }

  /// Peta kode cuaca WMO menjadi kondisi lokal aplikasi.
  static String _condition(int code, double maxTemp) {
    final c = switch (code) {
      0 || 1 => 'cerah',
      2 || 3 || 45 || 48 => 'berawan',
      51 ||
      53 ||
      55 ||
      56 ||
      57 ||
      61 ||
      63 ||
      66 ||
      67 ||
      71 ||
      73 ||
      75 ||
      77 ||
      80 ||
      85 ||
      86 =>
        'hujan',
      65 || 81 || 82 || 95 || 96 || 99 => 'hujan_lebat',
      _ => 'berawan',
    };
    if (c == 'cerah' && maxTemp >= 35) return 'panas';
    return c;
  }

  /// Cari alamat asli: dusun, desa, kelurahan, kecamatan, atau kota.
  static Future<List<Place>> searchPlace(String query) async {
    final uri = Uri.parse('$_nominatimUrl/search').replace(queryParameters: {
      'q': query.trim(),
      'format': 'jsonv2',
      'limit': '12',
      'countrycodes': 'id',
      'addressdetails': '1',
      'accept-language': 'id',
    });
    try {
      final hasil = (await _json(uri) as List)
          .map((r) => placeDariNominatim(Map<String, dynamic>.from(r as Map)))
          .where((p) => p.name.isNotEmpty)
          .toList();
      if (hasil.isNotEmpty) return hasil;
    } catch (e) {
      debugPrint('[lokasi] pencarian alamat gagal: $e');
    }
    // OpenStreetMap disusun oleh sukarelawan: sebuah dusun kecil bisa belum
    // tercatat. Geocoding kota tetap mengenal kabupaten dan kecamatan, sehingga
    // sumber itu dipakai sebagai cadangan.
    return _kotaOpenMeteo(query);
  }

  static Future<List<Place>> _kotaOpenMeteo(String query) async {
    final uri = Uri.parse(_geocodeUrl).replace(queryParameters: {
      'name': query.trim(),
      'count': '20',
      'language': 'id',
      'format': 'json',
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final semua = [
      for (final r in (j['results'] as List? ?? []).cast<Map>())
        Place(
          name: r['name'] as String,
          region: [
            r['admin2'],
            r['admin1'],
          ].whereType<String>().where((s) => s.isNotEmpty).join(', '),
          cc: (r['country_code'] as String?) ?? '',
          lat: (r['latitude'] as num).toDouble(),
          lon: (r['longitude'] as num).toDouble(),
        )
    ];
    // Prioritaskan tempat di Indonesia; bila tidak ada, gunakan hasil lainnya.
    final id = semua.where((p) => p.cc == 'ID').toList();
    return id.isEmpty ? semua : id;
  }

  /// Simulasi pola musiman sebagai cadangan tanpa jaringan: basah Nov–Mar.
  static WeatherSnapshot simulated() {
    final now = DateTime.now();
    return WeatherSnapshot(
      fetchedAt: now,
      live: false,
      note: 'Cuaca simulasi — tidak ada data nyata',
      days: [
        for (var i = 0; i < 7; i++)
          _simDay(DateTime(now.year, now.month, now.day + i))
      ],
    );
  }

  static double _noise(int n) {
    final x = math.sin(n * 78.233) * 43758.5453;
    return x - x.floorToDouble();
  }

  static int _dayIndex(DateTime d) => DateTime.utc(d.year, d.month, d.day)
      .difference(DateTime.utc(2024, 1, 1))
      .inDays;

  static WeatherDay _simDay(DateTime d) {
    final di = _dayIndex(d);
    final wet = 0.5 + 0.45 * math.cos((d.month - 1.2) / 12.0 * 2 * math.pi);
    final r = _noise(di * 7 + 3);
    final rainProb = (wet * 0.75 + r * 0.35).clamp(0.05, 0.97);
    final condition = rainProb > 0.75
        ? 'hujan_lebat'
        : rainProb > 0.5
            ? 'hujan'
            : r > 0.82
                ? 'panas'
                : r > 0.45
                    ? 'berawan'
                    : 'cerah';
    final heat = condition == 'panas'
        ? 4.0
        : condition == 'cerah'
            ? 2.0
            : -2.0;
    final minT = 22 + heat * 0.4 + _noise(di * 13 + 5) * 2;
    return WeatherDay(
      date: d,
      condition: condition,
      minTemp: minT,
      maxTemp: minT + 8 + heat + _noise(di * 17 + 9) * 3,
      rainProb: rainProb,
      humidity: (55 + rainProb * 40).clamp(45, 98),
    );
  }

  /// Saran aktivitas untuk kondisi [w].
  static List<String> advice(WeatherDay w) {
    final out = <String>[];
    switch (w.condition) {
      case 'hujan_lebat':
        out.addAll([
          tr('Tunda tanam bibit baru — risiko benih hanyut dan busuk pangkal.'),
          tr('Periksa drainase bedengan; genangan > 6 jam membahayakan akar.'),
          tr('Kosongkan penyiraman hari ini.'),
          tr('Semprotan pestisida/fungisida akan luntur — tunda sampai kering.'),
        ]);
      case 'hujan':
        out.addAll([
          tr('Siram cukup bila tanah masih lembap; cek dengan jari sedalam 2 cm.'),
          tr('Waktu baik menanam: tanah lembap membantu akar menempel.'),
          tr('Waspadai jamur daun pada tanaman padat — longgarkan pangkas.'),
        ]);
      case 'berawan':
        out.addAll([
          tr('Kondisi ideal untuk pemupukan akar — larut perlahan tanpa penguapan.'),
          tr('Bisa tanam maupun semprot tanpa cepat menguap.'),
        ]);
      case 'panas':
        out.addAll([
          tr('Siram pagi sebelum jam 7 atau sore setelah jam 4.'),
          tr('Pasang mulsa/teduhan untuk bibit yang baru pindah tanam.'),
          tr('Hindari semprot pestisida — uap panas meningkatkan risiko fitotoksisitas.'),
        ]);
      default: // cerah
        out.addAll([
          tr('Cocok untuk panen: keringkan hasil panen langsung di bawah matahari.'),
          tr('Pupuk susulan larut baik bila disiram setelahnya.'),
          tr('Cek kelembapan tanah siang ini; siram bila kering.'),
        ]);
    }
    if (w.rainProb >= 0.6 &&
        w.condition != 'hujan_lebat' &&
        w.condition != 'hujan') {
      out.add(tpl(
          'Peluang hujan {0}% nanti — siapkan penutup untuk hasil panen yang sedang dijemur.',
          [(w.rainProb * 100).round().toString()]));
    }
    return out;
  }
}
