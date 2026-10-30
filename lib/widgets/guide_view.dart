import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../models/crop_guide.dart';
import '../services/market_service.dart';
import 'common.dart';

String _ph(double v) =>
    v.toStringAsFixed(1).replaceAll('.', Lang.inggris ? '.' : ',');

/// Skala pH 4 sampai 9 dengan kotak penanda rentang pH yang sesuai.
class PhScale extends StatelessWidget {
  final double min, max;
  const PhScale({super.key, required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final w = box.maxWidth;
      double x(double v) => ((v.clamp(4.0, 9.0) - 4.0) / 5.0 * w).toDouble();
      final left = x(min);
      final width = (x(max) - left).clamp(14.0, w).toDouble();
      return Column(children: [
        SizedBox(
          height: 24,
          child: Stack(children: [
            Positioned(
              left: 0,
              right: 0,
              top: 7,
              height: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFFE5533D),
                      Color(0xFFF59E0B),
                      Color(0xFFFFD54F),
                      Color(0xFF66BB6A),
                      Color(0xFF42A5F5),
                      Color(0xFF7E57C2),
                    ]),
                  ),
                ),
              ),
            ),
            Positioned(
              left: left.clamp(0.0, w - width).toDouble(),
              width: width,
              top: 2,
              height: 20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.text, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UiText('4 Masam',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            UiText('6,5 Netral',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            UiText('9 Basa',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ],
        ),
      ]);
    });
  }
}

Color _typeColor(String t) {
  // Warna golongan hama digunakan sebagai tinta di atas kartu: pada mode gelap
  // seluruhnya diterangkan melalui aksen() agar tidak tenggelam.
  if (t.contains('Jamur')) return AppColors.aksen(const Color(0xFFB88A00));
  if (t.contains('Bakteri')) return AppColors.aksen(const Color(0xFF3B82F6));
  if (t.contains('Virus')) return AppColors.aksen(const Color(0xFF8E44AD));
  if (t.contains('Hama')) return AppColors.down;
  return AppColors.muted;
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _Info(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 19, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiText(label,
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
              UiText(value, style: const TextStyle(fontSize: 14, height: 1.35)),
            ]),
          ),
        ]),
      );
}

/// Seluruh isi tab "Panduan" pada layar detail komoditas.
List<Widget> buildGuide(Commodity c, double landArea) {
  final g = guideFor(c.id);
  if (g == null) {
    return const [
      Panel(child: UiText('Panduan untuk komoditas ini belum tersedia.')),
    ];
  }
  final ch = MarketService.changePct(c);

  return [
    // ----------------------------------------------------- harga pasar
    Panel(
      color: AppColors.mint,
      child: Row(children: [
        Icon(Icons.storefront_rounded, color: AppColors.green),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiText('Harga pasar hari ini',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            UiText('${rp(MarketService.current(c))}/kg',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ]),
        ),
        ChangeText(ch),
      ]),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(2, 6, 2, 0),
      child: UiText(MarketService.sourceNote,
          style: TextStyle(fontSize: 13, color: AppColors.muted)),
    ),

    // ------------------------------------------------- syarat tumbuh
    const SectionTitle('Syarat Tumbuh'),
    Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.science_rounded, size: 19, color: AppColors.green),
          const SizedBox(width: 10),
          UiText('pH tanah ideal',
              style: TextStyle(fontSize: 13, color: AppColors.muted)),
          const Spacer(),
          UiText(tpl('{0} sampai {1}', [_ph(g.phMin), _ph(g.phMax)]),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green)),
        ]),
        const SizedBox(height: 8),
        PhScale(min: g.phMin, max: g.phMax),
        const Divider(height: 22),
        _Info(Icons.landscape_rounded, 'Jenis tanah', g.soil),
        _Info(Icons.terrain_rounded, 'Ketinggian tempat', g.altitude),
        _Info(Icons.water_drop_rounded, 'Kebutuhan air', g.water),
        _Info(Icons.wb_sunny_rounded, 'Sinar matahari', g.sun),
        _Info(Icons.grid_on_rounded, 'Jarak tanam', g.spacing),
        _Info(
            Icons.schedule_rounded,
            'Umur sampai panen',
            c.growDays >= 365
                ? tpl('{0} tahun', [(c.growDays / 365).toStringAsFixed(1)])
                : tpl('{0} hari', ['${c.growDays}'])),
      ]),
    ),

    // ------------------------------------------------------- kalender
    const SectionTitle('Kalender Tanam'),
    ..._calendar(c, g),

    // --------------------------------------------------------- pupuk
    const SectionTitle('Pupuk yang Cocok'),
    Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var i = 0; i < g.fertilizers.length; i++) ...[
          if (i > 0) const Divider(height: 18),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.grain_rounded, size: 19, color: AppColors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiText(g.fertilizers[i].name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    UiText(g.fertilizers[i].detail,
                        style: TextStyle(
                            fontSize: 14, height: 1.4, color: AppColors.muted)),
                  ]),
            ),
          ]),
        ],
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.mint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: UiText(
              'Dosis di atas per hektar atau per pohon. Hitungan untuk lahan Anda ada di bagian bawah ini.',
              style: TextStyle(fontSize: 13, color: AppColors.green)),
        ),
      ]),
    ),

    ..._fertCalc(g, landArea),

    // ------------------------------------------------ hama & penyakit
    const SectionTitle('Hama dan Penyakit Umum'),
    for (final p in g.problems)
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Panel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: UiText(p.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800)),
              ),
              Pill(p.type,
                  bg: _typeColor(p.type).withAlpha(36), fg: _typeColor(p.type)),
            ]),
            const SizedBox(height: 8),
            UiText('Gejala',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            UiText(p.symptom,
                style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 8),
            UiText('Penanganan',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            UiText(p.action, style: const TextStyle(fontSize: 14, height: 1.4)),
          ]),
        ),
      ),

    // ---------------------------------------------------- perawatan
    const SectionTitle('Cara Perawatan'),
    Panel(
      child: Column(children: [
        for (var i = 0; i < g.care.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.mint, shape: BoxShape.circle),
                child: UiText('${i + 1}',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: UiText(g.care[i],
                    style: const TextStyle(fontSize: 14, height: 1.4)),
              ),
            ]),
          ),
      ]),
    ),

    // -------------------------------------------------------- panen
    const SectionTitle('Panen'),
    Panel(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.agriculture_rounded, size: 20, color: AppColors.green),
        const SizedBox(width: 10),
        Expanded(
          child: UiText(g.harvest,
              style: const TextStyle(fontSize: 14, height: 1.45)),
        ),
      ]),
    ),
    const SizedBox(height: 14),
    Panel(
      color: AppColors.sunTint,
      border: AppColors.sunTintLine,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.info_outline_rounded, color: AppColors.sunInk, size: 20),
        const SizedBox(width: 10),
        const Expanded(
          child: UiText(
              'Panduan umum. Dosis berbeda menurut varietas, tanah, dan musim: lakukan uji tanah dan tanyakan penyuluh pertanian (PPL) setempat. Baca label pestisida, pakai masker dan sarung tangan, dan utamakan cara non-kimia lebih dulu.',
              style: TextStyle(fontSize: 13, height: 1.45)),
        ),
      ]),
    ),
  ];
}

