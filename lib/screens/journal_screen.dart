import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

// ─────────────────────────── MODEL ───────────────────────────
class JournalEntry {
  final String id;
  final DateTime date;
  final String mood; // Emoji kondisi
  final String note;

  const JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'mood': mood,
        'note': note,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> j) => JournalEntry(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        mood: j['mood'] as String,
        note: j['note'] as String,
      );
}

// ─────────────────────────── LAYAR ───────────────────────────

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> _entries = [];
  bool _loading = true;
  static const _key = 'journal_entries';

  static const _moods = [
    ('☀️', 'Cerah'),
    ('🌧️', 'Hujan'),
    ('💪', 'Produktif'),
    ('🐛', 'Ada Hama'),
    ('😊', 'Baik'),
    ('😔', 'Kurang Baik'),
    ('🌱', 'Tanam'),
    ('🌾', 'Panen'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _entries = list
          .map((e) => JournalEntry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  Future<void> _tambah() async {
    final result = await showModalBottomSheet<JournalEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _JournalInputSheet(),
    );
    if (result != null) {
      setState(() {
        _entries.insert(0, result);
      });
      await _save();
    }
  }

  Future<void> _hapus(String id) async {
    final entry = _entries.firstWhere((e) => e.id == id);
    setState(() => _entries.removeWhere((e) => e.id == id));
    await _save();
    if (mounted) {
      toastUndo(context, 'Catatan dihapus', () async {
        setState(() {
          _entries.insert(0, entry);
          _entries.sort((a, b) => b.date.compareTo(a.date));
        });
        await _save();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UiText('Jurnal Kebun 📔'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _tambah,
              icon: Icon(Icons.add_rounded, color: AppColors.green),
              label: UiText('Tulis',
                  style: TextStyle(
                      color: AppColors.green, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambah,
        backgroundColor: AppColors.greenFill,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const UiText('Catat Hari Ini'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.book_outlined,
                    title: 'Jurnal masih kosong',
                    body:
                        'Catat kondisi kebun harianmu — cuaca, hama, panen, atau apa saja yang terjadi hari ini.',
                    actionLabel: 'Tulis Catatan Pertama',
                    onAction: _tambah,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: _entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final e = _entries[i];
                    return Dismissible(
                      key: Key(e.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.down.o(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.delete_outline_rounded,
                            color: AppColors.down),
                      ),
                      onDismissed: (_) => _hapus(e.id),
                      child: Panel(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Emoji kondisi dalam lingkaran.
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.mint,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.line),
                              ),
                              alignment: Alignment.center,
                              child: UiText(e.mood,
                                  style: const TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    UiText(
                                      _moodLabel(e.mood),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.green),
                                    ),
                                    const Spacer(),
                                    UiText(
                                      tanggalPendek(e.date),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.muted),
                                    ),
                                  ]),
                                  const SizedBox(height: 4),
                                  UiText(
                                    e.note,
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                        color: AppColors.text),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _moodLabel(String emoji) {
    for (final m in _moods) {
      if (m.$1 == emoji) return m.$2;
    }
    return 'Catatan';
  }
}

// ─────────────────────────── LEMBAR INPUT ───────────────────────────

class _JournalInputSheet extends StatefulWidget {
  const _JournalInputSheet();

  @override
  State<_JournalInputSheet> createState() => _JournalInputSheetState();
}

class _JournalInputSheetState extends State<_JournalInputSheet> {
  final _ctrl = TextEditingController();
  String _mood = '☀️';

  static const _moods = [
    ('☀️', 'Cerah'),
    ('🌧️', 'Hujan'),
    ('💪', 'Produktif'),
    ('🐛', 'Ada Hama'),
    ('😊', 'Baik'),
    ('😔', 'Kurang Baik'),
    ('🌱', 'Tanam'),
    ('🌾', 'Panen'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _simpan() {
    final note = _ctrl.text.trim();
    if (note.isEmpty) return;
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      mood: _mood,
      note: note,
    );
    Navigator.of(context).pop(entry);
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
            // Pegangan bawah layar
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
            const UiText('Catatan Hari Ini',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            // Pilih kondisi
            UiText('Kondisi kebun',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 8),
            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _moods.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final m = _moods[i];
                  final sel = _mood == m.$1;
                  return GestureDetector(
                    onTap: () => setState(() => _mood = m.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.mint : AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? AppColors.green : AppColors.line,
                          width: sel ? 1.6 : 1,
                        ),
                      ),
                      child: Row(children: [
                        UiText(m.$1,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        UiText(m.$2,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: sel
                                    ? AppColors.onMint
                                    : AppColors.muted)),
                      ]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            // Kolom catatan
            TextField(
              controller: _ctrl,
              maxLines: 4,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                    'Ceritakan kondisi kebun hari ini... (cuaca, hama, hasil, dll)',
                hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: const UiText('Simpan Catatan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
