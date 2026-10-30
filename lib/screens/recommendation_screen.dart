import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';
import 'input_screen.dart';

class RecommendationScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback? onMenu;
  const RecommendationScreen({super.key, this.embedded = false, this.onMenu});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final all = s.ranked;
    final list = _filter == 'Semua'
        ? all
        : all.where((r) => r.c.category == _filter).toList();
    final filters = ['Semua', ...commodityCategories];

    return Scaffold(
      appBar: AppBar(
        leading: widget.embedded
            ? IconButton(
                icon: const Icon(Icons.menu_rounded), onPressed: widget.onMenu)
            : null,
        title: const UiText('Rekomendasi Komoditas'),
        actions: [
          IconButton(
            tooltip: tr('Ubah data lahan & modal'),
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => push(context, const InputScreen()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final f in filters)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: UiText(f),
                    selected: _filter == f,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: AppColors.greenFill,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _filter == f ? Colors.white : AppColors.muted),
                    backgroundColor: AppColors.card,
                    side: BorderSide(
                        color: _filter == f ? AppColors.green : AppColors.line),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: UiText(
              tpl('Untuk {0} m² • {1} • {2} • Tujuan: {3}', [
                thousands(s.landArea),
                rp(s.capital),
                tr(s.landType),
                tr(s.goal),
              ]),
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
          for (var ri = 0; ri < list.length; ri++)
            StaggerIn(
              index: ri,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ScaleTap(
                  onTap: () => push(context, DetailScreen(id: list[ri].c.id)),
                  child: Panel(
                    child: Row(children: [
                      CommodityImage(list[ri].c,
                          size: 76,
                          radius: 12,
                          heroTag: 'commodity-${list[ri].c.id}'),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                _Rank(rank: all.indexOf(list[ri]) + 1),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: UiText(list[ri].c.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800)),
                                ),
                                if (all.first.c.id == list[ri].c.id) ...[
                                  const SizedBox(width: 8),
                                  const Pill('Optimal'),
                                ],
                              ]),
                              const SizedBox(height: 6),
                              UiText('Margin kotor',
                                  style: TextStyle(
                                      fontSize: 13, color: AppColors.muted)),
                              UiText(rp(list[ri].margin),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                              UiText('ROI ${pct(list[ri].roi)}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.green)),
                              if (list[ri].capitalLimited)
                                UiText('Modal terbatas',
                                    style: TextStyle(
                                        fontSize: 13, color: AppColors.down)),
                            ]),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                    ]),
                  ),
                ),
              ),
            ),
          Panel(
            color: AppColors.mint,
            child: Row(children: [
              Icon(Icons.lightbulb_outline_rounded, color: AppColors.green),
              const SizedBox(width: 10),
              Expanded(
                child: UiText(
                    'Rekomendasi ini mempertimbangkan luas lahan, modal, dan data pasar terkini.',
                    style: TextStyle(fontSize: 13, color: AppColors.green)),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Lingkaran peringkat: emas, perak, dan perunggu untuk tiga besar.
class _Rank extends StatelessWidget {
  final int rank;
  const _Rank({required this.rank});

  static const _medals = [
    Color(0xFFD4A017),
    Color(0xFF8E9BA8),
    Color(0xFFB87333),
  ];

  /// Angka di atas medali: teks putih di atas emas/perak hanya mencapai rasio
  /// kontras 2-3:1, sehingga digunakan tinta gelap yang tetap kontras ketika
  /// medali diterangkan pada mode gelap.
  static const _tintaMedali = Color(0xFF1A1408);

  @override
  Widget build(BuildContext context) {
    final top = rank <= 3;
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: top ? AppColors.aksen(_medals[rank - 1]) : AppColors.mint,
        shape: BoxShape.circle,
        border: top ? null : Border.all(color: AppColors.line),
      ),
      child: UiText('$rank',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: top ? _tintaMedali : AppColors.muted)),
    );
  }
}
