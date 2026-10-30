import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/core/theme.dart';
import 'package:agrinexa/screens/login_screen.dart';
import 'package:agrinexa/state/app_state.dart';

Future<AppState> _perangkat({required bool adaSesi}) async {
  SharedPreferences.setMockInitialValues({
    'accounts':
        '{"budi@gmail.com":{"name":"budi","pass":"","emoji":""},"siti@agrinexa.id":{"name":"sarido","pass":"x","emoji":""}}',
    if (adaSesi) 'session': 'budi@gmail.com',
  });
  final state = AppState();
  await state.load();
  return state;
}

Future<void> _buka(WidgetTester tester, AppState state) async {
  await tester.pumpWidget(AppScope(
      state: state,
      child: MaterialApp(theme: buildTheme(), home: const LoginScreen())));
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

void main() {
  testWidgets('email baru: ada kolom Nama di atas Email', (tester) async {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _buka(tester, await _perangkat(adaSesi: false));

    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Nama yang tampil di aplikasi'), findsOneWidget);
    final kolom = find.byType(TextField);
    expect(kolom, findsNWidgets(3));
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Belum punya akun? Buat akun baru'), findsOneWidget);

    await tester.enterText(kolom.first, 'Pak Budi');
    await tester.pump();
    expect(find.text('Pak Budi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tombol buat akun membalik mode tanpa kehilangan kolom',
      (tester) async {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _buka(tester, await _perangkat(adaSesi: false));

    await tester.tap(find.text('Belum punya akun? Buat akun baru'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Buat akun baru'), findsOneWidget);
    expect(find.text('Sudah punya akun? Masuk'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));

    // Password pendek ditolak sebelum menyentuh jaringan.
    await tester.enterText(find.byType(TextField).at(1), 'budi@agrinexa.id');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.tap(find.text('Buat akun baru'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Password minimal 6 huruf.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tautan atur password: email kosong ditolak tanpa jaringan',
      (tester) async {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _buka(tester, await _perangkat(adaSesi: false));

    expect(find.text('Lupa password? Kirim tautan ke email'), findsOneWidget);

    await tester.tap(find.text('Lupa password? Kirim tautan ke email'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(
        find.text('Isi email dulu, lalu tekan kirim tautan.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('akun yang sudah pernah masuk: kolom hilang, email di tombol',
      (tester) async {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _buka(tester, await _perangkat(adaSesi: false));

    // Kartu akun ada di bawah panel yang tinggi: gulir dulu, seperti pengguna.
    await tester.ensureVisible(find.text('siti@agrinexa.id'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.tap(find.text('siti@agrinexa.id'));
    await tester.pump(const Duration(milliseconds: 250));

    // Tinggal kolom password: emailnya sudah ada di dalam tombol di bawah.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Ganti email'), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(OutlinedButton),
            matching: find.text('siti@agrinexa.id')),
        findsOneWidget);

    await tester.tap(find.text('Ganti email'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(TextField), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });
}
