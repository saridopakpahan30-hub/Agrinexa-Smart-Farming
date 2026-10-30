import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/core/theme.dart';
import 'package:agrinexa/main.dart';
import 'package:agrinexa/screens/misc_screens.dart';
import 'package:agrinexa/screens/splash_screen.dart';
import 'package:agrinexa/state/app_state.dart';
import 'package:agrinexa/widgets/common.dart';
import 'package:agrinexa/widgets/price_chart.dart';

double _luminansi(Color c) {
  double f(double v) =>
      v <= 0.04045 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b);
}

/// Rasio kontras WCAG 2.1. 4,5:1 = standar teks kecil; 7:1 = nyaman untuk mata
/// tua dan layar yang dibaca di bawah matahari.
double kontras(Color depan, Color latar) {
  final a = _luminansi(depan), b = _luminansi(latar);
  return (max(a, b) + 0.05) / (min(a, b) + 0.05);
}

String _hex(Color c) => '0x${c.toARGB32().toRadixString(16).toUpperCase()}';

void main() {
  // AppColors menyimpan palet di variabel global; jangan bocorkan mode gelap
  // ke tes berikutnya (atau ke berkas tes lain).
  tearDown(() => AppColors.pakai(gelap: false));

  group('kontras kedua palet', () {
    for (final p in [paletTerang, paletGelap]) {
      final nama = identical(p, paletGelap) ? 'gelap' : 'terang';

      test('$nama: teks utama minimal 7:1 di semua latar', () {
        for (final lat in [p.bg, p.card, p.mint, p.sunTint, p.downTint]) {
          expect(kontras(p.text, lat), greaterThanOrEqualTo(7),
              reason: 'teks di atas ${_hex(lat)}');
        }
      });

      test('$nama: teks pendukung & warna makna minimal 4,5:1', () {
        for (final lat in [p.bg, p.card, p.mint]) {
          for (final fg in [p.muted, p.green, p.down, p.sunInk]) {
            expect(kontras(fg, lat), greaterThanOrEqualTo(4.5),
                reason: '${_hex(fg)} di atas ${_hex(lat)}');
          }
        }
      });

      test('$nama: tombol hijau & kapsul peringatan terbaca', () {
        expect(kontras(Colors.white, p.greenFill), greaterThan(4.5));
        expect(kontras(p.sunInk, p.sunTint), greaterThan(4.5));
        expect(kontras(p.downInk, p.downTint), greaterThan(4.5));
      });

      test('$nama: tinta di atas latar mint terbaca', () {
        expect(kontras(p.onMint, p.mint), greaterThanOrEqualTo(6));
      });

      test('$nama: lapis-lapis latar saling terlihat', () {
        // Kalau kartu hampir sama terangnya dengan halaman, atau pilihan
        // (mint) hampir sama dengan kartu, tampilan terlihat "pudar" dan
        // elemen seperti tidak terpilih. Mode terang boleh lebih rapat karena
        // kartu dipisahkan bayangan; mode gelap tidak.
        expect(kontras(p.card, p.bg), greaterThanOrEqualTo(1.06),
            reason: 'kartu ${_hex(p.card)} di atas halaman ${_hex(p.bg)}');
        expect(kontras(p.mint, p.card), greaterThanOrEqualTo(1.10),
            reason:
                'chip terpilih ${_hex(p.mint)} di atas kartu ${_hex(p.card)}');
        expect(kontras(p.sunTintLine, p.sunTint), greaterThanOrEqualTo(1.6));
        expect(kontras(p.downTintLine, p.downTint), greaterThanOrEqualTo(1.6));
      });
    }

    test('mode gelap tidak memakai hitam/putih murni (mengurangi halation)',
        () {
      expect(paletGelap.bg.computeLuminance(), greaterThan(0));
      expect(paletGelap.text.computeLuminance(), lessThan(1));
      // Kontras maksimal (~21:1) membuat huruf seolah "berkeringat" di latar
      // hitam — justru sulit dibaca mata berusia 40 tahun ke atas.
      expect(kontras(paletGelap.text, paletGelap.bg), lessThan(19));
    });

    test('mode gelap: tidak ada latar yang ikut terang', () {
      // Kelas bug yang paling sering muncul: panel krem / merah muda / putih
      // yang nilainya ditulis langsung sehingga tetap terang saat mode gelap.
      // Semua latar dalam palet gelap harus tetap gelap.
      for (final lat in [
        paletGelap.bg,
        paletGelap.card,
        paletGelap.mint,
        paletGelap.sunTint,
        paletGelap.downTint,
        paletGelap.line
      ]) {
        expect(lat.computeLuminance(), lessThan(0.25),
            reason: '${_hex(lat)} terlalu terang untuk mode gelap');
      }
      for (final lat in [paletTerang.bg, paletTerang.card, paletTerang.mint]) {
        expect(lat.computeLuminance(), greaterThan(0.55),
            reason: '${_hex(lat)} terlalu gelap untuk mode terang');
      }
    });
  });

  group('sakelar tampilan', () {
    Future<AppState> mulai(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final s = AppState();
      await s.load();
      await tester.pumpWidget(AgrinexaApp(state: s));
      return s;
    }

    testWidgets('bawaan = mode terang', (tester) async {
      await mulai(tester);
      expect(AppColors.gelap, isFalse);
      expect(AppColors.bg, paletTerang.bg);
    });

    testWidgets('pilihan Gelap memakai palet gelap dan tersimpan',
        (tester) async {
      final s = await mulai(tester);
      await s.setThemeMode('dark');
      await tester.pump();
      expect(AppColors.gelap, isTrue);
      expect(AppColors.bg, paletGelap.bg);
      expect(AppColors.card, paletGelap.card);
      final p = await SharedPreferences.getInstance();
      expect(p.getString('themeMode'), 'dark');

      await s.setThemeMode('light');
      await tester.pump();
      expect(AppColors.gelap, isFalse);
      expect(AppColors.bg, paletTerang.bg);
    });

    testWidgets('pilihan tersimpan dipakai lagi saat aplikasi dibuka',
        (tester) async {
      SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
      final s = AppState();
      await s.load();
      expect(s.themeMode, 'dark');
      await tester.pumpWidget(AgrinexaApp(state: s));
      expect(AppColors.gelap, isTrue);
    });

    testWidgets('Ikut setelan HP: mengikuti gelapnya sistem', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await mulai(tester);
      expect(AppColors.gelap, isTrue);
    });

    testWidgets('Ikut setelan HP: layar dibangun ulang saat HP berganti mode',
        (tester) async {
      await mulai(tester);
      expect(AppColors.gelap, isFalse);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      // Dispatcher dipakai bersama sepanjang berkas ini; tanpa dibersihkan,
      // nilai uji "dark" merembet ke tes berikutnya.
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      tester.binding.handlePlatformBrightnessChanged();
      await tester.pump();
      expect(AppColors.gelap, isTrue);
    });

    testWidgets('tema Material ikut berganti, bukan hanya AppColors',
        (tester) async {
      final s = await mulai(tester);
      // Elemen SplashScreen berada di bawah Theme buatan MaterialApp, jadi
      // Theme.of di sini membaca tema yang benar-benar dipakai layar.
      ThemeData tema() => Theme.of(tester.element(find.byType(SplashScreen)));
      expect(tema().brightness, Brightness.light);
      expect(tema().scaffoldBackgroundColor, paletTerang.bg);
      await s.setThemeMode('dark');
      await tester.pump();
      expect(tema().brightness, Brightness.dark);
      expect(tema().scaffoldBackgroundColor, paletGelap.bg);
      expect(tema().textTheme.bodyMedium!.color, paletGelap.text);
    });

    testWidgets('kartu Tampilan di Pengaturan benar-benar mengganti mode',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
        'session': 't@x.id',
      });
      final s = AppState();
      await s.load();
      // AppColors hanya diisi oleh AgrinexaApp, jadi di sini yang dipastikan
      // adalah pilihan tersimpan + hasil perhitungannya.
      await tester.pumpWidget(AppScope(
          state: s,
          child:
              MaterialApp(theme: buildTheme(), home: const SettingsScreen())));
      await tester.pump();
      expect(find.text('Tampilan layar'), findsOneWidget);
      expect(s.gelapAktif, isFalse);

      await tester.ensureVisible(find.text('Gelap'));
      await tester.pump();
      await tester.tap(find.text('Gelap'));
      await tester.pump();
      expect(s.themeMode, 'dark');
      expect(s.gelapAktif, isTrue);

      await tester.ensureVisible(find.text('Terang'));
      await tester.pump();
      await tester.tap(find.text('Terang'));
      await tester.pump();
      expect(s.gelapAktif, isFalse);
    });
  });

  testWidgets('const SectionTitle mengikuti tema terang-gelap-terang',
      (tester) async {
    const title = SectionTitle('Judul bagian');
    const home = Scaffold(body: title);
    final light = buildTheme();
    final dark = buildDarkTheme();
    Element? originalElement;

    for (final theme in [light, dark, light]) {
      // Sengaja berlawanan: warna harus berasal dari Theme, bukan global.
      AppColors.pakai(gelap: theme.brightness == Brightness.light);
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        themeAnimationDuration: Duration.zero,
        home: home,
      ));
      await tester.pumpAndSettle();

      final titleFinder = find.byWidget(title);
      final element = tester.element(titleFinder);
      originalElement ??= element;
      expect(element, same(originalElement));
      final onSurface = Theme.of(element).colorScheme.onSurface;
      expect(onSurface, theme.colorScheme.onSurface);
      expect(AppColors.text, isNot(onSurface));
      final text = tester.widget<Text>(find.descendant(
        of: titleFinder,
        matching: find.byType(Text),
      ));
      expect(text.style!.color, onSurface);
      expect(tester.takeException(), isNull);
    }
  });

  group('PriceChart pada lebar 320', () {
    Future<void> pumpChart(
      WidgetTester tester, {
      required Widget child,
      required bool dark,
      required double scale,
    }) async {
      AppColors.pakai(gelap: dark);
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        themeAnimationDuration: Duration.zero,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: Scaffold(body: Align(alignment: Alignment.topLeft, child: child)),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    void narrowView(WidgetTester tester) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 640);
      addTearDown(tester.view.reset);
    }

    final cases = <String, List<double>>{
      'variasi kecil': [77266, 77621, 77295],
      'harga jutaan': [1277266, 1577621, 1377295],
      'datar': [77266, 77266, 77266],
      'satu titik': [77266],
      'kosong': [],
    };

    for (final dark in [false, true]) {
      for (final scale in [1.0, 1.5]) {
        final mode = dark ? 'gelap' : 'terang';
        for (final entry in cases.entries) {
          testWidgets('${entry.key}, $mode, skala $scale', (tester) async {
            narrowView(tester);
            // Uji API dengan tanggal eksplisit maupun tanggal bawaan.
            for (final withDates in [false, true]) {
              final dates = withDates
                  ? List.generate(
                      entry.value.length, (i) => DateTime(2026, 10, 20 + i * 2))
                  : null;
              await pumpChart(tester,
                  child: PriceChart(data: entry.value, dates: dates),
                  dark: dark,
                  scale: scale);
              final chartFinder = find.byType(PriceChart);
              expect(tester.getSize(chartFinder).width, 320);
              final context = tester.element(chartFinder);
              expect(Theme.of(context).brightness,
                  dark ? Brightness.dark : Brightness.light);
              expect(MediaQuery.textScalerOf(context).scale(1), scale);

              if (entry.value.isEmpty) {
                expect(find.byType(LineChart), findsNothing);
                expect(
                    find.descendant(
                      of: chartFinder,
                      matching: find.byType(Text),
                    ),
                    findsOneWidget);
                continue;
              }

              final chart = tester.widget<LineChart>(find.byType(LineChart));
              final data = chart.data;
              expect(data.minY, lessThan(data.maxY));
              expect(data.minY, lessThanOrEqualTo(entry.value.reduce(min)));
              expect(data.maxY, greaterThanOrEqualTo(entry.value.reduce(max)));
              final bar = data.lineBarsData.single;
              expect(bar.isCurved, isFalse);
              expect(bar.dotData.show, isTrue);
              expect(bar.belowBarData.show, isTrue);
              expect(bar.belowBarData.color, isNotNull);
              expect(bar.spots.map((spot) => spot.y), entry.value);
              for (var i = 0; i < bar.spots.length; i++) {
                expect(bar.spots[i].x, (withDates ? i * 2 : i).toDouble());
                expect(bar.dotData.checkToShowDot(bar.spots[i], bar), isTrue);
              }

              final labels = find.descendant(
                of: chartFinder,
                matching: find.byWidgetPredicate((widget) =>
                    widget is Text && widget.textAlign == TextAlign.right),
              );
              expect(labels, findsWidgets);
              final texts = tester.widgetList<Text>(labels).toList();
              expect(
                  texts.map((text) => text.data).toSet().length, texts.length);
              for (final element in labels.evaluate()) {
                final text = element.widget as Text;
                expect(text.maxLines, 1);
                expect(text.softWrap, isFalse);
                expect(
                    text.data, matches(RegExp(r'^\d+(,\d+)? (jt|rb)$|^\d+$')));
                // Pasang batas ruang nyata, bukan hanya memeriksa properti:
                // label penuh harus muat tanpa terpotong pada skala besar.
                final painter = TextPainter(
                  text: TextSpan(
                    text: text.data,
                    style: DefaultTextStyle.of(element).style.merge(text.style),
                  ),
                  textDirection: Directionality.of(element),
                  textScaler: MediaQuery.textScalerOf(element),
                  maxLines: 1,
                )..layout();
                final width = tester.getSize(find.byWidget(text)).width;
                expect(painter.width, lessThanOrEqualTo(width + 0.01));
                painter.dispose();
              }
              if (entry.key == 'harga jutaan') {
                expect(
                    texts.every((text) => text.data!.endsWith(' jt')), isTrue);
              }
              expect(tester.takeException(), isNull);
            }
          });
        }

        testWidgets(
            'label bersebelahan Rp100 tetap berbeda, $mode, skala $scale',
            (tester) async {
          narrowView(tester);
          await pumpChart(tester,
              child: const PriceChart(data: [77266, 77621, 77295]),
              dark: dark,
              scale: scale);
          final data = tester.widget<LineChart>(find.byType(LineChart)).data;
          final titles = data.titlesData.leftTitles.sideTitles;
          // Interval otomatis saat ini Rp500 (rentang minimum 2%). Uji
          // formatter asli pada Rp100 agar pembulatan ke "77 rb" terdeteksi,
          // tanpa mengubah pilihan interval atau menyalin formatter aplikasi.
          final widgets = <Widget>[];
          for (final value in [77300.0, 77400.0, 77500.0, 77600.0]) {
            widgets.add(SizedBox(
              width: titles.reservedSize,
              child: titles.getTitlesWidget(
                value,
                TitleMeta(
                  min: data.minY,
                  max: data.maxY,
                  parentAxisSize: 210,
                  axisPosition: 0,
                  appliedInterval: 100,
                  sideTitles: titles,
                  formattedValue: '77 rb',
                  axisSide: AxisSide.left,
                ),
              ),
            ));
          }
          await pumpChart(tester,
              child: Column(children: widgets), dark: dark, scale: scale);
          final labels = tester.widgetList<Text>(find.byType(Text)).toList();
          expect(labels.map((text) => text.data).toList(),
              ['77,3 rb', '77,4 rb', '77,5 rb', '77,6 rb']);
          expect(labels.map((text) => text.data).toSet(), hasLength(4));
          for (final text in labels) {
            expect(text.maxLines, 1);
            expect(text.softWrap, isFalse);
          }
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
