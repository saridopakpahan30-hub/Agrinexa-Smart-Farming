import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../services/market_service.dart';
import '../services/recommendation.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/guide_view.dart';
import '../widgets/price_chart.dart';
import 'simulation_screen.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final int initialTab;
  const DetailScreen({super.key, required this.id, this.initialTab = 0});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final c = commodityById(widget.id);
    final r = Engine.evaluate(c,
        area: s.landArea,
        capital: s.capital,
        landType: s.landType,
        goal: s.goal);
    final rank = s.ranked.indexWhere((x) => x.c.id == c.id);

    return Scaffold(
      appBar: AppBar(
        title: UiText(c.name),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.mint, AppColors.bg],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PhotoBanner(
            asset: c.asset,
            height: 250,
            heroTag: 'commodity-${c.id}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: rank == 0
                              ? AppColors.green
                              : Colors.white.o(0.22),
                          borderRadius: BorderRadius.circular(20),
                          border: rank == 0
                              ? null
                              : Border.all(color: Colors.white.o(0.4)),
                        ),
                        child: UiText(
                          rank == 0
                              ? '★ Rekomendasi Terbaik'
                              : tpl('Peringkat #{0}', ['${rank + 1}']),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiText(c.fullName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(color: Color(0x55000000), blurRadius: 6)
                            ])),
                    const SizedBox(height: 6),
                    // Wrap, bukan Row: pada layar sempit chip harga turun ke
                    // baris kedua alih-alih meluber keluar.
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.o(0.22),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.o(0.35)),
                          ),
                          child: UiText('${c.emoji} ${tr(c.category)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                        ),
                        UiText('${rp(MarketService.current(c))}/kg',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
                        ChangeText(MarketService.changePct(c)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Segmented(
            labels: const ['Ringkasan', 'Panduan', 'Analisis', 'Pasar'],
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 14),
          if (_tab == 0) ..._summary(r, s),
          if (_tab == 1) ...buildGuide(c, s.landArea.toDouble()),
          if (_tab == 2) ..._analysis(r),
          if (_tab == 3) ..._market(c),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6)),
                onPressed: () {
                  s.setActive(c.id);
                  toast(context,
                      tpl('{0} dijadikan komoditas aktif.', [tr(c.name)]));
                },
                child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: UiText('Jadikan Aktif',
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700))),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6)),
                onPressed: () =>
                    push(context, SimulationScreen(initialId: c.id)),
                child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: UiText('Simulasikan Detail',
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700))),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _summary(Reco r, AppState s) {
    // Sebelumnya baris ini memakai r.cost sedangkan "Modal Dibutuhkan" memakai
    // r.fullCost: dua angka berbeda membuat sisa modal tampak nol.
    final left = s.capital - r.fullCost;
    final kurang = left < 0;
    return [
      Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const UiText('Proyeksi Keuntungan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          KeyValue('Potensi Margin Kotor', rp(r.margin), bold: true),
          KeyValue('Perkiraan Omzet', rp(r.omzet)),
          KeyValue('Biaya Variabel', rp(r.cost)),
          KeyValue('Modal Dibutuhkan', rp(r.fullCost)),
          KeyValue(
              'Sisa Modal', kurang ? tpl('Kurang {0}', [rp(-left)]) : rp(left),
              bold: true, color: kurang ? AppColors.down : AppColors.green),
          KeyValue('ROI', pct(r.roi)),
        ]),
      ),
      if (kurang)
        Panel(
          color: AppColors.downTint,
          border: AppColors.downTintLine,
          child: Row(children: [
            Icon(Icons.info_outline_rounded, size: 18, color: AppColors.down),
            const SizedBox(width: 10),
            Expanded(
              child: UiText(
                  tpl('Modal Anda masih kurang {0} untuk skala ini. Perkecil luas tanam atau tambah modal.',
                      [rp(-left)]),
                  style: TextStyle(fontSize: 13, color: AppColors.downInk)),
            ),
          ]),
        ),
      const SectionTitle('Keunggulan'),
      Panel(
        child: Column(children: [
          for (final p in Engine.strengths(r, s.landArea))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                Icon(
                    p.ok
                        ? Icons.check_circle_rounded
                        : Icons.warning_amber_rounded,
                    size: 20,
                    color: p.ok ? AppColors.green : AppColors.sunInk),
                const SizedBox(width: 10),
                Expanded(
                    child:
                        UiText(p.text, style: const TextStyle(fontSize: 14))),
              ]),
            ),
        ]),
      ),
    ];
  }

  List<Widget> _analysis(Reco r) {
    final c = r.c;
    String level(double v) =>
        v <= 0.15 ? 'Rendah' : (v <= 0.3 ? 'Sedang' : 'Tinggi');
    return [
      Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const UiText('Struktur Biaya',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          for (final e in c.costShare.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(children: [
                Row(children: [
                  Expanded(
                      child:
                          UiText(e.key, style: const TextStyle(fontSize: 14))),
                  UiText(rp(r.cost * e.value),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  SizedBox(
                      width: 38,
                      child: UiText('${(e.value * 100).round()}%',
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(fontSize: 13, color: AppColors.muted))),
                ]),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: e.value,
                    minHeight: 6,
                    backgroundColor: AppColors.mint,
                    color: AppColors.green,
                  ),
                ),
              ]),
            ),
        ]),
      ),
      const SizedBox(height: 12),
      Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const UiText('Parameter Budidaya',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          KeyValue('Hasil panen', '${c.yieldPerM2.toStringAsFixed(1)} kg/m²'),
          KeyValue('Estimasi total panen',
              '${thousands((r.effArea * c.yieldPerM2 * r.suit).round())} kg'),
          KeyValue(
              'Umur tanam',
              c.growDays >= 365
                  ? tpl('{0} tahun', [(c.growDays / 365).toStringAsFixed(1)])
                  : tpl('{0} hari', ['${c.growDays}'])),
          KeyValue('Risiko harga', level(c.volatility)),
          KeyValue('Kecocokan lahan', '${(r.suit * 100).round()}%'),
        ]),
      ),
      const SectionTitle('Tips Budidaya'),
      Panel(
        child: Column(children: [
          for (final t in c.tips)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.eco_rounded, size: 18, color: AppColors.green),
                const SizedBox(width: 10),
                Expanded(
                    child: UiText(t,
                        style: const TextStyle(fontSize: 14, height: 1.4))),
              ]),
            ),
        ]),
      ),
    ];
  }

  List<Widget> _market(Commodity c) {
    final ch = MarketService.changePct(c);
    final points = MarketService.historyPoints(c, 30);
    return [
      Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiText('Harga saat ini',
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                    UiText('${rp(MarketService.current(c))}/kg',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800)),
                  ]),
            ),
            ChangeText(ch),
          ]),
          const SizedBox(height: 14),
          PriceChart(
              data: [for (final p in points) p.harga],
              dates: [for (final p in points) p.waktu],
              height: 170),
        ]),
      ),
    ];
  }
}
