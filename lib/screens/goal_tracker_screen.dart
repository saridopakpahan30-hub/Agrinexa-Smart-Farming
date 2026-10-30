import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

// ─────────────────────────── MODEL ───────────────────────────

class SeasonGoal {
  final String id;
  final String label;
  final int target; // Dalam rupiah
  final int achieved;
  final DateTime createdAt;

  const SeasonGoal({
    required this.id,
    required this.label,
    required this.target,
    required this.achieved,
    required this.createdAt,
  });

  double get progress => target > 0 ? (achieved / target).clamp(0.0, 1.0) : 0;
  bool get tercapai => achieved >= target;

  SeasonGoal copyWith({int? achieved}) => SeasonGoal(
        id: id,
        label: label,
        target: target,
        achieved: achieved ?? this.achieved,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'target': target,
        'achieved': achieved,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SeasonGoal.fromJson(Map<String, dynamic> j) => SeasonGoal(
        id: j['id'] as String,
        label: j['label'] as String,
        target: (j['target'] as num).toInt(),
        achieved: (j['achieved'] as num).toInt(),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

// ─────────────────────────── LENCANA ───────────────────────────

class AgriBadge {
  final String emoji;
  final String name;
  final String desc;
  final bool unlocked;

  const AgriBadge(
      {required this.emoji,
      required this.name,
      required this.desc,
      required this.unlocked});
}

// ─────────────────────────── LAYAR ───────────────────────────

class GoalTrackerScreen extends StatefulWidget {
  const GoalTrackerScreen({super.key});

  @override
  State<GoalTrackerScreen> createState() => _GoalTrackerScreenState();
}

class _GoalTrackerScreenState extends State<GoalTrackerScreen>
    with SingleTickerProviderStateMixin {
  List<SeasonGoal> _goals = [];
  bool _loading = true;
  late final AnimationController _celebrateCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
  static const _key = 'goal_tracker';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _celebrateCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _goals = list
          .map((e) => SeasonGoal.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, jsonEncode(_goals.map((g) => g.toJson()).toList()));
  }

  Future<void> _tambahTarget() async {
    final result = await showModalBottomSheet<SeasonGoal>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _GoalInputSheet(),
    );
    if (result != null) {
      setState(() => _goals.insert(0, result));
      await _save();
    }
  }

  Future<void> _updatePencapaian(SeasonGoal goal) async {
    final ctrl = TextEditingController(
        text: goal.achieved > 0 ? goal.achieved.toString() : '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const UiText('Update Pencapaian'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          UiText('Target: ${rp(goal.target)}',
              style: TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Pencapaian sejauh ini (Rp)',
              prefixText: 'Rp ',
            ),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const UiText('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const UiText('Simpan')),
        ],
      ),
    );
    ctrl.dispose();
    if (ok == true) {
      final val = int.tryParse(ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final updated = goal.copyWith(achieved: val);
      setState(() {
        final i = _goals.indexWhere((g) => g.id == goal.id);
        if (i >= 0) _goals[i] = updated;
      });
      await _save();
      if (updated.tercapai && mounted) {
        _celebrateCtrl.forward(from: 0);
        toast(context, '🎉 Selamat! Target "${goal.label}" tercapai!');
      }
    }
  }

  Future<void> _hapus(String id) async {
    final goal = _goals.firstWhere((g) => g.id == id);
    setState(() => _goals.removeWhere((g) => g.id == id));
    await _save();
    if (mounted) {
      toastUndo(context, 'Target dihapus', () async {
        setState(() {
          _goals.insert(0, goal);
          _goals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        });
        await _save();
      });
    }
  }

