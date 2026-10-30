import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';

double _nice(double x) {
  if (x <= 0) return 1;
  final e = math.pow(10, (math.log(x) / math.ln10).floor()).toDouble();
  final f = x / e;
  final n = f < 1.5 ? 1 : (f < 3 ? 2 : (f < 7 ? 5 : 10));
  return n * e;
}

/// Label sumbu yang ringkas: 1.480.000 menjadi "1,48 jt", 26.500 menjadi
/// "26,5 rb".
String _kompak(int v) {
  String angka(double x) {
    var s = x == x.roundToDouble()
        ? x.toStringAsFixed(0)
        : x.toStringAsFixed(2).replaceAll('.', ',');
    if (s.contains(',')) {
      while (s.endsWith('0')) {
        s = s.substring(0, s.length - 1);
      }
      if (s.endsWith(',')) s = s.substring(0, s.length - 1);
    }
    return s;
  }

  if (v >= 1000000) return '${angka(v / 1000000)} jt';
  if (v >= 1000) return '${angka(v / 1000)} rb';
  return '$v';
}

/// Tren tujuh hingga empat belas hari tanpa sumbu, cukup muat dalam satu baris
/// daftar.
class SparkLine extends StatelessWidget {
  final List<double> data;
  final Color? color;
  final double width, height;
  const SparkLine(this.data,
      {super.key, this.color, this.width = 64, this.height = 28});

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) {
      return SizedBox(width: width, height: height);
    }
    final col = color ?? AppColors.green;
    final minV = data.reduce(math.min), maxV = data.reduce(math.max);
    final span = (maxV - minV) < 1 ? 1.0 : (maxV - minV);
    const hide = AxisTitles(sideTitles: SideTitles(showTitles: false));
    return SizedBox(
      width: width,
      height: height,
      child: LineChart(LineChartData(
        minY: minV - span * 0.3,
        maxY: maxV + span * 0.3,
        lineTouchData: const LineTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
            leftTitles: hide,
            rightTitles: hide,
            topTitles: hide,
            bottomTitles: hide),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < data.length; i++)
                FlSpot(i.toDouble(), data[i])
            ],
            isCurved: true,
            curveSmoothness: 0.32,
            color: col,
            barWidth: 1.8,
            dotData: const FlDotData(show: false),
            // Isian area: pada latar gelap 15% hampir tidak terlihat, sehingga
            // dibuat lebih pekat.
            belowBarData: BarAreaData(
                show: true, color: col.o(AppColors.gelap ? 0.3 : 0.15)),
          ),
        ],
      )),
    );
  }
}

/// fl_chart bawaan menampilkan gelembung abu-abu gelap dengan teks sewarna
/// garis, sehingga angka hijau di atasnya tidak terbaca. Ini gaya seragam untuk
/// seluruh grafik: gelembung sewarna kartu, garis tepi tipis, dan angka diformat
/// Rupiah.
///
/// Ditulis sebagai fungsi, bukan `final` tingkat berkas: `final` hanya dihitung
/// sekali, sedangkan warna palet berubah ketika mode gelap diaktifkan.
TextStyle _tipStyle() =>
    TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w800);

Color _tipBg() => AppColors.card;

const _tipPad = EdgeInsets.symmetric(horizontal: 9, vertical: 5);

LineTouchData priceLineTouch({String Function(double y)? label}) =>
    LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) => _tipBg(),
        tooltipRoundedRadius: 9,
        tooltipPadding: _tipPad,
        tooltipBorder: BorderSide(color: AppColors.line),
        fitInsideHorizontally: true,
        maxContentWidth: 200,
        getTooltipItems: (spots) => [
          for (final s in spots)
            LineTooltipItem(
                (label ?? ((v) => rp(v.round())))(s.y), _tipStyle()),
        ],
      ),
      getTouchedSpotIndicator: (bar, spots) => [
        for (var i = 0; i < spots.length; i++)
          TouchedSpotIndicatorData(
            FlLine(color: AppColors.green.o(0.30), strokeWidth: 1.4),
            FlDotData(
              show: true,
              getDotPainter: (spot, frac, data, index) => FlDotCirclePainter(
                radius: 4.6,
                color: _tipBg(),
                strokeWidth: 2.4,
                strokeColor: data.color ?? AppColors.green,
              ),
            ),
          ),
      ],
    );

BarTouchData priceBarTouch(String Function(double y) label) => BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => _tipBg(),
        tooltipRoundedRadius: 9,
        tooltipPadding: _tipPad,
        tooltipBorder: BorderSide(color: AppColors.line),
        fitInsideHorizontally: true,
        getTooltipItem: (group, gi, rod, ri) =>
            BarTooltipItem(label(rod.toY), _tipStyle()),
      ),
    );

