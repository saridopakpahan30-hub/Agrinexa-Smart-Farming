import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/models/commodity.dart';
import 'package:agrinexa/models/planting.dart';
import 'package:agrinexa/screens/field_mode_screen.dart';
import 'package:agrinexa/services/field_tasks.dart';
import 'package:agrinexa/services/weather_service.dart';
import 'package:agrinexa/state/app_state.dart';

WeatherSnapshot _cuaca(String kondisi, double prob) => WeatherSnapshot(
      fetchedAt: DateTime.now(),
      live: false,
      days: [
        for (var i = 0; i < 7; i++)
          WeatherDay(
            date: DateTime.now().add(Duration(days: i)),
            condition: kondisi,
            minTemp: 23,
            maxTemp: kondisi == 'panas' ? 36 : 31,
            rainProb: prob,
            humidity: 70,
          )
      ],
    );

/// Menjalankan frames cukup panjang sampai batas waktu 2 detik milik
/// [VoiceGuide] habis — kalau tidak, timer-nya masih menggantung saat uji selesai.
Future<void> stabil(WidgetTester tester) async {
  for (var i = 0; i < 18; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

void main() {
  test('tahap yang jatuh tempo hari ini muncul paling akhir urut', () {
    final c = commodityById('terong');
    final stages = stagesFor(c);
    final due = DateTime.now()
        .subtract(Duration(days: stages[2].dayOffset));
    final p = Planting(
        id: 'p1',
        commodityId: c.id,
        startMs: due.millisecondsSinceEpoch,
        done: const [0, 1]);
    final tugas = buildFieldTasks(
        plantings: [p], today: null, activeCrop: c, now: DateTime.now());

    expect(tugas.map((t) => t.title), contains(stages[2].label));
    final t = tugas.firstWhere((x) => x.title == stages[2].label);
    expect(t.dueLabel, 'Jatuh tempo hari ini');
    expect(t.plantingId, 'p1');
    expect(t.stage, 2);
    expect(t.detail, isNot(isEmpty));
    // tahap yang sudah selesai tidak ditagih lagi
    expect(tugas.map((t) => t.stage), isNot(contains(0)));
  });

  test('kerja yang sensitif cuaca dapat peringatan', () {
    final c = commodityById('terong');
    final stages = stagesFor(c);
    final pemupukan = stages.firstWhere((s) => s.label.contains('upuk'));
    expect(weatherCaution(pemupukan, _cuaca('hujan_lebat', 0.9).today),
        contains('Peluang hujan 90 persen'));
    expect(weatherCaution(pemupukan, _cuaca('cerah', 0.1).today), isNull);
  });

  test('tanpa rencana tanam, mode ladang tetap punya kerja', () {
    final tugas = buildFieldTasks(
        plantings: [],
        today: _cuaca('hujan', 0.6).today,
        activeCrop: commodityById('terong'));
    expect(tugas, isNotEmpty);
    expect(tugas.first.linkable, isFalse);
    expect(tugas.map((t) => t.title), contains('Keliling lahan & amati tanaman'));
  });

  testWidgets('Mode Ladang menandai tahap selesai lewat tombol Sudah',
      (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();
    final c = commodityById('terong');
    final planting = Planting(
      id: 'p1',
      commodityId: c.id,
      startMs: DateTime.now()
          .subtract(Duration(days: stagesFor(c)[2].dayOffset))
          .millisecondsSinceEpoch,
    );
    await state.addPlanting(planting);
    final tugas = buildFieldTasks(
        plantings: [planting], today: null, activeCrop: c);
    expect(tugas, isNotEmpty);

    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: FieldModeScreen())));
    await stabil(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('MODE LADANG'), findsOneWidget);
    expect(find.text(tugas.first.title), findsOneWidget);

    await tester.tap(find.text('Sudah dikerjakan'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(state.plantings.single.done, contains(tugas.first.stage));
    expect(find.text('Tugas 2 dari ${tugas.length}'), findsOneWidget);

    // sisa kerja hari ini diselesaikan satu per satu sampai layar selesai
    for (var i = 1; i < tugas.length; i++) {
      await tester.tap(find.text('Sudah dikerjakan'));
      await tester.pump(const Duration(milliseconds: 120));
    }
    expect(find.text('Catat hasil / biaya'), findsOneWidget);
    expect(state.plantings.single.done.length, tugas.length);

    await tester.tap(find.text('Keluar'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mode Ladang muat di layar sempit tanpa teks meluber',
      (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();
    await state.setFarmLocation(city: 'Kediri', lat: -7.8167, lon: 112.0167);

    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: FieldModeScreen())));
    // Di lingkungan uji engine TTS tidak pernah menjawab, jadi tunggu sampai
    // batas waktu 2 detik milik VoiceGuide habis dan kesimpulannya tampil.
    await stabil(tester);
    expect(tester.takeException(), isNull);
    // tanpa rencana tanam: tetap ada kerja, dan pemandu tidak layar kosong
    expect(find.textContaining('Keliling lahan'), findsOneWidget);
    // status suara ditulis apa adanya, bukan diam tanpa penjelasan
    expect(find.textContaining('Suara tidak tersedia'), findsOneWidget);
  });

  testWidgets('Mode Ladang tahan huruf diperbesar 1,3x dan 2x',
      (tester) async {
    for (final skala in [1.3, 2.0]) {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = skala;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      SharedPreferences.setMockInitialValues({
        'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
        'session': 't@x.id',
      });
      final state = AppState();
      await state.load();
      final c = commodityById('terong');
      await state.addPlanting(Planting(
        id: 'p$skala',
        commodityId: c.id,
        startMs: DateTime.now()
            .subtract(Duration(days: stagesFor(c)[2].dayOffset))
            .millisecondsSinceEpoch,
      ));

      await tester.pumpWidget(AppScope(
          state: state, child: const MaterialApp(home: FieldModeScreen())));
      await stabil(tester);
      expect(tester.takeException(), isNull, reason: 'skala $skala');

      await tester.tap(find.text('Sudah dikerjakan'));
      await tester.pump(const Duration(milliseconds: 150));
      expect(tester.takeException(), isNull, reason: 'skala $skala, lanjut');
    }
  });
}
