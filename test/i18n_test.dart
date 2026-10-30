import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/core/i18n.dart';
import 'package:agrinexa/core/translations_en.dart';
import 'package:agrinexa/data/pests.dart';
import 'package:agrinexa/main.dart';
import 'package:agrinexa/models/commodity.dart';
import 'package:agrinexa/models/crop_guide.dart';
import 'package:agrinexa/screens/misc_screens.dart';
import 'package:agrinexa/screens/splash_screen.dart';
import 'package:agrinexa/state/app_state.dart';

void main() {
  setUp(() => Lang.pakai('id'));
  tearDown(() => Lang.pakai('id'));

  test('terjemahan dan argumen mengikuti bahasa yang dipilih', () {
    expect(tr('Pengaturan'), 'Pengaturan');
    Lang.pakai('en');
    expect(tr('Pengaturan'), 'Settings');
    expect(tpl('Tanggal: {0}', ['22 Oct 2026']), 'Date: 22 Oct 2026');
    expect(tr('Nama kebun pengguna'), 'Nama kebun pengguna');
    Lang.pakai('id');
    expect(tpl('Tanggal: {0}', ['22 Okt 2026']), 'Tanggal: 22 Okt 2026');
  });

  test('semua komoditas, panduan tanam dan hama punya padanan Inggris', () {
    final keys = <String>{};
    for (final c in commodities) {
      keys.addAll([c.name, c.fullName, c.category, ...c.tips]);
      final g = guideFor(c.id)!;
      keys.addAll([
        g.soil,
        g.altitude,
        g.water,
        g.sun,
        g.spacing,
        g.harvest,
        g.calNote,
        ...g.care
      ]);
      for (final f in g.fertilizers) {
        keys.addAll([f.name, f.detail]);
      }
      for (final p in g.problems) {
        keys.addAll([p.name, p.type, p.symptom, p.action]);
      }
    }
    for (final p in pests) {
      keys.addAll(
          [p.name, p.brief, ...p.symptoms, ...p.prevention, ...p.treatment]);
    }
    final missing =
        keys.where((k) => k.isNotEmpty && !tabelInggris.containsKey(k));
    expect(missing.toList(), isEmpty);
  });

  test('slot angka pada setiap terjemahan tetap lengkap', () {
    final slot = RegExp(r'\{\d+\}');
    for (final e in tabelInggris.entries) {
      final id = slot.allMatches(e.key).map((m) => m[0]).toSet();
      final en = slot.allMatches(e.value).map((m) => m[0]).toSet();
      expect(en, id, reason: e.key);
    }
  });

  test('kunci literal antarmuka dan template tidak hilang', () {
    final literal = RegExp(r"'((?:[^'\\]|\\.)*)'");
    final call = RegExp(
        r"(?:UiText|tr|tpl|SectionTitle|KeyValue)\(\s*'((?:[^'\\]|\\.)*)'");
    const unchanged = {'Agrinexa', 'ROI', 'Budi Santoso', 'contoh@agrinexa.id'};
    final missing = <String>{};
    for (final f
        in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart') ||
          f.path.endsWith('translations_en.dart')) {
        continue;
      }
      final source = f.readAsStringSync().replaceAll(RegExp(r"'\s*\n\s*'"), '');
      for (final m in call.allMatches(source)) {
        final k = m[1]!.replaceAll(r"\'", "'").replaceAll(r'\n', '\n');
        if (k.length < 2 || k.contains(r'$') || unchanged.contains(k)) continue;
        if (!tabelInggris.containsKey(k)) missing.add('${f.path}: $k');
      }
      expect(literal.hasMatch(source), isTrue, reason: f.path);
    }
    expect(missing.toList(), isEmpty);
  });

  testWidgets('pilihan Inggris langsung mengganti layar dan tersimpan',
      (tester) async {
    tester.view.physicalSize = const Size(520, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    expect(state.bahasaAktif, 'id');
    await tester.pumpWidget(AgrinexaApp(state: state));
    Navigator.of(tester.element(find.byType(SplashScreen)))
        .push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bahasa Inggris'));
    await tester.tap(find.text('Bahasa Inggris'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(Lang.kode, 'en');
    expect((await SharedPreferences.getInstance()).getString('bahasa'), 'en');
    final reloaded = AppState();
    await reloaded.load();
    expect(reloaded.bahasaAktif, 'en');
    await tester.ensureVisible(find.text('Bahasa Indonesia'));
    await tester.tap(find.text('Bahasa Indonesia'));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(Lang.kode, 'id');
  });
}
