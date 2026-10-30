import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/core/i18n.dart';
import 'package:agrinexa/core/theme.dart';
import 'package:agrinexa/main.dart';
import 'package:agrinexa/screens/calendar_screen.dart';
import 'package:agrinexa/screens/fertilizer_screen.dart';
import 'package:agrinexa/screens/dashboard_screen.dart';
import 'package:agrinexa/screens/detail_screen.dart';
import 'package:agrinexa/screens/field_mode_screen.dart';
import 'package:agrinexa/screens/guide_list_screen.dart';
import 'package:agrinexa/screens/input_screen.dart';
import 'package:agrinexa/screens/ledger_screen.dart';
import 'package:agrinexa/screens/login_screen.dart';
import 'package:agrinexa/screens/market_screen.dart';
import 'package:agrinexa/screens/misc_screens.dart';
import 'package:agrinexa/screens/pest_screen.dart';
import 'package:agrinexa/screens/profile_screen.dart';
import 'package:agrinexa/screens/recommendation_screen.dart';
import 'package:agrinexa/screens/simulation_screen.dart';
import 'package:agrinexa/screens/weather_screen.dart';
import 'package:agrinexa/services/market_service.dart';
import 'package:agrinexa/services/weather_service.dart';
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

void main() {
  test('setelan yang belum terbuka tidak boleh membuat layar mati', () {
    // Regresi 2026-10-26 di HP: penyimpanan belum terisi saat layar dibangun,
    // satu pembacaan saja sudah cukup untuk mengubah seluruh aplikasi menjadi
    // layar error. Sekarang semua jalur punya penjaga.
    final state = AppState();
    expect(state.simpanSiap, isFalse);
    expect(state.needOnboarding, isTrue);
    expect(state.accountsList, isEmpty);
  });

  testWidgets('menampilkan splash saat belum login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(AgrinexaApp(state: state));
    expect(find.text('Agrinexa'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
  });

  testWidgets('mencatat harga sendiri dari layar Pasar', (tester) async {
    tester.view.physicalSize = const Size(520, 3600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final state = await akunUji();
    await tester.pumpWidget(
        AppScope(state: state, child: const MaterialApp(home: MarketScreen())));
    await tester.pumpAndSettle();

    final tombolHarga = find.text('Atur harga sendiri');
    await tester.scrollUntilVisible(tombolHarga, 600,
        scrollable: find.byType(Scrollable).first);
    // Baris harga kini lebih tinggi; pastikan tombol benar-benar di layar.
    await tester.ensureVisible(tombolHarga);
    await tester.pumpAndSettle();
    await tester.tap(tombolHarga);
    await tester.pumpAndSettle();
    expect(find.text('Harga catatan sendiri'), findsOneWidget);

    final kolom = find.descendant(
        of: find.byType(BottomSheet), matching: find.byType(TextField));
    await tester.enterText(kolom, '26500');
    await tester.tap(find.text('Simpan harga'));
    await tester.pumpAndSettle();

    expect(MarketService.manualCount(), 1);
    expect(find.textContaining('Ubah harga catatan'), findsOneWidget);

    await tester.tap(find.textContaining('Ubah harga catatan'));
    await tester.pumpAndSettle();
    expect(find.text('Sudah dicatat'), findsOneWidget);
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    expect(MarketService.manualCount(), 0);
    await tester.tap(find.byType(ModalBarrier).last);
    await tester.pumpAndSettle();
    expect(find.text('Atur harga sendiri'), findsOneWidget);
  });

  testWidgets('layar cuaca memakai lokasi pilihan, tanpa error initState',
      (tester) async {
    final state = await akunUji();
    await state.setFarmLocation(city: 'Kediri', lat: -7.8167, lon: 112.0167);
    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: WeatherScreen())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Cuaca & Saran Tanam'), findsOneWidget);
    expect(find.text('Kediri'), findsOneWidget);
    expect(state.weather, isNotNull);
  });

  testWidgets('semua layar muat di HP sempit, di mode terang maupun gelap',
      (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = await akunUji();
    await state.setFarmLocation(city: 'Kediri', lat: -7.8167, lon: 112.0167);

    final layar = <String, Widget>{
      'Beranda': const MainScreen(),
      'Masuk': const LoginScreen(),
      'Detail': const DetailScreen(id: 'terong'),
      'Rekomendasi': const RecommendationScreen(),
      'Pasar': const MarketScreen(),
      'Cuaca': const WeatherScreen(),
      'Pupuk': const FertilizerScreen(),
      'Mode Ladang': const FieldModeScreen(),
      'Kalender': const CalendarScreen(),
      'Buku Kas': const LedgerScreen(),
      'Simulasi': const SimulationScreen(),
      'Hama': const PestScreen(),
      'Panduan': const GuideListScreen(),
      'Input': const InputScreen(),
      'Profil': const ProfileScreen(),
      'Riwayat': const HistoryScreen(),
      'Pengaturan': const SettingsScreen(),
      'Notifikasi': const NotificationScreen(),
      'Bantuan': const FaqScreen(),
      'Sumber Gambar': const ImageCreditsScreen(),
      'Tentang': const AboutScreen(),
    };

    addTearDown(() => Lang.pakai('id'));
    for (final (gelap, kode) in [
      (false, 'id'),
      (true, 'id'),
      (false, 'en'),
      (true, 'en'),
    ]) {
      Lang.pakai(kode);
      AppColors.pakai(gelap: gelap);
      // pump() berulang, bukan pumpAndSettle(): Skeleton berdenyut tanpa henti
      // dan akan membuat pumpAndSettle menunggu sampai timeout.
      for (final e in layar.entries) {
        await tester.pumpWidget(AppScope(
            state: state,
            child: MaterialApp(
                locale: Locale(kode),
                theme: buildTheme(),
                darkTheme: buildDarkTheme(),
                themeMode: gelap ? ThemeMode.dark : ThemeMode.light,
                home: e.value)));
        for (var i = 0; i < 8; i++) {
          await tester.pump(const Duration(milliseconds: 150));
        }
        expect(tester.takeException(), isNull,
            reason: 'layar ${e.key} dalam mode ${gelap ? 'gelap' : 'terang'}');
      }
    }
    AppColors.pakai(gelap: false);
    Lang.pakai('id');
  });

  testWidgets('tanpa lokasi, cuaca meminta pilihan — bukan data Bandung',
      (tester) async {
    final state = await akunUji();
    expect(state.locationReady, isFalse);
    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: WeatherScreen())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Pilih lokasi kebun'), findsOneWidget);
    expect(state.weather, isNull);
  });

  test('alamat OpenStreetMap disusun dari yang paling spesifik, 3 bagian luas',
      () {
    final desa = WeatherService.placeDariNominatim({
      'lat': '-6.2626765',
      'lon': '106.4217324',
      'address': {
        'road': 'Jalan Raya Cisoka',
        'village': 'Selapajang',
        'municipality': 'Cisoka',
        'county': 'Kabupaten Tangerang',
        'state': 'Banten',
      },
    });
    expect(desa.name, 'Selapajang');
    // Nama jalan terbuang sendiri: itu bukan alamat yang dicari petani.
    expect(desa.full, 'Selapajang, Cisoka, Kabupaten Tangerang, Banten');
    expect(desa.lat, closeTo(-6.2627, 0.001));

    final dusun = WeatherService.placeDariNominatim({
      'lat': '-6.5',
      'lon': '106.8',
      'address': {
        'hamlet': 'Cibeureum',
        'village': 'Sukamaju',
        'municipality': 'Cigudeg',
        'county': 'Kabupaten Bogor',
        'state': 'Jawa Barat',
      },
    });
    expect(dusun.full, 'Cibeureum, Sukamaju, Cigudeg, Kabupaten Bogor');

    // Tempat alam tanpa bagian alamat tetap memakai namanya sendiri.
    final alami = WeatherService.placeDariNominatim({
      'lat': '-6.9',
      'lon': '106.7',
      'name': 'Gunung Salak',
      'address': {'county': 'Kabupaten Sukabumi', 'state': 'Jawa Barat'},
    });
    expect(alami.full, 'Gunung Salak, Kabupaten Sukabumi, Jawa Barat');
  });
}