  List<AgriBadge> _badges() {
    final total = _goals.length;
    final tercapai = _goals.where((g) => g.tercapai).length;
    final totalTarget = _goals.fold<int>(0, (s, g) => s + g.target);
    return [
      AgriBadge(
          emoji: '🌱',
          name: 'Petani Pemula',
          desc: 'Buat target pertama',
          unlocked: total >= 1),
      AgriBadge(
          emoji: '🏆',
          name: 'Target Tercapai',
          desc: 'Capai 1 target musim',
          unlocked: tercapai >= 1),
      AgriBadge(
          emoji: '💰',
          name: 'Jutawan Tani',
          desc: 'Total target Rp 10 juta',
          unlocked: totalTarget >= 10000000),
      AgriBadge(
          emoji: '🌾',
          name: 'Petani Berpengalaman',
          desc: 'Buat 5 target musim',
          unlocked: total >= 5),
      AgriBadge(
          emoji: '⭐',
          name: 'Konsisten',
          desc: 'Capai 3 target berturut',
          unlocked: tercapai >= 3),
      AgriBadge(
          emoji: '🚀',
          name: 'Petani Sukses',
          desc: 'Total pencapaian Rp 50 juta',
          unlocked: _goals.fold<int>(0, (s, g) => s + g.achieved) >= 50000000),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final badges = _badges();
    final totalTarget = _goals.fold<int>(0, (s, g) => s + g.target);
    final totalAchieved = _goals.fold<int>(0, (s, g) => s + g.achieved);
    final overallProgress =
        totalTarget > 0 ? (totalAchieved / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(title: const UiText('Target & Pencapaian 🎯')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahTarget,
        backgroundColor: AppColors.greenFill,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const UiText('Tambah Target'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Ringkasan keseluruhan ──
                  if (_goals.isNotEmpty) ...[
                    _OverallCard(
                      totalTarget: totalTarget,
                      totalAchieved: totalAchieved,
                      progress: overallProgress,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Lencana ──
                  const SectionTitle('Pencapaian 🏅'),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: badges.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) => _BadgeCard(badge: badges[i]),
                    ),
                  ),

                  const SectionTitle('Target Musim Tanam'),
                  if (_goals.isEmpty)
                    EmptyState(
                      icon: Icons.flag_outlined,
                      title: 'Belum ada target',
                      body:
                          'Tetapkan target penghasilan per musim tanam agar kamu bisa memantau progress dan merayakan pencapaian.',
                      actionLabel: 'Tambah Target Pertama',
                      onAction: _tambahTarget,
                    )
                  else
                    for (final g in _goals) ...[
                      _GoalCard(
                        goal: g,
                        onUpdate: () => _updatePencapaian(g),
                        onDelete: () => _hapus(g.id),
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────── WIDGET ───────────────────────────

class _OverallCard extends StatelessWidget {
  final int totalTarget, totalAchieved;
  final double progress;
  const _OverallCard(
      {required this.totalTarget,
      required this.totalAchieved,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.deepGreen, AppColors.darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.o(0.12)),
        boxShadow: [
          BoxShadow(
              color: AppColors.darkGreen.o(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const UiText('📊',
              style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          const Expanded(
            child: UiText('Ringkasan Semua Target',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.sun.o(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.sun.o(0.5)),
            ),
            child: UiText('${(progress * 100).round()}%',
                style: TextStyle(
                    color: AppColors.sun,
                    fontSize: 13,
                    fontWeight: FontWeight.w800)),
          ),
        ]),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.o(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.sun),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          _MiniStat('Target Total', rp(totalTarget)),
          const SizedBox(width: 16),
          _MiniStat('Pencapaian', rp(totalAchieved)),
          const SizedBox(width: 16),
          _MiniStat('Sisa', rp((totalTarget - totalAchieved).clamp(0, totalTarget))),
        ]),
      ]),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  const _MiniStat(this.label, this.value);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiText(label,
              style: TextStyle(color: Colors.white.o(0.7), fontSize: 12)),
          UiText(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
        ]),
      );
}

class _BadgeCard extends StatelessWidget {
  final AgriBadge badge;
  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: badge.unlocked ? 1.0 : 0.35,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: badge.unlocked ? AppColors.mint : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: badge.unlocked ? AppColors.green.o(0.4) : AppColors.line),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiText(badge.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            UiText(badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: badge.unlocked ? AppColors.onMint : AppColors.muted,
                    height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final SeasonGoal goal;
  final VoidCallback onUpdate, onDelete;
  const _GoalCard(
      {required this.goal, required this.onUpdate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final pct = goal.progress;
    final Color barColor = pct >= 1.0
        ? AppColors.green
        : pct >= 0.5
            ? AppColors.sun
            : AppColors.down;

    return Panel(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: UiText(goal.label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          ),
          if (goal.tercapai)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: AppColors.green.o(0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: UiText('🏆 Tercapai',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green)),
            ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline_rounded,
                size: 20, color: AppColors.muted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ]),
        const SizedBox(height: 10),
        // Batang kemajuan
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.line,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          UiText('${rp(goal.achieved)} / ${rp(goal.target)}',
              style: TextStyle(fontSize: 13, color: AppColors.muted)),
          const Spacer(),
          UiText('${(pct * 100).round()}%',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: barColor)),
        ]),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 36,
          child: OutlinedButton.icon(
            onPressed: onUpdate,
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36), padding: EdgeInsets.zero),
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const UiText('Update Pencapaian'),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────── LEMBAR INPUT ───────────────────────────

class _GoalInputSheet extends StatefulWidget {
  const _GoalInputSheet();

  @override
  State<_GoalInputSheet> createState() => _GoalInputSheetState();
}

class _GoalInputSheetState extends State<_GoalInputSheet> {
  final _labelCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();

  @override
  void dispose() {
    _labelCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    final label = _labelCtrl.text.trim();
    final target =
        int.tryParse(_targetCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (label.isEmpty || target <= 0) return;
    final goal = SeasonGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      target: target,
      achieved: 0,
      createdAt: DateTime.now(),
    );
    Navigator.of(context).pop(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const UiText('Target Baru 🎯',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            UiText('Nama target (misalnya: "Musim cabai Nov-Jan")',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 6),
            TextField(
              controller: _labelCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration(hintText: tr('Nama musim tanam atau target')),
            ),
            const SizedBox(height: 14),
            UiText('Target penghasilan',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 6),
            TextField(
              controller: _targetCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(prefixText: 'Rp ', hintText: '0'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.flag_rounded, size: 18),
                label: const UiText('Tetapkan Target'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pelukis partikel untuk efek perayaan (nilai tambah visual) ──
class _ConfettiPainter extends CustomPainter {
  final Animation<double> anim;
  _ConfettiPainter(this.anim) : super(repaint: anim);

  static final _rng = math.Random(42);
  static final _particles = List.generate(
      30,
      (_) => (
            _rng.nextDouble(),
            _rng.nextDouble(),
            _rng.nextDouble() * 8 + 4,
            Color((0xFF000000 | (_rng.nextInt(0xFFFFFF))).toSigned(32))
          ));

  @override
  void paint(Canvas canvas, Size size) {
    final t = anim.value;
    for (final p in _particles) {
      final x = p.$1 * size.width;
      final y = (p.$2 + t * 1.5) % 1.0 * size.height;
      canvas.drawCircle(
          Offset(x, y), p.$3 * (1 - t), Paint()..color = p.$4.o(1 - t));
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => true;
}
