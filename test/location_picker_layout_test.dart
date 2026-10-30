import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/core/theme.dart';
import 'package:agrinexa/state/app_state.dart';
import 'package:agrinexa/widgets/location_picker.dart';

void main() {
  Future<void> bukaSheet(
    WidgetTester tester, {
    required double lebar,
    required double skala,
  }) async {
    tester.view.physicalSize = Size(lebar * 3, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});

    final state = AppState();

    await tester.pumpWidget(AppScope(
      state: state,
      child: MaterialApp(
        theme: buildTheme(),
        builder: (ctx, child) => MediaQuery(
          data:
              MediaQuery.of(ctx).copyWith(textScaler: TextScaler.linear(skala)),
          child: child!,
        ),
        home: Builder(
          builder: (ctx) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showLocationPicker(ctx),
                child: const Text('buka'),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();
  }

  for (final skala in [1.0, 1.3, 1.5]) {
    testWidgets('kotak cari terlihat pada lebar 360 · skala $skala',
        (tester) async {
      await bukaSheet(tester, lebar: 360, skala: skala);

      final field = tester.getRect(find.byType(TextField));
      final tombol = tester.getRect(find.text('Cari'));
      // ignore: avoid_print
      print('skala $skala -> field $field, tombol $tombol');

      expect(field.width, greaterThan(240));
      expect(tombol.right, lessThanOrEqualTo(360));
      expect(tombol.top, greaterThan(field.bottom));
    });
  }
}
