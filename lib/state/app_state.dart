import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/i18n.dart';
import '../core/password.dart';
import '../data/farm_repository.dart';
import '../data/firestore_farm_backend.dart';
import '../data/local_farm_repository.dart';
import '../data/syncing_farm_repository.dart';
import '../models/commodity.dart';
import '../models/farm_activity.dart';
import '../models/farm_settings.dart';
import '../models/ledger.dart';
import '../models/optimization_run.dart';
import '../models/planting.dart';
import '../models/plot.dart';
import '../models/sim_record.dart';
import '../services/firebase_gate.dart';
import '../services/market_service.dart';
import '../services/recommendation.dart';
import '../services/weather_service.dart';

export '../models/sim_record.dart';

class AppState extends ChangeNotifier {
  late SharedPreferences _p;

  /// Bernilai `true` hanya bila [_p] benar-benar terisi. Seluruh pembaca yang
  /// dapat dipanggil sebelum [bukaSimpanan] selesai harus memeriksa nilai ini:
  /// sebelumnya, `late _p` yang belum terisi menimbulkan
  /// `LateInitializationError` dan aplikasi tidak dapat digunakan sama sekali.
  bool _simpanSiap = false;
  bool get simpanSiap => _simpanSiap;

  /// Penyebab [simpanSiap] gagal, untuk ditampilkan di layar. Tanpa kabel USB,
  /// tangkapan layar baris ini merupakan satu-satunya log dari perangkat yang
  /// dapat dibaca.
  static String? masalahSimpanan;

  /// Buka penyimpanan perangkat. Wajib menjadi langkah pertama, sebelum layar
  /// mana pun dibangun.
  ///
  /// Tiga pengamanan diterapkan karena penyebab kegagalan di perangkat tidak
  /// selalu dapat dibaca langsung: batas waktu untuk setiap langkah (akses
  /// penyimpanan dapat menggantung), satu kali percobaan ulang (pemicu yang
  /// umum berupa kegagalan sesaat), dan cadangan penyimpanan di memori agar
  /// aplikasi tetap dapat dijalankan meskipun setelan tidak tersimpan setelah
  /// ditutup.
  Future<void> bukaSimpanan() async {
    if (_simpanSiap) return;
    for (var kali = 1; kali <= 2; kali++) {
      try {
        _p = await SharedPreferences.getInstance()
            .timeout(const Duration(seconds: 6));
        _simpanSiap = true;
        masalahSimpanan = null;
        debugPrint('[simpanan] siap (percobaan $kali)');
        return;
      } catch (e) {
        debugPrint('[simpanan] percobaan $kali gagal: $e');
        masalahSimpanan = tpl(
            'Penyimpanan HP tidak bisa dibuka, jadi data tidak tersimpan '
            'setelah aplikasi ditutup. ({0})',
            ['$e']);
      }
    }
    // Hasil percobaan pertama disimpan oleh plugin, sehingga bila kegagalan
    // berupa gantung (bukan exception) maka getInstance() akan menggantung
    // kembali. Mengganti instance penyimpanan merupakan satu-satunya jalan
    // keluar.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(const {});
    _p = await SharedPreferences.getInstance();
    _simpanSiap = true;
    debugPrint('[simpanan] berjalan di memori saja');
  }

  /// Pintu tunggal ke data kebun. Selamanya tersedia dalam versi lokal, lalu
  /// beralih ke versi bersinkron begitu Firebase aktif dan akun ini memiliki
  /// uid.
  late final LocalFarmRepository _lokal = LocalFarmRepository(_p);
  SyncingFarmRepository? _sync;

  FarmRepository get _repo => _sync ?? _lokal;

  /// Kunci data di perangkat ini (email) beserta uid Firebase-nya. [uid] kosong
  /// untuk akun yang dibuat secara luring, sehingga datanya tetap berada di
  /// perangkat.
  String uid = '';
  PemilikData get _pemilik => PemilikData(email, uid: uid);

