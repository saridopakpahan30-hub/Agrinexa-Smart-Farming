import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/models/ledger.dart';
import 'package:agrinexa/models/planting.dart';
import 'package:agrinexa/screens/calendar_screen.dart';
import 'package:agrinexa/screens/ledger_screen.dart';
import 'package:agrinexa/state/app_state.dart';

Future<AppState> akunUji() async {
  SharedPreferences.setMockInitialValues({
    'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
    'session': 't@x.id',
  });
  final state = AppState();
  await state.load();
  return state;
}

void layarTinggi(WidgetTester tester, double tinggi) {
  tester.view.physicalSize = Size(360, tinggi);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('catatan yang dihapus dengan geser kembali persis di posisinya',
      (tester) async {
    layarTinggi(tester, 3600);
    final state = await akunUji();
    LedgerEntry cat(String id, String kategori) => LedgerEntry(
        id: id, timeMs: 1, income: false, category: kategori, amount: 1000);
    // addLedger menambah di depan, jadi urutannya [c, b, a].
    await state.addLedger(cat('a', 'Bibit'));
    await state.addLedger(cat('b', 'Pupuk'));
    await state.addLedger(cat('c', 'Tenaga kerja'));

    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: LedgerScreen())));
    await tester.pumpAndSettle();

    expect(find.text('Geser kartu ke kiri untuk menghapus — bisa diurungkan.'),
        findsOneWidget);

    await tester.drag(find.byType(Dismissible).at(1), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(state.ledger.map((e) => e.id).toList(), ['c', 'a']);
    expect(find.text('Catatan "Pupuk" dihapus'), findsOneWidget);

    await tester.tap(find.text('Urungkan'));
    await tester.pumpAndSettle();

    expect(state.ledger.map((e) => e.id).toList(), ['c', 'b', 'a']);
    expect(find.text('Pupuk'), findsOneWidget);
  });

  testWidgets('rencana tanam yang digeser balik lagi lewat Urungkan',
      (tester) async {
    layarTinggi(tester, 2600);
    final state = await akunUji();
    final awal = [
      for (final (i, id) in const ['padi', 'jagung', 'kentang'].indexed)
        Planting(
            id: id,
            commodityId: id,
            startMs: DateTime(2026, 10, 5 + i).millisecondsSinceEpoch),
    ];
    for (final p in awal) {
      await state.addPlanting(p);
    }

    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: CalendarScreen())));
    await tester.pumpAndSettle();

    expect(find.byType(Dismissible), findsNWidgets(3));
    await tester.drag(find.byType(Dismissible).at(1), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(state.plantings.map((p) => p.id).toList(), ['padi', 'kentang']);
    expect(find.text('Rencana Jagung dihapus'), findsOneWidget);

    await tester.tap(find.text('Urungkan'));
    await tester.pumpAndSettle();

    // addPlanting mengurutkan tanggal tanam, jadi posisinya kembali sendiri.
    expect(state.plantings.map((p) => p.id).toList(),
        ['padi', 'jagung', 'kentang']);
  });
}
