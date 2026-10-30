import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../services/market_service.dart';
import '../widgets/common.dart';

/// Layar perbandingan komoditas berdampingan, dilengkapi grafik radar dan tabel.
class CompareScreen extends StatefulWidget {
  /// Komoditas yang sudah dipilih saat layar dibuka (opsional).
  final String? initialId;
  const CompareScreen({super.key, this.initialId});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialId != null) _selected.add(widget.initialId!);
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < 3) {
        _selected.add(id);
      }
    });
  }

  List<Commodity> get _picked =>
      _selected.map((id) => commodityById(id)).toList();

  // Normalisasi nilai ke rentang 0–1 untuk grafik radar; setiap dimensi
  // memiliki skalanya sendiri.
  double _normMargin(Commodity c) {
    final prices = commodities.map((x) => MarketService.current(x)).toList()
      ..sort();
    final max = prices.last.toDouble();
    if (max == 0) return 0;
    return (MarketService.current(c) / max).clamp(0.0, 1.0);
  }

  double _normRoi(Commodity c) {
    // changePct digunakan sebagai pendekatan nilai ROI.
    final changes = commodities.map((x) => MarketService.changePct(x).abs());
    final max = changes.reduce(math.max);
    if (max == 0) return 0.5;
    return ((MarketService.changePct(c) + max) / (2 * max)).clamp(0.0, 1.0);
  }

  double _normStability(Commodity c) {
    final h = MarketService.history(c, 30);
    if (h.length < 2) return 0.5;
    final avg = h.reduce((a, b) => a + b) / h.length;
    if (avg == 0) return 0.5;
    final variance = h.map((v) => (v - avg) * (v - avg)).reduce((a, b) => a + b) / h.length;
    final std = math.sqrt(variance);
    final cv = std / avg;
    return (1 - cv).clamp(0.0, 1.0);
  }

  static const _dimensi = ['Harga', 'Tren', 'Stabilitas', 'Popularitas', 'Potensi'];

  // Warna untuk setiap slot pilihan.
  static final _colors = [
    const Color(0xFF1B7F3B),
    const Color(0xFF1565C0),
    const Color(0xFFB71C1C),
  ];

  @override
  Widget build(BuildContext context) {
    final picked = _picked;
    return Scaffold(
      appBar: AppBar(
        title: const UiText('Bandingkan Komoditas 📊'),
        bottom: picked.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(44),
                child: _SelectedChips(
                    picked: picked,
                    colors: _colors,
                    onRemove: (id) => setState(() => _selected.remove(id))),
              )
            : null,
      ),
      body: Column(
        children: [
          // ── Panel informasi ──
          if (_selected.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Panel(
                color: AppColors.mint,
                child: Row(children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.green, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: UiText(
                        'Pilih 2–3 komoditas dari daftar untuk membandingkannya.',
                        style: TextStyle(fontSize: 13, color: AppColors.onMint)),
                  ),
                ]),
              ),
            ),

          // ── Grafik radar (ditampilkan bila minimal dua komoditas dipilih) ──
          if (picked.length >= 2) ...[
            const SizedBox(height: 8),
            _RadarSection(picked: picked, colors: _colors),
          ],

          // ── Tabel perbandingan (ditampilkan bila minimal dua dipilih) ──
          if (picked.length >= 2) ...[
            const SizedBox(height: 4),
            _TableSection(picked: picked, colors: _colors),
          ],

          // ── Daftar untuk memilih komoditas ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: commodities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final c = commodities[i];
                final sel = _selected.contains(c.id);
                final slotIdx = _selected.indexOf(c.id);
                final canAdd = _selected.length < 3;
                return _CommoditySelectTile(
                  commodity: c,
                  selected: sel,
                  disabled: !sel && !canAdd,
                  color: sel ? _colors[slotIdx] : null,
                  onTap: () => _toggle(c.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────── KAPSUL TANAMAN TERPILIH ───────────

class _SelectedChips extends StatelessWidget {
  final List<Commodity> picked;
  final List<Color> colors;
  final void Function(String) onRemove;
  const _SelectedChips(
      {required this.picked, required this.colors, required this.onRemove});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          itemCount: picked.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final c = picked[i];
            final col = colors[i];
            return Chip(
              backgroundColor: col.o(0.12),
              side: BorderSide(color: col.o(0.4)),
              label: UiText(c.name,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: col)),
              deleteIcon: Icon(Icons.close_rounded, size: 16, color: col),
              onDeleted: () => onRemove(c.id),
            );
          },
        ),
      );
}

// ─────────── GRAFIK RADAR ───────────

