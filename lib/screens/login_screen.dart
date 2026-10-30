import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../state/app_state.dart';
import '../widgets/agri_scene.dart';
import '../widgets/common.dart';
import 'dashboard_screen.dart';
import 'onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _id = TextEditingController();
  final _nama = TextEditingController();
  final _pass = TextEditingController();
  bool _busy = false,
      _linkSent = false,
      _baru = false,
      _lihatPass = false,
      _resetSent = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cekTautan());
  }

  @override
  void dispose() {
    _id.dispose();
    _nama.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _fail(String m) => setState(() => _error = m);

  /// Apabila alamat saat ini membawa tautan email-link, login selesai otomatis.
  Future<void> _cekTautan() async {
    final state = AppScope.of(context);
    final err = await state.cobaTautanMasuk();
    if (!mounted) return;
    if (state.loggedIn) return _masuk();
    if (err != null) _fail(err);
  }

  void _masuk() {
    final state = AppScope.of(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => state.needOnboarding
                ? const OnboardingScreen()
                : const MainScreen()),
        (r) => false);
  }

  Future<void> _google() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final err =
        await AppScope.of(context).loginDenganGoogle(nama: _nama.text.trim());
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _busy = false;
        _error = err;
      });
      return;
    }
    if (AppScope.of(context).loggedIn) {
      _masuk();
    } else {
      setState(() => _busy = false);
    }
  }

  /// Masuk atau membuat akun dengan email dan kata sandi. Firebase Auth yang
  /// menyimpan kata sandi, sehingga akun yang sama dapat digunakan di perangkat
  /// lain.
  Future<void> _emailMasuk() async {
    final id = _id.text.trim();
    final pass = _pass.text;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(id)) {
      return _fail(tr('Isi email yang valid dulu.'));
    }
    if (pass.length < 6) {
      return _fail(tr('Password minimal 6 huruf.'));
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final state = AppScope.of(context);
    final err = _baru
        ? await state.daftarEmail(_nama.text.trim(), id, pass)
        : await state.masukEmail(id, pass);
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _busy = false;
        _error = err;
      });
      return;
    }
    if (state.loggedIn) {
      _masuk();
    } else {
      setState(() => _busy = false);
    }
  }

  /// Kirim tautan atur ulang kata sandi ke email. Ini satu-satunya tautan yang
  /// dapat diselesaikan pengguna Android: tautannya membuka halaman Firebase di
  /// peramban, bukan aplikasi ini, sehingga kata sandi baru diisi di sana lalu
  /// dipakai untuk masuk.
  Future<void> _lupa() async {
    final id = _id.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(id)) {
      return _fail(tr('Isi email dulu, lalu tekan kirim tautan.'));
    }
    setState(() {
      _busy = true;
      _error = null;
      _resetSent = false;
    });
    final err = await AppScope.of(context).lupaPassword(id);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _resetSent = err == null;
      _error = err;
    });
  }

  Future<void> _kirimTautan() async {
    final id = _id.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(id)) {
      return _fail(tr('Isi email yang valid dulu, lalu tekan kirim tautan.'));
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final err = await AppScope.of(context)
        .kirimTautanMasuk(id, nama: _nama.text.trim());
    if (!mounted) return;
    setState(() {
      _busy = false;
      _linkSent = err == null;
      _error = err;
    });
  }

  void _pickAccount(String id) => setState(() {
        _error = null;
        _linkSent = false;
        _resetSent = false;
        _id.text = id;
        // Nama yang sedang diketik bukan milik akun yang baru dipilih, sehingga
        // harus dibuang: jika tidak, ia menimpa nama akun lama saat masuk.
        _nama.clear();
      });

  /// Email yang terisi pernah masuk di perangkat ini. Bila ya, kolom nama dan
  /// email tidak diperlukan lagi karena emailnya tampil di dalam tombol.
  Map<String, String>? _akunLama(List<Map<String, String>> accounts) {
    final mail = _id.text.trim().toLowerCase();
    if (mail.isEmpty) return null;
    for (final a in accounts) {
      if (a['id']!.toLowerCase() == mail) return a;
    }
    return null;
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 14),
        child:
            UiText(t, style: TextStyle(fontSize: 14, color: AppColors.muted)),
      );

  Widget _accountsSection(List<Map<String, String>> accounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        UiText('Akun di perangkat ini',
            style: TextStyle(fontSize: 14, color: AppColors.muted)),
        const SizedBox(height: 8),
        SizedBox(
          // Tinggi 64, bukan 56: dua baris teks (nama dan email) beserta
          // padding membutuhkan 48 px, dan metrik font berubah bila Plus Jakarta
          // Sans belum termuat — pada uji ini chip mengalami overflow 1 px di
          // tinggi 56.
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final a = accounts[i];
              final selected =
                  _id.text.trim().toLowerCase() == a['id']!.toLowerCase();
              return GestureDetector(
                onTap: () => _pickAccount(a['id']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.mint : AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: selected ? AppColors.green : AppColors.line,
                        width: selected ? 1.6 : 1),
                  ),
                  child: Row(children: [
                    Avatar(a['name']!, size: 30, emoji: a['emoji']),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 110,
                          child: UiText(a['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                        ),
                        SizedBox(
                          width: 110,
                          child: UiText(a['id']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.muted)),
                        ),
                      ],
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
        UiText('Ketuk untuk memilih akun.',
            style: TextStyle(fontSize: 13, color: AppColors.muted)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final accounts = state.accountsList;
    final lama = _akunLama(accounts);
    final mail = _id.text.trim();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 210,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AgriScene(
                      hillHeight: 66,
                      frontColor: AppColors.bg,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: AssetImg(Assets.logo,
                                width: 52,
                                height: 52,
                                fit: BoxFit.contain,
                                fallback: Icon(Icons.eco_rounded,
                                    size: 48, color: AppColors.green)),
                          ),
                          const SizedBox(height: 8),
                          UiText('Agrinexa',
                              style: TextStyle(
                                  color: AppColors.tintaFoto,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  shadows: const [
                                    Shadow(
                                        color: Color(0x55000000), blurRadius: 8)
                                  ])),
                          UiText('Data hari ini, panen esok',
                              style: TextStyle(
                                  color: AppColors.tintaFotoLembut,
                                  fontSize: 14,
                                  shadows: const [
                                    Shadow(
                                        color: Color(0x44000000), blurRadius: 6)
                                  ])),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Panel(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const UiText('Masuk ke akun Anda',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800)),
                          if (lama == null || _baru) ...[
                            _label('Nama'),
                            TextField(
                                controller: _nama,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    hintText:
                                        tr('Nama yang tampil di aplikasi'))),
                            _label('Email'),
                            TextField(
                                controller: _id,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                    hintText: tr('contoh@agrinexa.id'))),
                          ],
                          _label('Password'),
                          TextField(
                              controller: _pass,
                              obscureText: !_lihatPass,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _emailMasuk(),
                              decoration: InputDecoration(
                                hintText: tr('Minimal 6 huruf'),
                                suffixIcon: IconButton(
                                  tooltip: tr('Lihat password'),
                                  onPressed: () =>
                                      setState(() => _lihatPass = !_lihatPass),
                                  icon: Icon(_lihatPass
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded),
                                ),
                              )),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _busy ? null : _emailMasuk,
                              child: UiText(_baru ? 'Buat akun baru' : 'Masuk',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                          TextButton(
                            onPressed: _busy ? null : _lupa,
                            child: const UiText(
                                'Lupa password? Kirim tautan ke email',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() {
                                      _baru = !_baru;
                                      _error = null;
                                      _linkSent = false;
                                      _resetSent = false;
                                    }),
                            child: UiText(
                                _baru
                                    ? 'Sudah punya akun? Masuk'
                                    : 'Belum punya akun? Buat akun baru',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(children: [
                                Icon(Icons.error_outline_rounded,
                                    color: AppColors.down, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: UiText(_error!,
                                      style: TextStyle(
                                          color: AppColors.down, fontSize: 14)),
                                ),
                              ]),
                            ),
                          if (_resetSent)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.mark_email_read_outlined,
                                        color: AppColors.green, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: UiText(
                                          tpl('Kalau email itu terdaftar, tautan atur password sudah dikirim ke {0}. Buka Gmail, ketuk tautan, lalu isi password baru.',
                                              [_id.text.trim()]),
                                          style: TextStyle(
                                              color: AppColors.green,
                                              fontSize: 13)),
                                    ),
                                  ]),
                            ),
                          const SizedBox(height: 18),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.card,
                                foregroundColor: AppColors.text,
                                side: BorderSide(color: AppColors.line)),
                            onPressed: _busy ? null : _google,
                            icon: _busy
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : Image.asset(Assets.googleG,
                                    width: 22, height: 22),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const UiText('Lanjut dengan Google',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    if (mail.isNotEmpty)
                                      UiText(mail,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.muted)),
                                  ]),
                            ),
                          ),
                          if (lama != null)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: _busy
                                      ? null
                                      : () => setState(() {
                                            _id.clear();
                                            _nama.clear();
                                            _error = null;
                                            _linkSent = false;
                                            _resetSent = false;
                                          }),
                                  child: const UiText('Ganti email',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600))),
                            ),
                          // Tautan email hanya dapat diselesaikan di web: pada
                          // Android tautan membuka peramban, bukan aplikasi ini.
                          if (kIsWeb) ...[
                            const SizedBox(height: 2),
                            TextButton.icon(
                              onPressed: _busy ? null : _kirimTautan,
                              icon: const Icon(Icons.mail_outline_rounded,
                                  size: 20),
                              label: const UiText('Kirim tautan masuk ke email',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ],
                          if (_linkSent)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(children: [
                                Icon(Icons.mark_email_read_outlined,
                                    color: AppColors.green, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: UiText(
                                      tpl('Tautan dikirim ke {0}. Buka email Anda lalu ketuk tautan di dalamnya.',
                                          [_id.text.trim()]),
                                      style: TextStyle(
                                          color: AppColors.green,
                                          fontSize: 13)),
                                ),
                              ]),
                            ),
                          const SizedBox(height: 14),
                          Center(
                            child: UiText(
                                'Setiap akun punya lahan, modal, dan riwayatnya sendiri.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: AppColors.muted)),
                          ),
                        ],
                      ),
                    ),
                    if (accounts.isNotEmpty) _accountsSection(accounts),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
