import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../data/pests.dart';
import '../models/commodity.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

class PestScreen extends StatefulWidget {
  const PestScreen({super.key});

  @override
  State<PestScreen> createState() => _PestScreenState();
}

class _PestScreenState extends State<PestScreen> {
  String _cat = 'Semua';
  String _q = '';

  List<PestInfo> get _shown {
    final q = _q.trim().toLowerCase();
    return [
      for (final p in pests)
        if ((_cat == 'Semua' ||
                p.categories.isEmpty ||
                p.matchCategory(_cat)) &&
            (q.isEmpty ||
                p.name.toLowerCase().contains(q) ||
                p.brief.toLowerCase().contains(q)))
          p
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final active = s.active;
    final forActive = pests.where((p) => p.matchCommodity(active.id)).toList();
    final shown = _shown;
    return Scaffold(
      appBar: AppBar(title: const UiText('Hama & Penyakit')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (forActive.isNotEmpty) ...[
            Panel(
              color: AppColors.mint,
              onTap: () => setState(() {
                _cat = active.category;
                _q = '';
              }),
              child: Row(children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.sunInk),
                const SizedBox(width: 10),
                Expanded(
                  child: UiText(
                    tpl('{0} hama/penyakit umum pada {1} Anda — ketuk untuk menyaring.',
                        [forActive.length.toString(), tr(active.name)]),
                    style: TextStyle(fontSize: 13, color: AppColors.onMint),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.green),
              ]),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            onChanged: (v) => setState(() => _q = v),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: tr('Cari hama atau gejala…'),
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final cat in pestCategories) ...[
                  ChoiceChip(
                    label: UiText(cat),
                    selected: _cat == cat,
                    onSelected: (_) => setState(() => _cat = cat),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SectionTitle('Daftar Pengganggu'),
          for (var i = 0; i < shown.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _PestCard(pest: shown[i]),
          ],
          if (shown.isEmpty)
            Panel(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: UiText('Tidak ada yang cocok dengan pencarian.',
                      style: TextStyle(fontSize: 14, color: AppColors.muted)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PestCard extends StatelessWidget {
  final PestInfo pest;
  const _PestCard({required this.pest});

  @override
  Widget build(BuildContext context) {
    final cats =
        pest.categories.isEmpty ? commodityCategories : pest.categories;
    return Panel(
      onTap: () => push(context, PestDetailScreen(pest: pest)),
      child: Row(children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: (pest.severe ? AppColors.down : AppColors.leaf).o(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: UiText(pest.emoji.isEmpty ? '🐛' : pest.emoji,
              style: const TextStyle(fontSize: 22)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(
                child: UiText(pest.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800)),
              ),
              if (pest.severe) ...[
                const SizedBox(width: 6),
                Pill('BERBAHAYA', bg: AppColors.down),
              ],
            ]),
            const SizedBox(height: 3),
            UiText(pest.brief,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 5),
            UiText(cats.map(tr).join(' • '),
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.green,
                    fontWeight: FontWeight.w700)),
          ]),
        ),
        Icon(Icons.chevron_right_rounded, color: AppColors.muted),
      ]),
    );
  }
}

class PestDetailScreen extends StatelessWidget {
  final PestInfo pest;
  const PestDetailScreen({super.key, required this.pest});

  Widget _section(BuildContext context, IconData icon, String title,
          List<String> items, Color color) =>
      Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            UiText(title,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w800, color: color)),
          ]),
          const SizedBox(height: 10),
          for (final t in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: Container(
                      width: 6,
                      height: 6,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle)),
                ),
                Expanded(
                    child: UiText(t,
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: AppColors.text))),
              ]),
            ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final affected = pest.commodityIds.isNotEmpty
        ? [for (final id in pest.commodityIds) commodityById(id)]
        : [
            for (final c in commodities)
              if (pest.categories.isEmpty ||
                  pest.categories.contains(c.category))
                c
          ];
    return Scaffold(
      appBar: AppBar(title: UiText(pest.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          PhotoBanner(
            asset: 'assets/images/${affected.first.id}.png',
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (pest.severe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child:
                        Pill('SERANGAN BISA MENULAR CEPAT', bg: AppColors.down),
                  ),
                UiText(pest.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(color: Color(0x55000000), blurRadius: 6)
                        ])),
                const SizedBox(height: 2),
                UiText(pest.brief,
                    style: TextStyle(fontSize: 13, color: Colors.white.o(0.9))),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _section(context, Icons.visibility_rounded, 'Gejala', pest.symptoms,
              AppColors.down),
          const SizedBox(height: 12),
          _section(context, Icons.shield_moon_rounded, 'Pencegahan',
              pest.prevention, AppColors.green),
          const SizedBox(height: 12),
          _section(context, Icons.medication_rounded, 'Penanganan',
              pest.treatment, AppColors.aksen(const Color(0xFF1565C0))),
          const SectionTitle('Sering menyerang'),
          Panel(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in affected.take(12))
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Pill('${c.emoji} ${tr(c.name)}',
                        bg: AppColors.mint, fg: AppColors.onMint),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Panel(
            child: UiText(
              'Panduan umum berbasis praktik lapang. Untuk rekomendasi '
              'pestisida resmi, konsultasikan dengan petugas Dinas Pertanian '
              'atau Penyuluh setempat.',
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}
