import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../models/planting.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      // Judul sudah dipindahkan ke dalam banner foto; tombol kembali tetap
      // dibuat otomatis.
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'calendar-add',
        backgroundColor: AppColors.greenFill,
        foregroundColor: Colors.white,
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.event_available_rounded),
        label: const UiText('Tanam Baru'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          StaggerIn(
            index: 0,
            child: PhotoBanner(
              asset: commodityById('padi').asset,
              height: 140,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UiText('Kalender Tanam',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Color(0x99000000), blurRadius: 10)
                          ])),
                  SizedBox(height: 4),
                  UiText('Jadwal perawatan dari tanam sampai panen',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Color(0x99000000), blurRadius: 8)
                          ])),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (s.plantings.isEmpty)
            StaggerIn(
              index: 1,
              child: EmptyState(
                icon: Icons.eco_rounded,
                title: 'Belum ada rencana tanam',
                body: 'Catat tanggal tanam dan Agrinexa akan menyusun jadwal '
                    'perawatan sampai panen untuk Anda.',
                actionLabel: 'Tanam Baru',
                onAction: () => _openForm(context),
              ),
            )
          else ...[
            const GeserHapusHint(),
            for (var i = 0; i < s.plantings.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PlantingCard(planting: s.plantings[i]),
              ),
          ],
        ],
      ),
    );
  }
}

class _PlantingCard extends StatelessWidget {
  final Planting planting;
  const _PlantingCard({required this.planting});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final c = planting.commodity;
    final stages = stagesFor(c);
    final today = DateTime.now();
    final cleanToday = DateTime(today.year, today.month, today.day);
    final startClean =
        DateTime(planting.start.year, planting.start.month, planting.start.day);
    final daysSince = cleanToday.difference(startClean).inDays;
    final harvestDate = startClean.add(Duration(days: c.growDays));
    final daysToHarvest = harvestDate.difference(cleanToday).inDays;
    final progress =
        ((daysSince + 7) / (c.growDays + 7)).clamp(0.0, 1.0).toDouble();

    return Dismissible(
      key: ValueKey(planting.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: AppColors.down.o(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_rounded, color: AppColors.down),
      ),
      onDismissed: (_) {
        s.removePlanting(planting.id);
        toastUndo(
          context,
          tpl('Rencana {0} dihapus', [tr(c.fullName)]),
          () => s.addPlanting(planting),
        );
      },
      child: Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CommodityImage(c, size: 48, radius: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiText(c.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                    UiText(
                        tpl('Tanam {0} • panen ± {1}', [
                          '${tanggalPendek(planting.start)} ${planting.start.year}',
                          '${tanggalPendek(harvestDate)} ${harvestDate.year}',
                        ]),
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    daysToHarvest <= 0 ? AppColors.sun.o(0.25) : AppColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: UiText(
                daysToHarvest <= 0
                    ? 'Waktunya panen!'
                    : tpl('{0} hari lagi', ['$daysToHarvest']),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: daysToHarvest <= 0
                        ? AppColors.sunInk
                        : AppColors.green),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.line,
              valueColor: AlwaysStoppedAnimation(AppColors.green),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < stages.length; i++) ...[
            if (i > 0) const SizedBox(height: 2),
            _StageRow(
              stage: stages[i],
              start: startClean,
              done: planting.done.contains(i),
              overdue: !planting.done.contains(i) &&
                  startClean
                      .add(Duration(days: stages[i].dayOffset))
                      .isBefore(cleanToday),
              onToggle: () => s.toggleStage(planting.id, i),
            ),
          ],
        ]),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  final PlantStage stage;
  final DateTime start;
  final bool done, overdue;
  final VoidCallback onToggle;
  const _StageRow({
    required this.stage,
    required this.start,
    required this.done,
    required this.overdue,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final date = start.add(Duration(days: stage.dayOffset));
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(children: [
          Icon(
            done
                ? Icons.check_circle_rounded
                : (overdue
                    ? Icons.radio_button_unchecked
                    : Icons.circle_outlined),
            size: 20,
            color: done
                ? AppColors.green
                : (overdue ? AppColors.down : AppColors.muted),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: UiText(stage.label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: done ? FontWeight.w500 : FontWeight.w700,
                    decoration: done ? TextDecoration.lineThrough : null,
                    color: done ? AppColors.muted : AppColors.text)),
          ),
          UiText(
            '${tanggalPendek(date)}'
            '${overdue ? tr(' • terlewat') : ''}',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: overdue ? AppColors.down : AppColors.muted),
          ),
        ]),
      ),
    );
  }
}

Future<void> _openForm(BuildContext context) async {
  final s = AppScope.of(context);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _PlantingForm(state: s),
  );
}

class _PlantingForm extends StatefulWidget {
  final AppState state;
  const _PlantingForm({required this.state});

  @override
  State<_PlantingForm> createState() => _PlantingFormState();
}

class _PlantingFormState extends State<_PlantingForm> {
  String _commodityId = commodities.first.id;
  DateTime _date = DateTime.now();

  Future<void> _save() async {
    await widget.state.addPlanting(Planting(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      commodityId: _commodityId,
      startMs: _date.millisecondsSinceEpoch,
    ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = commodityById(_commodityId);
    final harvest = _date.add(Duration(days: c.growDays));
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 14),
          const UiText('Rencana Tanam Baru',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _commodityId,
            isExpanded: true,
            decoration: InputDecoration(labelText: tr('Komoditas')),
            items: [
              for (final x in commodities)
                DropdownMenuItem(
                    value: x.id, child: UiText('${x.emoji}  ${tr(x.name)}')),
            ],
            onChanged: (v) => setState(() => _commodityId = v ?? _commodityId),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.event_rounded, color: AppColors.green),
            title: UiText(tpl('Tanggal tanam: {0}', [tanggalPanjang(_date)]),
                style: const TextStyle(fontSize: 14)),
            trailing:
                Icon(Icons.edit_rounded, size: 18, color: AppColors.muted),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (d != null) setState(() => _date = d);
            },
          ),
          const SizedBox(height: 6),
          Panel(
            color: AppColors.mint,
            child: Row(children: [
              Icon(Icons.spa_rounded, color: AppColors.green, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: UiText(
                  tpl('Perkiraan panen {0} ({1} hari setelah tanam)', [
                    '${tanggalPendek(harvest)} ${harvest.year}',
                    '${c.growDays}',
                  ]),
                  style: TextStyle(fontSize: 13, color: AppColors.green),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
              onPressed: _save, child: const UiText('Simpan Jadwal')),
        ],
      ),
    );
  }
}