// =========================================================== Kalender Tanam
const _bulanNama = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember'
];
const _bulanPendek = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des'
];
const _bulanInisial = [
  'J',
  'F',
  'M',
  'A',
  'M',
  'J',
  'J',
  'A',
  'S',
  'O',
  'N',
  'D'
];

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend(this.color, this.label);

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(width: 5),
        UiText(label, style: TextStyle(fontSize: 13, color: AppColors.muted)),
      ]);
}

List<Widget> _calendar(Commodity c, CropGuide g) {
  final now = DateTime.now().month;
  final annual = c.growDays < 365;
  final bestSet = g.best.toSet(), okSet = g.ok.toSet();
  final hBest = annual ? harvestMonths(c.growDays, g.best) : <int>{};
  final hOk = annual ? harvestMonths(c.growDays, g.ok) : <int>{};

  final plantBest = AppColors.green;
  // Penanda "masih sesuai" dibuat lebih pekat pada mode gelap agar tidak
  // tenggelam.
  final plantOk = AppColors.leaf.withAlpha(AppColors.gelap ? 150 : 110);
  final harvBest = AppColors.sun;
  final harvOk = AppColors.sun.withAlpha(AppColors.gelap ? 140 : 100);

  final sortedBest = [...g.best]..sort();
  final String status;
  final Color statusColor;
  if (bestSet.contains(now)) {
    status = tpl('Bulan ini ({0}) adalah waktu terbaik untuk menanam.',
        [tr(_bulanNama[now - 1])]);
    statusColor = AppColors.green;
  } else if (okSet.contains(now)) {
    status = 'Bulan ini masih bisa menanam, tetapi bukan waktu terbaik.';
    statusColor = AppColors.sunInk;
  } else {
    status = tpl('Bulan ini kurang cocok untuk menanam. Waktu terbaik: {0}.',
        [sortedBest.map((m) => tr(_bulanPendek[m - 1])).join(', ')]);
    statusColor = AppColors.down;
  }

  Widget labels() => Row(children: [
        for (var m = 1; m <= 12; m++)
          Expanded(
            child: Center(
              child: UiText(_bulanInisial[m - 1],
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: m == now ? FontWeight.w800 : FontWeight.w500,
                      color: m == now ? AppColors.text : AppColors.muted)),
            ),
          ),
      ]);

  Widget grid(Color Function(int) col) => Row(children: [
        for (var m = 1; m <= 12; m++)
          Expanded(
            child: Container(
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: col(m),
                borderRadius: BorderRadius.circular(8),
                border: m == now
                    ? Border.all(color: AppColors.text, width: 1.5)
                    : null,
              ),
            ),
          ),
      ]);

  Color plantColor(int m) => bestSet.contains(m)
      ? plantBest
      : (okSet.contains(m) ? plantOk : AppColors.line);
  Color harvColor(int m) => hBest.contains(m)
      ? harvBest
      : (hOk.contains(m) ? harvOk : AppColors.line);

  return [
    Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.event_available_rounded, size: 20, color: statusColor),
          const SizedBox(width: 10),
          Expanded(
            child: UiText(status,
                style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: statusColor)),
          ),
        ]),
        const SizedBox(height: 14),
        labels(),
        const SizedBox(height: 4),
        UiText('Tanam', style: TextStyle(fontSize: 13, color: AppColors.muted)),
        const SizedBox(height: 3),
        grid(plantColor),
        if (annual) ...[
          const SizedBox(height: 10),
          UiText('Panen',
              style: TextStyle(fontSize: 13, color: AppColors.muted)),
          const SizedBox(height: 3),
          grid(harvColor),
        ],
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 6, children: [
          _Legend(plantBest, 'Tanam terbaik'),
          _Legend(plantOk, 'Tanam masih bisa'),
          if (annual) _Legend(harvBest, 'Panen'),
        ]),
        if (!annual) ...[
          const SizedBox(height: 10),
          UiText(
              g.calNote.isEmpty
                  ? 'Masa tanam sampai panen lebih dari satu tahun; waktu panen mengikuti umur tanaman dan kondisi daerah.'
                  : g.calNote,
              style: const TextStyle(fontSize: 13, height: 1.45)),
        ] else if (g.calNote.isNotEmpty) ...[
          const SizedBox(height: 10),
          UiText(g.calNote, style: const TextStyle(fontSize: 13, height: 1.45)),
        ],
        const SizedBox(height: 10),
        UiText(
            'Kalender umum berdasarkan pola musim hujan Nov sampai Apr dan kemarau Mei sampai Okt. Curah hujan tiap daerah berbeda (sebagian daerah hujan merata sepanjang tahun), jadi cocokkan dengan kalender tanam setempat: tanyakan penyuluh (PPL) atau lihat Kalender Tanam Terpadu (Katam) Kementerian Pertanian.',
            style:
                TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted)),
      ]),
    ),
  ];
}

