import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../models/crop_guide.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';

/// Daftar semua tanaman beserta ringkasan pH, mudah dicari dan difilter.
class GuideListScreen extends StatefulWidget {
  const GuideListScreen({super.key});

  @override
  State<GuideListScreen> createState() => _GuideListScreenState();
}

class _GuideListScreenState extends State<GuideListScreen> {
  String _cat = 'Semua';
  String _q = '';
  bool _nowOnly = false;

  String _ph(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

  @override
  Widget build(BuildContext context) {
    final list = commodities.where((c) {
      final okCat = _cat == 'Semua' || c.category == _cat;
      final okQ = _q.isEmpty || c.fullName.toLowerCase().contains(_q);
      final okNow = !_nowOnly ||
          (guideFor(c.id)?.best.contains(DateTime.now().month) ?? false);
      return okCat && okQ && okNow;
    }).toList();

    return Scaffold(
      // Tema dibaca di sini agar layar ini (yang tidak menggunakan AppState)
      // ikut dibangun ulang ketika mode terang/gelap berganti: AppColors
      // bersifat global dan tidak memicu pembangunan ulang sendiri.
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const UiText('Panduan Tanaman')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: TextField(
            onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: tr('Cari tanaman'),
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  avatar: Icon(Icons.event_available_rounded,
                      size: 16,
                      color: _nowOnly ? Colors.white : AppColors.green),
                  label: const UiText('Cocok ditanam bulan ini'),
                  selected: _nowOnly,
                  onSelected: (v) => setState(() => _nowOnly = v),
                  selectedColor: AppColors.greenFill,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: _nowOnly ? Colors.white : AppColors.green),
                  backgroundColor: AppColors.card,
                  side: BorderSide(color: AppColors.green),
                ),
              ),
              for (final f in ['Semua', ...commodityCategories])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: UiText(f),
                    selected: _cat == f,
                    onSelected: (_) => setState(() => _cat = f),
                    selectedColor: AppColors.greenFill,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _cat == f ? Colors.white : AppColors.muted),
                    backgroundColor: AppColors.card,
                    side: BorderSide(
                        color: _cat == f ? AppColors.green : AppColors.line),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: UiText('Tanaman tidak ditemukan.',
                      style: TextStyle(color: AppColors.muted)))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final c in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Panel(
                          onTap: () => push(
                              context, DetailScreen(id: c.id, initialTab: 1)),
                          child: Row(children: [
                            CommodityImage(c, size: 54, radius: 12),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UiText(c.fullName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 2),
                                    UiText(
                                        tpl('{0}  •  pH {1} sampai {2}', [
                                          tr(c.category),
                                          _ph(guideFor(c.id)?.phMin ?? 0),
                                          _ph(guideFor(c.id)?.phMax ?? 0)
                                        ]),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.muted)),
                                  ]),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: AppColors.muted),
                          ]),
                        ),
                      ),
                  ],
                ),
        ),
      ]),
    );
  }
}