class PriceChart extends StatelessWidget {
  final List<double> data;
  final List<DateTime>? dates;
  final double height;
  const PriceChart(
      {super.key, required this.data, this.dates, this.height = 210})
      : assert(dates == null || dates.length == data.length);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
            child: UiText('Belum ada harga pada periode ini.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant))),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    final minV = data.reduce(math.min), maxV = data.reduce(math.max);
    final span = math.max(maxV - minV, math.max(1.0, maxV * 0.02));
    final step = _nice(span / 4);
    final minY = math.max(0.0, ((minV - span * 0.12) / step).floor() * step);
    final maxY = ((maxV + span * 0.12) / step).ceil() * step;
    final now = DateTime.now();
    final times = dates ??
        [
          for (var i = 0; i < data.length; i++)
            DateTime(now.year, now.month, now.day - data.length + 1 + i),
        ];
    final first = times.first.toLocal();
    // Dibulatkan ke tengah hari: stempel waktu Supabase memuat jam, dan tanpa
    // ini titik bergeser antara dua label tanggal.
    DateTime norm(DateTime t) => DateTime(t.year, t.month, t.day);
    final start = norm(first);
    double x(DateTime time) =>
        norm(time).difference(start).inMilliseconds /
        Duration.millisecondsPerDay;
    final spots = [
      for (var i = 0; i < data.length; i++) FlSpot(x(times[i]), data[i])
    ];
    final end = math.max(1.0, spots.last.x.ceilToDouble());
    final labelStyle = TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant);
    final scaler = MediaQuery.textScalerOf(context);
    // Label tengah dapat lebih panjang daripada label ujung ("77,5 rb"
    // dibandingkan "78 rb"), sehingga semua label interval diukur, bukan hanya
    // maxY.
    final painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: scaler,
    );
    var widest = 0.0;
    for (var v = minY; v <= maxY + 0.5; v += step) {
      painter.text = TextSpan(text: _kompak(v.round()), style: labelStyle);
      painter.layout();
      widest = math.max(widest, painter.width);
    }
    painter.dispose();
    final leftWidth = widest.ceilToDouble() + 12;
    const hide = AxisTitles(sideTitles: SideTitles(showTitles: false));
    return LayoutBuilder(builder: (context, box) {
      final divisions = math.max(
          1, ((box.maxWidth - leftWidth) / (76 * scaler.scale(1))).floor());
      final dateStep = math.max(1.0, (end / divisions).ceilToDouble());
      return SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 16),
          child: LineChart(LineChartData(
            minX: 0,
            maxX: end,
            minY: minY,
            maxY: maxY,
            lineTouchData: priceLineTouch().copyWith(
                touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => scheme.surface,
              tooltipRoundedRadius: 9,
              tooltipPadding: _tipPad,
              tooltipBorder: BorderSide(color: scheme.outlineVariant),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touched) => [
                for (final s in touched)
                  LineTooltipItem(
                      '${tanggalPendek(times[s.spotIndex])}\n${rp(s.y)}/kg',
                      TextStyle(
                          color: scheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
              ],
            )),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: step,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: scheme.outlineVariant, strokeWidth: 0.8),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: hide,
              rightTitles: hide,
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: leftWidth,
                interval: step,
                getTitlesWidget: (v, m) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(_kompak(v.round()),
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.right,
                      style: labelStyle),
                ),
              )),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30 * scaler.scale(1),
                interval: dateStep,
                getTitlesWidget: (v, m) {
                  if (v != end && end - v < dateStep * 0.55) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Transform.translate(
                      offset: Offset(v == 0 ? 12 : (v == end ? -12 : 0), 0),
                      child: Text(
                          tanggalPendek(DateTime(
                              start.year, start.month, start.day + v.round())),
                          maxLines: 1,
                          softWrap: false,
                          style: labelStyle),
                    ),
                  );
                },
              )),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: scheme.primary,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, bar) =>
                      data.length <= 14 || spot == spots.last,
                  getDotPainter: (spot, frac, bar, index) {
                    final last = spot == spots.last;
                    // Titik akhir dibuat lebih besar: isi putih dengan cincin
                    // hijau.
                    return FlDotCirclePainter(
                        radius: last ? 4.6 : 3.4,
                        color: scheme.surface,
                        strokeWidth: last ? 2.6 : 1.5,
                        strokeColor: scheme.primary);
                  },
                ),
                // Isian hijau tipis di bawah garis.
                belowBarData: BarAreaData(
                    show: true,
                    color: scheme.primary.o(
                        Theme.of(context).brightness == Brightness.dark
                            ? 0.22
                            : 0.12)),
              )
            ],
          )),
        ),
      );
    });
  }
}
