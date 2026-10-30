import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../services/weather_service.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/location_picker.dart';

IconData weatherIcon(String condition) => switch (condition) {
      'cerah' => Icons.wb_sunny_rounded,
      'berawan' => Icons.cloud_rounded,
      'hujan' => Icons.water_drop_rounded,
      'hujan_lebat' => Icons.thunderstorm_rounded,
      _ => Icons.local_fire_department_rounded,
    };

List<Color> weatherColors(String condition) => switch (condition) {
      'cerah' => const [Color(0xFF1B7F3B), Color(0xFF5FA845)],
      'berawan' => const [Color(0xFF4B6A5C), Color(0xFF7FA08E)],
      'hujan' => const [Color(0xFF2F5D75), Color(0xFF4E8FA8)],
      'hujan_lebat' => const [Color(0xFF24435C), Color(0xFF3C6E8F)],
      _ => const [Color(0xFFB86A00), Color(0xFFE0A800)],
    };

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _sudahTarik = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sudahTarik) return;
    _sudahTarik = true;
    final s = AppScope.of(context);
    if (s.weather == null) s.refreshWeather();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final snap = s.weather;
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const UiText('Cuaca & Saran Tanam'),
          UiText(s.locationReady ? s.farmCity : 'Lokasi belum dipilih',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted)),
        ]),
        actions: [
          IconButton(
            tooltip: tr('Ubah lokasi kebun'),
            icon: const Icon(Icons.place_outlined),
            onPressed: () => showLocationPicker(context),
          ),
          IconButton(
            tooltip: tr('Perbarui'),
            icon: s.weatherBusy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2.2))
                : const Icon(Icons.refresh_rounded),
            onPressed: (s.weatherBusy || !s.locationReady)
                ? null
                : () => s.refreshWeather(),
          ),
        ],
      ),
      body: snap == null
          ? (!s.locationReady
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Panel(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.place_outlined,
                              size: 34, color: AppColors.green),
                          const SizedBox(height: 10),
                          const UiText('Pilih lokasi kebun',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          UiText(
                              'Cuaca diambil dari Open-Meteo untuk koordinat '
                              'daerah Anda — semua kota dan kecamatan di '
                              'Indonesia tersedia.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.muted,
                                  height: 1.4)),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: () => showLocationPicker(context),
                            icon: const Icon(Icons.search_rounded, size: 18),
                            label: const UiText('Cari daerah saya'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Skeleton(height: 26, width: 190, radius: 20),
                    ),
                    const SizedBox(height: 12),
                    const Skeleton(height: 172, radius: 18),
                    const SizedBox(height: 26),
                    const Skeleton(height: 16, width: 150, radius: 8),
                    const SizedBox(height: 10),
                    const Skeleton(height: 250, radius: 14),
                    const SizedBox(height: 26),
                    UiText('Mengambil prakiraan cuaca…',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: AppColors.muted)),
                  ],
                ))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _SourcePill(snapshot: snap),
                const SizedBox(height: 10),
                _TodayCard(day: snap.today),
                const SectionTitle('Prakiraan 7 Hari'),
                Panel(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(children: [
                    for (var i = 0; i < snap.days.length; i++) ...[
                      _ForecastRow(day: snap.days[i], isToday: i == 0),
                    ],
                  ]),
                ),
                const SectionTitle('Saran Untuk Hari Ini'),
                for (final a in WeatherService.advice(snap.today))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Panel(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                size: 18, color: AppColors.sun),
                            const SizedBox(width: 10),
                            Expanded(
                                child: UiText(a,
                                    style: const TextStyle(
                                        fontSize: 14, height: 1.4))),
                          ]),
                    ),
                  ),
                _PlantingAlert(state: s, days: snap.days),
                Panel(
                  color: AppColors.mint,
                  child: Row(children: [
                    Icon(Icons.info_outline_rounded,
                        size: 18, color: AppColors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: UiText(WeatherService.liveNote(snap),
                          style:
                              TextStyle(fontSize: 13, color: AppColors.green)),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}

class _SourcePill extends StatelessWidget {
  final WeatherSnapshot snapshot;
  const _SourcePill({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    // Kapsul "belum terhubung" mengikuti palet: warna krem tetap terbaca pada
    // mode gelap karena latar, garis tepi, dan tintanya satu keluarga.
    final live = snapshot.live;
    final latar = live ? AppColors.mint : AppColors.sunTint;
    final garis = live ? AppColors.green : AppColors.sunTintLine;
    final tinta = live ? AppColors.green : AppColors.sunInk;
    return Row(children: [
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: latar,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: garis),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              snapshot.live
                  ? Icons.cloud_done_rounded
                  : Icons.cloud_off_rounded,
              size: 14,
              color: tinta,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: UiText(
                  snapshot.live ? 'Data cuaca nyata' : 'Data belum terhubung',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w800, color: tinta)),
            ),
          ]),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: UiText(tpl('{0} hari', ['${snapshot.days.length}']),
              maxLines: 1,
              style: TextStyle(fontSize: 13, color: AppColors.muted)),
        ),
      ),
    ]);
  }
}