class _RadarSection extends StatelessWidget {
  final List<Commodity> picked;
  final List<Color> colors;
  const _RadarSection({required this.picked, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Panel(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const UiText('Grafik Radar Perbandingan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          // Legenda
          Wrap(
            spacing: 12,
            children: [
              for (var i = 0; i < picked.length; i++)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: colors[i], shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  UiText(picked[i].name,
                      style:
                          TextStyle(fontSize: 12, color: AppColors.muted)),
                ]),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: TextStyle(color: AppColors.muted, fontSize: 10),
                gridBorderData:
                    BorderSide(color: AppColors.line, width: 1),
                titleTextStyle:
                    TextStyle(color: AppColors.text, fontSize: 12),
                getTitle: (i, _) => RadarChartTitle(
                    text: const ['Harga', 'Tren', 'Stabilitas', 'Pop.', 'Potensi'][i]),
                dataSets: [
                  for (var i = 0; i < picked.length; i++)
                    _radarData(picked[i], colors[i]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  RadarDataSet _radarData(Commodity c, Color color) {
    final price = MarketService.current(c);
    final prices = commodities.map((x) => MarketService.current(x)).toList()..sort();
    final maxPrice = prices.last.toDouble();
    final normPrice = maxPrice > 0 ? price / maxPrice : 0.5;

    final change = MarketService.changePct(c);
    final normTrend = ((change + 10) / 20).clamp(0.0, 1.0);

    final h = MarketService.history(c, 30);
    double normStability = 0.5;
    if (h.length >= 2) {
      final avg = h.reduce((a, b) => a + b) / h.length;
      if (avg > 0) {
        final variance = h.map((v) => (v - avg) * (v - avg)).reduce((a, b) => a + b) / h.length;
        final cv = math.sqrt(variance) / avg;
        normStability = (1 - cv).clamp(0.0, 1.0);
      }
    }

    final idx = commodities.indexOf(c);
    final normPop = idx >= 0 ? (1 - idx / commodities.length) : 0.5;
    final normPotential = (normPrice * 0.4 + normTrend * 0.3 + normStability * 0.3).clamp(0.0, 1.0);

    return RadarDataSet(
      fillColor: color.o(0.15),
      borderColor: color,
      borderWidth: 2,
      entryRadius: 4,
      dataEntries: [
        RadarEntry(value: normPrice * 5),
        RadarEntry(value: normTrend * 5),
        RadarEntry(value: normStability * 5),
        RadarEntry(value: normPop * 5),
        RadarEntry(value: normPotential * 5),
      ],
    );
  }
}

// ─────────── TABEL PERBANDINGAN ───────────

class _TableSection extends StatelessWidget {
  final List<Commodity> picked;
  final List<Color> colors;
  const _TableSection({required this.picked, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Panel(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const UiText('Perbandingan Detail',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          // Kepala tabel.
          Row(children: [
            const Expanded(
                flex: 2, child: UiText('Kriteria', style: TextStyle(fontSize: 12))),
            for (var i = 0; i < picked.length; i++)
              Expanded(
                child: Center(
                  child: UiText(picked[i].name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: colors[i])),
                ),
              ),
          ]),
          Divider(color: AppColors.line, height: 16),
          _Row('Harga /kg', picked.map((c) => rp(MarketService.current(c))).toList()),
          _Row('Perubahan',
              picked.map((c) => '${MarketService.changePct(c) >= 0 ? '▲' : '▼'} ${pct(MarketService.changePct(c).abs())}').toList(),
              colors: picked.map((c) => MarketService.changePct(c) >= 0 ? AppColors.green : AppColors.down).toList()),
          _Row('Kategori', picked.map((c) => c.category).toList()),
        ]),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final List<String> values;
  final List<Color>? colors;
  const _Row(this.label, this.values, {this.colors});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Expanded(
              flex: 2,
              child: UiText(label,
                  style: TextStyle(fontSize: 13, color: AppColors.muted))),
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Center(
                child: UiText(values[i],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colors != null ? colors![i] : AppColors.text)),
              ),
            ),
        ]),
      );
}

// ─────────── BUTIR PILIH ───────────

class _CommoditySelectTile extends StatelessWidget {
  final Commodity commodity;
  final bool selected, disabled;
  final Color? color;
  final VoidCallback onTap;
  const _CommoditySelectTile({
    required this.commodity,
    required this.selected,
    required this.disabled,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = commodity;
    final tileColor = color ?? AppColors.green;
    return AnimatedOpacity(
      opacity: disabled ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Panel(
        onTap: disabled ? null : onTap,
        color: selected ? tileColor.o(0.07) : null,
        child: Row(children: [
          CommodityImage(c, size: 48, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiText(c.fullName,
                  style:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              UiText('${rp(MarketService.current(c))}/kg • ${c.category}',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ]),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: selected ? tileColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: selected ? tileColor : AppColors.line, width: 2),
            ),
            child: selected
                ? const Icon(Icons.check_rounded,
                    size: 16, color: Colors.white)
                : null,
          ),
        ]),
      ),
    );
  }
}
