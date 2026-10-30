import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';

/// Satu zona pada peta lahan.
class PlotZone {
  final String name;
  final double area;
  final Color color;
  final String emoji;

  const PlotZone(
      {required this.name,
      required this.area,
      required this.color,
      this.emoji = ''});
}

/// Kotak lahan yang dibagi secara proporsional: luas satu warna sama dengan
/// luas tanaman yang diwakilinya, sehingga 1.000 m² terong benar-benar terlihat
/// dua kali lebih besar dari 500 m² cabai.
class PlotMap extends StatelessWidget {
  final List<PlotZone> zones;
  final double height;
  final double radius;

  const PlotMap(
      {super.key, required this.zones, this.height = 250, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final isi = [...zones.where((z) => z.area > 0)]
      ..sort((a, b) => b.area.compareTo(a.area));
    if (isi.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        color: Theme.of(context).colorScheme.outlineVariant,
        child: _belah(isi, Axis.horizontal, 0),
      ),
    );
  }
}

/// Bagi kotak menjadi dua bagian sesuai porsi luasnya, lalu belah bagian
/// tersebut lagi dengan arah bergantian agar blok tidak memanjang.
Widget _belah(List<PlotZone> z, Axis arah, int kedalaman) {
  if (z.isEmpty) return const SizedBox.shrink();
  if (z.length == 1) return _blok(z.first);

  final total = z.fold<double>(0, (t, e) => t + e.area);
  final target = total / 2;
  var jalan = 0.0, potong = 1;
  for (var i = 0; i < z.length - 1; i++) {
    jalan += z[i].area;
    potong = i + 1;
    if (jalan >= target) break;
  }
  final kiri = z.sublist(0, potong);
  final kanan = z.sublist(potong);
  final luasKiri = kiri.fold<double>(0, (t, e) => t + e.area);
  final f1 = (luasKiri / total * 1000).round().clamp(1, 999);

  final lanjut = arah == Axis.horizontal ? Axis.vertical : Axis.horizontal;
  return Flex(
    direction: arah,
    children: [
      Expanded(flex: f1, child: _belah(kiri, lanjut, kedalaman + 1)),
      Expanded(flex: 1000 - f1, child: _belah(kanan, lanjut, kedalaman + 1)),
    ],
  );
}

Widget _blok(PlotZone z) {
  final teks = z.color.computeLuminance() > 0.55
      ? const Color(0xFF16281C)
      : Colors.white;
  return Padding(
    padding: const EdgeInsets.all(2),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: z.color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: LayoutBuilder(builder: (_, box) {
        final w = box.maxWidth, h = box.maxHeight;
        if (w < 46 || h < 30) return const SizedBox.shrink();
        if (w < 96 || h < 66) {
          return Center(
            child: UiText(z.emoji.isEmpty ? z.name.substring(0, 1) : z.emoji,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800, color: teks)),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: UiText(
                    z.emoji.isEmpty ? tr(z.name) : '${z.emoji} ${tr(z.name)}',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800, color: teks),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: UiText('${thousands(z.area.round())} m²',
                      maxLines: 1, style: TextStyle(fontSize: 12, color: teks)),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}

/// Keterangan ringkas di bawah peta: warna, nama, dan porsinya.
class PlotLegend extends StatelessWidget {
  final List<PlotZone> zones;
  const PlotLegend({super.key, required this.zones});

  @override
  Widget build(BuildContext context) {
    final isi = [...zones.where((z) => z.area > 0)]
      ..sort((a, b) => b.area.compareTo(a.area));
    if (isi.isEmpty) return const SizedBox.shrink();
    final total = isi.fold<double>(0, (t, e) => t + e.area);
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final z in isi)
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  color: z.color, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: UiText(
                '${tr(z.name)} ${(z.area / total * 100).round()}%',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text),
              ),
            ),
          ]),
      ],
    );
  }
}