class _TodayCard extends StatelessWidget {
  final WeatherDay day;
  const _TodayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final colors = weatherColors(day.condition);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 6))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiText(tanggalPanjang(day.date),
            style: TextStyle(fontSize: 14, color: Colors.white.o(0.85))),
        const SizedBox(height: 10),
        Row(children: [
          Icon(weatherIcon(day.condition), size: 56, color: AppColors.sun),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiText(day.label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              UiText(
                  '${day.minTemp.round()}°C – ${day.maxTemp.round()}°C • '
                  'kelembapan ${day.humidity.round()}%',
                  style: TextStyle(fontSize: 14, color: Colors.white.o(0.9))),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _ProbBar('Peluang hujan', day.rainProb)),
        ]),
      ]),
    );
  }
}

class _ProbBar extends StatelessWidget {
  final String label;
  final double v;
  const _ProbBar(this.label, this.v);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            UiText(label,
                style: TextStyle(fontSize: 13, color: Colors.white.o(0.85))),
            UiText('${(v * 100).round()}%',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ]),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: v,
              minHeight: 6,
              backgroundColor: Colors.white.o(0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      );
}

class _ForecastRow extends StatelessWidget {
  final WeatherDay day;
  final bool isToday;
  const _ForecastRow({required this.day, required this.isToday});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        child: Row(children: [
          SizedBox(
            width: 52,
            child: UiText(isToday ? 'Hari ini' : _hariSingkat(day.date),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                    color: isToday ? AppColors.green : AppColors.text)),
          ),
          Icon(weatherIcon(day.condition), size: 20, color: AppColors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: UiText(day.label,
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ),
          UiText('${(day.rainProb * 100).round()}%',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.aksen(const Color(0xFF2F5D75)))),
          const SizedBox(width: 12),
          SizedBox(
            width: 74,
            child: UiText('${day.minTemp.round()}° / ${day.maxTemp.round()}°',
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ]),
      );
}

String _hariSingkat(DateTime d) =>
    const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'][d.weekday - 1];

/// Peringatan silang: jadwal panen dekat + prakiraan hujan.
class _PlantingAlert extends StatelessWidget {
  final AppState state;
  final List<WeatherDay> days;
  const _PlantingAlert({required this.state, required this.days});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final clean = DateTime(now.year, now.month, now.day);
    final wetSoon = days
        .where((d) =>
            d.rainProb > 0.7 && !d.date.difference(clean).inDays.isNegative)
        .toList();
    final alerts = <String>[];
    for (final p in state.plantings) {
      final start = DateTime(p.start.year, p.start.month, p.start.day);
      final harvest = start.add(Duration(days: p.commodity.growDays));
      final diff = harvest.difference(clean).inDays;
      if (diff >= -3 && diff <= 5 && wetSoon.isNotEmpty) {
        alerts.add('Panen ${p.commodity.name} perkiraan '
            '${tanggalPendek(harvest)} bertepatan dengan hujan lebat — '
            'panen lebih awal agar hasil tidak membusuk.');
      }
    }
    if (alerts.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      for (final a in alerts)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Panel(
            color: AppColors.downTint,
            border: AppColors.downTintLine,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.warning_rounded, size: 18, color: AppColors.down),
              const SizedBox(width: 10),
              Expanded(
                  child: UiText(a,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: AppColors.downInk))),
            ]),
          ),
        ),
    ]);
  }
}