  bool loggedIn = false;
  String name = '', email = '';
  String avatarEmoji = '';
  int landArea = 1000, capital = 5000000;
  String landType = landTypes.first, goal = 'Keuntungan';
  String? activeId;
  bool hasInput = false, notifOn = true, priceAlert = true;

  /// Mode tampilan: 'system' mengikuti setelan perangkat, 'light'/'dark'
  /// merupakan pilihan pengguna. Disimpan per perangkat, bukan per akun, agar
  /// aplikasi selalu terbuka dengan warna yang sama sebelum pengguna masuk.
  String themeMode = 'system';
  static const themeModes = ['system', 'light', 'dark'];

  bool get gelapAktif => switch (themeMode) {
        'dark' => true,
        'light' => false,
        _ => WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
      };

  /// Bahasa antarmuka: 'sistem' mengikuti bahasa perangkat, 'id'/'en' merupakan
  /// pilihan pengguna. Sama seperti [themeMode], ini setelan perangkat, bukan
  /// akun.
  String bahasa = 'id';
  static const bahasaYangDidukung = ['sistem', ...Lang.daftar];

  bool get bahasaInggris => bahasaAktif == 'en';

  /// Kode bahasa yang benar-benar dipakai sekarang.
  String get bahasaAktif => switch (bahasa) {
        'en' => 'en',
        'id' => 'id',
        _ => localeSistem().languageCode,
      };

  /// Bahasa perangkat yang digunakan saat pilihan 'sistem' aktif.
  static Locale localeSistem() {
    for (final c in WidgetsBinding.instance.platformDispatcher.locales) {
      if (Lang.daftar.contains(c.languageCode)) return c;
    }
    return const Locale('id');
  }

  List<SimRecord> history = [];
  List<LedgerEntry> ledger = [];
  List<Planting> plantings = [];

  /// Petak lahan yang tercatat. Untuk sementara masih kosong sampai layar kebun
  /// dapat menambahkannya; [PlotZone] pada peta lahan tetap berupa hasil
  /// turunan.
  List<Plot> plots = [];

  /// Kerja dan pengamatan lapangan yang pernah dicatat pengguna.
  List<FarmActivity> activities = [];

  /// Arsip rencana optima yang pernah dihitung.
  List<OptimizationRun> optimizations = [];

  /// Lokasi kebun, digunakan untuk prakiraan cuaca nyata (Open-Meteo).
  /// Kosong berarti belum terdeteksi; aplikasi tidak lagi memakai Bandung
  /// sebagai nilai bawaan agar data yang tampil benar-benar lokasi pengguna.
  double farmLat = 0, farmLon = 0;
  String farmCity = '';
  bool locationChosen = false;
  bool get locationReady => farmCity.isNotEmpty;

  /// Harga yang dicatat pengguna sendiri, menggantikan angka simulasi.
  Map<String, double> manualPrices = {};
  Map<String, double> manualPricesPrev = {};

  WeatherSnapshot? weather;
  bool weatherBusy = false;

  List<Reco> get ranked => Engine.rank(
      area: landArea, capital: capital, landType: landType, goal: goal);
  Reco get top => ranked.first;
  Commodity get active => commodityById(activeId ?? top.c.id);

  // ---------- penyimpanan ----------
  Future<void> load() async {
    await bukaSimpanan();
    themeMode = _p.getString('themeMode') ?? 'system';
    bahasa = _p.getString('bahasa') ?? 'id';
    final s = _p.getString('session');
    if (s == null) return;
    // Membuka kembali akun lama menyentuh data yang ditulis versi aplikasi
    // sebelumnya. Bila formatnya tidak cocok, aplikasi harus tetap terbuka
    // sebagai tamu, bukan berhenti pada layar awal.
    try {
      final acc = _accounts()[s];
      if (acc != null) await _enter(s, acc as Map);
    } catch (e) {
      debugPrint('[load] akun lama gagal dibuka, buka sebagai tamu: $e');
      loggedIn = false;
    }
  }