// ======================================================= Hitungan Pupuk
String _num(double v) {
  if (v >= 100) return thousands(v.round());
  var t = v.toStringAsFixed(1);
  if (t.endsWith('.0')) t = t.substring(0, t.length - 2);
  return t.replaceAll('.', Lang.inggris ? '.' : ',');
}

String _range(double lo, double hi) {
  final double div;
  final String unit;
  if (hi >= 1000) {
    div = 1000;
    unit = 'ton';
  } else if (hi >= 1) {
    div = 1;
    unit = 'kg';
  } else {
    div = 0.001;
    unit = 'g';
  }
  final a = _num(lo / div), b = _num(hi / div);
  return a == b ? '$a $unit' : tpl('{0} sampai {1} {2}', [a, b, unit]);
}

bool _organic(String name) {
  final n = name.toLowerCase();
  return n.contains('kompos') || n.contains('kandang') || n.contains('organik');
}

List<Widget> _fertCalc(CropGuide g, double areaM2) {
  final plan = fertilizerPlan(g, areaM2);
  if (plan.isEmpty) return const [];
  final ha = areaM2 / 10000;
  final haText = ha
      .toStringAsFixed(ha < 0.1 ? 3 : 2)
      .replaceAll('.', Lang.inggris ? '.' : ',');
  final trees = g.trees > 0 ? (ha * g.trees).round() : 0;

  return [
    const SectionTitle('Kebutuhan Pupuk Lahan Anda'),
    Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.calculate_rounded, size: 20, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(
            child: UiText(
                tpl('Luas {0} m² = {1} ha{2}', [
                  thousands(areaM2.round()),
                  haText,
                  trees > 0
                      ? tpl('  •  sekitar {0} pohon', [thousands(trees)])
                      : ''
                ]),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ]),
        const Divider(height: 22),
        for (var i = 0; i < plan.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiText(plan[i].fert.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 1),
                    UiText(
                        '${tr(plan[i].when)}'
                        '${plan[i].fert.optional ? tr('  •  bila diperlukan') : ''}'
                        '${plan[i].fert.unit == 'kg/ha' && !_organic(plan[i].fert.name) && plan[i].highKg >= 25 ? tpl('  •  sekitar {0} karung @50 kg', [
                                '${(plan[i].highKg / 50).ceil()}'
                              ]) : ''}',
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: AppColors.muted)),
                  ]),
            ),
            const SizedBox(width: 10),
            UiText(_range(plan[i].lowKg, plan[i].highKg),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green)),
          ]),
        ],
        const SizedBox(height: 14),
        UiText(
            'Hitungan dari luas lahan di menu Input Lahan; ubah luas di sana. Ini perkiraan: sesuaikan dengan uji tanah dan saran penyuluh.',
            style:
                TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted)),
      ]),
    ),
  ];
}