  Map<String, dynamic> _accounts() {
    if (!_simpanSiap) return {};
    final s = _p.getString('accounts');
    return s == null ? {} : Map<String, dynamic>.from(jsonDecode(s) as Map);
  }

  static const avatarChoices = [
    '👨‍🌾',
    '👩‍🌾',
    '🧑‍🌾',
    '👴',
    '👵',
    '🌱',
    '🌻',
    '🌾',
    '🍅',
    '🌶️',
    '🥬',
    '🍌',
    '🥥',
    '🐔',
    '🐄',
  ];

  /// Daftar akun yang tersimpan di perangkat ini (tanpa password).
  List<Map<String, String>> get accountsList => [
        for (final e in _accounts().entries)
          {
            'id': e.key,
            'name': ((e.value as Map)['name'] as String?) ?? e.key,
            'emoji': ((e.value as Map)['emoji'] as String?) ?? '',
          }
      ];

  Future<void> _enter(String mail, Map acc) async {
    email = mail;
    name = (acc['name'] as String?) ?? mail;
    avatarEmoji = (acc['emoji'] as String?) ?? '';
    uid = (acc['uid'] as String?) ?? '';
    loggedIn = true;
    _pasangSinkron();
    _terapkan(await _repo.muat(_pemilik) ?? FarmSnapshot.kosong());
    weather = _readWeatherCache(mail);
    await _p.setString('session', mail);
    notifyListeners();
    if (!locationChosen) await autoLocate();
    refreshWeather();
  }

  /// Pasang lapisan sinkron Firestore. Dipanggil ulang setiap masuk akun,
  /// tetapi hanya membuat objek baru bila belum ada: lapisan inilah yang
  /// menyimpan antrean kirim, sehingga membuatnya ulang akan membuang perubahan
  /// yang belum terkirim.
  void _pasangSinkron() {
    if (_sync != null || !FirebaseGate.siap || uid.isEmpty) return;
    final s =
        SyncingFarmRepository(lokal: _lokal, server: FirestoreFarmBackend());
    s.padaTarikUlang = (versi) {
      _terapkan(versi);
      notifyListeners();
    };
    _sync = s;
  }

  /// Ada perubahan yang belum sampai ke server?
  bool get belumTersinkron => _sync?.menungguSinkron.value ?? false;

  /// Kirim sekarang, tanpa menunggu jeda otomatis.
  Future<void> sinkronkanSekarang() async {
    await _sync?.cobaSinkronLagi();
    notifyListeners();
  }

  @override
  void dispose() {
    _sync?.dispose();
    super.dispose();
  }

  /// Isi state dari snapshot repository.
  void _terapkan(FarmSnapshot s) {
    final st = s.settings;
    landArea = st.landArea;
    capital = st.capital;
    landType = st.landType;
    goal = st.goal;
    activeId = st.activeId;
    hasInput = st.hasInput;
    notifOn = st.notifOn;
    priceAlert = st.priceAlert;
    farmLat = st.farmLat;
    farmLon = st.farmLon;
    farmCity = st.farmCity;
    locationChosen = st.locationChosen;
    manualPrices = Map.of(st.manualPrices);
    manualPricesPrev = Map.of(st.manualPricesPrev);
    history = List.of(s.history);
    ledger = List.of(s.ledger);
    plantings = List.of(s.plantings);
    plots = List.of(s.plots);
    activities = List.of(s.activities);
    optimizations = List.of(s.optimizations);
    MarketService.manual = manualPrices;
    MarketService.manualPrev = manualPricesPrev;
  }

  /// State sekarang, dalam bentuk yang dimengerti repository.
  FarmSnapshot _snapshot() => FarmSnapshot(
        settings: FarmSettings(
          landArea: landArea,
          capital: capital,
          landType: landType,
          goal: goal,
          activeId: activeId,
          hasInput: hasInput,
          notifOn: notifOn,
          priceAlert: priceAlert,
          farmLat: farmLat,
          farmLon: farmLon,
          farmCity: farmCity,
          locationChosen: locationChosen,
          manualPrices: manualPrices,
          manualPricesPrev: manualPricesPrev,
        ),
        history: history,
        ledger: ledger,
        plantings: plantings,
        plots: plots,
        activities: activities,
        optimizations: optimizations,
        // Penentu versi yang menang ketika dua perangkat berubah bersamaan:
        // perubahan yang terakhir disimpan yang digunakan.
        diubahMs: DateTime.now().millisecondsSinceEpoch,
      );

  WeatherSnapshot? _readWeatherCache(String mail) {
    final raw = _p.getString('wx_$mail');
    if (raw == null) return null;
    try {
      return WeatherSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeWeatherCache(WeatherSnapshot w) =>
      _p.setString('wx_$email', jsonEncode(w.toJson()));

  /// Ambil prakiraan nyata. Bila gagal, cache dipertahankan; simulasi dipakai
  /// ketika cache kosong.
  Future<void> refreshWeather() async {
    if (weatherBusy || !locationReady) return;
    weatherBusy = true;
    notifyListeners();
    try {
      weather = await WeatherService.fetch(farmLat, farmLon);
      await _writeWeatherCache(weather!);
    } catch (_) {
      weather ??= WeatherService.simulated();
    } finally {
      weatherBusy = false;
      notifyListeners();
    }
  }

  /// Perkiraan posisi dari alamat jaringan, tanpa izin sehingga aman dipanggil
  /// otomatis saat aplikasi menyala. Tombol "Pakai lokasi perangkat saya"
  /// memakai GPS asli dan tersedia di layar lokasi.
  Future<void> autoLocate() async {
    try {
      final p = await WeatherService.detectLocation();
      farmCity = p.name;
      farmLat = p.lat;
      farmLon = p.lon;
      weather = null;
      await _save();
      notifyListeners();
      refreshWeather();
    } catch (_) {
      notifyListeners();
    }
  }

  Future<void> setFarmLocation({
    required String city,
    required double lat,
    required double lon,
  }) async {
    farmCity = city;
    farmLat = lat;
    farmLon = lon;
    locationChosen = true;
    weather = null;
    await _save();
    notifyListeners();
    refreshWeather();
  }

  /// Simpan harga catatan sendiri; nilai null atau nol mengembalikan ke
  /// simulasi.
  Future<void> setManualPrice(String commodityId, double? value) async {
    if (value == null || value <= 0) {
      manualPrices.remove(commodityId);
      manualPricesPrev.remove(commodityId);
    } else {
      if (manualPrices[commodityId] != null) {
        manualPricesPrev[commodityId] = manualPrices[commodityId]!;
      }
      manualPrices[commodityId] = value;
    }
    MarketService.manual = manualPrices;
    MarketService.manualPrev = manualPricesPrev;
    await _save();
    notifyListeners();
  }

  Future<void> _save() => _repo.simpan(_pemilik, _snapshot());

  // ---------- akun ----------
  Future<String?> register(String nm, String id, String pass) async {
    final key = id.trim().toLowerCase();
    final acc = _accounts();
    if (acc.containsKey(key)) return 'Akun sudah terdaftar. Silakan masuk.';
    acc[key] = {'name': nm.trim(), 'pass': Password.hash(pass)};
    await _p.setString('accounts', jsonEncode(acc));
    await _enter(key, acc[key] as Map);
    return null;
  }

  Future<String?> login(String id, String pass) async {
    final key = id.trim().toLowerCase();
    final acc = _accounts()[key];
    if (acc == null) return 'Akun tidak ditemukan. Silakan daftar dulu.';
    final simpan = (acc as Map)['pass'] as String;
    if (!Password.verify(simpan, pass)) return 'Password salah.';
    if (Password.perluUpgrade(simpan)) {
      final semua = _accounts();
      (semua[key] as Map)['pass'] = Password.hash(pass);
      await _p.setString('accounts', jsonEncode(semua));
    }
    await _enter(key, acc);
    return null;
  }

  Future<void> logout() async {
    // Perubahan yang masih mengantre dikirim dulu sebelum akun ditinggalkan.
    await _sync?.cobaSinkronLagi();
    _sync?.dispose();
    _sync = null;
    uid = '';
    await _p.remove('session');
    loggedIn = false;
    notifyListeners();
  }

  // ---------- akun online (Firebase) ----------

  /// Alamat yang dipakai tautan email-link. Pada web, alamat tempat aplikasi
  /// sedang dibuka; pada Android, alamat hosting karena tautan datang dari luar
  /// aplikasi.
  String get tautanDasar =>
      kIsWeb ? Uri.base.toString() : 'https://agrinexa-5082d.web.app/';

  Future<String?> loginDenganGoogle({String nama = ''}) async {
    if (!await FirebaseGate.mulai()) {
      return tr('Firebase belum dikonfigurasi di perangkat ini.');
    }
    try {
      final cred = kIsWeb
          ? await FirebaseGate.auth.signInWithPopup(GoogleAuthProvider())
          : await FirebaseGate.auth.signInWithProvider(GoogleAuthProvider());
      return await _serapPengguna(cred.user, nama);
    } on FirebaseAuthException catch (e) {
      final m = pesanAuth(e);
      return m.isEmpty ? null : tr(m);
    } catch (_) {
      return tr('Gagal terhubung ke Google. Periksa koneksi internet.');
    }
  }

  /// Masuk dengan email dan kata sandi. Masuk ini memakai Firebase Auth agar
  /// uid-nya juga berlaku di perangkat lain (kunci dokumen Firestore); akun
  /// perangkat kemudian disiapkan melalui jalur yang sama dengan Google.
  Future<String?> masukEmail(String mail, String pass) async {
    if (!await FirebaseGate.mulai()) {
      return tr('Firebase belum dikonfigurasi di perangkat ini.');
    }
    try {
      final cred = await FirebaseGate.auth
          .signInWithEmailAndPassword(email: mail.trim(), password: pass);
      return await _serapPengguna(cred.user);
    } on FirebaseAuthException catch (e) {
      final m = pesanAuth(e);
      return tr(m.isEmpty
          ? 'Gagal masuk. Periksa koneksi internet lalu coba lagi.'
          : m);
    }
  }

  Future<String?> daftarEmail(String nama, String mail, String pass) async {
    if (!await FirebaseGate.mulai()) {
      return tr('Firebase belum dikonfigurasi di perangkat ini.');
    }
    try {
      final cred = await FirebaseGate.auth
          .createUserWithEmailAndPassword(email: mail.trim(), password: pass);
      final u = cred.user;
      if (u != null && nama.trim().isNotEmpty) {
        await u.updateDisplayName(nama.trim());
      }
      return await _serapPengguna(u, nama);
    } on FirebaseAuthException catch (e) {
      final m = pesanAuth(e);
      return tr(m.isEmpty
          ? 'Gagal membuat akun. Periksa koneksi internet lalu coba lagi.'
          : m);
    }
  }

  /// Kirim tautan atur ulang kata sandi. Firebase yang mengirim email dan
  /// menyimpan kata sandinya, sehingga alur ini juga berjalan di Android —
  /// berbeda dengan tautan masuk yang hanya dapat diselesaikan di peramban web.
  ///
  /// Email yang belum terdaftar sengaja dijawab seolah berhasil: aplikasi tidak
  /// boleh memberi tahu kepada siapa pun email mana yang memiliki akun.
  Future<String?> lupaPassword(String mail) async {
    if (!await FirebaseGate.mulai()) {
      return tr('Firebase belum dikonfigurasi di perangkat ini.');
    }
    try {
      await FirebaseGate.auth
          .sendPasswordResetEmail(email: mail.trim().toLowerCase());
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return null;
      final m = pesanAuth(e);
      return m.isEmpty ? tr('Gagal mengirim tautan.') : tr(m);
    }
  }

  Future<String?> kirimTautanMasuk(String mail, {String nama = ''}) async {
    if (!await FirebaseGate.mulai()) {
      return tr('Firebase belum dikonfigurasi di perangkat ini.');
    }
    try {
      await FirebaseGate.auth.sendSignInLinkToEmail(
        email: mail,
        actionCodeSettings:
            ActionCodeSettings(url: tautanDasar, handleCodeInApp: true),
      );
      await _p.setString('tautanEmail', mail);
      // Tautan dibuka pada pemuatan halaman baru, sehingga nama harus disimpan
      // sekarang: saat login selesai, kolom namanya sudah tidak ada.
      if (nama.trim().isNotEmpty) await _p.setString('tautanNama', nama.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      final m = pesanAuth(e);
      return m.isEmpty ? tr('Gagal mengirim tautan.') : tr(m);
    }
  }

  /// Dipanggil layar masuk: apabila alamat saat ini membawa tautan email-link,
  /// login diselesaikan tanpa pengguna mengetik apa pun.
  Future<String?> cobaTautanMasuk() async {
    if (!kIsWeb) return null;
    if (!await FirebaseGate.mulai()) return null;
    if (!FirebaseGate.auth.isSignInWithEmailLink(Uri.base.toString())) {
      return null;
    }
    final mail = _p.getString('tautanEmail');
    if (mail == null) {
      return tr('Masukkan email Anda, lalu buka lagi tautan dari email.');
    }
    try {
      final cred = await FirebaseGate.auth
          .signInWithEmailLink(email: mail, emailLink: Uri.base.toString());
      return await _serapPengguna(cred.user, _p.getString('tautanNama') ?? '');
    } on FirebaseAuthException catch (e) {
      final m = pesanAuth(e);
      return m.isEmpty ? null : tr(m);
    }
  }

  /// Akun Google/email-link dijadikan akun lokal agar lahan, modal, dan riwayat
  /// tetap tersimpan per akun seperti sebelumnya. uid-nya ikut disimpan karena
  /// nilai tersebut menjadi kunci dokumen di Firestore.
  ///
  /// Urutan prioritas nama: nama yang diketik pengguna, nama akun ini pada
  /// perangkat, nama Google, lalu awalan email.
  Future<String?> _serapPengguna(User? u, [String nama = '']) async {
    if (u == null) return null;
    final mail = (u.email ?? '').trim().toLowerCase();
    if (mail.isEmpty) return tr('Akun Google ini tidak punya email.');
    final semua = _accounts();
    final lama = semua[mail] as Map?;
    final acc = lama ?? <String, dynamic>{'pass': '', 'emoji': ''};
    final namaDipilih = [
      nama.trim(),
      (acc['name'] as String?)?.trim() ?? '',
      (u.displayName ?? '').trim(),
    ].firstWhere((t) => t.isNotEmpty, orElse: () => mail.split('@').first);
    final perluDisimpan = lama == null ||
        lama['uid'] != u.uid ||
        (lama['name'] as String?) != namaDipilih;
    acc['name'] = namaDipilih;
    acc['uid'] = u.uid;
    if (perluDisimpan) {
      semua[mail] = acc;
      await _p.setString('accounts', jsonEncode(semua));
    }
    await _enter(mail, acc);
    return null;
  }

  Future<void> updateName(String nm) async {
    final acc = _accounts();
    if (acc[email] != null) {
      (acc[email] as Map)['name'] = nm.trim();
      await _p.setString('accounts', jsonEncode(acc));
    }
    name = nm.trim();
    notifyListeners();
  }

  Future<void> setAvatarEmoji(String emoji) async {
    final acc = _accounts();
    if (acc[email] != null) {
      (acc[email] as Map)['emoji'] = emoji;
      await _p.setString('accounts', jsonEncode(acc));
    }
    avatarEmoji = emoji;
    notifyListeners();
  }

  // ---------- onboarding ----------
  bool get needOnboarding =>
      !_simpanSiap || !(_p.getBool('seenOnboarding') ?? false);
  Future<void> finishOnboarding() async {
    if (_simpanSiap) await _p.setBool('seenOnboarding', true);
  }

  // ---------- data usaha tani ----------
  Future<void> saveFarm({
    required int area,
    required int cap,
    required String type,
    required String goalValue,
  }) async {
    landArea = area;
    capital = cap;
    landType = type;
    goal = goalValue;
    hasInput = true;
    activeId = null; // Mengikuti rekomendasi teratas
    await _save();
    notifyListeners();
  }

  Future<void> setActive(String id) async {
    activeId = id;
    await _save();
    notifyListeners();
  }

  Future<void> addRecord(SimRecord r) async {
    history.insert(0, r);
    if (history.length > 50) history = history.sublist(0, 50);
    await _save();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history = [];
    await _save();
    notifyListeners();
  }

  // ---------- buku kas ----------
  int get ledgerIn =>
      ledger.where((e) => e.income).fold(0, (a, e) => a + e.amount);
  int get ledgerOut =>
      ledger.where((e) => !e.income).fold(0, (a, e) => a + e.amount);
  int get ledgerBalance => ledgerIn - ledgerOut;

  Future<void> addLedger(LedgerEntry e) async {
    ledger = [e, ...ledger];
    await _save();
    notifyListeners();
  }

  Future<void> removeLedger(String id) async {
    ledger.removeWhere((e) => e.id == id);
    ledger = List.of(ledger);
    await _save();
    notifyListeners();
  }

  /// Mengembalikan catatan yang baru dihapus ke posisi awalnya. Buku kas tidak
  /// pernah diurutkan, sehingga tanpa indeks ini hasil "Urungkan" akan mengubah
  /// urutan.
  Future<void> restoreLedger(LedgerEntry e, int index) async {
    ledger = [...ledger]..insert(index.clamp(0, ledger.length), e);
    await _save();
    notifyListeners();
  }

  // ---------- kalender tanam ----------
  Future<void> addPlanting(Planting p) async {
    plantings = [...plantings, p]
      ..sort((a, b) => a.startMs.compareTo(b.startMs));
    await _save();
    notifyListeners();
  }

  Future<void> toggleStage(String id, int stage) async {
    final i = plantings.indexWhere((p) => p.id == id);
    if (i < 0) return;
    final p = plantings[i];
    final done = List<int>.from(p.done);
    done.contains(stage) ? done.remove(stage) : done.add(stage);
    plantings[i] = Planting(
        id: p.id, commodityId: p.commodityId, startMs: p.startMs, done: done);
    await _save();
    notifyListeners();
  }

  Future<void> removePlanting(String id) async {
    plantings.removeWhere((p) => p.id == id);
    plantings = List.of(plantings);
    await _save();
    notifyListeners();
  }

  Future<void> resetFarm() async {
    landArea = 1000;
    capital = 5000000;
    landType = landTypes.first;
    goal = 'Keuntungan';
    activeId = null;
    hasInput = false;
    await _save();
    notifyListeners();
  }

  Future<void> setNotif({bool? on, bool? price}) async {
    if (on != null) notifOn = on;
    if (price != null) priceAlert = price;
    await _save();
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    themeMode = mode;
    await _p.setString('themeMode', mode);
    notifyListeners();
  }

  Future<void> setBahasa(String kode) async {
    bahasa = kode;
    await _p.setString('bahasa', kode);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
