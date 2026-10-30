/// Padanan bahasa Inggris untuk kalimat Indonesia yang digunakan aplikasi.
///
/// Kunci adalah kalimat Indonesia persis seperti yang tampil di layar,
/// sehingga penambahan bahasa tidak pernah menghapus teks: kunci yang belum
/// tersedia di sini tetap ditampilkan dalam bahasa Indonesia. Karena kunci
/// harus identik karakter per karakter, `test/i18n_test.dart` memindai `lib/`
/// dan menuntut setiap kalimat memiliki baris di tabel ini.
library;

const Map<String, String> tabelInggris = {
  // ---------------------------------------------------------------- beranda
  'Menu Cepat': 'Quick menu',
  'Data masih bawaan. Ketuk untuk mengisi luas lahan & modal Anda.':
      'Still using sample data. Tap to enter your land area & capital.',
  'Rekomendasi Hari Ini': "Today's recommendations",
  '★ PILIHAN TERBAIK': '★ BEST CHOICE',
  'Keuntungan potensial': 'Potential profit',
  'Lihat Detail': 'See details',
  'Panduan tanam  →': 'Growing guide  →',
  'Harga Pasar Terkini': 'Latest market prices',
  'Lihat Semua': 'See all',
  'Mode Ladang': 'Field Mode',
  'Mulai': 'Start',
  'Ringkasan Usaha Tani': 'Farm summary',
  'Beranda': 'Home',
  'Rekomendasi': 'Recommendations',
  'Pasar': 'Market',
  'Profil': 'Profile',
  'Input Lahan': 'Land & capital',
  'Simulasi': 'Simulation',
  'Panduan': 'Guides',
  'Buku Kas': 'Cash book',
  'Kalender Tanam': 'Planting calendar',
  'Hama & Penyakit': 'Pests & diseases',
  'Cuaca': 'Weather',
  'Notifikasi': 'Notifications',
  'Petani': 'Farmer',
  'Luas Lahan': 'Land area',
  'Modal Tersedia': 'Available capital',
  'Komoditas Aktif': 'Active crop',
  // ------------------------------------------------------------ rekomendasi
  'Rekomendasi Komoditas': 'Crop recommendations',
  'Ubah data lahan & modal': 'Change land & capital data',
  'Optimal': 'Optimal',
  'Margin kotor': 'Gross margin',
  'Modal terbatas': 'Limited capital',
  'Rekomendasi ini mempertimbangkan luas lahan, modal, dan data pasar terkini.':
      'These recommendations weigh your land area, capital and current market data.',
  'Semua': 'All',
  // ------------------------------------------------------------------ detail
  '★ Rekomendasi Terbaik': '★ Best recommendation',
  'Ringkasan': 'Summary',
  'Analisis': 'Analysis',
  'Jadikan Aktif': 'Set as active',
  'Simulasikan Detail': 'Run detailed simulation',
  'Proyeksi Keuntungan': 'Profit projection',
  'Potensi Margin Kotor': 'Potential gross margin',
  'Perkiraan Omzet': 'Estimated revenue',
  'Biaya Variabel': 'Variable cost',
  'Modal Dibutuhkan': 'Capital needed',
  'Sisa Modal': 'Capital left',
  'Perkecil luas tanam atau tambah modal.':
      'Reduce the planted area or add capital.',
  'Keunggulan': 'Strengths',
  'Rendah': 'Low',
  'Sedang': 'Medium',
  'Tinggi': 'High',
  'Struktur Biaya': 'Cost structure',
  'Parameter Budidaya': 'Growing parameters',
  'Hasil panen': 'Yield',
  'Estimasi total panen': 'Estimated total harvest',
  'Umur tanam': 'Crop age',
  'Risiko harga': 'Price risk',
  'Kecocokan lahan': 'Land suitability',
  'Tips Budidaya': 'Growing tips',
  'Harga saat ini': 'Current price',
  'Permintaan': 'Demand',
  // ---------------------------------------------------------------- input
  'Input Lahan & Modal': 'Land & capital',
  'Data Lahan': 'Land data',
  'Jenis Tanah': 'Land type',
  'Jumlah Modal': 'Capital amount',
  'Preferensi': 'Preferences',
  'Tujuan Utama': 'Main goal',
  'Kestabilan': 'Stability',
  'Keuntungan': 'Profit',
  'Luas lahan minimal 1 m².': 'Land area must be at least 1 m².',
  'Modal minimal Rp 100.000.': 'Capital must be at least Rp 100,000.',
  'Mengurutkan komoditas dari margin terbesar.':
      'Ranks crops by the largest margin.',
  'Memprioritaskan komoditas dengan harga lebih stabil.':
      'Prioritises crops with steadier prices.',
  'Lanjut': 'Continue',

  // --------------------------------------------------------------- kalender
  'Tanam Baru': 'New planting',
  'Jadwal perawatan dari tanam sampai panen':
      'Care schedule from planting to harvest',
  'Rencana Tanam Baru': 'New planting plan',
  'Komoditas': 'Crop',
  'Simpan Jadwal': 'Save schedule',
  'Belum ada rencana tanam': 'No planting plans yet',
  'Catat tanggal tanam dan Agrinexa akan menyusun jadwal perawatan sampai panen untuk Anda.':
      'Enter the planting date and Agrinexa builds the care schedule up to harvest for you.',

  // ------------------------------------------------- tahap tanam (model)
  'Pengolahan lahan & lubang tanam': 'Land prep & planting holes',
  'Penanaman bibit': 'Transplanting seedlings',
  'Pemupukan awal': 'Base fertiliser',
  'Pemangkasan & sanitasi kebun': 'Pruning & orchard sanitation',
  'Pemupukan lanjutan': 'Follow-up fertiliser',
  'Awal panen (selektif)': 'First harvest (selective)',
  'Pengolahan lahan & bedengan': 'Land prep & raised beds',
  'Penanaman': 'Planting',
  'Penyulaman & pemupukan awal': 'Replanting gaps & base fertiliser',
  'Pemupukan kedua': 'Second fertiliser',
  'Pemeliharaan & pengawasan hama': 'Crop care & pest scouting',
  'Perkiraan panen': 'Estimated harvest',

  // --------------------------------------------------------------- buku kas
  'Catat': 'Record',
  'Pemasukan dan pengeluaran usaha tani': 'Farm income and expenses',
  'Riwayat': 'History',
  'Riwayat Catatan': 'Entry history',
  'Saldo Kas': 'Cash balance',
  'Arus Kas 6 Bulan': 'Six-month cash flow',
  'Uang masuk': 'Money in',
  'Uang keluar': 'Money out',
  'Jumlah': 'Amount',
  'Belum ada catatan': 'No entries yet',
  'Ketuk "Catat" untuk menambah pengeluaran atau pemasukan panen.':
      'Tap "Record" to add an expense or harvest income.',
  'Tidak ada hasil': 'No results',
  'Tidak ada catatan pada filter ini.': 'No entries match this filter.',
  'Catatan (opsional), mis. beli pupuk urea':
      'Note (optional), e.g. bought urea',
  'Komoditas terkait (opsional)': 'Related crop (optional)',
  'Simpan Catatan': 'Save entry',

  // ------------------------------------------------------------------ pasar
  'Informasi Pasar': 'Market information',
  'Cari komoditas (nama atau kategori)': 'Search crop (name or category)',
  'Data Harga Terbaru': 'Latest price data',
  'sejak kemarin': 'since yesterday',
  'harga catatan Anda': 'your own recorded price',
  'Komoditas tidak ditemukan.': 'Crop not found.',
  'Terendah': 'Lowest',
  'Tertinggi': 'Highest',
  'Harga catatan sendiri': 'Own recorded price',
  'Pakai harga yang Anda terima di lapangan. Rekomendasi, simulasi, dan buku kas ikut memakai angka ini.':
      'Uses the price you actually got in the field. Recommendations, simulations and the cash book all read this number.',
  'Harga per kg (Rp)': 'Price per kg (Rp)',
  'mis. 12000': 'e.g. 12000',
  'Simpan harga': 'Save price',
  'Hapus': 'Delete',
  'Sudah dicatat': 'Recorded',

  // ------------------------------------------------------------------ cuaca
  'Cuaca & Saran Tanam': 'Weather & planting advice',
  'Ubah lokasi kebun': 'Change farm location',
  'Perbarui': 'Refresh',
  'Pilih lokasi kebun': 'Choose farm location',
  'Cuaca diambil dari Open-Meteo untuk koordinat daerah Anda — semua kota dan kecamatan di Indonesia tersedia.':
      'Weather comes from Open-Meteo using your area coordinates — every city and district in Indonesia is available.',
  'Cari daerah saya': 'Find my area',
  'Mengambil prakiraan cuaca…': 'Loading the forecast…',
  'Prakiraan 7 Hari': 'Seven-day forecast',
  'Saran Untuk Hari Ini': "Today's advice",
  'Simulasi hari ini': "Today's simulation",

  // ----------------------------------------------------------- hama & panduan
  'Cari hama atau gejala…': 'Search pest or symptom…',
  'Daftar Pengganggu': 'Pest list',
  'Tidak ada yang cocok dengan pencarian.': 'Nothing matches your search.',
  'BERBAHAYA': 'DANGEROUS',
  'SERANGAN BISA MENULAR CEPAT': 'SPREADS QUICKLY',
  'Sering menyerang': 'Common on',
  'Panduan umum berbasis praktik lapang. Untuk rekomendasi pestisida resmi, konsultasikan dengan petugas Dinas Pertanian atau Penyuluh setempat.':
      'A general guide based on field practice. For official pesticide recommendations, ask your local agriculture agency officer or extension worker (PPL).',

  // ------------------------------------------------------------ pilih lokasi
  'Lokasi kebun': 'Farm location',
  'Cuaca, saran tanam, dan kalender mengikuti daerah ini.':
      'Weather, planting advice and the calendar follow this area.',
  'Pakai lokasi perangkat saya': 'Use my device location',
  'Atau cari: desa / kecamatan / kota':
      'Or search: village / district / city',
  'Cari': 'Search',
  'Seluruh Indonesia — coba "Cisoka, Tangerang" atau nama dusun Anda.':
      'All of Indonesia — try "Cisoka, Tangerang" or the name of your hamlet.',
  'Alamat: © OpenStreetMap contributors':
      'Addresses: © OpenStreetMap contributors',
  'Lokasi GPS': 'GPS location',
  'Lokasi tidak terbaca. Izinkan lokasi, nyalakan GPS, atau ketik nama daerah Anda.':
      'Location could not be read. Allow location access, turn on GPS, or type your area.',
  'Layar ini gagal dibuka': 'This screen failed to open',
  'Tutup lalu buka lagi Agrinexa. Kalau berulang, kirim foto layar ini ke pengembang aplikasi.':
      'Close and reopen Agrinexa. If it keeps happening, send a photo of this screen to the developer.',
  'Penyimpanan HP tidak bisa dibuka, jadi data tidak tersimpan setelah aplikasi ditutup. ({0})':
      'Phone storage could not be opened, so nothing is saved after the app closes. ({0})',

  // -------------------------------------------------- mode ladang & panduan
  'MODE LADANG': 'FIELD MODE',
  'Sudah dikerjakan': 'Done',
  'Catat hasil / biaya': 'Log harvest / cost',
  'Panduan Tanaman': 'Crop guides',
  'Cari tanaman': 'Search crops',
  'Cocok ditanam bulan ini': 'Good to plant this month',
  'Tanaman tidak ditemukan.': 'No crops found.',
  'Urungkan': 'Undo',
  'Geser kartu ke kiri untuk menghapus — bisa diurungkan.':
      'Swipe the card left to delete — you can undo it.',
  'Lewati': 'Skip',
  'Pertanian maju,\nmasa depan cerah':
      'Farming that moves ahead,\na future that shines',
  'Bersama Agrinexa,\npetani lebih kuat!':
      'With Agrinexa,\nfarmers grow stronger!',

  // --------------------------------------------------------------- simulasi
  'Simulasi Usaha Tani': 'Farm simulation',
  'Beberapa tanaman dalam satu simulasi': 'Several crops in one simulation',
  'Parameter': 'Parameters',
  'Berlaku hanya untuk simulasi ini.': 'Applies to this simulation only.',
  'Rencana Tanam': 'Planting plan',
  'Rencana sendiri': 'My own plan',
  'Kombinasi terbaik': 'Best combination',
  'Pilih semua': 'Select all',
  'Pilih lebih banyak tanaman agar lahan terbagi.':
      'Pick more crops so the land gets shared.',
  'program linear': 'linear programming',
  'Satu tanaman maksimal': 'One crop at most',
  'Skenario Harga': 'Price scenario',
  'Perubahan harga jual': 'Change in selling price',
  'Jalankan Simulasi': 'Run simulation',
  'Perkiraan omzet': 'Estimated revenue',
  'Total biaya': 'Total cost',
  'Luas terpakai': 'Land used',
  'Rencana ini yang dihitung tombol Jalankan Simulasi.':
      'This plan is what the Run simulation button calculates.',
  'Pakai Rencana Ini': 'Use this plan',
  'Hasil Simulasi': 'Simulation result',
  'Luas direncanakan': 'Planned area',
  'Luas terhitung': 'Funded area',
  'Modal kurang — luas diperkecil merata.':
      'Capital is short — areas were cut evenly.',
  'Melebihi lahan tercatat. Perbarui ukuran lahan.':
      'Exceeds the recorded land. Update the land size.',
  'Rincian per Tanaman': 'Per-crop details',
  'Peta Lahan': 'Land map',
  'Luas warna = luas yang terbiayai.':
      'Each colour is sized by the funded area.',
  'Perbandingan Margin Kotor': 'Gross margin comparison',
  'Rencana Anda': 'Your plan',
  'Pembanding': 'Comparator',
  'Tiap tanaman tercatat otomatis di Riwayat Simulasi.':
      'Each crop is saved automatically in Simulation history.',

  // ------------------------------------------------------- login & profil
  'Akun di perangkat ini': 'Accounts on this device',
  'Ketuk untuk memilih akun.': 'Tap to pick an account.',
  'Email': 'Email',
  'Ketuk untuk memilih akun, lalu masukkan password.':
      'Tap to pick an account, then enter the password.',
  'Data hari ini, panen esok': "Today's data, tomorrow's harvest",
  'Masukkan password': 'Enter password',
  'atau': 'or',
  'Lanjut dengan Google': 'Continue with Google',
  'Nama': 'Name',
  'Nama yang tampil di aplikasi': 'Name shown in the app',
  'Ganti email': 'Change email',
  'Ubah nama': 'Change name',
  'Nama lengkap': 'Full name',
  'Batal': 'Cancel',
  'Simpan': 'Save',
  'Pilih avatar': 'Choose an avatar',
  'Tanpa avatar': 'No avatar',
  'Tutup': 'Close',
  'Keluar': 'Log out',

  // ------------------------------------------- notifikasi, riwayat, pengaturan
  'Notifikasi dimatikan atau belum ada pemberitahuan.':
      'Notifications are off, or there is nothing to report yet.',
  'Riwayat Simulasi': 'Simulation history',
  'Hapus semua': 'Clear all',
  'Hapus semua riwayat?': 'Clear all history?',
  'Tindakan ini tidak bisa dibatalkan.': 'This action cannot be undone.',
  'Belum ada simulasi': 'No simulations yet',
  'Jalankan simulasi untuk melihat riwayat.':
      'Run a simulation to see it listed here.',
  'Tanggal': 'Date',
  'Luas lahan': 'Land area',
  'Modal': 'Capital',
  'Skenario harga': 'Price scenario',
  'Omzet': 'Revenue',
  'Biaya': 'Cost',
  'Margin': 'Margin',
  'Pengaturan': 'Settings',
  'Tampilkan pemberitahuan di aplikasi': 'Show alerts inside the app',
  'Peringatan harga': 'Price alerts',
  'Beri tahu saat harga naik/turun tajam':
      'Notify me when a price moves sharply',
  'Tampilan layar': 'Screen appearance',
  'Bahasa aplikasi': 'App language',
  'Hapus riwayat simulasi': 'Clear simulation history',
  'Reset data usaha tani': 'Reset farm data',
  'Bantuan & FAQ': 'Help & FAQ',
  'Tentang Aplikasi': 'About the app',
  'Agrinexa membantu petani memilih komoditas, memantau harga pasar, dan mensimulasikan keuntungan usaha tani.':
      'Agrinexa helps farmers choose crops, follow market prices, and simulate farm profit.',
  'Versi 1.0.0': 'Version 1.0.0',
  'Ikut bahasa HP': 'Follow my phone',
  'Sama seperti pengaturan bahasa di HP Anda':
      'Same as the language setting on your phone',
  'Bahasanya aplikasi ini dibuat, istilah pertanian memakai kata sehari-hari':
      'The language this app was built in; farm terms use everyday words',
  'Bahasa Inggris': 'English',
  'Untuk presentasi dan penilai yang tidak membaca bahasa Indonesia':
      'For presentations and judges who do not read Indonesian',

  // -------------------------------------------------------- panduan tanaman
  '4 Masam': '4 Acidic',
  '6,5 Netral': '6.5 Neutral',
  '9 Basa': '9 Alkaline',
  'Panduan untuk komoditas ini belum tersedia.':
      'A guide for this crop is not available yet.',
  'Harga pasar hari ini': "Today's market price",
  'Syarat Tumbuh': 'Growing conditions',
  'pH tanah ideal': 'Ideal soil pH',
  'Pupuk yang Cocok': 'Suitable fertilisers',
  'Dosis di atas per hektar atau per pohon. Hitungan untuk lahan Anda ada di bagian bawah ini.':
      'The doses above are per hectare or per tree. The figures for your plot are at the bottom.',
  'Hama dan Penyakit Umum': 'Common pests & diseases',
  'Gejala': 'Symptoms',
  'Penanganan': 'Treatment',
  'Cara Perawatan': 'Care',
  'Panen': 'Harvest',
  'Tanam': 'Plant',
  'Kebutuhan Pupuk Lahan Anda': 'Fertiliser needed for your plot',
  'Panduan umum. Dosis berbeda menurut varietas, tanah, dan musim: lakukan uji tanah dan tanyakan penyuluh pertanian (PPL) setempat. Baca label pestisida, pakai masker dan sarung tangan, dan utamakan cara non-kimia lebih dulu.':
      'A general guide. Doses vary by variety, soil and season: run a soil test and ask the local extension worker (PPL). Read pesticide labels, wear a mask and gloves, and try non-chemical methods first.',
  'Kalender umum berdasarkan pola musim hujan Nov sampai Apr dan kemarau Mei sampai Okt. Curah hujan tiap daerah berbeda (sebagian daerah hujan merata sepanjang tahun), jadi cocokkan dengan kalender tanam setempat: tanyakan penyuluh (PPL) atau lihat Kalender Tanam Terpadu (Katam) Kementerian Pertanian.':
      'A general calendar based on the usual wet season (Nov–Apr) and dry season (May–Oct). Rainfall differs by area — some get rain all year — so check it against your local planting calendar: ask the extension worker (PPL) or see the Ministry of Agriculture Integrated Planting Calendar (Katam).',
  'Hitungan dari luas lahan di menu Input Lahan; ubah luas di sana. Ini perkiraan: sesuaikan dengan uji tanah dan saran penyuluh.':
      'Calculated from the land area on the Land & capital screen; change it there. This is an estimate: match it to a soil test and your extension worker\'s advice.',

  // ------------------------------------------------------- mode ladang (tugas)
  'Keliling lahan & amati tanaman': 'Walk the plot and inspect the crops',
  'Jatuh tempo hari ini': 'Due today',
  'Hari ini': 'Today',
  'Atur lokasi kebun': 'Set the farm location',
  'Sekali saja': 'One-off',

  // ------------------------------------------------ tile pilihan tampilan
  'Ikut setelan HP': 'Follow my phone',
  'Terang atau gelap sama seperti pengaturan di HP Anda':
      'Light or dark, same as the setting on your phone',
  'Terang': 'Light',
  'Paling jelas dibaca di bawah matahari, saat di ladang':
      'Easiest to read under the sun, out in the field',
  'Gelap': 'Dark',
  'Tidak menyilaukan di malam hari, huruf tetap besar dan tebal':
      'Easy on the eyes at night, letters stay large and bold',

  // --------------------------------------------------------------------- FAQ
  'Bagaimana rekomendasi komoditas dihitung?':
      'How are the crop recommendations calculated?',
  'Aplikasi membandingkan tiap komoditas berdasarkan luas lahan, modal, jenis lahan, dan harga pasar terkini. Luas yang dihitung dibatasi modal Anda. Tujuan "Keuntungan" mengurutkan menurut margin, sedangkan "Kestabilan" menurunkan nilai komoditas yang harganya fluktuatif.':
      'The app compares each crop using land area, capital, land type and current market prices. The calculated area is capped by your capital. The "Profit" goal sorts by margin, while "Stability" lowers crops whose prices swing a lot.',
  'Apa arti ROI?': 'What does ROI mean?',
  'ROI di sini adalah margin kotor dibagi biaya variabel, dalam persen. Semakin tinggi, semakin besar hasil per rupiah modal.':
      'ROI here is gross margin divided by variable cost, in percent. The higher it is, the more you earn per rupiah of capital.',
  'Dari mana data harga berasal?': 'Where does the price data come from?',
  'Dua sumber. Harga yang Anda catat sendiri (Pasar > Atur harga sendiri) selalu dipakai bila ada. Sisanya angka simulasi lokal — versi produksi perlu disambungkan ke panel harga resmi (PIHPS / Badan Pangan).':
      'Two sources. A price you recorded yourself (Market > Own recorded price) always wins. The rest are local simulated figures — the production build needs to be connected to an official price panel (PIHPS / National Food Agency).',
  'Dari mana data cuaca berasal?': 'Where does the weather data come from?',
  'Prakiraan diambil dari Open-Meteo untuk lokasi kebun Anda (gratis, tanpa akun). Bila tidak ada jaringan, aplikasi memakai cache terakhir atau simulasi pola musim, dan labelnya berubah menjadi "belum terhubung".':
      'The forecast comes from Open-Meteo for your farm location (free, no account needed). With no network the app uses the last cache or a seasonal pattern, and the label changes to "not connected".',
  'Apakah hasil simulasi pasti terjadi?':
      'Will the simulation result definitely happen?',
  'Tidak. Hasil adalah proyeksi berdasarkan asumsi rata-rata hasil panen dan biaya. Cuaca, hama, dan harga di lapangan bisa berbeda.':
      'No. The result is a projection based on average yield and cost assumptions. Weather, pests and real field prices can differ.',
  'Bagaimana mengubah data lahan dan modal?':
      'How do I change my land and capital data?',
  'Buka Beranda lalu ketuk kartu Ringkasan, atau lewat Profil > Data Usaha Tani.':
      'Open Home and tap the summary card, or go to Profile > Farm data.',

  // ------------------------------------------------------ layar: sisa teks
  'Paling stabil & menguntungkan': 'Most stable & profitable',
  'Potensi keuntungan tertinggi': 'Highest profit potential',
  'Isi jumlah lebih dari 0.': 'Enter an amount greater than 0.',
  'Nama wajib diisi.': 'Name is required.',
  'Email atau No. HP wajib diisi.': 'Email or phone number is required.',
  'Format email tidak valid.': 'That email address is not valid.',
  'Nomor HP minimal 9 digit.': 'Phone number needs at least 9 digits.',
  'Password minimal 6 karakter.': 'Password needs at least 6 characters.',
  'Buat akun baru': 'Create a new account',
  'Password': 'Password',
  'Minimal 6 huruf': 'At least 6 characters',
  'Lihat password': 'Show password',
  'Belum punya akun? Buat akun baru': 'No account yet? Create one',
  'Sudah punya akun? Masuk': 'Already have an account? Sign in',
  'Isi email yang valid dulu.': 'Enter a valid email first.',
  'Password minimal 6 huruf.': 'Password needs at least 6 characters.',
  'Email atau password salah.': 'Incorrect email or password.',
  'Email ini sudah terdaftar. Silakan masuk.':
      'This email is already registered. Please sign in.',
  'Password terlalu pendek — minimal 6 huruf.':
      'Password too short — at least 6 characters.',
  'Email dan password harus diisi.': 'Email and password are required.',
  'Gagal membuat akun. Periksa koneksi internet lalu coba lagi.':
      'Could not create the account. Check your internet connection and try again.',
  'Lupa password? Kirim tautan ke email': 'Forgot password? Send a reset link',
  'Isi email dulu, lalu tekan kirim tautan.':
      'Fill in your email first, then press send link.',
  'Kalau email itu terdaftar, tautan atur password sudah dikirim ke {0}. Buka Gmail, ketuk tautan, lalu isi password baru.':
      'If that email is registered, a password reset link was sent to {0}. Open Gmail, tap the link, then set a new password.',
  'Masuk ke akun Anda': 'Sign in to your account',
  'Email atau No. HP': 'Email or phone number',
  'Buat Akun & Masuk': 'Create account & sign in',
  'Login Google belum aktif: perlu konfigurasi Google Sign-In/Firebase.':
      'Google login is not enabled yet: it needs Google Sign-In / Firebase setup.',
  'Dengan mendaftar, data Anda tersimpan hanya di perangkat ini.':
      'When you register, your data is stored on this device only.',
  'Setiap akun punya lahan, modal, dan riwayatnya sendiri.':
      'Each account has its own land, capital and history.',
  'Atur harga sendiri': 'Set your own price',
  'Lengkapi data usaha tani': 'Complete your farm data',
  'Isi luas lahan dan modal agar rekomendasi sesuai kondisi Anda.':
      'Enter your land area and capital so the recommendations fit your situation.',
  'Belum ada — semua harga masih simulasi':
      'None yet — every price is still simulated',
  'Riwayat simulasi dihapus.': 'Simulation history cleared.',
  'Data usaha tani dikembalikan ke awal.': 'Farm data reset to the start.',
  'Pilih komoditas cerdas': 'Choose crops smartly',
  'Rekomendasi tanaman dan simulasi untung-rugi dihitung dari luas lahan, modal, dan harga pasar terkini.':
      'Crop recommendations and profit-and-loss simulations are calculated from your land area, capital and current market prices.',
  'Kelola musim tanam': 'Manage the planting season',
  'Catat pengeluaran & pendapatan di Buku Kas, lalu pantau tiap tanaman sampai panen lewat Kalender Tanam.':
      'Log expenses and income in the Cash book, then follow each crop to harvest in the Planting calendar.',
  'Waspadai hama & cuaca': 'Watch pests & weather',
  'Panduan gejala dan penanganan hama-penyakit, plus saran aktivitas harian mengikuti prakiraan cuaca.':
      'Symptom and treatment guides for pests and diseases, plus daily activity advice that follows the forecast.',
  'Mulai Bertani →': 'Start farming →',
  'Sudah punya akun? ': 'Already have an account? ',
  'Data Usaha Tani': 'Farm data',

  // ------------------------------------------------- layar: sisa simulasi
  'Pilih minimal satu tanaman.': 'Pick at least one crop.',
  'Isi modal (min Rp 100.000).': 'Enter capital (min Rp 100,000).',
  'Kombinasi terbaik belum tersedia.': 'No best combination available yet.',
  'Isi luas tiap tanaman minimal 1 m².': 'Give each crop at least 1 m².',
  'Isi modal (min Rp 100.000) lebih dulu.':
      'Enter capital first (minimum Rp 100,000).',
  'Isi luas lahan minimal 1 m².': 'Enter a land area of at least 1 m².',
  'Aplikasi yang membagi luas untuk margin terbesar.':
      'The app splits the area for the largest margin.',
  'Anda atur sendiri. Saran tampil di bawah.':
      'You set it yourself. The suggestion appears below.',
  'Ketuk tanaman yang boleh ditanam.': 'Tap the crops you allow to be planted.',
  'Ketuk untuk menambah atau mengeluarkan.': 'Tap to add or remove.',
  'Kombinasi Terbaik — rencana Anda': 'Best combination — your plan',
  'Kombinasi Terbaik — saran': 'Best combination — suggestion',
  'Luas dibagi otomatis untuk margin terbesar.':
      'Area is split automatically for the largest margin.',
  'Campuran tanaman dengan margin terbesar untuk lahan dan modal Anda.':
      'The crop mix with the largest margin for your land and capital.',

  'Belum ada harga pada periode ini.': 'No prices recorded in this period.',
  '{0} harga tercatat pada periode ini': '{0} prices recorded in this period',
  'Lahan tidak terpakai': 'Unused land',
  'Margin kotor setahun (estimasi)': 'Annual gross margin (estimate)',
  'Profit Maksimal': 'Maximum profit',
  'Strategi': 'Strategy',
  'Perkiraan omzet setahun': 'Estimated annual revenue',
  'Biaya produksi setahun': 'Annual production cost',
  'Margin kotor per siklus': 'Gross margin per cycle',
  'Luas tersedia': 'Available area',
  'Pemanfaatan lahan': 'Land utilization',
  'Sisa lahan': 'Unused area',
  'Modal tersedia': 'Available capital',
  'Modal per siklus': 'Capital per cycle',
  'Sisa modal kerja': 'Remaining working capital',
  'Sumber harga': 'Price sources',
  'Optimasi per siklus. Estimasi setahun: tanam berulang dengan harga tetap; tanaman tahunan setelah produktif.':
      'Optimization is per cycle. Annual estimate: repeated planting at fixed prices; perennial crops after maturity.',
  'ROI setahun': 'Annual ROI',
  'Porsi terkecil dalam hasil': 'Smallest share in the result',
  'Batas porsi per tanaman': 'Maximum share per crop',
  '{0} m² terhitung': '{0} m² included',
  'Per tahun setelah produktif': 'Per year after maturity',
  '{0} hari per siklus': '{0} days per cycle',

  // ----------------------------------------------- layar: cuaca & mode ladang
  'Lokasi belum dipilih': 'No location chosen yet',
  'Data cuaca nyata': 'Real weather data',
  'Data belum terhubung': 'Not connected to live data',
  'Lewat dulu hari ini': 'Skip this today',
  'Suara tidak tersedia di peramban atau perangkat ini. Teks di layar tetap lengkap.':
      'Voice is not available in this browser or device. The on-screen text stays complete.',
  'Tidak ada kerja yang ditandai selesai. Anda bisa mengulang daftar tugas hari ini dari awal.':
      'No work was marked done. You can run today\'s task list again from the start.',
  'Daftar perawatan di kalender tanam sudah diperbarui. Catat hasil panen dan biaya hari ini supaya laporan Anda benar.':
      'The care list in the planting calendar has been updated. Log today\'s harvest and costs so your reports stay correct.',
  'Cuaca & Saran': 'Weather & advice',
  'Perangkat ini belum punya suara bahasa Indonesia, jadi kerja dibacakan lewat teks saja. Tambahkan di Android: Setelan ▸ Suara & getaran ▸ Teks-ke-ucapan ▸ Instal suara bahasa Indonesia. Di Chrome/Windows: Setelan ▸ Waktu & bahasa ▸ Suara & ucapan ▸ tambah Bahasa Indonesia.':
      'This device has no matching voice installed, so tasks are read as text only. On Android: Settings ▸ Sound & vibration ▸ Text-to-speech ▸ install voices. In Chrome/Windows: Settings ▸ Time & language ▸ Speech ▸ add a language.',

  // -------------------------------------------------- panduan & pilih lokasi
  'Umur sampai panen': 'Age at harvest',
  'Bulan ini masih bisa menanam, tetapi bukan waktu terbaik.':
      'You can still plant this month, but it is not the best time.',
  'Tanam masih bisa': 'Planting still possible',
  'Masa tanam sampai panen lebih dari satu tahun; waktu panen mengikuti umur tanaman dan kondisi daerah.':
      'Planting to harvest takes more than a year; harvest time follows the crop age and local conditions.',
  'Ketik minimal 2 huruf, mis. "Kediri".':
      'Type at least 2 letters, e.g. "Kediri".',
  'Nama tempat tidak ditemukan.': 'Place name not found.',
  'Pencarian gagal — periksa koneksi internet.':
      'Search failed — check your internet connection.',
  'Lokasi jaringan tidak terbaca. Ketik nama daerah Anda.':
      'Network location could not be read. Type your area name.',

  // ------------------------------------------------------- layanan: cuaca
  'Cerah': 'Clear',
  'Berawan': 'Cloudy',
  'Hujan ringan': 'Light rain',
  'Hujan lebat': 'Heavy rain',
  'Panas terik': 'Scorching heat',
  'Ditampilkan dari cache terakhir': 'Shown from the last cache',
  'Cuaca simulasi — periksa koneksi untuk data nyata.':
      'Simulated weather — check your connection for real data.',
  'Cuaca simulasi — tidak ada data nyata': 'Simulated weather — no real data',
  'kota tidak dikenali': 'city not recognised',
  'data cuaca kosong': 'weather data empty',
  'Tunda tanam bibit baru — risiko benih hanyut dan busuk pangkal.':
      'Delay planting new seedlings — seeds can wash away and stems can rot.',
  'Periksa drainase bedengan; genangan > 6 jam membahayakan akar.':
      'Check bed drainage; water standing for more than 6 hours harms the roots.',
  'Kosongkan penyiraman hari ini.': 'Skip watering today.',
  'Semprotan pestisida/fungisida akan luntur — tunda sampai kering.':
      'Pesticide or fungicide spray will wash off — wait until it dries.',
  'Siram cukup bila tanah masih lembap; cek dengan jari sedalam 2 cm.':
      'Water lightly if the soil is still damp; check with your finger 2 cm deep.',
  'Waktu baik menanam: tanah lembap membantu akar menempel.':
      'Good planting time: moist soil helps roots establish.',
  'Waspadai jamur daun pada tanaman padat — longgarkan pangkas.':
      'Watch for leaf fungus on dense crops — open up the pruning.',
  'Kondisi ideal untuk pemupukan akar — larut perlahan tanpa penguapan.':
      'Ideal for root fertilising — it dissolves slowly without evaporating.',
  'Bisa tanam maupun semprot tanpa cepat menguap.':
      'You can plant or spray without it evaporating quickly.',
  'Siram pagi sebelum jam 7 atau sore setelah jam 4.':
      'Water before 7 a.m. or after 4 p.m.',
  'Pasang mulsa/teduhan untuk bibit yang baru pindah tanam.':
      'Use mulch or shade for seedlings that were just transplanted.',
  'Hindari semprot pestisida — uap panas meningkatkan risiko fitotoksisitas.':
      'Avoid pesticide sprays — hot vapour raises the risk of leaf burn.',
  'Cocok untuk panen: keringkan hasil panen langsung di bawah matahari.':
      'Good for harvest: dry the crop straight in the sun.',
  'Pupuk susulan larut baik bila disiram setelahnya.':
      'Follow-up fertiliser dissolves well if watered in afterwards.',
  'Cek kelembapan tanah siang ini; siram bila kering.':
      'Check soil moisture around midday; water if it is dry.',

  // --------------------------------------------- layanan: rekomendasi & akun
  'belum ada tanaman yang menguntungkan pada kondisi ini':
      'no crop is profitable under these conditions',
  'tanaman pilihan Anda belum menguntungkan pada kondisi ini':
      'your chosen crops are not profitable under these conditions',
  'optimasi tidak konvergen': 'the optimisation did not converge',
  'lahan dan modal habis lebih dulu': 'land and capital ran out first',
  'lahan habis lebih dulu': 'the land ran out first',
  'modal habis lebih dulu': 'the capital ran out first',
  'Permintaan pasar tinggi': 'High market demand',
  'Permintaan pasar sedang': 'Moderate market demand',
  'Harga relatif stabil': 'Prices are relatively stable',
  'Harga fluktuatif, siapkan dana cadangan':
      'Prices swing a lot — keep a cash reserve',
  'Kecocokan lahan sedang': 'Moderate land suitability',
  'Modal mencukupi untuk seluruh lahan': 'Capital covers the whole area',
  'Harga dasar masih simulasi lokal. Ketuk "Atur harga sendiri" di layar Pasar untuk memakai harga panen Anda sendiri.':
      'The base price is still a local simulation. Tap "Set your own price" on the Market screen to use the price you actually got.',
  'Akun sudah terdaftar. Silakan masuk.':
      'Account already registered. Please sign in.',
  'Akun tidak ditemukan. Silakan daftar dulu.':
      'Account not found. Register first.',

  // ------------------------------------------- layanan: kerja harian di ladang
  'Bersihkan lahan dari gulma dan sisa tanaman musim lalu. Buat bedengan setinggi tiga puluh sampai empat puluh sentimeter agar air tidak menggenang, lalu diamkan tiga sampai tujuh hari sebelum tanam.':
      'Clear the plot of weeds and last season\'s crop remains. Make beds thirty to forty centimetres high so water does not pool, then leave them three to seven days before planting.',
  'Tanam pagi sebelum jam sembilan atau sore setelah jam empat agar bibit tidak stres. Siram bedengan lebih dulu, tutup pangkal batang perlahan, dan jangan menekan terlalu padat.':
      'Plant before nine in the morning or after four in the afternoon so seedlings are not stressed. Water the beds first, cover the stem base gently, and do not press the soil too firm.',
  'Jalani barisan tanam dan ganti bibit yang mati atau tumbuh kerdil. Siapkan cadangan dari persemaian yang sama umur dan tingginya.':
      'Walk the rows and replace seedlings that died or stayed stunted. Keep reserves from the same nursery bed, same age and height.',
  'Potong cabang patah, tunas air yang tidak diperlukan, dan daun kuning di bawah kanopi. Kumpulkan dan buang jauh dari tanaman supaya spora jamur tidak menyebar.':
      'Cut broken branches, unneeded water shoots, and yellow leaves under the canopy. Collect and remove them far from the plants so fungal spores do not spread.',
  'Periksa daun bagian bawah dan pucuk di sepuluh titik acak. Kutip kelompok telur atau daun yang bergejala, lalu cocokkan gejala dengan panduan hama sebelum memutuskan penyemprotan.':
      'Inspect the underside of leaves and the shoots at ten random spots. Pick off egg clusters or symptomatic leaves, then match the symptoms in the pest guide before deciding to spray.',
  'Panen pagi setelah embun kering tetapi sebelum panas. Potong, jangan tarik batang. Sortir segera agar hasil tidak tertumpuk panas di dalam karung.':
      'Harvest in the morning after the dew dries but before the heat. Cut, do not pull the stem. Sort right away so the crop does not build up heat inside the sack.',
  'Hujan lebat dan tanah jenuh air. Menginjak bedengan hari ini memadatkan tanah; tunda satu sampai dua hari.':
      'Heavy rain and saturated soil. Walking on the beds today compacts the soil; wait one to two days.',
  'Semprotan akan luntur sebelum menempel. Kerjakan pengamatan saja, tunda penyemprotan sampai daun kering.':
      'Spray will wash off before it sticks. Do scouting only, and delay spraying until the leaves are dry.',
  'Mode Ladang menyesuaikan kerja dengan cuaca di kebun Anda. Buka layar Cuaca lalu pilih nama desa atau kecamatan kebun Anda.':
      'Field Mode matches the work to the weather on your farm. Open the Weather screen and choose the name of your village or district.',

  // ------------------------------------------------- data: nama komoditas
  'Cabai': 'Chili',
  'Tomat': 'Tomato',
  'Bawang Merah': 'Shallot',
  'Kentang': 'Potato',
  'Kubis': 'Cabbage',
  'Wortel': 'Carrot',
  'Sawi': 'Mustard greens',
  'Terong': 'Eggplant',
  'Timun': 'Cucumber',
  'Kacang Panjang': 'Long bean',
  'Jagung': 'Corn',
  'Padi': 'Rice',
  'Kedelai': 'Soybean',
  'Kacang Tanah': 'Peanut',
  'Ubi Jalar': 'Sweet potato',
  'Singkong': 'Cassava',
  'Semangka': 'Watermelon',
  'Melon': 'Melon',
  'Pepaya': 'Papaya',
  'Pisang': 'Banana',
  'Nanas': 'Pineapple',
  'Kopi': 'Coffee',
  'Kakao': 'Cocoa',
  'Karet': 'Rubber',
  'Kelapa Sawit': 'Oil palm',
  'Tebu': 'Sugarcane',
  'Jahe': 'Ginger',
  'Kunyit': 'Turmeric',
  'Lada': 'Pepper',
  'Serai': 'Lemongrass',
  'Cabai Merah': 'Red chili',
  'Padi (Gabah)': 'Rice (paddy)',
  'Kopi (Biji Hijau)': 'Coffee (green beans)',
  'Kakao (Biji Kering)': 'Cocoa (dried beans)',
  'Karet (Slab/Sheet)': 'Rubber (slab / sheet)',
  'Kelapa Sawit (TBS)': 'Oil palm (fresh fruit bunches)',
  'Lada (Merica)': 'Pepper (peppercorns)',
  'Serai Wangi': 'Fragrant lemongrass',

  // ------------------------------------------------ data: kategori & jenis lahan
  'Sayuran': 'Vegetables',
  'Pangan': 'Staples',
  'Buah': 'Fruits',
  'Perkebunan': 'Plantation',
  'Rempah': 'Spices',
  'Lahan Sawah': 'Paddy field',
  'Lahan Kering': 'Dry land',
  'Pekarangan': 'Home garden',
  'Dataran Tinggi': 'Highland',
  'Bibit': 'Seedlings',
  'Pupuk': 'Fertiliser',
  'Tenaga kerja': 'Labour',
  'Pestisida': 'Pesticide',
  'Sewa alat': 'Equipment rental',
  'Lainnya': 'Other',

  // ---------------------------------------------- data: tips budidaya (1/4)
  'Gunakan mulsa plastik untuk menekan gulma dan menjaga kelembapan.':
      'Use plastic mulch to suppress weeds and hold moisture.',
  'Pantau hama thrips dan antraknosa, terutama saat musim hujan.':
      'Watch for thrips and anthracnose, especially in the wet season.',
  'Atur jadwal panen bertahap agar harga lebih terjaga.':
      'Stagger the harvest schedule so prices hold better.',
  'Pasang ajir/turus agar buah tidak menyentuh tanah.':
      'Set stakes so the fruit never touches the ground.',
  'Siram teratur dan hindari genangan untuk mencegah busuk akar.':
      'Water regularly and avoid pooling to prevent root rot.',
  'Panen saat buah mulai berwarna agar tahan saat dikirim.':
      'Harvest when the fruit starts to colour, so it survives transport.',
  'Pilih umbi bibit yang sehat dan sudah melewati masa dormansi.':
      'Choose healthy seed bulbs that have passed dormancy.',
  'Waspadai ulat bawang dan penyakit bercak ungu saat lembap.':
      'Watch for onion caterpillars and purple leaf spot in humid weather.',
  'Lakukan pembumbunan agar umbi tidak terkena sinar matahari.':
      'Hill up soil so the tubers are not hit by sunlight.',
  'Cegah busuk daun (hawar) dengan drainase baik dan rotasi tanaman.':
      'Prevent leaf blight with good drainage and crop rotation.',
  'Kendalikan ulat daun kubis sejak fase bibit.':
      'Control cabbage worms from the seedling stage.',
  'Panen saat krop padat sebelum pecah.':
      'Harvest while the head is firm, before it splits.',
  'Gemburkan tanah dalam-dalam agar umbi lurus dan tidak bercabang.':
      'Loosen the soil deeply so tubers grow straight and unbranched.',
  'Lakukan penjarangan saat tanaman berumur 3 minggu.':
      'Thin the plants when they are three weeks old.',
  'Umur panen singkat, cocok untuk perputaran modal cepat.':
      'A short season — good for fast capital turnover.',
  'Tutup bedengan dengan jaring untuk mengurangi serangan ulat.':
      'Cover the beds with netting to cut caterpillar damage.',

  // ---------------------------------------------- data: tips budidaya (2/4)
  'Pangkas tunas air agar buah lebih besar dan seragam.':
      'Prune water shoots so the fruit grows larger and more uniform.',
  'Panen rutin setiap 3 sampai 4 hari untuk menjaga produksi.':
      'Harvest every three to four days to keep production steady.',
  'Gunakan lanjaran agar buah bersih dan lurus.':
      'Use trellis poles so the fruit stays clean and straight.',
  'Jaga kelembapan tanah, hindari penyiraman saat bunga mekar.':
      'Keep the soil moist, but do not water while flowers are open.',
  'Pasang lanjaran sejak tanaman berumur 2 minggu.':
      'Put in trellis poles from two weeks after planting.',
  'Panen polong muda secara rutin agar produksi terus berlanjut.':
      'Pick young pods regularly so production keeps going.',
  'Tanam serempak dengan petani sekitar untuk menekan serangan hama.':
      'Plant at the same time as neighbouring farmers to suppress pests.',
  'Pupuk nitrogen diberikan bertahap pada fase vegetatif.':
      'Give nitrogen fertiliser in stages during the vegetative phase.',
  'Keringkan hasil panen sampai kadar air aman sebelum disimpan.':
      'Dry the harvest to a safe moisture level before storing it.',
  'Atur pengairan berselang untuk menghemat air dan menekan penyakit.':
      'Use alternate wetting and drying to save water and cut disease.',
  'Gunakan benih bersertifikat dan jarak tanam jajar legowo.':
      'Use certified seed and the jajar legowo row spacing.',
  'Tanam setelah padi dengan olah tanah minimal untuk menghemat biaya.':
      'Plant after rice with minimum tillage to save cost.',
  'Waspadai hama penggerek polong saat pengisian biji.':
      'Watch for pod borers while the seeds are filling out.',
  'Tanah gembur dan berpasir memberi hasil polong terbaik.':
      'Loose sandy soil gives the best pod yield.',
  'Panen tepat waktu untuk mencegah polong berjamur.':
      'Harvest on time so the pods do not go mouldy.',
  'Gunakan stek pucuk yang sehat sepanjang 25 sampai 30 cm.':
      'Use healthy shoot cuttings 25 to 30 cm long.',

  // ---------------------------------------------- data: tips budidaya (3/4)
  'Cegah hama boleng dengan menjaga tanah tetap tertutup.':
      'Prevent rodent damage by keeping the soil covered.',
  'Tumpangsari dengan kacang-kacangan untuk menambah pendapatan.':
      'Intercrop with legumes for extra income.',
  'Panen pada umur 8 sampai 10 bulan untuk kadar pati optimal.':
      'Harvest at eight to ten months for the best starch content.',
  'Seleksi buah (1 sampai 2 per tanaman) agar ukuran besar dan manis.':
      'Keep only one or two fruit per plant so they grow large and sweet.',
  'Kurangi penyiraman menjelang panen agar rasa lebih manis.':
      'Reduce watering before harvest so the taste turns sweeter.',
  'Budidaya di dalam rumah plastik menjaga kualitas dan mengurangi penyakit.':
      'Growing under a plastic house protects quality and lowers disease.',
  'Lakukan pewiyatan (pemangkasan) sesuai fase untuk hasil seragam.':
      'Prune at the right growth stage for a uniform harvest.',
  'Pastikan drainase baik, akar pepaya sangat peka terhadap genangan.':
      'Keep drainage good — papaya roots are very sensitive to standing water.',
  'Pilih varietas dengan permintaan pasar tinggi di daerah Anda.':
      'Choose the variety with the highest market demand in your area.',
  'Sisakan 2 sampai 3 anakan per rumpun agar produksi berkelanjutan.':
      'Leave two to three tillers per clump so production continues.',
  'Bungkus tandan buah untuk melindungi dari hama dan memperbaiki kulit.':
      'Bag the fruit bunch to shield it from pests and improve the skin.',
  'Tanah masam cenderung cocok; hindari lahan yang tergenang.':
      'Acidic soil suits it; avoid land that floods.',
  'Perangsangan pembungaan membuat panen lebih serempak.':
      'Inducing flowering makes the harvest more simultaneous.',
  'Arabika tumbuh baik di dataran tinggi, robusta di dataran lebih rendah.':
      'Arabica does well in the highlands, robusta at lower altitudes.',
  'Petik buah merah saja dan olah pascapanen bersih untuk harga lebih baik.':
      'Pick only red fruit and handle post-harvest cleanly for a better price.',
  'Tanam pohon pelindung untuk menjaga mutu dan kelembapan kebun.':
      'Plant shade trees to protect quality and keep the garden humid.',

  // ---------------------------------------------- data: tips budidaya (4/4)
  'Sadap pada pagi hari dengan teknik yang benar agar pohon awet.':
      'Tap the tree in the morning with the right technique so it stays productive.',
  'Jaga kebersihan lateks agar harga sheet tidak turun.':
      'Keep the latex clean so the sheet price does not fall.',
  'Panen TBS pada tingkat matang yang tepat dan segera kirim ke pabrik.':
      'Harvest bunches at the right ripeness and send them to the mill straight away.',
  'Pemupukan berimbang menentukan produksi tandan.':
      'Balanced fertiliser decides how many bunches you get.',
  'Kemitraan dengan pabrik gula membantu kepastian harga dan pasar.':
      'A partnership with a sugar mill secures price and market.',
  'Lakukan keprasan (ratoon) untuk menghemat biaya bibit.':
      'Keep the ratoon crop to save on planting material.',
  'Gunakan rimpang bibit sehat dan lakukan perlakuan sebelum tanam.':
      'Use healthy seed rhizomes and treat them before planting.',
  'Hindari genangan agar tidak terserang busuk rimpang.':
      'Avoid waterlogging so the rhizomes do not rot.',
  'Cocok ditanam di bawah naungan ringan, misalnya di antara pohon buah.':
      'Happy under light shade, for example between fruit trees.',
  'Panen saat daun menguning untuk kadar kurkumin terbaik.':
      'Harvest when the leaves turn yellow for the best curcumin content.',
  'Gunakan tiang panjat hidup atau tiang tahan lama.':
      'Use living support poles or durable stakes.',
  'Jemur biji sampai kering merata untuk menjaga mutu dan harga.':
      'Sun-dry the seeds evenly to protect quality and price.',
  'Mudah dirawat dan bisa dipanen berulang dari rumpun yang sama.':
      'Easy to care for and harvestable again and again from the same clump.',
  'Olah menjadi minyak atsiri untuk nilai tambah.':
      'Process it into essential oil for extra value.',

  // ---------------------------------------------------- data: nama hama
  'Kutu Daun (Aphids)': 'Aphids',
  'Thrips & Virus Keriting': 'Thrips & Leaf Curl Virus',
  'Antraknosa (Pateak)': 'Anthracnose (pateak)',
  'Lalat Buah': 'Fruit Fly',
  'Wereng Batang Cokelat': 'Brown Planthopper',
  'Ulat Graya Jagung': 'Fall Armyworm',
  'Busuk Akar & Layu Fusarium': 'Root Rot & Fusarium Wilt',
  'Hawar Daun (Late Blight)': 'Late Blight',
  'Bercak Ungu Bawang': 'Onion Purple Blotch',
  'Ulat Daun Kubis (Plutella)': 'Diamondback Moth (Plutella)',
  'Penggerek Polong Kedelai': 'Soybean Pod Borer',
  'Busuk Rimpang Jahe & Kunyit': 'Ginger & Turmeric Rhizome Rot',
  'Kutu Putih & Semut': 'Whitefly & Ants',
  'Tikus Sawah': 'Rice Field Rat',

  // -------------------------------------------------- data: ringkasan hama
  'Serangga kecil pengisap daun muda, pembawa virus.':
      'Small sap-sucking insects on young leaves that carry virus.',
  'Hama utama cabai; menyebarkan virus keriting daun.':
      'The main chili pest; it spreads leaf curl virus.',
  'Jamur penyebab bercak tenggelam pada buah.':
      'A fungus that sinks round lesions into the fruit.',
  'Belitnya menggerek buah dari dalam.':
      'Its maggots bore the fruit from inside.',
  'Pengisap pangkal batang padi penyebab "taman tebu".':
      'Sucks rice stems at the base, causing hopperburn patches.',
  'Fall armyworm: merusak daun dan titik tumbuh jagung.':
      'Fall armyworm: destroys corn leaves and the growing point.',
  'Jamur tular tanah akibat drainase buruk.':
      'A soil-borne fungus encouraged by bad drainage.',
  'Penyakit kentang/tomat penyebab busuk daun cepat menular.':
      'A potato and tomato disease whose leaf rot spreads fast.',
  'Jamur Alternaria pada daun bawang merah.':
      'Alternaria fungus on shallot leaves.',
  'Lubang kecil penuh di daun sawi, kubis, dan pakcoy.':
      'Mustard, cabbage and pakcoy leaves riddled with small holes.',
  'Larva memakan biji di dalam polong.':
      'Larvae eat the seeds inside the pods.',
  'Layu dan bau pada rimpang akibat jamur/bakteri.':
      'Wilting and off-smelling rhizomes caused by fungi or bacteria.',
  'Gumpalan putih di ketiak daun dan batang.':
      'White fluff in the leaf axils and on the stems.',
  'Merusak batang muda dan menggerek bulir isi susu.':
      'Damages young stems and bores into milky grain.',

  // ------------------------------------------- data: gejala hama (kutu daun, thrips, antraknosa)
  'Daun muda keriting, melengkung ke bawah, dan mengkerut.':
      'Young leaves curl, bend downward and pucker.',
  'Permukaan daun lengket (embun madu) dan sering dihinggapi semut.':
      'The leaf surface is sticky (honeydew) and often visited by ants.',
  'Coloni kutu hijau/hitam terlihat di balik daun dan pucuk.':
      'Green or black aphid colonies show under leaves and on shoots.',
  'Pasang perangkap kuning lengket beberapa meter dari bedengan.':
      'Hang sticky yellow traps a few metres from the beds.',
  'Jangan berlebih pupuk nitrogen — jaringan muda terlalu lunak.':
      'Do not over-apply nitrogen — young tissue turns too soft.',
  'Tanam bunga pengusir (kenikir, zinnia) di tepi bedengan.':
      'Plant repellent flowers (marigold, zinnia) along the bed edges.',
  'Semprot air kuat untuk merontokkan koloni bila serangan awal.':
      'Use a strong water jet to knock colonies off in an early attack.',
  'Aplikasikan insektisida nabati (minyak nimba / sabun larut).':
      'Apply a botanical insecticide (neem oil / soluble soap).',
  'Pada serangan berat: rotasi bahan aktif insektisida, semprot sore hari.':
      'On heavy attacks rotate insect active ingredients and spray in the evening.',
  'Ujung daun muda menggulung ke atas dan kaku.':
      'Young leaf tips curl upward and turn stiff.',
  'Lingkaran kecokelatan pada buah (bekas gigitan thrips).':
      'Brown rings on the fruit — thrips feeding scars.',
  'Tanaman kerdil dan bunga rontok bila tertular virus.':
      'Plants stay stunted and flowers drop once virus-infected.',
  'Gunakan mulsa perak untuk mengusir thrips dan memantulkan cahaya.':
      'Use silver mulch: it reflects light and repels thrips.',
  'Pasang perangkap kuning + jaring pelindung sejak pembibitan.':
      'Put out yellow traps and protective netting from the nursery stage.',
  'Tanam serempak dalam satu hamparan, hindari inang alternatif.':
      'Plant at once across a block and avoid alternative hosts.',
  'Cabut dan bakar tanaman yang sudah tertular virus (tidak bisa sembuh).':
      'Rogue out and burn virus-infected plants — they cannot recover.',
  'Semprot insektisida sistemik pada fase bibit; rotasi bahan aktif.':
      'Spray a systemic insecticide at seedling stage; rotate active ingredients.',
  'Kendalikan semut yang memelihara koloni thrips.':
      'Control the ants that tend thrip colonies.',
  'Bercak bulat tenggelam pada buah dengan cincin hitam-kemerahan.':
      'Sunken round lesions on the fruit with black-to-red rings.',
  'Buah membusuk dari ujung dan sering mengering menggantung.':
      'Fruit rots from the tip and often dries while still hanging.',
  'Menjalar cepat saat cuaca lembap dan banyak hujan.':
      'Spreads quickly in humid, rainy weather.',
  'Atur jarak tanam agar sirkulasi udara baik dan daun cepat kering.':
      'Space plants so air circulates and leaves dry fast.',
  'Sanitasi: bersihkan sisa tanaman dan buah jatuh dari area.':
      'Sanitation: clear crop debris and fallen fruit from the area.',
  'Rotasi tanaman minimal 1 musim dengan bukan famili terong-terongan.':
      'Rotate for at least one season with crops outside the nightshade family.',

  // ------------------------------ data: gejala & penanganan (buah, wereng, ulat graya)
  'Petik dan buang buah bergejala jauh dari lahan (jangan dikompos).':
      'Pick off symptomatic fruit and remove it far away — do not compost it.',
  'Semprot fungisida kontak (mancozeb) + sistemik (benomil) bergantian.':
      'Alternate a contact fungicide (mancozeb) with a systemic one (benomyl).',
  'Kurangi penyiraman over-head; siram ke tanah, bukan daun.':
      'Cut back overhead watering; water the soil, not the leaves.',
  'Titik tusukan pada kulit buah, buah busuk sebelum matang.':
      'Puncture marks on the skin; the fruit rots before ripening.',
  'Belatung kecil berwarna putih-krem di dalam buah.':
      'Small cream-white maggots inside the fruit.',
  'Buah jatuh dini dan bau asam.': 'Fruit drops early and smells sour.',
  'Bungkus buah (kertas/kantong plastik berlubang) sejak 2 minggu setelah bunga mekar.':
      'Bag the fruit (paper or perforated plastic) from two weeks after flowering.',
  'Pasang perangkap metil eugenol di tepi lahan.':
      'Hang methyl eugenol traps along the field edge.',
  'Bersihkan buah jatuh setiap hari — putusnya siklus perkembangbiakan.':
      'Collect fallen fruit every day — it breaks the breeding cycle.',
  'Kumpulkan buah terserang, rendam air 1–2 hari atau kubur > 30 cm.':
      'Gather infested fruit, soak it for 1–2 days, or bury it deeper than 30 cm.',
  'Semprot umpan protein + insektisida di sore hari pada titik-titik hinggap.':
      'Spray protein bait with insecticide in the evening on the resting spots.',
  'Sanitasi kebun tetangga serentak bila memungkinkan.':
      'Clean neighbouring gardens at the same time where possible.',
  'Rumpun menguning dan mengering seperti terbakar, meluas dari satu titik.':
      'Clumps yellow and dry as if burnt, spreading out from one patch.',
  'Bangkai wereng dan busa di pangkal batang.':
      'Hopper corpses and foam at the stem base.',
  'Parah pada varietas rentan + pupuk N tinggi + jarak tanam rapat.':
      'Worst on susceptible varieties with high nitrogen and tight spacing.',
  'Tanam varietas tahan dan jajar legowo untuk udara lancar.':
      'Plant resistant varieties and jajar legowo rows so air flows.',
  'Pengairan berselang memutus siklus wereng.':
      'Alternate wetting and drying breaks the hopper cycle.',
  'Hindari insektisida spektrum luas yang membunuh predator.':
      'Avoid broad-spectrum insecticides that kill the predators.',
  'Semprot selektif (buprofezin/imidakloprid) hanya pada radius serangan.':
      'Spray selectively (buprofezin / imidacloprid) only around the attacked area.',
  'Turunkan populasi cepat sebelum menyebar — wereng berkembang biak eksponensial.':
      'Cut the population fast before it spreads — planthoppers breed exponentially.',
  'Lubang tidak beraturan pada daun dengan serbuk gergaji di ketiak daun.':
      'Irregular holes in the leaves with sawdust-like frass in the axils.',
  'Titik tumbuh (heart) digerogoti, tanaman muda bisa mati.':
      'The growing point is chewed out; young plants can die.',
  'Ulat bergaris kepala membentuk huruf Y terbalik.':
      'The caterpillar head marks look like an inverted Y.',
  'Tanam lebih awal dan serempak agar lolos generasi puncak hama.':
      'Plant early and together to miss the peak pest generation.',

  // --------------------- data: gejala & penanganan (graya, layu, hawar, bercak ungu)
  'Semprot ekstrak nimba pada fase 1–4 daun.':
      'Spray neem extract at the one-to-four leaf stage.',
  'Pasang beacon trap / tanaman pemburu di sekitar lahan.':
      'Set beacon traps and trap crops around the field.',
  'Aplikasi insektisida tepat di titik tumbuh (arahkan semprotan ke kerucut daun).':
      'Apply insecticide straight into the growing point, aiming at the leaf cone.',
  'Manfaatkan musuh alami: Trichogramma, predator, dan burung.':
      'Use natural enemies: Trichogramma wasps, predators and birds.',
  'Rotasi bahan aktif untuk mencegah resistensi.':
      'Rotate active ingredients to prevent resistance.',
  'Tanaman layu siang hari lalu pulih pagi — makin lama menetap.':
      'Plants wilt at midday and recover in the morning, until the wilt becomes permanent.',
  'Pangkal batang menghitam, akar kecokelatan dan hancur.':
      'The stem base blackens and the roots turn brown and crumble.',
  'Menyebar lewat air genangan dan alat kerja.':
      'It spreads through standing water and tools.',
  'Bedengan tinggi + saluran drainase; jangan tanam di lahan tergenang.':
      'Build high beds with drainage channels; never plant on waterlogged land.',
  'Rotasi tanaman dan solarisasi tanah sebelum musim baru.':
      'Rotate crops and solarise the soil before a new season.',
  'Gunakan bibit sehat dan perlakuan Trichoderma pada lubang tanam.':
      'Use healthy seedlings and treat the planting holes with Trichoderma.',
  'Cabut tanaman sakit, taburi kapur dolomit di lubang bekasnya.':
      'Rogue out sick plants and dust dolomite lime into the hole they leave.',
  'Kurangi frekuensi siram; biarkan lapisan atas tanah mengering.':
      'Water less often and let the top soil layer dry.',
  'Fungisida sistemik (metalaksil) hanya membantu pada infeksi awal.':
      'Systemic fungicide (metalaxyl) only helps during an early infection.',
  'Bercak basah tak beraturan pada tepi daun dengan lingkaran putih kabur.':
      'Irregular water-soaked lesions at leaf edges with a pale white halo.',
  'Batang hitam dan tanaman rebah dalam hitungan hari.':
      'Stems blacken and plants fall over within days.',
  'Umbi berbintik cokelat dengan busuk masuk ke dalam.':
      'Tubers show brown speckles as the rot moves inward.',
  'Gunakan umbi/benih bersertifikat bebas penyakit.':
      'Use certified, disease-free seed tubers or seed.',
  'Pembumbunan tinggi dan hindari daun basah terlalu lama.':
      'Hill up high and keep leaves from staying wet for long.',
  'Fungisida protektif terjadwal saat kelembapan tinggi.':
      'Apply protective fungicide on schedule when humidity is high.',
  'Pangkas dan buang bagian terserang, jangan dikompos.':
      'Prune out and remove infected parts — do not compost them.',
  'Semprot fungisida kontak + sistemik bergantian, ulangi 7–10 hari.':
      'Alternate contact and systemic fungicide, repeating every 7–10 days.',
  'Panen umbi segera bila busuk mulai masuk, keringkan sebelum simpan.':
      'Harvest tubers at once once rot moves in, and dry them before storing.',
  'Bercak oval putih-kuning membesar menjadi ungu dengan cincin konsentris.':
      'White-yellow oval spots enlarge and turn purple with concentric rings.',

  // ---------------- data: gejala & penanganan (bawang, kubis, kedelai, rimpang)
  'Ujung daun mengering seperti terbakar, fotosintesis turun.':
      'Leaf tips dry as if scorched, so photosynthesis drops.',
  'Serangan parah membuat umbi kecil dan tahan simpan rendah.':
      'Severe attacks give small bulbs that keep poorly in storage.',
  'Jarak tanam cukup dan penyiraman pagi agar daun cepat kering.':
      'Space plants properly and water in the morning so leaves dry quickly.',
  'Gunakan umbi bibit sehat, rendam fungisida sebelum tanam.':
      'Use healthy seed bulbs, soaked in fungicide before planting.',
  'Rotasi 2–3 musim dengan bukan bawang-bawangan.':
      'Rotate for 2–3 seasons with non-allium crops.',
  'Semprot fungisida (mancozeb/klorotalonil) 7 hari sekali saat lembap.':
      'Spray fungicide (mancozeb / chlorothalonil) every 7 days while humidity is high.',
  'Buang daun terserang berat dari lahan.':
      'Remove badly attacked leaves from the field.',
  'Jendela transparan pada daun lalu berlubang.':
      'The leaves show transparent windows, then holes.',
  'Ulat hijau kecil menggantung dengan benang sutra saat diganggu.':
      'Small green caterpillars hang from silk threads when disturbed.',
  'Krop kubis terisi kotoran dan rapuh.':
      'Cabbage heads fill with frass and turn fragile.',
  'Tutup bedengan dengan jaring halus sejak semai.':
      'Cover the beds with fine netting from sowing time.',
  'Tanam tanaman perangkap (lobak/sawi pahit) di keliling.':
      'Grow trap crops (radish, bitter mustard) around the edges.',
  'Kumpulkan telur dan ulat pagi hari secara manual.':
      'Collect eggs and caterpillars by hand in the morning.',
  'Semprot Bt (Bacillus thuringiensis) — efektif dan aman panen dekat.':
      'Spray Bt (Bacillus thuringiensis) — effective and safe near harvest.',
  'Insektisida kontak sore hari bila ledakan populasi.':
      'Use a contact insecticide in the evening if numbers explode.',
  'Lubang bulat bersih pada polong dengan butiran kotoran.':
      'Clean round holes in the pods with frass pellets.',
  'Biji bolong dan berkurang bobotnya saat disimpan.':
      'Seeds come out holed and lose weight during storage.',
  'Ngengat kecil aktif terbang sore menjelang malam.':
      'Small moths fly actively from late afternoon into the night.',
  'Tanam tepat awal musim agar fase polong lolos puncak populasi ngengat.':
      'Plant right at the start of the season so podding misses the moth peak.',
  'Perangkap lampu untuk memantau dan mengurangi ngengat.':
      'Use light traps to monitor and reduce the moths.',
  'Jangan menunda panen lebih dari 10 hari setelah polong masak.':
      'Do not delay harvest more than 10 days after the pods mature.',
  'Semprot saat ambang: 2 ulat per tanaman pada fase pengisian biji.':
      'Spray at threshold: 2 caterpillars per plant while the seeds fill.',
  'Simpan biji dengan daun salam / suhu rendah untuk menekan larva sisa.':
      'Store seed with bay leaves or at low temperature to suppress leftover larvae.',
  'Daun menguning lalu layu meski tanah lembap.':
      'Leaves yellow and then wilt even though the soil is moist.',

  // ----------------------- data: gejala & penanganan (kutu putih, tikus, rimpang)
  'Rimpang lunak, berair, dan bau tajam tidak sedap.':
      'Rhizomes turn soft and watery with a sharp, unpleasant smell.',
  'Menular cepat lewat air yang menggenang.':
      'It spreads fast through standing water.',
  'Hanya rimpang bibit sehat; rendam fungisida + bakterisida sebelum tanam.':
      'Use only healthy seed rhizomes; soak in fungicide plus bactericide before planting.',
  'Bedengan tinggi dengan saluran drainase dalam.':
      'Build high beds with deep drainage channels.',
  'Rotasi lahan minimal 2 tahun untuk lahan endemik.':
      'On endemic land, rotate for at least two years.',
  'Bongkar tanaman sakit dan taburi lubang dengan dolomit.':
      'Dig out sick plants and dust the hole with dolomite.',
  'Hentikan sementara pengairan berlebihan; keringkan zona perakaran.':
      'Suspend over-watering and dry out the root zone.',
  'Bintik seperti kapas menempel pada ketiak daun, batang, dan buah muda.':
      'Cotton-like patches stick to leaf axils, stems and young fruit.',
  'Daun menguning dan tumbuh kerdil karena cairan diisap.':
      'Leaves yellow and growth stunts because the sap is sucked out.',
  'Sering ada semut yang "memelihara" kutu.':
      'Ants are often there to "farm" the bugs.',
  'Pangkas agar tajuk tidak terlalu lembap dan rapat.':
      'Prune so the canopy stays neither damp nor dense.',
  'Putus akses semut dengan perangkap lem di batang/pancang.':
      'Block ant access with glue traps on stems or stakes.',
  'Lepaskan predator Cryptolaemus bila tersedia.':
      'Release Cryptolaemus predators if they are available.',
  'Lap/semprot air sabun pada koloni kecil.':
      'Wipe or spray soapy water on small colonies.',
  'Minyak nimba / petrolium emulsi pada serangan luas, semprot balik daun.':
      'Neem oil or petroleum emulsion on wide attacks; spray the leaf undersides.',
  'Bekas potongan serong pada batang seperti digunting.':
      'Angled cut marks on the stems, as if snipped.',
  'Jejak dan lubang di pematang; bulir hilang sebagian.':
      'Tracks and burrows on the ridges; part of the grain disappears.',
  'Kerusakan parah pada pertanaman tidak serempak.':
      'Damage is worst where planting was not simultaneous.',
  'Tanam serempak seluas hamparan agar tikus kehabisan inang bergilir.':
      'Plant the whole block at once so rats run out of rotating patches to eat.',
  'Gropyokan dan sanitasi semak di sekitar lahan.':
      'Community rat drives, plus clearing the scrub around the field.',
  'Pasang pagar tanaman border (serai/vezu) di tepi hamparan.':
      'Plant a border hedge (lemongrass / vetiver) along the block edge.',
  'Umpan beracun (rodentisida) di lubang aktif, hati-hati hewan peliharaan.':
      'Put rodenticide bait in active burrows — keep pets and livestock away.',
  'Perangkap bukaan dan EMPO (rumah tikus) dengan predator.':
      'Use open traps and EMPO rat houses that harbour predators.',

  // ------------------------------------------------ panduan: jenis tanah
  'Lempung berpasir, gembur, kaya bahan organik, drainase baik.':
      'Sandy loam, loose, rich in organic matter, well drained.',
  'Lempung gembur, subur, drainase baik.': 'Loose loam, fertile, well drained.',
  'Lempung berpasir, remah, drainase baik.':
      'Sandy loam, crumbly structure, well drained.',
  'Andosol atau lempung gembur, subur, drainase baik.':
      'Andisol or loose loam, fertile, well drained.',
  'Lempung gembur, subur, kaya bahan organik.':
      'Loose loam, fertile, rich in organic matter.',
  'Gembur, dalam, berpasir lempung, bebas batu.':
      'Loose, deep, sandy loam, free of stones.',
  'Gembur, subur, kaya bahan organik.':
      'Loose, fertile, rich in organic matter.',
  'Gembur, subur, kaya bahan organik, drainase baik.':
      'Loose, fertile, rich in organic matter, well drained.',
  'Lempung berpasir, gembur, drainase baik.':
      'Sandy loam, loose, well drained.',
  'Lempung gembur, drainase baik, subur.': 'Loose loam, well drained, fertile.',
  'Lempung liat sawah, mampu menahan air.':
      'Paddy clay loam that holds water well.',
  'Lempung berpasir gembur, kaya kalsium.':
      'Loose sandy loam, rich in calcium.',
  'Gembur dan berpasir, drainase baik.': 'Loose and sandy, well drained.',
  'Gembur, berpasir sampai lempung; toleran tanah kurang subur.':
      'Loose, sandy to loamy; tolerates poorer soil.',
  'Lempung gembur, drainase sangat baik.': 'Loose loam, very well drained.',
  'Lempung gembur kaya bahan organik, drainase baik.':
      'Loose loam rich in organic matter, well drained.',
  'Lempung berpasir, drainase sangat baik; toleran masam.':
      'Sandy loam, very well drained; tolerates acidity.',
  'Andosol atau lempung gembur, subur, kaya bahan organik.':
      'Andisol or loose loam, fertile, rich in organic matter.',
  'Lempung dalam, subur, drainase baik.': 'Deep loam, fertile, well drained.',
  'Lempung berpasir dalam, drainase baik.': 'Deep sandy loam, well drained.',
  'Tanah mineral atau gambut dalam, drainase baik.':
      'Mineral soil or deep peat, well drained.',
  'Gembur, kaya bahan organik, drainase baik.':
      'Loose, rich in organic matter, well drained.',
  'Gembur dan subur, drainase baik.': 'Loose and fertile, well drained.',
  'Gembur, drainase baik; toleran tanah kurang subur.':
      'Loose, well drained; tolerates poorer soil.',

  // ----------------------------------------------- panduan: ketinggian & sinar
  '0 sampai 1.200 mdpl': '0 to 1,200 masl',
  '0 sampai 1.500 mdpl (optimal 700 sampai 1.300)':
      '0 to 1,500 masl (best 700–1,300)',
  '0 sampai 1.000 mdpl (optimal dataran rendah)':
      '0 to 1,000 masl (best in the lowlands)',
  '1.000 sampai 2.000 mdpl': '1,000 to 2,000 masl',
  '300 sampai 2.000 mdpl (optimal 800 sampai 1.500)':
      '300 to 2,000 masl (best 800–1,500)',
  '1.000 sampai 1.500 mdpl': '1,000 to 1,500 masl',
  '0 sampai 1.000 mdpl': '0 to 1,000 masl',
  '0 sampai 800 mdpl': '0 to 800 masl',
  '0 sampai 1.300 mdpl': '0 to 1,300 masl',
  '0 sampai 1.200 mdpl (optimal 0 sampai 650)': '0 to 1,200 masl (best 0–650)',
  '0 sampai 900 mdpl': '0 to 900 masl',
  '0 sampai 700 mdpl': '0 to 700 masl',
  'Arabika 1.000 sampai 1.800 mdpl; Robusta 300 sampai 800 mdpl':
      'Arabica 1,000–1,800 masl; robusta 300–800 masl',
  '0 sampai 600 mdpl': '0 to 600 masl',
  '0 sampai 400 mdpl (hingga 600)': '0 to 400 masl (up to 600)',
  '0 sampai 400 mdpl': '0 to 400 masl',
  '200 sampai 900 mdpl': '200 to 900 masl',
  'Penuh (lebih dari 8 jam per hari).': 'Full (more than 8 hours a day).',
  'Penuh.': 'Full sun.',
  'Penuh, minimal 70 persen penyinaran.': 'Full, at least 70 percent sunlight.',
  'Penuh sampai teduh ringan.': 'Full sun to light shade.',
  'Penuh, sangat butuh sinar.': 'Full — very sun-hungry.',
  'Perlu naungan 30 sampai 50 persen (lamtoro, dadap).':
      'Needs 30–50 percent shade (lamtoro, corkwood).',
  'Perlu naungan, terutama saat muda.': 'Needs shade, especially while young.',
  'Penuh sampai naungan ringan.': 'Full sun to light shade.',
  'Naungan ringan.': 'Light shade.',

  // -------------------------------------------------- panduan: kebutuhan air
  'Sedang. Siram teratur, hindari genangan.':
      'Moderate. Water regularly and avoid waterlogging.',
  'Sedang dan merata. Hindari membasahi daun.':
      'Moderate and even. Keep the leaves dry.',
  'Cukup tetapi tidak tergenang; kurangi menjelang panen.':
      'Enough but never waterlogged; cut back near harvest.',
  'Sedang dan merata; kebutuhan tinggi saat pembentukan umbi.':
      'Moderate and even; demand peaks while tubers form.',
  'Cukup dan merata.': 'Enough, spread evenly.',
  'Merata; kekeringan lalu basah membuat umbi pecah.':
      'Even; drying then wetting splits the tubers.',
  'Cukup; siram 1 sampai 2 kali sehari saat kemarau.':
      'Enough; water once or twice a day in the dry season.',
  'Sedang dan teratur.': 'Moderate and regular.',
  'Sedang; peka terhadap genangan.': 'Moderate; sensitive to standing water.',
  'Cukup, terutama saat berbunga dan pengisian biji.':
      'Enough, especially during flowering and seed filling.',
  'Tinggi; gunakan pengairan berselang untuk hemat air.':
      'High; use alternate wetting and drying to save water.',
  'Sedang; jangan tergenang saat polong terbentuk.':
      'Moderate; keep water from pooling while pods form.',
  'Sedang; kurangi menjelang panen.': 'Moderate; reduce before harvest.',
  'Rendah sampai sedang; tidak tahan genangan.':
      'Low to moderate; it will not tolerate waterlogging.',
  'Cukup saat tumbuh; kurangi menjelang panen agar manis.':
      'Enough while growing; cut back before harvest for sweetness.',
  'Teratur dan terukur; kurangi saat buah matang.':
      'Regular and measured; ease off as the fruit ripens.',
  'Sedang; sangat peka genangan.': 'Moderate; very sensitive to waterlogging.',
  'Tinggi dan merata; tidak tahan genangan.':
      'High and even; it cannot stand waterlogging.',
  'Curah hujan 1.500 sampai 2.500 mm per tahun, merata.':
      'Rainfall 1,500–2,500 mm a year, evenly spread.',
  'Curah hujan 2.000 sampai 3.000 mm per tahun.':
      'Rainfall 2,000–3,000 mm a year.',
  'Curah hujan 2.000 sampai 2.500 mm per tahun, merata.':
      'Rainfall 2,000–2,500 mm a year, evenly spread.',
  'Tinggi saat tumbuh, kurangi menjelang tebang.':
      'High while growing, reduced before cutting.',
  'Sedang; toleran naungan.': 'Moderate; tolerates shade.',
  'Curah hujan 2.000 sampai 3.000 mm per tahun; tidak tahan genangan.':
      'Rainfall 2,000–3,000 mm a year; it cannot stand waterlogging.',
  'Sedang.': 'Moderate.',
  'Sedang; peka genangan, butuh air saat berbunga dan pengisian polong.':
      'Moderate; sensitive to waterlogging, needs water at flowering and pod filling.',
  'Curah hujan 1.500 sampai 2.500 mm per tahun dengan 2 sampai 3 bulan kering.':
      'Rainfall 1,500–2,500 mm a year with 2–3 dry months.',

  // ------------------------------------------------------- panduan: panen
  'Mulai 75 sampai 90 hari setelah tanam. Petik saat buah merah 80 sampai 90 persen, lakukan bertahap tiap 3 sampai 7 hari.':
      'From 75–90 days after planting. Pick when the fruit is 80–90 percent red, in stages every 3–7 days.',
  'Mulai 70 sampai 90 hari setelah tanam. Petik saat buah mulai merah (breaker) bila akan dikirim jauh.':
      'From 70–90 days after planting. Pick at the breaker stage if it has to travel far.',
  'Umur 60 sampai 70 hari, saat 60 sampai 70 persen daun rebah. Angin-anginkan 1 sampai 2 minggu sebelum disimpan.':
      'At 60–70 days, when 60–70 percent of the leaves have fallen. Air-dry for 1–2 weeks before storing.',
  'Umur 90 sampai 120 hari, saat daun menguning dan kulit umbi kuat. Biarkan 1 sampai 2 minggu setelah daun mati sebelum panen.':
      'At 90–120 days, when leaves yellow and the skin is firm. Wait 1–2 weeks after the leaves die back before harvesting.',
  'Umur 70 sampai 90 hari. Panen saat krop padat, sebelum pecah.':
      'At 70–90 days. Harvest while the head is firm, before it splits.',
  'Umur 90 sampai 100 hari, saat umbi berwarna penuh dan ukuran seragam.':
      'At 90–100 days, when the tubers are fully coloured and uniform in size.',
  'Umur 30 sampai 40 hari. Panen saat daun lebar dan belum berbunga.':
      'At 30–40 days. Harvest when the leaves are broad and before flowering.',
  'Mulai 70 sampai 100 hari. Petik saat buah mengkilap dan belum keras bijinya, tiap 3 sampai 4 hari.':
      'From 70–100 days. Pick when the fruit is glossy and the seeds still soft, every 3–4 days.',
  'Umur 45 sampai 55 hari. Panen tiap 1 sampai 2 hari saat buah muda dan seragam.':
      'At 45–55 days. Harvest every 1–2 days while the fruit is young and uniform.',
  'Mulai 50 sampai 60 hari. Petik polong muda sebelum biji menonjol, tiap 2 sampai 3 hari.':
      'From 50–60 days. Pick young pods before the seeds bulge, every 2–3 days.',
  'Umur 90 sampai 110 hari. Panen saat klobot menguning dan biji keras; jemur sampai kadar air sekitar 14 persen.':
      'At 90–110 days. Harvest when the husks yellow and the kernels harden; sun-dry to about 14 percent moisture.',
  'Umur 105 sampai 125 hari, saat 90 persen bulir menguning. Keringkan gabah sampai kadar air sekitar 14 persen.':
      'At 105–125 days, when 90 percent of the panicles yellow. Dry the unhusked rice to about 14 percent moisture.',
  'Umur 80 sampai 90 hari, saat 95 persen polong menguning kecokelatan.':
      'At 80–90 days, when 95 percent of the pods turn yellow-brown.',
  'Umur 90 sampai 100 hari. Keringkan polong sampai kadar air 9 persen atau kurang.':
      'At 90–100 days. Dry the pods to 9 percent moisture or less.',
  'Umur 3,5 sampai 4 bulan, saat daun menguning. Panen di tanah kering.':
      'At 3.5–4 months, when the leaves yellow. Harvest in dry soil.',
  'Umur 8 sampai 12 bulan, tergantung varietas. Panen saat kadar pati tinggi.':
      'At 8–12 months depending on the variety. Harvest when the starch content is high.',
  'Umur 65 sampai 80 hari, saat tangkai dan sulur dekat buah mengering, bunyi berdengung.':
      'At 65–80 days, when the stalk and the tendril near the fruit dry out and it sounds hollow.',
  'Umur 60 sampai 75 hari, saat jaring merata dan aroma harum.':
      'At 60–75 days, when the netting is even and the aroma is sweet.',
  'Mulai 8 sampai 10 bulan. Panen saat 1 sampai 2 garis kuning muncul di kulit.':
      'From 8–10 months. Harvest when one or two yellow lines appear on the skin.',
  'Umur 9 sampai 12 bulan, saat buah bulat dan sudut mulai membulat.':
      'At 9–12 months, when the fruit is round and the corners begin to fill out.',
  'Umur 14 sampai 18 bulan, saat mata buah mulai menguning dari pangkal.':
      'At 14–18 months, when the fruit eyes start to yellow from the base.',
  'Panen selektif buah merah. Olah segera setelah petik (basah atau kering) dan jemur sampai kadar air sekitar 12 persen.':
      'Selectively pick red fruit. Process it right after picking, wet or dry, and sun-dry to about 12 percent moisture.',
  'Panen tiap 1 sampai 2 minggu saat buah menguning atau memerah.':
      'Harvest every 1–2 weeks as the fruit yellows or reddens.',
  'Mulai sadap umur 5 sampai 6 tahun. Bekukan lateks dengan benar agar mutu terjaga.':
      'Start tapping at 5–6 years. Coagulate the latex properly to keep the grade.',
  'Panen TBS matang (minimal 2 brondolan jatuh) dan kirim ke pabrik dalam 24 jam.':
      'Harvest ripe fresh fruit bunches (at least two loose fruits fallen) and deliver to the mill within 24 hours.',
  'Umur 10 sampai 12 bulan, saat rendemen optimum.':
      'At 10–12 months, when the sugar content is optimal.',
  'Panen 8 sampai 10 bulan untuk jahe muda, 10 sampai 12 bulan untuk jahe tua.':
      'Harvest at 8–10 months for young ginger, 10–12 months for mature ginger.',
  'Umur 9 sampai 12 bulan, saat daun menguning dan mengering.':
      'At 9–12 months, when the leaves yellow and dry out.',
  'Panen saat buah mulai kuning kemerahan, sekitar 8 sampai 9 bulan setelah berbunga. Jemur sampai kering merata.':
      'Harvest when the fruit turns yellow-red, about 8–9 months after flowering. Sun-dry until evenly dry.',
  'Potong daun 10 sampai 15 cm di atas tanah. Segera sulingkan atau layukan sebentar.':
      'Cut the leaves 10–15 cm above the soil. Distil straight away, or wilt them briefly.',

  // ------------------------------------------------ panduan: catatan kalender
  'Panen sekitar 14 sampai 18 bulan setelah tanam. Induksi pembungaan membantu panen lebih serempak.':
      'Harvest about 14–18 months after planting. Flowering induction makes the harvest more even.',
  'Tanaman tahunan: tanam di awal musim hujan. Panen raya biasanya setahun sekali, waktunya berbeda menurut ketinggian dan daerah. Populasi dihitung dari jarak Arabika; Robusta sekitar 1.100 pohon per ha.':
      'A perennial: plant at the start of the rainy season. The main harvest is once a year, timed differently by altitude and area. Density is calculated from Arabica spacing; Robusta is about 1,100 trees per ha.',
  'Tanaman tahunan: tanam di awal musim hujan. Biasanya ada panen raya dan panen sela dalam setahun, waktunya mengikuti curah hujan daerah.':
      'A perennial: plant at the start of the rainy season. There is usually a main and a mid-year harvest, timed with local rainfall.',
  'Tanaman tahunan: tanam di awal musim hujan. Sadap bisa sepanjang tahun; hasil turun saat gugur daun dan hujan lebat.':
      'A perennial: plant at the start of the rainy season. Tapping runs all year; yields fall during leaf drop and heavy rain.',
  'Tanaman tahunan: tanam di awal musim hujan. Panen sepanjang tahun tiap 7 sampai 14 hari; produksi naik turun mengikuti curah hujan.':
      'A perennial: plant at the start of the rainy season. Harvest all year every 7–14 days; output rises and falls with rainfall.',
  'Masa tanam sampai tebang sekitar 12 bulan. Tebang dilakukan pada musim giling (musim kemarau).':
      'Planting to cutting is about 12 months. Cutting happens in the milling season (the dry season).',
  'Tanaman tahunan: tanam di awal musim hujan. Panen umumnya sekali setahun, waktunya berbeda menurut daerah.':
      'A perennial: plant at the start of the rainy season. Harvest is usually once a year, timed differently by area.',

  // --------------------------------------------------- panduan: jarak tanam
  'Baris 20 cm, antar tanaman 5 sampai 10 cm':
      'Rows 20 cm, 5–10 cm between plants',
  '60 × 40 cm dengan lanjaran': '60 × 40 cm with trellis poles',
  '60 × 30 cm (2 biji per lubang)': '60 × 30 cm (2 seeds per hole)',
  '75 × 20 cm (1 biji per lubang)': '75 × 20 cm (1 seed per hole)',
  'Jajar legowo 2:1 (25 × 12,5 × 50 cm)':
      'Jajar legowo 2:1 (25 × 12.5 × 50 cm)',
  '40 × 15 cm (2 biji per lubang)': '40 × 15 cm (2 seeds per hole)',
  '40 × 10 sampai 15 cm': '40 × 10–15 cm',
  '100 × 25 cm (guludan)': '100 × 25 cm (formed on ridges)',
  '200 × 60 sampai 100 cm': '200 × 60–100 cm',
  '100 × 50 cm dengan lanjaran': '100 × 50 cm with trellis poles',
  '3 × 3 m (atau 2,5 × 2,5 m)': '3 × 3 m (or 2.5 × 2.5 m)',
  'Arabika 2,5 × 2,5 m; Robusta 3 × 3 m':
      'Arabica 2.5 × 2.5 m; Robusta 3 × 3 m',
  'Segitiga sama sisi 9 m': 'Equilateral triangle, 9 m apart',
  'Jarak antar baris 135 sampai 150 cm': 'Row spacing 135–150 cm',
  '2 × 2 m dengan tiang panjat': '2 × 2 m with climbing poles',
  '6 × 3 m atau 7 × 3 m': '6 × 3 m or 7 × 3 m',

  // ------------------------------------------ panduan: nama pupuk & jenis masalah
  'Kompos / pupuk kandang': 'Compost / manure',
  'Pupuk kandang / kompos': 'Manure / compost',
  'Pupuk kandang': 'Farm manure',
  'Kompos matang': 'Well-rotted compost',
  'Kompos': 'Compost',
  'ZA (sumber belerang)': 'ZA (sulphur source)',
  'Belerang / pH rendah': 'Sulphur / low pH',
  'Pupuk organik / jerami': 'Organic fertiliser / straw',
  'Pupuk organik': 'Organic fertiliser',
  'Inokulum Rhizobium / kapur': 'Rhizobium inoculant / lime',
  'Kapur pertanian / gipsum': 'Agricultural lime / gypsum',
  'Hindari N berlebih': 'Avoid excess nitrogen',
  'Batasi N': 'Limit nitrogen',
  'Dolomit': 'Dolomite',
  'Dolomit / kalsium': 'Dolomite / calcium',
  'KCl / ZK (kalium)': 'KCl / ZK (potassium)',
  'KCl / ZK': 'KCl / ZK',
  'KCl (MOP)': 'KCl (MOP)',
  'Kieserit (magnesium)': 'Kieserite (magnesium)',
  'Borat': 'Borate',
  'Boraks (boron)': 'Borax (boron)',
  'Kalsium': 'Calcium',
  'Kalium': 'Potassium',
  'Kalium dan magnesium': 'Potassium and magnesium',
  'Boron': 'Boron',
  'NPK 16-16-16 (tanaman muda)': 'NPK 16-16-16 (young plants)',
  'NPK 16-16-16 (tanaman menghasilkan)': 'NPK 16-16-16 (bearing plants)',
  'kg/pohon': 'kg/tree',
  'kg/pohon/thn': 'kg/tree/year',
  'g/pohon/kali': 'g/tree/round',
  'g/pohon/thn': 'g/tree/year',
  'Jamur': 'Fungus',
  'Bakteri': 'Bacteria',
  'Hama': 'Pest',
  'Fisiologis': 'Physiological',
  'Virus': 'Virus',
  'Jamur / Bakteri': 'Fungus / bacteria',

  // ----------------------------------------- panduan: nama masalah (1/3)
  'Antraknosa (patek)': 'Anthracnose (patek)',
  'Layu bakteri / Fusarium': 'Bacterial / Fusarium wilt',
  'Thrips dan kutu kebul': 'Thrips and whitefly',
  'Hawar daun (Phytophthora)': 'Leaf blight (Phytophthora)',
  'Layu bakteri': 'Bacterial wilt',
  'Busuk ujung buah': 'Blossom-end rot',
  'Ulat bawang (Spodoptera exigua)': 'Beet armyworm (Spodoptera exigua)',
  'Bercak ungu (Alternaria)': 'Purple blotch (Alternaria)',
  'Moler / Fusarium': 'Moler / Fusarium',
  'Busuk daun (Phytophthora infestans)': 'Late blight (Phytophthora infestans)',
  'Kudis (Streptomyces)': 'Common scab (Streptomyces)',
  'Akar gada (Plasmodiophora)': 'Clubroot (Plasmodiophora)',
  'Ulat daun kubis (Plutella)': 'Diamondback moth (Plutella)',
  'Busuk hitam (Xanthomonas)': 'Black rot (Xanthomonas)',
  'Busuk lunak (Erwinia)': 'Soft rot (Erwinia)',
  'Bercak daun (Alternaria / Cercospora)':
      'Leaf spot (Alternaria / Cercospora)',
  'Nematoda puru akar': 'Root-knot nematode',
  'Ulat daun (Plutella / Crocidolomia)':
      'Leaf caterpillars (Plutella / Crocidolomia)',
  'Kutu daun': 'Aphids',
  'Busuk lunak / bercak daun': 'Soft rot / leaf spot',
  'Penggerek buah dan pucuk (Leucinodes)': 'Bud and fruit borer (Leucinodes)',
  'Tungau dan kutu kebul': 'Mites and whitefly',
  'Embun tepung (powdery mildew)': 'Powdery mildew',
  'Bulai (downy mildew)': 'Downy mildew',
  'Lalat buah dan kumbang daun': 'Fruit fly and leaf beetle',
  'Kutu daun dan penggerek polong': 'Aphids and pod borer',
  'Karat daun': 'Leaf rust',
  'Virus mosaik': 'Mosaic virus',
  'Bulai (Peronosclerospora)': 'Downy mildew (Peronosclerospora)',
  'Ulat grayak (Spodoptera frugiperda)':
      'Fall armyworm (Spodoptera frugiperda)',

  // ----------------------------------------- panduan: nama masalah (2/3)
  'Hawar daun (Helminthosporium)': 'Leaf blight (Helminthosporium)',
  'Blas (Pyricularia)': 'Blast (Pyricularia)',
  'Wereng cokelat': 'Brown planthopper',
  'Tungro': 'Tungro',
  'Karat daun (Phakopsora)': 'Leaf rust (Phakopsora)',
  'Penggerek polong (Etiella)': 'Pod borer (Etiella)',
  'Pengisap polong (Riptortus)': 'Pod-sucking bug (Riptortus)',
  'Bercak daun (Cercospora)': 'Leaf spot (Cercospora)',
  'Busuk batang (Sclerotium)': 'Stem rot (Sclerotium)',
  'Aflatoksin (Aspergillus)': 'Aflatoxin (Aspergillus)',
  'Boleng / lanas (Cylas formicarius)':
      'Cassava weevil / boleng (Cylas formicarius)',
  'Kudis (Sphaceloma)': 'Scab (Sphaceloma)',
  'Busuk batang (Fusarium)': 'Stem rot (Fusarium)',
  'Hawar bakteri (Xanthomonas)': 'Bacterial blight (Xanthomonas)',
  'Tungau merah dan kutu putih': 'Red spider mite and mealybug',
  'Busuk akar': 'Root rot',
  'Layu fusarium': 'Fusarium wilt',
  'Embun tepung dan antraknosa': 'Powdery mildew and anthracnose',
  'Kutu daun dan lalat buah': 'Aphids and fruit fly',
  'Embun tepung': 'Powdery mildew',
  'Virus bercak cincin (PRSV)': 'Ring spot virus (PRSV)',
  'Busuk pangkal batang (Phytophthora)': 'Stem-base rot (Phytophthora)',
  'Antraknosa': 'Anthracnose',
  'Layu fusarium (Panama)': 'Fusarium wilt (Panama disease)',
  'Layu bakteri (darah)': 'Bacterial wilt (blood disease)',
  'Bercak daun (sigatoka)': 'Leaf spot (Sigatoka)',
  'Busuk hati / akar (Phytophthora)': 'Core and root rot (Phytophthora)',
  'Layu kutu putih (mealybug wilt)': 'Mealybug wilt',
  'Busuk pangkal buah': 'Fruit-base rot',
  'Karat daun (Hemileia vastatrix)': 'Leaf rust (Hemileia vastatrix)',

  // ----------------------------------------- panduan: nama masalah (3/3)
  'Penggerek buah kopi (PBKo)': 'Coffee berry borer (PBKo)',
  'Jamur akar': 'Root fungus',
  'Busuk buah (Phytophthora palmivora)': 'Pod rot (Phytophthora palmivora)',
  'Penggerek buah kakao (PBK)': 'Cocoa pod borer (PBK)',
  'VSD (Vascular Streak Dieback)': 'VSD (vascular streak dieback)',
  'Jamur akar putih (Rigidoporus)': 'White root fungus (Rigidoporus)',
  'Gugur daun (Colletotrichum)': 'Leaf fall (Colletotrichum)',
  'Kering alur sadap (KAS)': 'Tapping panel dryness (KAS)',
  'Busuk pangkal batang (Ganoderma)': 'Stem-base rot (Ganoderma)',
  'Ulat api dan ulat kantong': 'Fireworms and bagworms',
  'Kumbang tanduk (Oryctes)': 'Rhinoceros beetle (Oryctes)',
  'Pokahbung': 'Bunchy top (pokahbung)',
  'Penggerek batang dan pucuk': 'Stem and shoot borer',
  'Luka api (smut)': 'Smut (luka api)',
  'Busuk rimpang (Fusarium / Ralstonia)': 'Rhizome rot (Fusarium / Ralstonia)',
  'Bercak daun': 'Leaf spot',
  'Lalat rimpang': 'Rhizome fly',
  'Bercak daun (Colletotrichum)': 'Leaf spot (Colletotrichum)',
  'Busuk rimpang': 'Rhizome rot',
  'Penggulung daun': 'Leaf roller',
  'Busuk pangkal batang (Phytophthora capsici)':
      'Stem-base rot (Phytophthora capsici)',
  'Penyakit kuning (nematoda)': 'Yellowing disease (nematode)',
  'Penggerek batang': 'Stem borer',
  'Bercak daun (Curvularia)': 'Leaf spot (Curvularia)',
  'Busuk pangkal': 'Base rot',

  // ------------------------------------- panduan: dosis pupuk (1/4)
  '15 sampai 20 ton per ha sebagai pupuk dasar.':
      '15–20 tonnes per ha as a base fertiliser.',
  '300 sampai 400 kg per ha, dibagi 3 sampai 4 kali (dasar, 2, 5, dan 8 MST).':
      '300–400 kg per ha, split 3–4 times (base, then 2, 5 and 8 weeks after planting).',
  '100 sampai 150 kg per ha saat mulai berbuah.':
      '100–150 kg per ha when fruiting begins.',
  '1 sampai 2 ton per ha bila pH di bawah 5,5, 2 minggu sebelum tanam.':
      '1–2 tonnes per ha if the pH is below 5.5, two weeks before planting.',
  '300 sampai 400 kg per ha, bertahap tiap 2 sampai 3 minggu.':
      '300–400 kg per ha, in stages every 2–3 weeks.',
  '100 sampai 200 kg per ha, penting saat pembuahan.':
      '100–200 kg per ha; important during fruit set.',
  'Cegah busuk ujung buah; berikan sebelum tanam dan jaga penyiraman.':
      'Prevents blossom-end rot; apply before planting and keep watering steady.',
  '10 sampai 20 ton per ha sebagai pupuk dasar.':
      '10–20 tonnes per ha as a base fertiliser.',
  '300 sampai 400 kg per ha, dibagi 2 kali (dasar dan 3 MST).':
      '300–400 kg per ha, split twice (base and 3 weeks after planting).',
  '200 sampai 300 kg per ha; bawang butuh belerang.':
      '200–300 kg per ha; onions need sulphur.',
  '100 sampai 150 kg per ha untuk kualitas umbi.':
      '100–150 kg per ha for tuber quality.',
  '20 sampai 30 ton per ha sebagai pupuk dasar.':
      '20–30 tonnes per ha as a base fertiliser.',
  'Sekitar 600 sampai 800 kg per ha, dibagi saat tanam dan 30 hari.':
      'About 600–800 kg per ha, split at planting and at 30 days.',
  '150 sampai 200 kg per ha untuk pembesaran umbi.':
      '150–200 kg per ha for tuber bulking.',
  'Jaga pH di bawah 6,0 untuk menekan penyakit kudis.':
      'Keep the pH below 6.0 to suppress common scab.',
  '300 sampai 400 kg per ha, bertahap.': '300–400 kg per ha, in stages.',
  '100 sampai 150 kg per ha pada fase pertumbuhan daun.':
      '100–150 kg per ha during the leaf growth phase.',
  'Sekitar 10 sampai 15 kg per ha bila tanah miskin boron (krop berlubang).':
      'About 10–15 kg per ha if the soil is short of boron (hollow stems).',
  '15 sampai 20 ton per ha. Hindari pupuk kandang segar (umbi bercabang).':
      '15–20 tonnes per ha. Avoid fresh manure (it forks the tubers).',
  'Sekitar 300 kg per ha, dibagi 2 kali.': 'About 300 kg per ha, split twice.',
  'Sekitar 100 kg per ha untuk kualitas umbi.':
      'About 100 kg per ha for tuber quality.',
  '10 sampai 15 ton per ha sebagai pupuk dasar.':
      '10–15 tonnes per ha as a base fertiliser.',
  '100 sampai 150 kg per ha, dibagi 2 kali (7 dan 21 hari).':
      '100–150 kg per ha, split twice (at 7 and 21 days).',
  'Sekitar 200 kg per ha bila perlu.': 'About 200 kg per ha if needed.',

  // ------------------------------------- panduan: dosis pupuk (2/4)
  '300 sampai 400 kg per ha, bertahap tiap 3 sampai 4 minggu.':
      '300–400 kg per ha, in stages every 3–4 weeks.',
  '100 sampai 150 kg per ha saat pembuahan.':
      '100–150 kg per ha while fruiting.',
  '250 sampai 300 kg per ha, bertahap.': '250–300 kg per ha, in stages.',
  'Sekitar 100 kg per ha saat berbuah.': 'About 100 kg per ha when fruiting.',
  'Sekitar 10 ton per ha sebagai pupuk dasar.':
      'About 10 tonnes per ha as a base fertiliser.',
  '100 kg per ha untuk perakaran dan pembungaan.':
      '100 kg per ha for rooting and flowering.',
  '50 sampai 75 kg per ha.': '50–75 kg per ha.',
  'Dosis rendah (NPK 100 sampai 150 kg per ha); kacang-kacangan memfiksasi N sendiri.':
      'A low dose (NPK 100–150 kg per ha); legumes fix their own nitrogen.',
  '300 sampai 400 kg per ha, 2 sampai 3 tahap (7 sampai 10, 25 sampai 30, dan 40 hari).':
      '300–400 kg per ha in 2–3 stages (7–10, 25–30 and 40 days).',
  '100 sampai 150 kg per ha sebagai pupuk dasar.':
      '100–150 kg per ha as a base fertiliser.',
  'Sekitar 100 kg per ha.': 'About 100 kg per ha.',
  '2 sampai 5 ton per ha untuk memperbaiki tanah.':
      '2–5 tonnes per ha to improve the soil.',
  '200 sampai 250 kg per ha, 3 tahap (7 sampai 10, 25 sampai 30, dan 40 sampai 45 hari).':
      '200–250 kg per ha in 3 stages (7–10, 25–30 and 40–45 days).',
  '75 sampai 100 kg per ha sebagai pupuk dasar.':
      '75–100 kg per ha as a base fertiliser.',
  '50 sampai 100 kg per ha.': '50–100 kg per ha.',
  'Sekitar 2 ton per ha untuk memperbaiki tanah.':
      'About 2 tonnes per ha to improve the soil.',
  '25 sampai 50 kg per ha sebagai starter; selebihnya dari bintil akar.':
      '25–50 kg per ha as a starter; the rest comes from the root nodules.',
  'Bantu bintil akar; kapur bila tanah masam.':
      'Supports the root nodules; add lime if the soil is acidic.',
  '300 sampai 500 kg per ha saat berbunga untuk pengisian polong.':
      '300–500 kg per ha at flowering for pod filling.',
  '25 sampai 50 kg per ha sebagai starter.': '25–50 kg per ha as a starter.',
  '200 sampai 300 kg per ha.': '200–300 kg per ha.',
  '100 sampai 150 kg per ha untuk pembesaran umbi.':
      '100–150 kg per ha for tuber bulking.',
  'Terlalu banyak N membuat daun lebat, umbi kecil.':
      'Too much nitrogen gives heavy leaves and small tubers.',

  // ------------------------------------- panduan: dosis pupuk (3/4)
  '5 sampai 10 ton per ha sebagai pupuk dasar.':
      '5–10 tonnes per ha as a base fertiliser.',
  '150 sampai 250 kg per ha.': '150–250 kg per ha.',
  '100 sampai 150 kg per ha, 2 kali.': '100–150 kg per ha, twice.',
  'Sekitar 100 kg per ha untuk meningkatkan pati.':
      'About 100 kg per ha to raise the starch content.',
  'Berikan saat pembentukan buah untuk kemanisan.':
      'Apply during fruit set to improve sweetness.',
  'N berlebih saat berbuah membuat rasa kurang manis.':
      'Excess nitrogen while fruiting makes the taste less sweet.',
  'Bertahap; naikkan kalium saat pembentukan buah.':
      'In stages; raise potassium as the fruit sets.',
  'Mendukung kemanisan dan tekstur.': 'Supports sweetness and texture.',
  'Menguatkan kulit dan mengurangi pecah buah.':
      'Strengthens the skin and reduces fruit splitting.',
  '10 sampai 20 kg per pohon sebagai pupuk dasar.':
      '10–20 kg per tree as a base fertiliser.',
  '100 sampai 200 g per pohon tiap 2 sampai 3 bulan.':
      '100–200 g per tree every 2–3 months.',
  'Tambah saat berbuah untuk kualitas.':
      'Add more while fruiting, for quality.',
  'Cukupi untuk mengurangi buah cacat.':
      'Keep it sufficient to reduce deformed fruit.',
  '10 sampai 20 kg per rumpun sebagai pupuk dasar.':
      '10–20 kg per clump as a base fertiliser.',
  '100 sampai 200 g per rumpun tiap 2 sampai 3 bulan.':
      '100–200 g per clump every 2–3 months.',
  'Pisang butuh banyak kalium untuk pengisian tandan.':
      'Bananas need plenty of potassium to fill the bunch.',
  'Dibagi 4 sampai 5 kali selama pertumbuhan.':
      'Split 4–5 times during the growth period.',
  'Mendukung ukuran dan rasa buah.': 'Supports fruit size and flavour.',
  '10 sampai 20 kg per pohon per tahun.': '10–20 kg per tree per year.',
  'Sekitar 150 sampai 300 g per pohon per tahun, dibagi 2 kali (awal dan akhir musim hujan).':
      'About 150–300 g per tree per year, split twice (early and late in the rainy season).',
  'Bila pH di bawah 5,0, berikan 0,5 sampai 1 kg per pohon.':
      'If the pH is below 5.0, apply 0.5–1 kg per tree.',
  '10 sampai 15 kg per pohon per tahun.': '10–15 kg per tree per year.',

  // ------------------------------------- panduan: dosis pupuk (4/4)
  'Sekitar 100 sampai 300 g per pohon per tahun, dibagi 2 kali.':
      'About 100–300 g per tree per year, split twice.',
  'Bila tanah masam.': 'If the soil is acidic.',
  'Sekitar 100 sampai 200 g per pohon per tahun, bertahap.':
      'About 100–200 g per tree per year, in stages.',
  'Sekitar 250 sampai 400 g per pohon per tahun, 2 kali.':
      'About 250–400 g per tree per year, twice.',
  'Perbaiki struktur tanah di piringan.':
      'Improve the soil structure in the tree disc.',
  '1,5 sampai 2,5 kg per pohon per tahun untuk tanaman menghasilkan, dibagi 2 kali.':
      '1.5–2.5 kg per bearing tree per year, split twice.',
  '2 sampai 3 kg per pohon per tahun.': '2–3 kg per tree per year.',
  '1 sampai 1,5 kg per pohon per tahun.': '1–1.5 kg per tree per year.',
  '100 sampai 200 g per pohon per tahun.': '100–200 g per tree per year.',
  '400 sampai 600 kg per ha, 2 sampai 3 tahap.':
      '400–600 kg per ha in 2–3 stages.',
  '100 sampai 200 kg per ha.': '100–200 kg per ha.',
  'Dukung pembentukan rimpang.': 'Supports rhizome formation.',
  '10 sampai 20 ton per ha.': '10–20 tonnes per ha.',
  '200 sampai 300 kg per ha, bertahap.': '200–300 kg per ha, in stages.',
  'Dukung pembesaran rimpang.': 'Supports rhizome bulking.',
  'Sekitar 10 kg per pohon per tahun.': 'About 10 kg per tree per year.',
  '150 sampai 300 g per pohon per tahun, dibagi 2 sampai 3 kali.':
      '150–300 g per tree per year, split 2–3 times.',
  '100 sampai 200 kg per ha, bagi dalam beberapa kali setelah tiap panen.':
      '100–200 kg per ha, split over several applications after each harvest.',
  'Tambahan bila hasil daun kurang.': 'An extra dose if leaf growth is weak.',

  // ------------------------------------- panduan: gejala masalah (1/4)
  'Bercak cekung kehitaman pada buah, buah busuk dan mengering.':
      'Sunken blackish lesions on the fruit; it rots and dries out.',
  'Tanaman layu mendadak walau tanah lembap, pangkal batang cokelat.':
      'Plants wilt suddenly even in moist soil and the stem base turns brown.',
  'Daun keriting, keperakan atau menguning; pembawa virus keriting.':
      'Leaves curl, turn silvery or yellow; it carries leaf curl virus.',
  'Bercak basah cokelat pada daun dan buah saat lembap.':
      'Wet brown spots on leaves and fruit in humid weather.',
  'Tanaman segar layu mendadak, batang berlendir.':
      'A healthy plant wilts at once and the stem turns slimy.',
  'Ujung buah hitam dan cekung.':
      'The bottom of the fruit goes black and sunken.',
  'Daun berlubang, tampak transparan.': 'Leaves are holed or look transparent.',
  'Bercak ungu cekung pada daun, daun patah.':
      'Sunken purple blotches on the leaves; they snap off.',
  'Tanaman layu, pangkal umbi busuk, daun memutar.':
      'Plants wilt, the tuber base rots and the leaves twist.',
  'Bercak basah cokelat tua, cepat meluas saat lembap dan dingin.':
      'Dark brown wet patches that spread fast in cold, humid weather.',
  'Tanaman layu, umbi berlendir dan berbau.':
      'Plants wilt; tubers go slimy and smell.',
  'Bercak kasar seperti kudis pada kulit umbi.':
      'Rough scab-like patches on the tuber skin.',
  'Akar membengkak, tanaman layu di siang hari.':
      'Roots swell and plants wilt during the day.',
  'Daun berlubang seperti jendela.': 'The leaves show window-like holes.',
  'Bercak kuning berbentuk V dari tepi daun, urat menghitam.':
      'Yellow V-shaped patches spreading in from the leaf edge; the veins blacken.',
  'Umbi lembek berlendir dan berbau.':
      'Tubers turn soft, slimy and foul-smelling.',
  'Bercak cokelat pada daun.': 'Brown spots on the leaves.',
  'Umbi berbintil dan bercabang.': 'Tubers grow knobby and forked.',
  'Daun berlubang-lubang.': 'Leaves riddled with holes.',
  'Daun keriting, ada koloni kecil di bawah daun.':
      'Curled leaves with small colonies on the underside.',
  'Daun busuk berlendir atau bercak cokelat.':
      'Leaves rot slimy or show brown patches.',
  'Tanaman layu mendadak.': 'Plants wilt suddenly.',
  'Pucuk layu, buah berlubang.': 'Shoots wilt and the fruit is bored through.',
  'Daun menguning bercak, keperakan.':
      'Leaves yellow in patches and turn silvery.',

  // ------------------------------------- panduan: gejala masalah (2/4)
  'Bercak putih seperti tepung di daun.':
      'White powdery patches on the leaves.',
  'Bercak kuning bersudut, bawah daun keunguan.':
      'Angular yellow spots, purple underside of the leaves.',
  'Buah cacat, daun berlubang.': 'Misshapen fruit and holed leaves.',
  'Daun keriting; polong berlubang.': 'Curled leaves; pods bored through.',
  'Bintik oranye kecokelatan pada daun.':
      'Orange-brown pustules on the leaves.',
  'Daun belang dan kerdil.': 'Mottled leaves and stunted growth.',
  'Garis putih kekuningan pada daun, tanaman kerdil.':
      'Pale yellow-white trails on the leaves, plants stunted.',
  'Daun berlubang, kotoran di pucuk.': 'Holed leaves, droppings on the shoots.',
  'Bercak lonjong cokelat memanjang di daun.':
      'Long brown oval lesions running along the leaf.',
  'Bercak belah ketupat pada daun; leher malai patah.':
      'Diamond-shaped lesions on the leaf; the neck of the panicle breaks.',
  'Tanaman mengering melingkar (hopperburn).':
      'Plants dry out in circles (hopperburn).',
  'Daun kuning-jingga, tanaman kerdil.':
      'Yellow-orange leaves, stunted plants.',
  'Bintik cokelat kemerahan di bawah daun.':
      'Reddish-brown specks on the underside of the leaves.',
  'Polong berlubang, biji rusak.': 'Pods bored through, seeds damaged.',
  'Biji kempes dan bercak.': 'Shrivelled seeds with discolouration.',
  'Bercak cokelat bulat pada daun, daun gugur.':
      'Round brown spots on the leaves, leaves drop.',
  'Pangkal batang busuk dengan miselium putih.':
      'Stem base rots with white fungal threads.',
  'Biji berjamur saat penyimpanan.': 'Seeds go mouldy in storage.',
  'Umbi berlubang dan terasa pahit.': 'Tubers holed and taste bitter.',
  'Bercak kasar pada batang dan daun.': 'Rough lesions on stems and leaves.',
  'Batang busuk dan layu.': 'Stems rot and wilt.',
  'Bercak bersudut basah, daun layu.': 'Wet angular spots, leaves wilt.',
  'Daun menguning bercak, pucuk kerdil.':
      'Yellowing spotted leaves and stunted shoots.',

  // ------------------------------------- panduan: gejala masalah (3/4)
  'Akar dan umbi busuk.': 'Roots and tubers rot.',
  'Tanaman layu dari satu sisi, batang pecah.':
      'Plants wilt from one side, the stem splits.',
  'Bercak putih atau cekung pada daun dan buah.':
      'White or sunken spots on the leaves and fruit.',
  'Daun keriting; buah cacat.': 'Curled leaves; misshapen fruit.',
  'Tanaman layu dan batang berlendir.': 'Plants wilt and the stem turns slimy.',
  'Lapisan putih tepung di daun.': 'A white powdery coat on the leaves.',
  'Daun menguning keperakan.': 'Leaves yellow and turn silvery.',
  'Daun mosaik, cincin pada buah.': 'Mosaic leaves, rings on the fruit.',
  'Pangkal batang busuk basah, tanaman layu.':
      'Wet rot at the stem base, plants wilt.',
  'Bercak cekung pada buah.': 'Sunken spots on the fruit.',
  'Daun tua menguning dan patah, batang busuk dalam.':
      'Old leaves yellow and break, the stem rots from inside.',
  'Daun layu, getah kemerahan di bonggol.':
      'Leaves wilt, reddish gum oozes from the corm.',
  'Bercak cokelat memanjang di daun.': 'Long brown streaks on the leaves.',
  'Daun muda layu dan mudah dicabut, pangkal busuk.':
      'Young leaves wilt and pull out easily, the base rots.',
  'Daun memerah dan layu.': 'Leaves redden and wilt.',
  'Pangkal buah lunak, berbau.': 'The fruit base turns soft and smells.',
  'Bintik oranye di bawah daun, daun gugur.':
      'Orange specks under the leaves, leaves drop.',
  'Buah berlubang kecil, biji rusak.':
      'Small holes in the fruit, seeds damaged.',
  'Pohon layu, akar membusuk.': 'The tree wilts and the roots rot.',
  'Bercak cokelat basah pada buah, lalu busuk.':
      'Wet brown patches on the fruit, then rot.',
  'Biji lengket, buah masak awal.': 'Sticky seeds, fruit ripens early.',
  'Daun menguning sepasang pada ranting.':
      'Leaves yellow in pairs along the twig.',

  // ------------------------------------- panduan: gejala masalah (4/4)
  'Daun layu, akar membusuk dengan miselium putih.':
      'Leaves wilt, roots rot with white fungal threads.',
  'Daun muda gugur, bercak cokelat.': 'Young leaves drop, brown spots appear.',
  'Alur sadap mengering dan tidak mengeluarkan lateks.':
      'The tapping panel dries and yields no latex.',
  'Pelepah patah, tubuh buah jamur di pangkal batang.':
      'Fronds break, fungal fruiting bodies at the stem base.',
  'Daun habis dimakan.': 'The leaves are eaten right off.',
  'Pucuk muda tergerek.': 'Young shoots are chewed back.',
  'Pucuk membusuk, daun muda keriput.':
      'Shoots rot, young leaves turn wrinkled.',
  'Lubang pada batang, pucuk mati.': 'Holes in the stem, the shoot dies.',
  'Pucuk berbentuk cambuk hitam.': 'Shoots become black whips.',
  'Daun menguning dan layu, rimpang busuk.':
      'Leaves yellow and wilt, the rhizome rots.',
  'Rimpang berlubang.': 'The rhizome is bored with holes.',
  'Rimpang lunak dan berbau.': 'The rhizome turns soft and smells.',
  'Daun menggulung dan rusak.': 'Leaves curl and are damaged.',
  'Layu mendadak, pangkal batang busuk.':
      'Sudden wilting, rot at the stem base.',
  'Daun menguning, pertumbuhan terhambat.': 'Leaves yellow and growth stalls.',
  'Batang berlubang dan layu.': 'Stems are bored through and wilt.',
  'Bintik oranye di daun.': 'Orange spots on the leaves.',
  'Pangkal rumpun busuk.': 'The base of the clump rots.',

  // ----------------------------------- panduan: aksi masalah (1/4)
  'Buang buah sakit, jaga jarak tanam, hindari genangan, fungisida sesuai label.':
      'Remove affected fruit, keep plant spacing, avoid waterlogging, apply fungicide per label.',
  'Cabut dan musnahkan tanaman, rotasi dengan non-terung-terungan, perbaiki drainase.':
      'Rogue out and destroy plants, rotate with non-solanaceous crops, improve drainage.',
  'Mulsa perak, perangkap kuning, insektisida nabati (neem).':
      'Silver mulch, yellow sticky traps, botanical insecticide (neem).',
  'Fungisida protektif, jarak tanam longgar, jangan basahi daun malam hari.':
      'Protective fungicide, wider spacing, do not wet the leaves at night.',
  'Cabut tanaman, rotasi, perbaiki drainase dan pH.':
      'Rogue out plants, rotate crops, improve drainage and pH.',
  'Penyiraman teratur, cukupi kalsium, jangan beri N berlebih.':
      'Water regularly, meet calcium needs, avoid excess nitrogen.',
  'Kumpulkan telur dan ulat, perangkap feromon, insektisida sesuai label.':
      'Collect eggs and caterpillars, use pheromone traps, apply insecticide per label.',
  'Kurangi kelembapan, fungisida, drainase baik.':
      'Lower humidity, apply fungicide, keep drainage good.',
  'Gunakan bibit sehat, rotasi, Trichoderma.':
      'Use healthy seedlings, rotate crops, apply Trichoderma.',
  'Fungisida bergantian, varietas tahan, drainase, jarak tanam longgar.':
      'Alternate fungicides, resistant varieties, good drainage, wider spacing.',
  'Bibit bersertifikat, rotasi, cabut tanaman sakit.':
      'Certified seed, crop rotation, remove diseased plants.',
  'Jaga pH rendah, rotasi, hindari kapur berlebihan.':
      'Keep the pH low, rotate crops, avoid over-liming.',
  'Naikkan pH mendekati 7, rotasi 3 sampai 5 tahun, bibit sehat.':
      'Raise the pH towards 7, rotate for 3 to 5 years, use healthy seed.',
  'Bt, musuh alami, tanaman perangkap sawi.':
      'Bt, natural enemies, mustard trap crops.',
  'Benih sehat, rotasi, hindari luka.':
      'Healthy seed, crop rotation, avoid wounding the plants.',
  'Drainase baik, hindari luka saat panen, rotasi.':
      'Good drainage, avoid injuring tubers at harvest, rotate crops.',
  'Fungisida sesuai label, jaga jarak tanam.':
      'Apply fungicide per label, keep plant spacing.',
  'Rotasi dengan serealia, tambah bahan organik.':
      'Rotate with cereals, add organic matter.',
  'Jaring penutup, Bt, ambil ulat manual.':
      'Row cover, Bt, pick off caterpillars by hand.',
  'Semprot air sabun atau neem.': 'Spray soapy water or neem.',
  'Drainase baik, jangan terlalu rapat, buang tanaman sakit.':
      'Good drainage, do not plant too densely, remove diseased plants.',
  'Cabut tanaman, rotasi, drainase baik, bibit sehat.':
      'Rogue out plants, rotate crops, good drainage, healthy seedlings.',

  // ----------------------------------- panduan: aksi masalah (2/4)
  'Buang bagian terserang, perangkap feromon.':
      'Remove attacked parts, use pheromone traps.',
  'Neem, perangkap kuning, jaga kelembapan.':
      'Neem, yellow sticky traps, keep humidity up.',
  'Jaga sirkulasi udara, fungisida belerang atau sesuai label.':
      'Keep air moving, sulfur fungicide or apply per label.',
  'Hindari daun basah lama, fungisida sesuai label.':
      'Keep the leaves from staying wet, apply fungicide per label.',
  'Perangkap atraktan, bungkus buah, sanitasi.':
      'Attractant traps, bag the fruit, keep the plot clean.',
  'Perangkap kuning, buang polong terserang, insektisida nabati.':
      'Yellow traps, remove attacked pods, botanical insecticide.',
  'Jaga jarak tanam, fungisida sesuai label.':
      'Keep plant spacing, apply fungicide per label.',
  'Cabut tanaman sakit, kendalikan kutu daun.':
      'Remove diseased plants, control aphids.',
  'Benih tahan dan berlapis fungisida, musnahkan tanaman sakit, tanam serempak.':
      'Resistant and fungicide-treated seed, destroy diseased plants, plant at the same time.',
  'Pantau dini, Bt atau insektisida nabati, tumpangsari.':
      'Scout early, use Bt or botanical insecticide, intercrop.',
  'Varietas tahan, fungisida bila serangan berat.':
      'Resistant variety, fungicide only if the attack is severe.',
  'Varietas tahan, kurangi N berlebih, fungisida sesuai label.':
      'Resistant variety, cut back excess nitrogen, fungicide per label.',
  'Varietas tahan, pengairan berselang, hindari insektisida berlebihan.':
      'Resistant variety, alternate wetting and drying, avoid overusing insecticide.',
  'Tanam serempak, varietas tahan, kendalikan wereng hijau.':
      'Plant together, resistant variety, control the green leafhopper.',
  'Varietas tahan, fungisida sesuai label.':
      'Resistant variety, fungicide per label.',
  'Tanam serempak, pantau saat pembentukan polong.':
      'Plant together, scout closely at pod formation.',
  'Sanitasi gulma, insektisida sesuai ambang.':
      'Weed the borders, insecticide only above the threshold.',
  'Rotasi, fungisida sesuai label.': 'Rotate crops, fungicide per label.',
  'Drainase, rotasi, cabut tanaman sakit.':
      'Drainage, crop rotation, remove diseased plants.',
  'Keringkan cepat, simpan kering dan bersih.':
      'Dry the harvest quickly, store it dry and clean.',
  'Bumbun tinggi, rotasi, perangkap feromon, panen tepat waktu.':
      'Hill up high, rotate, pheromone traps, harvest on time.',

  // ----------------------------------- panduan: aksi masalah (3/4)
  'Stek sehat, rotasi.': 'Healthy cuttings, crop rotation.',
  'Stek bebas penyakit, drainase baik.':
      'Disease-free cuttings, good drainage.',
  'Stek sehat, rotasi, sanitasi.':
      'Healthy cuttings, rotate crops, keep the plot clean.',
  'Neem, musuh alami, tanam sesuai musim.':
      'Neem, natural enemies, plant in the right season.',
  'Drainase baik, hindari lahan tergenang.':
      'Good drainage, keep water off the plot.',
  'Rotasi, bibit sehat, tanah tidak terlalu basah.':
      'Rotate crops, healthy seedlings, soil not waterlogged.',
  'Fungisida sesuai label, sirkulasi udara.':
      'Fungicide per label, keep the air moving.',
  'Perangkap, bungkus buah.': 'Traps, bag the fruit.',
  'Media bersih, rotasi, bibit sehat.':
      'Clean growing media, rotate crops, healthy seedlings.',
  'Sirkulasi udara, fungisida sesuai label.':
      'Air circulation, fungicide per label.',
  'Perangkap, neem, pantau rutin.': 'Traps, neem, scout regularly.',
  'Cabut tanaman sakit, kendalikan kutu daun, bibit sehat.':
      'Remove diseased plants, control aphids, use healthy seedlings.',

  // ----------------------------------- panduan: aksi masalah (4/4)
  'Drainase baik, bumbun, hindari luka.':
      'Good drainage, hill up, avoid wounding.',
  'Panen tepat waktu, fungisida sesuai label.':
      'Harvest on time, fungicide per label.',
  'Bibit bebas penyakit, musnahkan rumpun sakit, jangan pindahkan tanah.':
      'Disease-free planting material, destroy affected clumps, do not move soil.',
  'Sanitasi alat, musnahkan rumpun, bunga jantan dipotong.':
      'Disinfect tools, destroy affected clumps, cut off the male flowers.',
  'Buang daun sakit, jarak tanam longgar.':
      'Remove diseased leaves, keep wider spacing.',
  'Drainase baik, bibit sehat.': 'Good drainage, healthy seedlings.',
  'Kendalikan kutu putih dan semut.': 'Control mealybugs and ants.',
  'Hindari luka saat panen.': 'Avoid bruising the crop at harvest.',
  'Varietas tahan, naungan, pemupukan cukup, fungisida tembaga.':
      'Resistant variety, shade, balanced fertilisation, copper fungicide.',
  'Petik bubuk, lelesan (ambil buah jatuh), perangkap.':
      'Hand-pick the beetles, collect fallen fruit, use traps.',
  'Drainase baik, bongkar pohon sakit.':
      'Good drainage, dig out diseased trees.',
  'Panen sering, buang buah sakit, pangkas agar tidak terlalu lembap.':
      'Harvest often, remove bad fruit, prune so the canopy stays airy.',
  'Panen sering, sarungisasi buah, pangkas.':
      'Harvest often, bag the fruit, prune.',
  'Pangkas ranting 30 cm di bawah gejala.':
      'Prune 30 cm below the symptomatic branch.',
  'Bongkar akar sakit, beri Trichoderma atau belerang.':
      'Remove the affected roots, apply Trichoderma or sulfur.',
  'Pemupukan cukup, fungisida bila perlu.':
      'Balanced fertilisation, fungicide only if needed.',
  'Istirahatkan sadap, kurangi intensitas.':
      'Rest the tapping panel, lower the tapping frequency.',

  // --------------------------- panduan: aksi masalah (4/4, lanjutan)
  'Sanitasi, bongkar pohon sakit, parit isolasi.':
      'Sanitation, dig out diseased trees, cut an isolation ditch.',
  'Pantau, Bt, musuh alami.': 'Scout, Bt, natural enemies.',
  'Sanitasi tumpukan batang, perangkap feromon.':
      'Clean up stem piles, use pheromone traps.',
  'Sanitasi, musuh alami (parasitoid).':
      'Sanitation, natural enemies (parasitoids).',
  'Cabut rumpun sakit, bibit sehat.':
      'Remove affected clumps, use healthy planting material.',
  'Bibit sehat, drainase baik, rotasi, cabut tanaman sakit.':
      'Healthy seedlings, good drainage, rotation, remove diseased plants.',
  'Sanitasi, jarak tanam longgar.': 'Sanitation, wider plant spacing.',
  'Rotasi, sanitasi lahan.': 'Crop rotation, clean the field.',
  'Sanitasi daun sakit, fungisida bila parah.':
      'Remove diseased leaves, fungicide if severe.',
  'Buang daun terserang.': 'Remove the attacked leaves.',
  'Drainase baik, hindari luka, Trichoderma, cabut tanaman sakit.':
      'Good drainage, avoid wounding, Trichoderma, remove diseased plants.',
  'Bahan organik, bibit sehat.': 'Organic matter, healthy seedlings.',
  'Buang bagian terserang.': 'Remove the attacked parts.',
  'Sanitasi dan jarak tanam longgar.': 'Sanitation and wider plant spacing.',
  'Buang daun sakit, fungisida bila parah.':
      'Remove diseased leaves, fungicide if severe.',
  'Drainase baik.': 'Good drainage.',

  // --------------------------------------- panduan: perawatan (1/6)
  'Pasang mulsa plastik untuk menekan gulma dan menjaga kelembapan.':
      'Lay plastic mulch to suppress weeds and hold in moisture.',
  'Pasang ajir dan ikat batang saat tanaman mulai tinggi.':
      'Put in stakes and tie the stems as the plants grow tall.',
  'Siram pagi atau sore, kurangi saat hujan deras.':
      'Water in the morning or evening; cut back during heavy rain.',
  'Pangkas tunas air di bawah percabangan pertama agar buah lebih banyak.':
      'Prune the water shoots below the first fork so the tree sets more fruit.',
  'Pasang ajir lalu ikat batang secara berkala.':
      'Put in stakes, then tie the stems regularly.',
  'Wiwil (buang) tunas air agar tanaman fokus berbuah.':
      'Pinch off the side shoots so the plant focuses on fruiting.',
  'Gunakan mulsa agar buah bersih dan kelembapan stabil.':
      'Use mulch so the fruit stays clean and moisture stays steady.',
  'Siram teratur; fluktuasi air memicu buah pecah.':
      'Water regularly; uneven watering makes the fruit split.',
  'Pakai umbi bibit yang sudah cukup tua (2 sampai 3 bulan setelah panen).':
      'Use seed tubers that have aged 2 to 3 months after harvest.',
  'Siram teratur di awal, kurangi saat umbi membesar.':
      'Water regularly early on, then reduce it as the tubers swell.',
  'Bersihkan gulma pada umur 2 dan 4 minggu.':
      'Clear the weeds at 2 and 4 weeks after planting.',
  'Buat bedengan tinggi dengan parit agar air tidak menggenang.':
      'Build tall beds with drains so water never stands.',
  'Pakai bibit bersertifikat (G3 atau G4).':
      'Use certified seed potatoes (grade G3 or G4).',
  'Lakukan pembumbunan 2 kali agar umbi tidak terkena sinar (menghijau).':
      'Hill up twice so the tubers stay out of the light and do not turn green.',
  'Pastikan drainase baik; genangan memicu busuk.':
      'Make sure drainage is good; standing water causes rot.',

  // --------------------------------------- panduan: perawatan (2/6)
  'Pantau cuaca lembap dan dingin; semprot pencegahan bila perlu.':
      'Watch for cool, humid weather; spray preventively if needed.',
  'Semai 3 sampai 4 minggu lalu pindah tanam.':
      'Sow in a nursery for 3 to 4 weeks, then transplant.',
  'Bersihkan gulma dan lakukan pembumbunan.':
      'Clear the weeds and hill up the soil.',
  'Siram teratur; kekurangan air membuat krop kecil.':
      'Water regularly; a shortage of water gives small heads.',
  'Pantau ulat sejak awal dan rutin periksa bagian bawah daun.':
      'Scout for caterpillars from the start and check under the leaves often.',
  'Olah tanah dalam dan halus agar umbi lurus.':
      'Till the soil deep and fine so the tubers grow straight.',
  'Jarangkan tanaman umur 2 sampai 3 minggu.':
      'Thin the plants at 2 to 3 weeks old.',
  'Bumbun agar bahu umbi tertutup (tidak menghijau).':
      'Hill up so the shoulder of the tuber is covered and stays green-free.',
  'Siram teratur tanpa menggenang.': 'Water regularly without waterlogging.',
  'Semai 7 sampai 10 hari lalu pindah tanam.':
      'Sow for 7 to 10 days, then transplant.',
  'Siram pagi dan sore, tanpa membuat tanah becek.':
      'Water morning and evening, but do not leave the soil soggy.',
  'Bersihkan gulma pada 2 minggu pertama.':
      'Clear the weeds during the first two weeks.',
  'Tutup bedengan dengan jaring bila ulat banyak.':
      'Cover the beds with netting if caterpillars are plentiful.',
  'Pasang ajir agar batang tidak rebah.':
      'Put in stakes so the stems do not fall over.',
  'Pangkas tunas yang tidak produktif.': 'Prune the unproductive shoots.',

  // --------------------------------------- panduan: perawatan (3/6)
  'Mulsa untuk menjaga kelembapan.': 'Mulch to hold in moisture.',
  'Panen rutin agar tanaman terus berbuah.':
      'Harvest regularly so the plant keeps fruiting.',
  'Pasang lanjaran agar buah bersih dan lurus.':
      'Set up trellis poles so the fruit stays clean and straight.',
  'Mulsa untuk menjaga kelembapan dan menekan gulma.':
      'Mulch to hold in moisture and suppress weeds.',
  'Siram teratur, hindari menyiram saat bunga mekar.':
      'Water regularly, but avoid watering while the flowers are open.',
  'Panen rutin sebelum buah terlalu tua.':
      'Harvest regularly before the fruit gets over-mature.',
  'Pasang lanjaran sejak umur 2 minggu.':
      'Set up trellis poles from two weeks after planting.',
  'Siram teratur terutama saat berbunga.':
      'Water regularly, especially while flowering.',
  'Petik polong muda secara rutin agar produksi berlanjut.':
      'Pick the young pods regularly so production continues.',
  'Tanam serempak dengan petani sekitar untuk menekan hama.':
      'Plant at the same time as neighbouring farmers to hold pests down.',
  'Lakukan penyiangan dan pembumbunan pada 2 sampai 4 minggu.':
      'Weed and hill up between weeks 2 and 4.',
  'Pastikan air cukup saat bunga jantan dan betina muncul.':
      'Keep enough water flowing when the male and female flowers appear.',
  'Pupuk nitrogen diberikan bertahap, bukan sekaligus.':
      'Split the nitrogen doses instead of applying it all at once.',
  'Gunakan benih bersertifikat dan rendam sebelum semai.':
      'Use certified seed and soak it before sowing.',
  'Atur air: macak-macak awal, tergenang tipis saat anakan, keringkan menjelang panen.':
      'Manage the water: moist at the start, a thin film during tillering, drained before harvest.',

  // --------------------------------------- panduan: perawatan (4/6)
  'Siang gulma pada 3 dan 6 minggu setelah tanam.':
      'Weed at 3 and 6 weeks after planting.',
  'Pantau hama dan penyakit tiap pekan.':
      'Scout for pests and diseases every week.',
  'Siang gulma pada 14 dan 30 hari.': 'Weed at 14 and 30 days.',
  'Buat parit drainase agar tidak tergenang.':
      'Dig drainage channels so the plot never floods.',
  'Bumbun saat 30 hari agar ginofor mudah menembus tanah.':
      'Hill up at 30 days so the pegs can enter the soil easily.',
  'Jaga tanah tetap gembur.': 'Keep the soil loose.',
  'Siang gulma secara hati-hati agar tidak melukai ginofor.':
      'Weed carefully so the pegs are not damaged.',
  'Gunakan stek pucuk sepanjang 25 sampai 30 cm.':
      'Use tip cuttings 25 to 30 cm long.',
  'Buat guludan agar umbi mudah membesar dan dipanen.':
      'Form ridges so the tubers swell and lift easily.',
  'Tutup retakan tanah agar boleng sulit masuk.':
      'Close the cracks in the soil so the tuber moth cannot get in.',
  'Gunakan stek batang sehat 20 sampai 25 cm, 5 sampai 7 ruas.':
      'Use healthy stem cuttings 20 to 25 cm long with 5 to 7 nodes.',
  'Siang gulma pada 1 dan 2 bulan.': 'Weed at 1 and 2 months.',
  'Tumpangsari dengan kacang-kacangan menambah pendapatan.':
      'Intercropping with legumes adds income.',
  'Gunakan mulsa plastik hitam-perak.': 'Use black-and-silver plastic mulch.',
  'Sisakan 1 sampai 2 buah per tanaman.': 'Leave 1 to 2 fruit per plant.',

  // --------------------------------------- panduan: perawatan (5/6)
  'Alasi buah dengan jerami agar tidak busuk.':
      'Prop the fruit on straw so it does not rot.',
  'Atur sulur agar tidak kusut.': 'Train the vines so they do not tangle.',
  'Budidaya di rumah plastik meningkatkan kualitas.':
      'Growing under plastic raises quality.',
  'Wiwil tunas samping hingga ruas 8 sampai 10.':
      'Remove side shoots up to node 8 to 10.',
  'Seleksi 1 buah per tanaman.': 'Keep only one fruit per plant.',
  'Kurangi air saat buah mulai membentuk jaring.':
      'Cut the water back once the fruit starts to net.',
  'Tanam 2 sampai 3 bibit per lubang, pertahankan yang betina atau hermafrodit.':
      'Plant 2 to 3 seedlings per hole and keep the female or hermaphrodite ones.',
  'Siang gulma di sekitar batang.': 'Weed around the stem.',
  'Pastikan tanah tidak menggenang.': 'Make sure the soil never floods.',
  'Sisakan 2 sampai 3 anakan per rumpun.': 'Leave 2 to 3 tillers per clump.',
  'Buang daun kering dan sanitasi rumpun.':
      'Remove dry leaves and keep the clump clean.',
  'Bungkus tandan dan beri penyangga agar tidak rebah.':
      'Bag the bunch and prop it up so it does not fall.',
  'Gunakan mahkota atau tunas sehat sebagai bibit.':
      'Use the crown or a healthy sucker as planting material.',
  'Mulsa menekan gulma dan menjaga kelembapan.':
      'Mulch suppresses weeds and holds in moisture.',
  'Induksi pembungaan agar panen serempak.':
      'Induce flowering so the harvest comes at once.',

  // --------------------------------------- panduan: perawatan (6/6)
  'Pangkas bentuk dan produksi secara teratur.':
      'Prune for shape and for cropping on a regular basis.',
  'Jaga pohon naungan agar mutu dan kelembapan terjaga.':
      'Keep shade trees so quality and moisture are held.',
  'Beri mulsa di sekitar pohon.': 'Mulch around the tree.',
  'Lakukan sanitasi buah dan ranting sakit.':
      'Remove diseased fruit and twigs to keep the plot clean.',
  'Pangkas dan atur naungan.': 'Prune and manage the shade.',
  'Sanitasi buah busuk dan kulit buah.':
      'Clean out rotten fruit and discard the pod husks.',
  'Fermentasi biji 5 sampai 6 hari untuk mutu dan harga lebih baik.':
      'Ferment the beans for 5 to 6 days for better quality and price.',
  'Sadap pagi (sekitar 05.00 sampai 07.00) dengan kemiringan 30 sampai 40 derajat.':
      'Tap in the morning (around 05.00 to 07.00) at a 30 to 40 degree slope.',
  'Jangan menyadap terlalu dalam.': 'Do not tap too deeply.',
  'Jaga kebersihan piringan dan mutu lateks.':
      'Keep the tapping panel clean and the latex good.',
  'Pangkas pelepah songgo dua.':
      'Prune the two petioles that sit opposite the bunch.',
  'Jaga piringan bersih dan jalan panen.':
      'Keep the weeding ring clean and the harvest path open.',
  'Rawat parit dan drainase.': 'Maintain the ditches and drainage.',
  'Gunakan bibit bagal 2 sampai 3 mata.': 'Use setts with 2 to 3 buds.',
  'Kletek (buang daun kering) untuk mengurangi hama.':
      'Remove the dried leaves to cut down on pests.',

  // ------------------------------- panduan: perawatan (tambahan 1/2)
  'Lakukan keprasan 2 sampai 3 kali untuk menghemat bibit.':
      'Prune the nursery canes 2 to 3 times to save planting material.',
  'Pakai rimpang bibit 2 sampai 3 mata tunas, sekitar 25 sampai 40 g.':
      'Use seed rhizomes with 2 to 3 buds, about 25 to 40 g each.',
  'Beri mulsa jerami dan lakukan pembumbunan.':
      'Mulch with straw and hill up the soil.',
  'Beri naungan ringan pada awal pertumbuhan.':
      'Provide light shade in the early growth stage.',
  'Beri mulsa jerami agar tanah lembap.':
      'Mulch with straw so the soil stays moist.',
  'Lakukan pembumbunan saat tanaman berumur 2 sampai 3 bulan.':
      'Hill up when the plants are 2 to 3 months old.',
  'Cocok di antara pohon buah dengan naungan ringan.':
      'Suits the space between fruit trees under light shade.',
  'Pasang tiang panjat dan ikat sulur.':
      'Set up climbing poles and tie the vines to them.',
  'Pangkas sulur cacing agar produksi meningkat.':
      'Prune the non-fruiting shoots so yields rise.',
  'Beri mulsa untuk menjaga kelembapan.': 'Mulch to hold in moisture.',
  'Tanam anakan rumpun yang sehat.': 'Plant tillers taken from healthy clumps.',
  'Panen pertama 4 sampai 6 bulan, berikutnya tiap 3 sampai 4 bulan.':
      'First harvest at 4 to 6 months, then every 3 to 4 months.',
  'Sulingkan segera setelah panen untuk mutu minyak.':
      'Distil right after harvest so the oil quality stays high.',

  // ------------------------------- data: tips budidaya (tambahan)
  'Atur jadwal tanam bertahap agar panen tidak menumpuk di satu waktu.':
      'Stagger the planting dates so the harvest does not pile up at one time.',
  'Panen pada tingkat kematangan yang tepat agar tahan saat dikirim.':
      'Harvest at the right ripeness so it survives transport.',
  'Tanaman tahunan: angka simulasi dihitung per tahun panen produktif.':
      'Perennial crop: the simulated figures are per productive harvest year.',
  'Jaga kebersihan dan pengeringan agar mutu simplisia terjaga.':
      'Keep the crop clean and dry so the dried-medicine quality holds up.',
  'Fermentasi biji kakao meningkatkan mutu dan harga jual.':
      'Fermenting the cocoa beans raises both quality and selling price.',
  'Pangkas rutin dan kendalikan penggerek buah kakao.':
      'Prune regularly and control the cocoa pod borer.',

  // ── templat tersusun (tpl) ──
  'Selamat pagi': 'Good morning',
  'Selamat siang': 'Good afternoon',
  'Selamat sore': 'Good afternoon',
  'Selamat malam': 'Good evening',
  ' • terlewat': ' • overdue',
  'Perkiraan panen {0} ({1} hari setelah tanam)':
      'Expected harvest {0} ({1} days after planting)',
  'Rencana {0} dihapus': '{0} plan deleted',
  'Tanam {0} • panen ± {1}': 'Planted {0} • harvest ± {1}',
  'Tanggal tanam: {0}': 'Planting date: {0}',
  '{0} hari lagi': 'In {0} days',
  'Terdekat: {0}': 'Next up: {0}',
  '{0} kerja hari ini • dipandu suara': '{0} tasks today • voice-guided',
  '{0} kerja terlewat • dipandu suara': '{0} overdue tasks • voice-guided',
  'Kurang {0}': 'Short by {0}',
  'Modal Anda masih kurang {0} untuk skala ini. Perkecil luas tanam atau tambah modal.':
      'Your capital is still {0} short for this scale. Reduce the planted area or add capital.',
  'Peringkat #{0}': 'Rank #{0}',
  '{0} dijadikan komoditas aktif.': '{0} is now the active crop.',
  'Selesai. Kerja ladang hari ini {0} langkah.':
      'Done. Today\'s field work: {0} steps.',
  'Sisa {0} kerja': '{0} tasks left',
  'Suara Indonesia aktif{0}': 'Indonesian voice active{0}',
  'Suara Inggris aktif{0}': 'English voice active{0}',
  'Tugas {0} dari {1}': 'Task {0} of {1}',
  '{0} kerja ladang tercatat selesai': '{0} field tasks marked done',
  '{0} • hari ke-{1} dari {2}': '{0} • day {1} of {2}',
  ', hari ke {0}': ', day {0}',
  '{0}, untuk {1}{2}.': '{0}, for {1}{2}.',
  'Perhatian: {0}': 'Caution: {0}',
  'Besok': 'Tomorrow',
  'Terlewat 1 hari': '1 day overdue',
  'Terlewat {0} hari': '{0} days overdue',
  'Sesuaikan kerja dengan cuaca {0}': 'Adjust work to {0} weather',
  'Beri pupuk di samping barisan, sekitar sepuluh sentimeter dari batang, jangan menempel ke pangkal. Timbun tipis dan siram agar larut perlahan. {0} paling butuh pada fase tumbuh cepat ini.':
      'Apply fertilizer beside the row, about ten centimeters from the stem, never touching the base. Cover it lightly and water so it dissolves slowly. {0} needs it most in this fast-growth phase.',
  'Jalani barisan tanaman {0} dan periksa sepuluh titik acak: warna daun, lubang bekas gigit, dan kelembapan tanah sedalam dua sentimeter. Catat yang aneh di panduan hama agar saran berikutnya tepat.':
      'Walk the {0} rows and check ten random spots: leaf color, bite holes, and soil moisture two centimeters deep. Note anything odd in the pest guide so the next advice is accurate.',
  'Lakukan {0} sesuai jadwal kalender tanam Anda, kemudian catat hasilnya agar jadwal berikutnya makin akurat.':
      'Do the {0} step on your planting calendar schedule, then record the result so the next schedule is more accurate.',
  'Panas terik {0} derajat. Tanam sore dan pasang teduhan sementara selama tiga hari pertama.':
      'Scorching heat, {0} degrees. Plant in the late afternoon and put up temporary shade for the first three days.',
  'Peluang hujan {0} persen. Panen lebih pagi, siapkan terpal pengering, dan jangan simpan hasil basah di karung tertutup.':
      'Chance of rain {0} percent. Harvest earlier, prepare a drying tarp, and never store wet produce in closed sacks.',
  'Peluang hujan {0} persen. Pupuk akan larut terbawa air sebelum akar sempat menyerap; lebih baik setelah hujan reda.':
      'Chance of rain {0} percent. Fertilizer will wash away before the roots can absorb it; better after the rain stops.',
  'Suhu {0} derajat. Siram bedengan dulu agar pupuk tidak membakar akar, dan kerjakan sebelum jam tujuh pagi.':
      'Temperature {0} degrees. Water the beds first so the fertilizer does not burn the roots, and finish before seven in the morning.',
  'Catatan "{0}" dihapus': 'Entry "{0}" deleted',
  '{0} · {1}': '{0} · {1}',
  'Catat {0}': 'Record {0}',
  'Tanggal: {0}': 'Date: {0}',
  '{0} komoditas memakai harga catatan Anda; sisanya simulasi.':
      '{0} crops use your recorded prices; the rest are simulated.',
  '{0} komoditas memakai harga catatan Anda; sisanya masih contoh di Supabase.':
      '{0} crops use your recorded prices; the rest are still placeholders in Supabase.',
  '{0} komoditas memakai harga catatan Anda; {1} lainnya harga pasar nyata dari Supabase.':
      '{0} crops use your recorded prices; {1} more are real market prices from Supabase.',
  '{0} komoditas memakai harga pasar nyata dari Supabase; sisanya masih simulasi.':
      '{0} crops use real market prices from Supabase; the rest are still simulated.',
  'Semua angka dari Supabase masih contoh, belum harga pasar nyata — tarik ke bawah untuk menyegarkan.':
      'Every figure from Supabase is still a placeholder, not a real market price — pull down to refresh.',
  'masih simulasi': 'still simulated',
  'simulasi harian · {0}': 'daily simulation · {0}',
  'Gabah memakai HPP pemerintah (acuan), bukan harga pasar harian.':
      'Paddy uses the government purchase price (reference), not a daily market price.',
  'Sebab harga Supabase belum terpakai: {0}':
      'Why the Supabase prices are not used yet: {0}',
  'Ubah harga catatan — {0} sudah diisi':
      'Edit recorded price — {0} already entered',
  'Harga {0} (Rp/kg)': '{0} price (Rp/kg)',
  'Indeks Permintaan {0}': '{0} demand index',
  'Saat ini: {0} ({1}/100)': 'Currently: {0} ({1}/100)',
  'Indeks {0} / 100': 'Index {0} / 100',
  'Simulasi hari ini: {0}/kg': 'Today\'s simulation: {0}/kg',
  '{0}/kg • sedang dipilih': '{0}/kg • currently selected',
  'Harga {0} {1} {2}': '{0} price {1} {2}',
  'Sekarang {0}/kg. Pertimbangkan waktu panen/jual.':
      'Now {0}/kg. Consider when to harvest or sell.',
  'Sekarang {0}/kg. Tahan dulu jika memungkinkan.':
      'Now {0}/kg. Hold off if possible.',
  'Rekomendasi hari ini: {0}': 'Today\'s recommendation: {0}',
  'Proyeksi margin {0} untuk lahan {1} m².':
      'Projected margin {0} for {1} m² of land.',
  'Simulasi {0}': '{0} simulation',
  '{0} • {1} • {2}': '{0} • {1} • {2}',
  '{0} komoditas memakai harga Anda': '{0} crops use your prices',
  '{0} hama/penyakit umum pada {1} Anda — ketuk untuk menyaring.':
      '{0} common pests/diseases affecting your {1} — tap to filter.',
  'Untuk {0} m² • {1} • {2} • Tujuan: {3}':
      'For {0} m² • {1} • {2} • Goal: {3}',
  'Cuaca nyata dari Open-Meteo, diperbarui {0}.':
      'Live weather from Open-Meteo, updated at {0}.',
  '{0}. Periksa koneksi untuk memperbarui.':
      '{0}. Check your connection to update.',
  'Peluang hujan {0}% nanti — siapkan penutup untuk hasil panen yang sedang dijemur.':
      '{0}% chance of rain later — prepare covers for harvested crops drying in the sun.',
  'batas {0}% lahan per tanaman yang menahan':
      'the {0}% land limit per crop is the limiting factor',
  'Cocok untuk lahan {0} m²': 'Suitable for {0} m² of land',
  'Modal hanya cukup untuk {0} m²': 'Capital only covers {0} m²',
  '{0}  •  pH {1} sampai {2}': '{0}  •  pH {1} to {2}',
  '{0} tahun': '{0} years',
  '{0} hari': '{0} days',
  'Belum ada kombinasi: {0}.': 'No combination yet: {0}.',
  '{0} dipilih': '{0} selected',
  '{0} tanaman': '{0} crops',
  'Total direncanakan {0} m²': 'Total planned: {0} m²',
  '{0}% lahan': '{0}% of land',
  'Melebar jadi {0}% agar lahan terpakai penuh.':
      'Widened to {0}% so all land is used.',
  'Biaya {0}/m²': 'Cost {0}/m²',
  '{0} tanaman optimal': '{0} optimal crops',
  'Batas yang paling menekan: {0}.': 'The main limiting factor: {0}.',
  'Harga hari ini. Satu tanaman maksimal {0}% lahan.':
      "Today's prices. One crop at most {0}% of the land.",
  '{0} tanaman gabungan': '{0} combined crops',
  'Margin {0}': 'Margin {0}',
  '{0} m² · margin {1}/m²': '{0} m² · {1}/m² margin',
  'Pemasukan': 'Income',
  'Pengeluaran': 'Expenses',
  'Harga Pasar': 'Market prices',
  '7H': '7D',
  '1B': '1M',
  '3B': '3M',
  '6B': '6M',
  '1T': '1Y',
  'naik': 'rose',
  'turun': 'fell',
  'belum dipilih': 'not selected',
  'pilihan Anda': 'your selection',
  'deteksi otomatis': 'automatic detection',
  'cuaca belum dimuat': 'weather not loaded',
  'cuaca nyata dari Open-Meteo': 'live weather from Open-Meteo',
  'belum terhubung, pakai simulasi': 'not connected, using simulation',
  'Pencegahan': 'Prevention',
  'Masuk': 'Sign in',
  '{0} sampai {1}': '{0} to {1}',
  '{0} sampai {1} {2}': '{0} to {1} {2}',
  'Bulan ini ({0}) adalah waktu terbaik untuk menanam.':
      'This month ({0}) is the best time to plant.',
  'Bulan ini kurang cocok untuk menanam. Waktu terbaik: {0}.':
      'This month is less suitable for planting. Best time: {0}.',
  'Luas {0} m² = {1} ha{2}': 'Area {0} m² = {1} ha{2}',
  '  •  sekitar {0} pohon': '  •  about {0} trees',
  '  •  bila diperlukan': '  •  if needed',
  '  •  sekitar {0} karung @50 kg': '  •  about {0} sacks of 50 kg',
  '60 × 50 cm': '60 × 50 cm',
  '20 × 15 cm': '20 × 15 cm',
  '70 × 30 cm': '70 × 30 cm',
  '20 × 20 cm': '20 × 20 cm',
  '70 × 60 cm': '70 × 60 cm',
  '100 × 80 cm': '100 × 80 cm',
  '2 × 2 m': '2 × 2 m',
  '60 × 30 × 30 cm (zig-zag)': '60 × 30 × 30 cm (zig-zag)',
  '3 × 3 m': '3 × 3 m',
  '40 × 30 cm': '40 × 30 cm',
  '50 × 40 cm': '50 × 40 cm',
  '100 × 50 cm': '100 × 50 cm',
  'NPK 16-16-16': 'NPK 16-16-16',
  'NPK 15-15-15': 'NPK 15-15-15',
  'KCl': 'KCl',
  'Urea': 'Urea',
  'SP-36': 'SP-36',
  'Urea / NPK': 'Urea / NPK',
  'NPK / Urea': 'NPK / Urea',
  'Urea / ZA': 'Urea / ZA',
  'ZA': 'ZA',
  'NPK': 'NPK',

  // ---- kelompok 10 tanaman baru (foto asli Wikimedia Commons)
  '0 sampai 1.500 mdpl': '0 to 1,500 m asl',
  '0,5 sampai 1,5 kg per pohon per tahun sesuai umur.': '0.5 to 1.5 kg per tree per year depending on age.',
  '1 sampai 2 kg per pohon per tahun, dibagi dua kali.': '1 to 2 kg per tree per year, split into two applications.',
  '1 sampai 3 kg per pohon per tahun sesuai umur.': '1 to 3 kg per tree per year depending on age.',
  '10 × 10 m': '10 × 10 m',
  '10 × 12 m': '10 × 12 m',
  '100 sampai 150 kg per ha sebagai susulan setelah ratun.': '100 to 150 kg per ha as a top dressing after ratoon.',
  '100 sampai 200 g per tanaman per tahun.': '100 to 200 g per plant per year.',
  '100 sampai 200 kg per ha sekali saat tunas tumbuh.': '100 to 200 kg per ha, once when shoots emerge.',
  '100 × 100 cm': '100 × 100 cm',
  '15 sampai 25 ton per ha sebagai pupuk dasar.': '15 to 25 tonnes per ha as basal fertiliser.',
  '150 sampai 250 kg per ha, dibagi dua kali.': '150 to 250 kg per ha, split into two applications.',
  '20 sampai 30 kg per pohon per tahun.': '20 to 30 kg per tree per year.',
  '20 sampai 40 kg per pohon per tahun.': '20 to 40 kg per tree per year.',
  '20 × 15 cm atau sebar rata': '20 × 15 cm or broadcast evenly',
  '200 sampai 300 kg per ha, dibagi dua kali pemberian.': '200 to 300 kg per ha, split into two applications.',
  '200 × 150 cm dengan tiang panjat': '200 × 150 cm with a support post',
  '200 × 200 cm atau rapat 100 × 100 cm': '200 × 200 cm, or 100 × 100 cm for close spacing',
  '30 sampai 50 kg per pohon per tahun.': '30 to 50 kg per tree per year.',
  '300 sampai 1.500 mdpl': '300 to 1,500 m asl',
  '5 sampai 10 kg per tanaman per tahun.': '5 to 10 kg per plant per year.',
  '50 sampai 100 g per tanaman per tahun.': '50 to 100 g per plant per year.',
  '50 sampai 100 kg per ha setelah tiap panen potong.': '50 to 100 kg per ha after each cut harvest.',
  '500 sampai 1.500 mdpl': '500 to 1,500 m asl',
  '70 × 20 cm': '70 × 20 cm',
  '70 × 20 cm (merambat) atau 50 × 20 cm (tegak)': '70 × 20 cm (climbing) or 50 × 20 cm (bush)',
  '700 sampai 1.200 mdpl': '700 to 1,200 m asl',
  '80 sampai 120 kg per ha saat pembentukan umbi.': '80 to 120 kg per ha during bulb formation.',
  'Alpukat': 'Avocado',
  'Ambil manual, insektisida nabati.': 'Hand-pick, use botanical insecticides.',
  'Ambil manual, sanitasi lahan, insektisida bila parah.': 'Hand-pick, keep the field clean, insecticide if severe.',
  'Bantu penyerbukan dengan kuas pada malam hari.': 'Help pollination with a brush at night.',
  'Bantu penyerbukan pada malam hari agar buah lebih banyak.': 'Hand-pollinate at night to set more fruit.',
  'Banyak dan merata; musim kering pendek memicu bunga.': 'High and even; a short dry season triggers flowering.',
  'Banyak; jaga tanah selalu lembap.': 'High; keep the soil constantly moist.',
  'Batang lembek dan tanaman rebah.': 'Soft stems and lodging plants.',
  'Batang menguning lalu lembek.': 'Stems yellow then turn soft.',
  'Belalang': 'Grasshoppers',
  'Benih sehat, rotasi tanaman.': 'Healthy seed, crop rotation.',
  'Bercak cokelat berair pada kulit buah.': 'Watery brown spots on the fruit skin.',
  'Bercak cokelat pada helaian daun.': 'Brown spots on the leaf blade.',
  'Bercak cokelat pada polong dan biji.': 'Brown spots on pods and seeds.',
  'Bercak hitam pada daun, bunga, dan buah.': 'Black spots on leaves, flowers and fruit.',
  'Bercak kasar pada kulit buah dan daun.': 'Rough scabs on fruit skin and leaves.',
  'Bercak keunguan pada daun, daun mengering.': 'Purple spots on leaves, leaves dry out.',
  'Bercak pada daun dan sulur.': 'Spots on leaves and tendrils.',
  'Beri mulsa daun kering untuk menjaga kelembapan tanah.': 'Mulch with dry leaves to hold soil moisture.',
  'Beri mulsa tebal di sekitar perakaran dangkal.': 'Mulch thickly around the shallow root zone.',
  'Bersihkan gulma dengan hati-hati karena akar dangkal.': 'Weed carefully because the roots are shallow.',
  'Biarkan tunas ratun tumbuh untuk panen kedua tanpa tanam ulang.': 'Let ratoon shoots grow for a second harvest without replanting.',
  'Bintik cokelat kemerahan pada daun.': 'Reddish-brown pustules on leaves.',
  'Bintik oranye di bawah daun.': 'Orange pustules under the leaves.',
  'Bintik putih di bawah daun.': 'White spots under the leaves.',
  'Bisa ditanam sepanjang tahun asal air tersedia.': 'Can be planted all year round as long as water is available.',
  'Buah berlubang dan gugur muda.': 'Fruit with holes that drop early.',
  'Buang daun sakit, rotasi.': 'Remove diseased leaves, rotate crops.',
  'Buncis': 'Green Bean',
  'Bungkus buah muda dengan kertas agar kulit mulus bebas bercak.': 'Bag young fruit with paper for smooth, spot-free skin.',
  'Bungkus buah muda dengan kertas untuk kulit yang mulus.': 'Bag young fruit with paper for a smooth skin.',
  'Busuk akar Phytophthora': 'Phytophthora root rot',
  'Busuk batang': 'Stem rot',
  'Busuk batang Diplodia': 'Diplodia stem rot',
  'Busuk batang Fusarium': 'Fusarium stem rot',
  'Busuk buah': 'Fruit rot',
  'Busuk pangkal Phytophthora': 'Phytophthora collar rot',
  'Busuk polong': 'Pod rot',
  'Busuk umbi': 'Corm rot',
  'Cabut tanaman sakit, rotasi minimal 2 tahun.': 'Pull out diseased plants, rotate for at least 2 years.',
  'Campur tipe bunga A dan B agar penyerbukan lebih baik.': 'Mix flower type A and B trees for better pollination.',
  'Curing bertahap menentukan harga; jangan terburu-buru.': 'Step-by-step curing sets the price; do not rush it.',
  'Daun berlubang besar.': 'Large holes in the leaves.',
  'Daun berlubang dan tergulung.': 'Holed and rolled leaves.',
  'Daun berlubang dan terlipat.': 'Holed and folded leaves.',
  'Daun berlubang tidak beraturan.': 'Irregular holes in the leaves.',
  'Daun habis dimakan saat muda.': 'Leaves eaten bare while young.',
  'Daun menguning dan layu, akar cokelat.': 'Yellowing wilting leaves, brown roots.',
  'Daun menguning dan tanaman kerdil.': 'Yellowing leaves and stunted plants.',
  'Daun menguning dari ujung, umbi busuk.': 'Leaves yellow from the tip, bulbs rot.',
  'Drainase baik, bibit bebas penyakit, hindari genangan.': 'Good drainage, disease-free seedlings, avoid waterlogging.',
  'Drainase baik, bibit sehat, cabut tanaman sakit.': 'Good drainage, healthy seedlings, pull out diseased plants.',
  'Drainase baik, rotasi.': 'Good drainage, crop rotation.',
  'Drainase baik, sanitasi.': 'Good drainage, sanitation.',
  'Drainase, sanitasi, fungisida sistemik.': 'Drainage, sanitation, systemic fungicide.',
  'Durian': 'Durian',
  'Gembur, kaya bahan organik, di bawah naungan.': 'Friable, rich in organic matter, under shade.',
  'Gembur, kaya bahan organik, drainase baik, di bawah naungan.': 'Friable, rich in organic matter, well drained, under shade.',
  'Getah dan luka cokelat pada pangkal batang.': 'Gumming and brown lesions at the trunk base.',
  'Gunakan bibit okulasi varietas unggul agar berbuah lebih cepat.': 'Use grafted seedlings of superior varieties for earlier fruiting.',
  'Gunakan bibit okulasi varietas unggul agar cepat berbuah.': 'Use grafted seedlings of superior varieties to fruit sooner.',
  'Hampir semua tanah; subur dan lembap lebih baik.': 'Almost any soil; fertile and moist is better.',
  'Harga sangat berfluktuasi; pastikan pembeli sebelum menanam luas.': 'Prices swing wildly; secure a buyer before planting at scale.',
  'Hindari bekerja di kebun saat daun basah untuk menekan penyakit.': 'Avoid working in the field while leaves are wet to suppress disease.',
  'Jaga drainase; akar mangga tidak tahan genangan lama.': 'Keep drainage good; mango roots cannot stand long waterlogging.',
  'Jaga kelembapan, buang polong sakit.': 'Keep humidity in check, remove diseased pods.',
  'Jaga tanah tetap lembap; kangkung darat tetap butuh air banyak.': 'Keep the soil moist; upland water spinach still needs plenty of water.',
  'Jarangkan buah muda agar ukuran dan mutu terjaga.': 'Thin young fruit to keep size and quality up.',
  'Jemur biji sampai kadar air di bawah 12 persen sebelum disimpan.': 'Sun-dry the grain to below 12 percent moisture before storing.',
  'Jemur gulungan kulit perlahan untuk warna dan aroma terbaik.': 'Dry the bark quills slowly for the best colour and aroma.',
  'Jemur malai segera setelah panen untuk mencegah jamur.': 'Sun-dry the panicles right after harvest to prevent mould.',
  'Kangkung': 'Water Spinach',
  'Karat putih': 'White rust',
  'Kayu Manis': 'Cinnamon',
  'Kerak buah (scab)': 'Fruit scab',
  'Kumpulkan katak (umbi bibit) dari daun untuk bibit musim depan.': 'Collect the bulbils from the leaves as planting stock for next season.',
  'Kupas kulit segera setelah tebang agar tidak menghitam.': 'Peel the bark right after felling so it does not blacken.',
  'Lalat bibit': 'Seedling flies',
  'Lalat buah': 'Fruit flies',
  'Layu Fusarium': 'Fusarium wilt',
  'Lempung berpasir sampai liat, subur, drainase baik.': 'Sandy loam to clay, fertile, well drained.',
  'Lempung berpasir, gembur, bahan organik tinggi, drainase baik.': 'Sandy loam, friable, high in organic matter, well drained.',
  'Lempung dalam, drainase baik, tidak tergenang.': 'Deep loam, well drained, never waterlogged.',
  'Lempung dalam, drainase sangat baik; tidak tahan akar tergenang.': 'Deep loam with excellent drainage; roots cannot stand waterlogging.',
  'Lempung dalam, subur, drainase baik; tidak tahan genangan.': 'Deep, fertile, well-drained loam; cannot stand waterlogging.',
  'Lempung gembur, drainase baik.': 'Friable loam, well drained.',
  'Lilitkan sulur pada tiang agar mudah diserbuki dan dipanen.': 'Wind the vines around the post for easy pollination and harvest.',
  'Lubang dan serbuk kayu pada batang.': 'Holes and frass on the trunk.',
  'Lubang pada batang muda.': 'Holes in young stems.',
  'Lubang pada kecambah dan batang muda.': 'Holes in seedlings and young stems.',
  'Luka berlendir dan getah pada batang.': 'Slimy, oozing wounds on the trunk.',
  'Mangga': 'Mango',
  'Naungan 50 sampai 70 persen menjaga kelembapan tanaman.': '50 to 70 percent shade keeps the plants humid.',
  'Panen 100 sampai 120 hari setelah tanam saat biji keras dan malai cokelat. Jemur sampai kadar air di bawah 12 persen.': 'Harvest 100 to 120 days after planting when the grain is hard and the panicle brown. Sun-dry to below 12 percent moisture.',
  'Panen 100 sampai 130 hari setelah berbunga tergantung varietas; buah matang jatuh sendiri, jadi panen tepat waktu atau pasang jaring.': 'Harvest 100 to 130 days after flowering depending on variety; ripe fruit drops on its own, so pick on time or hang nets.',
  'Panen 45 sampai 55 hari setelah tanam; petik polong muda tiap 2 sampai 3 hari sekali.': 'Harvest 45 to 55 days after planting; pick young pods every 2 to 3 days.',
  'Panen 8 sampai 10 bulan setelah berbunga; ciri tangkai menguning dan kulit kusam. Matangkan pada suhu ruang 5 sampai 7 hari.': 'Harvest 8 to 10 months after flowering; the stalk yellows and the skin dulls. Ripen at room temperature for 5 to 7 days.',
  'Panen 8 sampai 10 bulan setelah tanam saat daun menguning dan rebah (dormansi). Gali hati-hati agar umbi tidak luka.': 'Harvest 8 to 10 months after planting when leaves yellow and collapse (dormancy). Dig carefully so the corm is not wounded.',
  'Panen 8 sampai 9 bulan setelah penyerbukan saat ujung polong menguning. Lanjutkan curing 3 sampai 6 bulan hingga hitam beraroma.': 'Harvest 8 to 9 months after pollination when the pod tip yellows. Then cure for 3 to 6 months until black and fragrant.',
  'Panen 90 sampai 120 hari setelah berbunga tergantung varietas; petik matang pohon dengan menyisakan tangkai 5 sampai 10 cm.': 'Harvest 90 to 120 days after flowering depending on variety; pick tree-ripe, leaving a 5 to 10 cm stalk.',
  'Panen 90 sampai 120 hari setelah tanam saat 60 persen daun menguning dan rebah. Angkat umbi, ikat, lalu keringkan 2 sampai 3 minggu.': 'Harvest 90 to 120 days after planting when 60 percent of leaves yellow and fall over. Lift the bulbs, tie them, then dry for 2 to 3 weeks.',
  'Panen cara potong memberi 2 sampai 3 kali panen dari satu tanam.': 'Cut harvesting gives 2 to 3 pickings from one planting.',
  'Panen matang pohon harganya jauh di atas petik muda.': 'Tree-ripe fruit fetches far more than early-picked.',
  'Panen pagi hari agar daun tidak cepat layu saat dijual.': 'Harvest in the morning so leaves do not wilt quickly at market.',
  'Panen pertama 25 sampai 30 hari setelah tanam dengan cara potong atau cabut. Panen potong berulang tiap 10 sampai 14 hari.': 'First harvest 25 to 30 days after planting by cutting or pulling. Repeat cut harvests every 10 to 14 days.',
  'Panen potong menyisakan 2 sampai 3 buku untuk panen berikutnya.': 'Cut harvests leave 2 to 3 nodes for the next picking.',
  'Panen saat daun rebah (dormansi) agar umbi maksimal.': 'Harvest when the leaves collapse (dormancy) for the biggest corm.',
  'Panen umur 4 sampai 5 tahun dengan menebang batang; kupas kulit, gulung, lalu jemur perlahan 3 sampai 5 hari.': 'Harvest at 4 to 5 years by felling the stem; peel the bark, roll it, then dry slowly for 3 to 5 days.',
  'Panen umur 4 sampai 5 tahun saat batang mudah dikupas.': 'Harvest at 4 to 5 years of age when the bark peels easily.',
  'Pangkas bentuk sejak muda agar batang lurus dan mudah dikupas.': 'Prune for shape from a young age so stems grow straight and peel easily.',
  'Pangkas setelah panen agar tajuk terbuka dan buah mudah dipetik.': 'Prune after harvest to open the canopy and make picking easier.',
  'Pangkas setelah panen agar tajuk terbuka dan sinar masuk.': 'Prune after harvest to open the canopy and let light in.',
  'Pangkas tajuk, fungisida saat berbunga.': 'Prune the canopy, apply fungicide at flowering.',
  'Pasang ajir segera untuk tipe merambat.': 'Set up stakes early for climbing types.',
  'Pasang jaring atau panen tepat waktu sebelum buah jatuh.': 'Hang nets or harvest on time before fruit drops.',
  'Pemantauan rutin, insektisida bila ambang terlampaui.': 'Regular monitoring, insecticide only past the threshold.',
  'Pemantauan, insektisida bila perlu.': 'Monitoring, insecticide if needed.',
  'Pemantauan, pengendalian mekanis.': 'Monitoring, mechanical control.',
  'Penuh hingga teduh ringan.': 'Full sun to light shade.',
  'Penuh saat dewasa; teduh ringan saat bibit.': 'Full sun when mature; light shade as a seedling.',
  'Penuh; teduh ringan saat masih bibit.': 'Full sun; light shade while still a seedling.',
  'Penyerbukan dilakukan manual pada pagi hari saat bunga mekar.': 'Pollination is done by hand in the morning while flowers are open.',
  'Perangkap atraktan, bungkus buah.': 'Attractant traps, bag the fruit.',
  'Perlakuan benih, tanam serempak.': 'Seed treatment, synchronous planting.',
  'Petik pada umur tua; alpukat tidak matang di pohon.': 'Pick at full maturity; avocados do not ripen on the tree.',
  'Petik polong muda secara rutin agar pembungaan berlanjut.': 'Pick young pods regularly so flowering continues.',
  'Petik polong muda tiap 2 hari agar tanaman terus berbunga.': 'Pick young pods every 2 days so the plant keeps flowering.',
  'Pilih siung bibit yang padat dan bebas cacat.': 'Choose firm, defect-free clove seeds.',
  'Polong bercak cokelat dan busuk.': 'Pods with brown spots that rot.',
  'Porang': 'Porang',
  'Porang (Iles-iles)': 'Porang (Iles-iles)',
  'Potong dan musnahkan bagian terserang.': 'Cut out and destroy infested parts.',
  'Proses curing menentukan harga; lakukan bertahap dan sabar.': 'Curing sets the price; do it in stages and patiently.',
  'Rotasi dengan jagung atau padi untuk memutus siklus penyakit.': 'Rotate with maize or rice to break the disease cycle.',
  'Rotasi tanaman, sanitasi, fungisida sesuai label.': 'Crop rotation, sanitation, fungicide per label.',
  'Sangat tahan kekeringan, cocok untuk lahan kering berisiko.': 'Very drought tolerant, suited to risky rainfed land.',
  'Sanitasi buah gugur, fungisida.': 'Sanitise fallen fruit, apply fungicide.',
  'Sanitasi luka, oles fungisida.': 'Clean the wound, paint with fungicide.',
  'Sanitasi tajuk, fungisida saat berbunga.': 'Canopy sanitation, fungicide at flowering.',
  'Sanitasi, atur kerapatan naungan.': 'Sanitation, adjust shade density.',
  'Sanitasi, drainase, bibit sehat.': 'Sanitation, drainage, healthy seedlings.',
  'Sanitasi, fungisida bila parah.': 'Sanitation, fungicide if severe.',
  'Sanitasi, rotasi, fungisida sesuai label.': 'Sanitation, rotation, fungicide per label.',
  'Sanitasi, suntik insektisida pada lubang.': 'Sanitation, inject insecticide into the holes.',
  'Satu kali tanam bisa panen dua kali lewat tunas ratun.': 'One planting can yield two harvests through ratoon shoots.',
  'Sedang dan merata sepanjang tahun.': 'Moderate and even all year round.',
  'Sedang sampai banyak dan merata.': 'Moderate to high and even.',
  'Sedang; hindari genangan.': 'Moderate; avoid waterlogging.',
  'Sedang; kelembapan udara tinggi disukai.': 'Moderate; high air humidity is preferred.',
  'Sedang; kurangi menjelang panen agar umbi kering.': 'Moderate; reduce towards harvest so bulbs dry off.',
  'Sedang; musim kering memicu pembungaan.': 'Moderate; a dry season triggers flowering.',
  'Sedang; tidak tahan genangan.': 'Moderate; cannot stand waterlogging.',
  'Sedikit; sangat tahan kekeringan.': 'Low; very drought tolerant.',
  'Serbuk sari harus dipindahkan manual pada pagi hari saat bunga mekar.': 'Pollen must be transferred by hand in the morning while flowers are open.',
  'Simpan biji pada kadar air di bawah 12 persen.': 'Store grain at below 12 percent moisture.',
  'Simpan pada suhu ruang; buah matang dalam 5 sampai 7 hari.': 'Keep at room temperature; fruit ripens in 5 to 7 days.',
  'Siram teratur namun berhenti 1 sampai 2 minggu sebelum panen.': 'Water regularly but stop 1 to 2 weeks before harvest.',
  'Siram tiap hari pada musim kemarau.': 'Water daily in the dry season.',
  'Sorgum': 'Sorghum',
  'Tanam campuran tipe bunga A dan B agar penyerbukan silang baik.': 'Plant a mix of flower type A and B for good cross-pollination.',
  'Tanam di bawah naungan pohon atau paranet.': 'Plant under tree shade or shade netting.',
  'Teduh (naungan 50 sampai 70 persen).': 'Shade (50 to 70 percent shade netting).',
  'Teduh parsial (naungan 50 sampai 60 persen).': 'Partial shade (50 to 60 percent shade netting).',
  'Tipe merambat butuh ajir setinggi 1,5 sampai 2 meter.': 'Climbing types need stakes 1.5 to 2 metres tall.',
  'Toleran; dari lempung subur sampai tanah marginal.': 'Tolerant; from fertile loam to marginal soils.',
  'Tumbuh baik di bawah naungan pohon atau paranet 50 sampai 60 persen.': 'Grows well under tree shade or 50 to 60 percent shade netting.',
  'Ulat bawang': 'Onion caterpillars',
  'Ulat daun': 'Leaf caterpillars',
  'Ulat grayak': 'Armyworms',
  'Umbi lembek dan berbau tidak sedap.': 'Soft, foul-smelling corms.',
  'Vanili': 'Vanilla',
  'Varietas tahan, rotasi tanaman.': 'Resistant varieties, crop rotation.',
  'Sumber gambar': 'Image sources',
  'Sumber Gambar': 'Image Sources',
  'Bawang Putih': 'Garlic',
  'Tanam di dataran tinggi di atas 700 mdpl agar umbi terbentuk penuh.':
      'Plant above 700 m asl so the bulbs form fully.',
  'Gunakan bibit siung sehat yang sudah disimpan minimal 2 bulan.':
      'Use healthy clove seeds stored for at least 2 months.',
  'Keringkan umbi 2 sampai 3 minggu sebelum disimpan agar awet.':
      'Dry the bulbs for 2 to 3 weeks before storing so they keep.',
  'Foto asli dan lisensinya': 'Real photos and their licences',
  'Foto: {0}': 'Photo: {0}',
  'Foto tanaman di aplikasi ini adalah foto asli, bukan gambar buatan. Sebagian besar adalah dokumentasi pribadi yang dibagikan ke Agrinexa, sebagian lain dari Pexels, dengan menyebut sumbernya di bawah ini.': 'The crop photos in this app are real photographs, not generated images. Most are personal documentation shared with Agrinexa, others come from Pexels, with the sources credited below.',
  'Kirim tautan masuk ke email': 'Send a sign-in link to your email',
  'Tautan dikirim ke {0}. Buka email Anda lalu ketuk tautan di dalamnya.':
      'Link sent to {0}. Open your email and tap the link inside.',
  'Firebase belum dikonfigurasi di perangkat ini.':
      'Firebase is not configured on this device.',
  'Gagal terhubung ke Google. Periksa koneksi internet.':
      'Could not reach Google. Check your internet connection.',
  'Gagal mengirim tautan.': 'Could not send the link.',
  'Masukkan email Anda, lalu buka lagi tautan dari email.':
      'Enter your email, then open the link from your email again.',
  'Akun Google ini tidak punya email.': 'This Google account has no email.',
  'Isi email yang valid dulu, lalu tekan kirim tautan.':
      'Enter a valid email first, then press send link.',
  'Tidak ada koneksi internet.': 'No internet connection.',
  'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.':
      'Too many attempts. Wait a moment and try again.',
  'Akun ini dinonaktifkan.': 'This account has been disabled.',
  'Cara masuk ini belum diaktifkan di konsol Firebase.':
      'This sign-in method is not enabled in the Firebase console.',
  'Konfigurasi Firebase belum benar.': 'Firebase configuration is not correct.',
  'Gagal masuk. Periksa koneksi internet lalu coba lagi.':
      'Sign-in failed. Check your internet connection and try again.',
  // ----------------------- kelompok 31 komoditas dengan foto dokumentasi pribadi
  'Labu': 'Pumpkin',
  'Labu Kuning': 'Yellow pumpkin',
  'Alas jerami atau mulsa mencegah buah busuk karena menyentuh tanah.': 'A straw or mulch bed stops the fruit rotting where it touches the soil.',
  'Pangkas sulur liar agar nutrisi terfokus ke pembesaran buah.': 'Prune stray runners so nutrients focus on fruit growth.',
  'Panen saat tangkai mengering dan kulit keras tidak tertekan kuku.': 'Harvest when the stem dries and the rind is too hard to dent with a fingernail.',
  'Lempung berpasir subur kaya organik, drainase baik.': 'Fertile organic-rich sandy loam with good drainage.',
  'Sedang sampai banyak; kritis saat pembungaan.': 'Moderate to high; critical at flowering.',
  '150 × 100 cm, merambat atau menjalar': '150 x 100 cm, climbing or trailing',
  'Panen 80 sampai 100 hari setelah tanam saat tangkai mengering dan kulit keras; potong dengan tangkai 3 sampai 5 cm.': 'Harvest 80 to 100 days after planting when the stem dries and the rind hardens; cut with a 3 to 5 cm stem.',
  'Alas buah dengan jerami atau plastik mulsa.': 'Bed the fruit on straw or plastic mulch.',
  'Pangkas sulur liar agar nutrisi terfokus ke buah.': 'Prune stray runners so nutrients focus on the fruit.',
  'Kawinkan bunga manual pagi hari bila serangga penyerbuk sedikit.': 'Hand-pollinate flowers in the morning when pollinating insects are scarce.',
  '250 sampai 350 kg per ha dibagi dua aplikasi.': '250 to 350 kg per ha split over two applications.',
  'Lapisan putih pada permukaan daun.': 'White coating on the leaf surface.',
  'Buah berlubang lalu busuk.': 'Fruit pierced, then rotting.',
  'Pembungkusan buah, perangkap.': 'Fruit bagging, traps.',
  'Bercak basah pada buah yang menyentuh tanah.': 'Wet spots on fruit touching the soil.',
  'Alas jerami, drainase baik.': 'Straw bedding, good drainage.',
  'Paprika': 'Bell pepper',
  'Rumah plastik atau paranet menjaga buah mulus dan warna merata.': 'A plastic house or shade net keeps the fruit smooth and evenly coloured.',
  'Pasang ajir sejak dini karena buah berat dan batang mudah patah.': 'Install stakes early because the fruit is heavy and the stem snaps easily.',
  'Panen saat warna penuh terbentuk untuk harga terbaik.': 'Harvest once full colour has formed for the best price.',
  'Lempung gembur kaya organik; paling baik di rumah plastik.': 'Loose organic-rich loam; best inside a plastic house.',
  '600 sampai 1.500 mdpl': '600 to 1,500 m asl',
  'Teratur dan merata; tidak tahan tanah becek.': 'Regular and even; intolerant of waterlogged soil.',
  'Penuh dengan naungan ringan saat terik.': 'Full sun with light shade in scorching heat.',
  'Panen 90 sampai 110 hari setelah tanam saat warna penuh terbentuk; gunting tangkai, jangan ditarik.': 'Harvest 90 to 110 days after planting once full colour has formed; snip the stem, do not pull.',
  'Pasang ajir dan ikat batang utama sejak dini.': 'Install stakes and tie the main stem early.',
  'Buang buah pertama agar tanaman tumbuh kuat.': 'Remove the first fruit so the plant grows strong.',
  'Jaga kelembapan stabil dengan irigasi tetes.': 'Keep moisture stable with drip irrigation.',
  '300 sampai 400 kg per ha diberikan bertahap.': '300 to 400 kg per ha applied in stages.',
  'Bila ujung buah busuk karena kekurangan kalsium.': 'If the fruit tip rots from calcium deficiency.',
  'Ujung buah cokelat cekung dan kering.': 'Sunken, dry brown tip on the fruit.',
  'Irigasi teratur, pupuk kalsium.': 'Regular irrigation, calcium fertiliser.',
  'Bercak bulat cekung pada buah.': 'Sunken round spots on the fruit.',
  'Sanitasi, fungisida preventif.': 'Sanitation, preventive fungicide.',
  'Thrips': 'Thrips',
  'Daun keriting dengan bintik perak.': 'Curled leaves with silvery speckles.',
  'Perangkap, insektisida selektif.': 'Traps, selective insecticide.',
  'Sirsak': 'Soursop',
  'Bantu penyerbukan manual bila populasi kumbang penyerbuk sedikit.': 'Assist pollination by hand when pollinating beetle numbers are low.',
  'Tipiskan buah muda agar sisa buah tumbuh besar dan merata.': 'Thin young fruit so the rest grow large and even.',
  'Panen saat kulit berubah hijau kekuningan dan duri merenggang.': 'Harvest when the skin turns yellowish green and the spines spread apart.',
  'Lempung berpasir sampai liat dengan drainase baik.': 'Sandy loam to clay with good drainage.',
  '0 sampai 500 mdpl': '0 to 500 m asl',
  'Sedang; tahan kering sebentar setelah dewasa.': 'Moderate; tolerates short dry spells once mature.',
  '600 × 600 cm': '600 x 600 cm',
  'Panen 3 sampai 4 tahun setelah tanam saat kulit hijau kekuningan dan duri merenggang; potong dengan tangkai.': 'Harvest 3 to 4 years after planting when the skin is yellowish green and the spines spread apart; cut with the stem.',
  'Pangkas pembentukan tajuk rendah agar panen mudah.': 'Prune to a low canopy so harvesting is easy.',
  'Tipiskan buah muda sisakan satu sampai dua per tangkai.': 'Thin young fruit, leaving one or two per stem.',
  'Bungkus buah muda dengan kertas atau plastik berlubang.': 'Wrap young fruit in paper or perforated plastic.',
  '0,5 sampai 2 kg per pohon per tahun.': '0.5 to 2 kg per tree per year.',
  'Bercak hitam meluas pada kulit buah.': 'Spreading black spots on the fruit skin.',
  'Sanitasi, pembungkusan buah muda.': 'Sanitation, bagging young fruit.',
  'Kutu putih': 'Mealybugs',
  'Bintik putih pada daun dan buah.': 'White specks on leaves and fruit.',
  'Kendalikan semut, insektisida bila parah.': 'Control ants; insecticide when severe.',
  'Belatung di dalam buah rontok.': 'Maggots inside dropped fruit.',
  'Perangkap, sanitasi buah jatuh.': 'Traps, clearing fallen fruit.',
  'Manggis': 'Mangosteen',
  'Butuh naungan parsial saat muda; tanaman dewasa tahan panas.': 'Needs partial shade when young; mature trees tolerate heat.',
  'Jaga kelembapan tanah stabil agar getah kuning tidak muncul di buah.': 'Keep soil moisture stable so yellow latex does not appear in the fruit.',
  'Panen saat kulit ungu penuh; petik dengan gunting, jangan ditarik.': 'Harvest at full purple skin; pick with secateurs, do not pull.',
  'Lempung dalam kaya organik tanpa genangan.': 'Deep organic-rich loam without waterlogging.',
  'Banyak dan merata; stres air merusak mutu buah.': 'High and even; water stress damages fruit quality.',
  'Teduh parsial saat muda, penuh saat produktif.': 'Partial shade when young, full sun when productive.',
  '1000 × 1000 cm': '1000 x 1000 cm',
  'Panen 8 sampai 10 tahun setelah tanam saat kulit ungu penuh; petik dengan gunting menyertakan tangkai 2 cm.': 'Harvest 8 to 10 years after planting at full purple skin; pick with secateurs leaving a 2 cm stem.',
  'Beri naungan parsial pada tanaman muda.': 'Give young trees partial shade.',
  'Mulsa tebal menjaga kelembapan zona akar.': 'Thick mulch keeps the root zone moist.',
  'Panen dengan gunting bertangkai, jangan dijatuhkan.': 'Harvest with long-handled secateurs; never drop the fruit.',
  '30 sampai 60 kg per pohon per tahun.': '30 to 60 kg per tree per year.',
  '1 sampai 3 kg per pohon per tahun.': '1 to 3 kg per tree per year.',
  'Getah kuning': 'Yellow latex',
  'Daging buah bercak getah kuning.': 'Flesh stained with yellow latex.',
  'Irigasi stabil, hindari stres air.': 'Stable irrigation; avoid water stress.',
  'Kulit menghitam dan buah lembek.': 'Blackening skin and soft fruit.',
  'Sanitasi, panen tepat waktu.': 'Sanitation, timely harvest.',
  'Permukaan buah berbintik putih.': 'White speckles on the fruit surface.',
  'Sanitasi, insektisida bila parah.': 'Sanitation; insecticide when severe.',
  'Kacang Merah': 'Red kidney bean',
  'Gunakan rhizobium atau tanah bekas tanaman kacang untuk bintil akar.': 'Use rhizobium or soil from a previous bean crop to form root nodules.',
  'Hindari genangan; akar kacang sangat sensitif tanah becek.': 'Avoid waterlogging; bean roots are very sensitive to sodden soil.',
  'Panen saat polong menguning kering lalu jemur sampai biji keras.': 'Harvest when the pods yellow and dry, then sun-dry until the seeds are hard.',
  'Lempung berpasir gembur dengan drainase baik.': 'Loose sandy loam with good drainage.',
  'Sedang; kurangi saat polong mengisi.': 'Moderate; reduce while the pods are filling.',
  '40 × 20 cm': '40 x 20 cm',
  'Panen 90 sampai 110 hari setelah tanam saat polong kering menguning; cabut, jemur, lalu pipil bijinya.': 'Harvest 90 to 110 days after planting when the pods turn yellow and dry; pull, sun-dry, then shell the seeds.',
  'Bumbun pangkal batang saat umur 3 minggu.': 'Earth up the stem base at 3 weeks old.',
  'Hindari genangan lebih dari satu hari.': 'Never leave water standing for more than a day.',
  'Panen bertahap saat polong menguning kering.': 'Harvest in stages as the pods yellow and dry.',
  '50 sampai 100 kg per ha saat tanam.': '50 to 100 kg per ha at planting.',
  'Tanaman layu mendadak saat berbunga.': 'Plants wilt suddenly at flowering.',
  'Rotasi tanaman, bibit sehat.': 'Crop rotation, healthy seed.',
  'Bintik cokelat berbubuk pada daun.': 'Powdery brown specks on the leaves.',
  'Varietas tahan, fungisida.': 'Resistant varieties, fungicide.',
  'Daun berlubang sampai gundul.': 'Leaves holed until bare.',
  'Kacang Polong': 'Green pea',
  'Sediakan lanjaran atau ajir saat tanaman mulai memanjat.': 'Provide trellises or stakes once the plants start climbing.',
  'Dataran tinggi memberi polong lebih manis dan renyah.': 'Highlands give sweeter, crisper pods.',
  'Petik polong muda bertahap agar tanaman terus berbunga.': 'Pick young pods in stages so the plant keeps flowering.',
  'Lempung gembur kaya organik.': 'Loose organic-rich loam.',
  '700 sampai 1.500 mdpl': '700 to 1,500 m asl',
  'Teratur; sensitif kekeringan saat berbunga.': 'Regular; sensitive to drought at flowering.',
  '50 × 10 cm dengan lanjaran': '50 x 10 cm with trellises',
  'Panen 55 sampai 70 hari setelah tanam saat polong muda berisi penuh; petik dengan tangan hati-hati.': 'Harvest 55 to 70 days after planting when young pods are fully filled; pick carefully by hand.',
  'Pasang lanjaran setinggi 150 cm saat mulai memanjat.': 'Set 150 cm trellises once climbing starts.',
  'Siram pagi hari pada masa berbunga.': 'Water in the morning during flowering.',
  'Petik polong muda tiap 2 sampai 3 hari.': 'Pick young pods every 2 to 3 days.',
  '50 sampai 75 kg per ha saat tanam.': '50 to 75 kg per ha at planting.',
  'Lapisan putih pada daun.': 'White coating on the leaves.',
  'Sirkulasi udara baik, fungisida.': 'Good air circulation, fungicide.',
  'Tanaman layu dan pangkal membusuk.': 'Plants wilt and the base rots.',
  'Rotasi tanaman, drainase baik.': 'Crop rotation, good drainage.',
  'Ulat polong': 'Pod borers',
  'Polong berlubang berisi ulat.': 'Pods holed and full of caterpillars.',
  'Petik polong terserang, insektisida.': 'Pick off infested pods; insecticide if needed.',
  'Belimbing': 'Starfruit',
  'Belimbing Manis': 'Sweet starfruit',
  'Bungkus buah muda dengan plastik atau kertas agar kulit mulus.': 'Wrap young fruit in plastic or paper for smooth skin.',
  'Tanaman pekarangan tetap produktif bila sinar matahari cukup.': 'Yard trees stay productive as long as sunlight is sufficient.',
  'Panen saat warna kuning merata dengan sedikit hijau di ujung.': 'Harvest when yellow is even with a little green at the tips.',
  'Lempung berpasir subur berdrainase baik.': 'Fertile, well-drained sandy loam.',
  'Panen 2 sampai 3 tahun setelah tanam (okulasi) saat warna kuning merata; potong menyertakan tangkai.': 'Harvest 2 to 3 years after planting (grafted) when the yellow is even; cut with the stem.',
  'Bungkus buah muda dengan plastik berlubang.': 'Wrap young fruit in perforated plastic.',
  'Pangkas tunas air agar cahaya masuk tajuk.': 'Prune water shoots so light reaches the canopy.',
  'Jaga irigasi saat pembungaan agar buah tidak rontok.': 'Keep irrigation steady at flowering so the fruit does not drop.',
  'Buah berlubang lalu rontok.': 'Fruit pierced, then dropping.',
  'Bintik putih pada tunas muda.': 'White specks on young shoots.',
  'Insektisida bila populasi tinggi.': 'Insecticide when numbers are high.',
  'Apel': 'Apple',
  'Hanya cocok di dataran tinggi di atas 1.000 mdpl.': 'Only suits highlands above 1,000 m asl.',
  'Perlu pangkas rutin dan penjarangan buah untuk ukuran besar.': 'Needs regular pruning and fruit thinning for large size.',
  'Panen pagi hari saat warna merah menutupi sebagian besar buah.': 'Harvest in the morning when red covers most of the fruit.',
  'Lempung berpasir dalam, subur, drainase baik.': 'Deep, fertile sandy loam with good drainage.',
  '1.000 sampai 1.400 mdpl': '1,000 to 1,400 m asl',
  'Teratur; mulsa membantu menjaga kelembapan.': 'Regular; mulch helps hold moisture.',
  '300 × 300 cm': '300 x 300 cm',
  'Panen 3 sampai 4 tahun setelah tanam saat warna merah menutup dan buah mudah dilepas; petik menyertakan tangkai.': 'Harvest 3 to 4 years after planting when red covers the fruit and it parts easily; pick with the stem.',
  'Pangkas pembentukan dan pembuahan tiap musim.': 'Prune for shape and fruiting every season.',
  'Jarangkan buah muda sisakan satu per dompol.': 'Thin young fruit, leaving one per cluster.',
  'Bungkus buah untuk warna dan mutu kulit.': 'Bag the fruit for better colour and skin quality.',
  '15 sampai 30 kg per pohon per tahun.': '15 to 30 kg per tree per year.',
  '0,5 sampai 1,5 kg per pohon per tahun.': '0.5 to 1.5 kg per tree per year.',
  'Lapisan putih pada daun muda.': 'White coating on young leaves.',
  'Fungisida, pangkas bagian sakit.': 'Fungicide; prune out diseased parts.',
  'Bercak cokelat membusuk pada buah.': 'Rotting brown spots on the fruit.',
  'Daun mengeriting berkoloni.': 'Leaves curled in colonies.',
  'Musuh alami, insektisida bila parah.': 'Natural enemies; insecticide when severe.',
  'Daun Pandan': 'Pandan leaf',
  'Pandan Wangi': 'Fragrant pandan',
  'Tumbuh subur di pekarangan lembap dengan naungan ringan.': 'Thrives in a moist yard with light shade.',
  'Potong daun dari luar ke dalam agar rumpun tetap produktif.': 'Cut leaves from the outside in so the clump stays productive.',
  'Ikat daun setelah panen dan jual segar sebelum layu.': 'Tie the leaves after harvest and sell them fresh before they wilt.',
  'Lempung lembap kaya bahan organik.': 'Moist loam rich in organic matter.',
  'Banyak; menyukai tanah lembap terus.': 'High; prefers constantly moist soil.',
  'Teduh ringan hingga penuh.': 'Light to full shade.',
  'Panen daun mulai umur 8 sampai 12 bulan dan seterusnya tiap 2 sampai 3 bulan; potong daun tua dekat pangkal.': 'Harvest leaves from 8 to 12 months old and every 2 to 3 months after; cut old leaves close to the base.',
  'Potong daun dari luar ke dalam rumpun.': 'Cut leaves from the outside of the clump inward.',
  'Beri mulsa organik untuk menjaga kelembapan.': 'Apply organic mulch to hold moisture.',
  'Pisahkan anakan sehat untuk bibit baru.': 'Separate healthy suckers for new planting material.',
  '20 sampai 40 g per tanaman setelah tiap panen daun.': '20 to 40 g per plant after each leaf harvest.',
  'Bercak cokelat memanjang pada daun.': 'Elongated brown spots on the leaves.',
  'Sanitasi daun tua, fungisida bila parah.': 'Clear old leaves; fungicide when severe.',
  'Bintik putih pada pangkal daun.': 'White specks at the leaf base.',
  'Tembakau': 'Tobacco',
  'Hujan saat panen merusak mutu; atur jadwal tanam ke musim kering.': 'Rain at harvest ruins quality; time planting to the dry season.',
  'Pangkas bunga agar daun menebal dan mutu merata.': 'Remove the flowers so the leaves thicken and quality is even.',
  'Peram dan keringkan daun bertahap di kumbung untuk warna terbaik.': 'Sweat and cure the leaves in stages in a barn for the best colour.',
  'Lempung berpasir subur dengan drainase sangat baik.': 'Fertile sandy loam with very good drainage.',
  'Sedang; hujan saat panen merusak mutu daun.': 'Moderate; rain at harvest damages leaf quality.',
  'Panen 90 sampai 120 hari bertahap dari daun bawah ke atas; peram 1 sampai 2 hari lalu keringkan di kumbung.': 'Harvest from 90 to 120 days in stages, bottom leaves upward; sweat 1 to 2 days then cure in a barn.',
  'Buang tunas ketiak (wiwil) rutin tiap minggu.': 'Remove axillary shoots (wiwil) every week.',
  'Pangkas bunga saat muncul agar daun menebal.': 'Remove the flowers as they appear so the leaves thicken.',
  'Naungi daun hasil petikan sebelum diperam.': 'Shade picked leaves before sweating them.',
  '300 sampai 500 kg per ha diberikan bertahap.': '300 to 500 kg per ha applied in stages.',
  'Batang menghitam dan tanaman layu.': 'Stems blacken and the plant wilts.',
  'Drainase baik, rotasi tanaman.': 'Good drainage, crop rotation.',
  'Bercak cokelat': 'Brown spot',
  'Bercak konsentris pada daun tua.': 'Concentric spots on old leaves.',
  'Sanitasi, fungisida.': 'Sanitation, fungicide.',
  'Kemiri': 'Candlenut',
  'Tahan lahan marginal dan cocok sekaligus untuk reboisasi.': 'Tolerates marginal land and doubles as reforestation.',
  'Kumpulkan buah jatuh alami untuk mutu biji terbaik.': 'Collect naturally fallen fruit for the best seed quality.',
  'Jemur dulu lalu pecah cangkang agar biji utuh.': 'Sun-dry first, then crack the shell so the kernel stays whole.',
  'Toleran; dari subur sampai marginal asal drainase baik.': 'Tolerant; from fertile to marginal soil as long as drainage is good.',
  'Sedang; tahan kering setelah dewasa.': 'Moderate; drought tolerant once mature.',
  'Panen 4 sampai 5 tahun setelah tanam saat buah jatuh alami; kupas kulit, jemur, lalu pecah cangkang.': 'Harvest 4 to 5 years after planting when the fruit falls naturally; peel, sun-dry, then crack the shell.',
  'Kumpulkan buah jatuh secara rutin saat musim panen.': 'Collect fallen fruit regularly during the harvest season.',
  'Jemur buah untuk melepas kulit luar.': 'Sun-dry the fruit to loosen the outer husk.',
  'Pecah cangkang setelah biji kering sempurna.': 'Crack the shell only after the kernel is fully dry.',
  '20 sampai 50 kg per pohon per tahun.': '20 to 50 kg per tree per year.',
  'Daun menguning dan tajuk menipis.': 'Leaves yellow and the canopy thins.',
  'Lubang gerekan pada batang.': 'Borer holes in the trunk.',
  'Potong bagian terserang, sanitasi.': 'Cut out infested parts, keep the area clean.',
  'Anggur': 'Grape',
  'Perlu musim kering jelas dan pemangkasan untuk memicu pembuahan.': 'Needs a clear dry season and pruning to trigger fruiting.',
  'Atur kanopi dan jarangkan dompol agar buah manis merata.': 'Manage the canopy and thin clusters so the fruit sweetens evenly.',
  'Panen saat gula puncak; anggur tidak matang lagi setelah dipetik.': 'Harvest at peak sugar; grapes do not ripen further after picking.',
  'Lempung berpasir dalam dengan drainase sangat baik.': 'Deep sandy loam with very good drainage.',
  '0 sampai 300 mdpl dengan musim kering jelas': '0 to 300 m asl with a clear dry season',
  'Sedang; kurangi saat pemasakan buah.': 'Moderate; reduce during ripening.',
  '300 × 300 cm dengan para-para': '300 x 300 cm with an overhead trellis',
  'Panen 1 sampai 2 tahun setelah tanam, 90 sampai 110 hari setelah pangkas; gunting dompol yang matang gula.': 'Harvest 1 to 2 years after planting, 90 to 110 days after pruning; snip clusters at full sugar.',
  'Pangkas pembuahan dua kali setahun setelah tanaman dewasa.': 'Prune for fruiting twice a year once the vine is mature.',
  'Jarangkan dompol dan buah untuk ukuran merata.': 'Thin clusters and berries for even size.',
  'Atur kanopi agar sinar masuk ke zona buah.': 'Manage the canopy so light reaches the fruit zone.',
  '0,5 sampai 1 kg per pohon per tahun.': '0.5 to 1 kg per vine per year.',
  'Lapisan kelabu pada daun dan buah.': 'Grey coating on leaves and fruit.',
  'Sirkulasi kanopi, fungisida.': 'Canopy air flow, fungicide.',
  'Dompol membusuk saat musim hujan.': 'Clusters rot in the rainy season.',
  'Jarangkan dompol, fungisida preventif.': 'Thin clusters, preventive fungicide.',
  'Rambutan': 'Rambutan',
  'Pilih varietas unggul seperti Binjai atau Lebak Bulus.': 'Choose superior varieties such as Binjai or Lebak Bulus.',
  'Jaga kelembapan saat berbunga agar buah tidak rontok.': 'Keep moisture steady at flowering so the fruit does not drop.',
  'Panen dengan memotong tangkai dompol, bukan memetik satuan.': 'Harvest by cutting the cluster stem, not by picking single fruits.',
  'Lempung dalam kaya bahan organik.': 'Deep loam rich in organic matter.',
  'Banyak saat tumbuh, kering saat pembungaan.': 'High while growing, dry at flowering.',
  'Panen 4 sampai 5 tahun setelah tanam saat kulit merah penuh; potong tangkai dompol, jangan petik satuan.': 'Harvest 4 to 5 years after planting at full red skin; cut the cluster stem, never pick single fruits.',
  'Pangkas tajuk agar cahaya merata dan panen mudah.': 'Prune the canopy for even light and easy harvesting.',
  'Panen per dompol dengan gunting atau pisau.': 'Harvest cluster by cluster with secateurs or a knife.',
  'Bercak cokelat pada kulit buah.': 'Brown spots on the fruit skin.',
  'Sanitasi, hindari buah menyentuh tanah.': 'Sanitation; keep the fruit off the soil.',
  'Bintik putih pada dompol buah.': 'White specks on the fruit clusters.',
  'Kacang Hijau': 'Mung bean',
  'Umur genjah dan hemat air; cocok sela atau setelah padi.': 'Short-lived and water-saving; ideal as an intercrop or after rice.',
  'Panen bertahap karena polong matang tidak serentak.': 'Harvest in stages because the pods ripen unevenly.',
  'Jemur polong sampai kering lalu pukul ringan untuk melepas biji.': 'Sun-dry the pods, then thresh lightly to release the seeds.',
  'Sedikit sampai sedang; relatif tahan kering.': 'Low to moderate; relatively drought tolerant.',
  '40 × 15 cm': '40 x 15 cm',
  'Panen 55 sampai 70 hari setelah tanam saat polong berubah cokelat kering; cabut utuh atau petik bertahap.': 'Harvest 55 to 70 days after planting when the pods turn dry brown; pull whole plants or pick in stages.',
  'Panen bertahap tiap 3 sampai 4 hari.': 'Harvest in stages every 3 to 4 days.',
  'Jemur polong sampai kering sebelum dipipil.': 'Sun-dry the pods fully before shelling.',
  '3 sampai 5 ton per ha sebagai pupuk dasar.': '3 to 5 tonnes per ha as basal fertiliser.',
  'Rotasi tanaman, fungisida bila parah.': 'Crop rotation; fungicide when severe.',
  'Polong berlubang.': 'Pods with holes.',
  'Ketumbar': 'Coriander',
  'Tanah gembur dan sinar penuh menghasilkan biji beraroma kuat.': 'Loose soil and full sun give strongly aromatic seeds.',
  'Panen saat buah cokelat lalu jemur dan pipil bijinya.': 'Harvest when the fruits turn brown, then sun-dry and shell the seeds.',
  'Simpan biji kering dalam wadah rapat agar aroma tidak menguap.': 'Store dry seeds in an airtight container so the aroma does not escape.',
  'Lempung gembur berdrainase baik.': 'Loose, well-drained loam.',
  'Sedang; kurangi saat biji mengisi.': 'Moderate; reduce while the seeds are filling.',
  '30 × 10 cm': '30 x 10 cm',
  'Panen 90 sampai 110 hari setelah tanam saat buah cokelat kering; potong tanaman, jemur, lalu pipil biji.': 'Harvest 90 to 110 days after planting when the fruits are dry brown; cut the plants, sun-dry, then shell the seeds.',
  'Siram seperlunya; tanaman tidak menyukai tanah becek.': 'Water only as needed; the plant dislikes sodden soil.',
  'Siangi gulma saat tanaman masih muda.': 'Weed while the plants are still young.',
  'Panen saat buah cokelat lalu jemur utuh.': 'Harvest when the fruits turn brown, then sun-dry them whole.',
  '100 sampai 150 kg per ha.': '100 to 150 kg per ha.',
  'Cengkeh': 'Clove',
  'Panen tepat saat bunga hijau kekuningan, sebelum berubah merah.': 'Harvest exactly at yellowish green buds, before they turn red.',
  'Petik tanpa menyertakan daun agar mutu bunga kering tinggi.': 'Pick without leaves so the dried buds stay high quality.',
  'Jemur sampai kering sempurna agar warna cokelat mengilap.': 'Sun-dry until fully dry for a glossy brown colour.',
  'Lempung dalam subur, drainase baik, terlindung angin.': 'Deep fertile loam, good drainage, sheltered from wind.',
  'Banyak dan merata; tidak tahan genangan.': 'High and even; intolerant of waterlogging.',
  'Penuh hingga teduh ringan saat muda.': 'Full sun to light shade when young.',
  '800 × 800 cm': '800 x 800 cm',
  'Panen 5 sampai 7 tahun setelah tanam saat bunga hijau kekuningan; petik tanpa daun, jemur sampai cokelat kering.': 'Harvest 5 to 7 years after planting at yellowish green buds; pick without leaves and sun-dry until brown.',
  'Panen bunga tepat warna sebelum berubah merah.': 'Pick the buds at exactly the right colour, before they turn red.',
  'Daun menguning dan ranting mengering.': 'Leaves yellow and twigs dry out.',
  'Bercak ungu kecokelatan pada daun.': 'Brownish purple spots on the leaves.',
  'Stroberi': 'Strawberry',
  'Media gembur dan drainase baik mencegah busuk buah.': 'Loose medium and good drainage prevent fruit rot.',
  'Gunakan mulsa plastik dan stolon terpilih untuk bibit.': 'Use plastic mulch and selected runners for planting material.',
  'Petik pagi hari saat merah penuh untuk rasa termanis.': 'Pick in the morning at full red for the sweetest flavour.',
  'Lempung berpasir gembur kaya organik, drainase baik.': 'Loose organic-rich sandy loam with good drainage.',
  '800 sampai 1.500 mdpl': '800 to 1,500 m asl',
  'Teratur; hindari daun dan buah basah.': 'Regular; keep leaves and fruit dry.',
  '40 × 30 cm pada bedengan': '40 x 30 cm on raised beds',
  'Panen 2 sampai 3 bulan setelah tanam bibit dan berlanjut 8 sampai 12 bulan; petik pagi saat merah penuh.': 'Harvest 2 to 3 months after planting runners and keep going for 8 to 12 months; pick in the morning at full red.',
  'Buang sulur berlebih, sisakan bibit terpilih.': 'Remove excess runners, keeping only selected ones.',
  'Mulsa plastik menjaga buah tetap kering.': 'Plastic mulch keeps the fruit dry.',
  'Petik buah matang setiap 2 hari.': 'Pick ripe fruit every 2 days.',
  '200 sampai 300 kg per ha diberikan bertahap.': '200 to 300 kg per ha applied in stages.',
  'Buah berbulu kelabu dan lembek.': 'Fruit covered in grey fuzz and turning soft.',
  'Mulsa, sirkulasi, fungisida.': 'Mulch, air flow, fungicide.',
  'Bercak ungu pada daun.': 'Purple spots on the leaves.',
  'Sanitasi daun tua, fungisida.': 'Clear old leaves, fungicide.',
  'Tungau': 'Spider mites',
  'Daun keriput berbintik kuning.': 'Wrinkled leaves with yellow speckles.',
  'Akarisida bila populasi tinggi.': 'Acaricide when numbers are high.',
  'Lemon': 'Lemon',
  'Butuh sinar penuh dan drainase baik agar buah asam segar.': 'Needs full sun and good drainage for fresh, sour fruit.',
  'Pupuk rutin menjaga produksi tetap ada sepanjang tahun.': 'Regular fertiliser keeps fruit coming all year.',
  'Panen saat kulit kuning mengilap dan buah terasa berat.': 'Harvest when the skin is glossy yellow and the fruit feels heavy.',
  'Sedang dan merata; genangan merusak akar.': 'Moderate and even; waterlogging damages the roots.',
  '500 × 500 cm': '500 x 500 cm',
  'Panen 2 sampai 3 tahun setelah tanam saat kulit kuning mengilap; potong dengan gunting menyertakan tangkai pendek.': 'Harvest 2 to 3 years after planting at glossy yellow skin; cut with secateurs leaving a short stem.',
  'Pangkas tunas air dan cabang di dalam tajuk.': 'Prune water shoots and inward-growing branches.',
  'Jaga irigasi saat pembungaan dan pembuahan.': 'Keep irrigation steady at flowering and fruiting.',
  'Panen dengan gunting agar tangkai rapi.': 'Harvest with secateurs so the stems stay neat.',
  'CVPD': 'CVPD',
  'Daun kuning belang dan tulang daun menonjol.': 'Mottled yellow leaves with prominent veins.',
  'Bibit bebas penyakit, kendalikan kutu loncat.': 'Disease-free planting material; control psyllids.',
  'Kapulaga': 'Cardamom',
  'Tumbuh terbaik di bawah naungan pohon atau sistem agroforestri.': 'Grows best under tree shade or in agroforestry.',
  'Panen polong satu per satu karena matangnya tidak serentak.': 'Harvest the pods one by one because they ripen unevenly.',
  'Keringkan perlahan agar warna dan aroma polong terjaga.': 'Dry slowly to preserve the colour and aroma of the pods.',
  'Lempung kaya organik, lembap, di bawah naungan.': 'Organic-rich loam, moist, under shade.',
  '300 sampai 1.000 mdpl': '300 to 1,000 m asl',
  'Teduh parsial (naungan 30 sampai 50 persen).': 'Partial shade (30 to 50 percent shade).',
  '150 × 150 cm': '150 x 150 cm',
  'Panen mulai umur 2 sampai 3 tahun saat polong hijau kekuningan; petik per tandan lalu keringkan perlahan.': 'Harvest from 2 to 3 years old at yellowish green pods; pick per bunch, then dry slowly.',
  'Pangkas batang tua setelah panen untuk merangsang anakan.': 'Cut out old stems after harvest to stimulate new shoots.',
  'Jaga seresah daun sebagai mulsa alami.': 'Keep the leaf litter as natural mulch.',
  'Panen polong matang satu per satu.': 'Harvest ripe pods one by one.',
  '200 sampai 300 kg per ha dibagi dua aplikasi.': '200 to 300 kg per ha split over two applications.',
  'Rimpang lembek dan tanaman layu.': 'Soft rhizomes and wilting plants.',
  'Teh': 'Tea',
  'Petik pucuk peko plus dua daun muda secara rutin.': 'Pick pekoe tips plus two young leaves regularly.',
  'Dataran tinggi berkabut memberi mutu pucuk terbaik.': 'Misty highlands give the best tip quality.',
  'Pangkas pohon berkala agar bidang petik tetap rendah.': 'Prune the bushes regularly to keep the picking table low.',
  'Lempung berpasir asam, dalam, drainase baik.': 'Deep, acidic sandy loam with good drainage.',
  '800 sampai 2.000 mdpl': '800 to 2,000 m asl',
  'Banyak dan merata sepanjang tahun.': 'High and even all year round.',
  '120 × 60 cm': '120 x 60 cm',
  'Panen pucuk setiap 7 sampai 14 hari sepanjang tahun setelah umur 3 tahun; standar pucuk peko plus dua daun.': 'Pick tips every 7 to 14 days year round from 3 years old; the standard is pekoe tip plus two leaves.',
  'Pangkas produksi berkala agar bidang petik tetap rendah.': 'Prune for production regularly to keep the picking table low.',
  'Petik pucuk peko plus dua daun muda.': 'Pick pekoe tips plus two young leaves.',
  'Kembalikan sisa pangkasan sebagai mulsa.': 'Return the prunings to the field as mulch.',
  '10 sampai 20 ton per ha per tahun.': '10 to 20 tonnes per ha per year.',
  '200 sampai 400 kg per ha per tahun dibagi empat.': '200 to 400 kg per ha per year split over four applications.',
  'Tanaman layu dan daun menguning.': 'Plants wilt and leaves yellow.',
  'Drainase baik, sanitasi tunggul.': 'Good drainage, clearing stumps.',
  'Daun berlubang sampai habis.': 'Leaves eaten full of holes.',
  'Petik manual, insektisida bila ambang.': 'Hand-pick; insecticide above threshold.',
  'Jeruk': 'Orange',
  'Jeruk Manis': 'Sweet orange',
  'Gunakan bibit bebas penyakit dan pastikan drainase tanah baik.': 'Use disease-free seedlings and make sure soil drainage is good.',
  'Jaga keseimbangan air saat pembuahan agar buah tidak pecah.': 'Balance water at fruit set so the fruit does not split.',
  'Kulit kuning merata dan sedikit lunak tanda buah siap petik.': 'Even yellow skin with slight softness means the fruit is ready to pick.',
  'Lempung berpasir dalam tanpa lapisan keras, drainase baik.': 'Deep sandy loam with no hardpan and good drainage.',
  '0 sampai 1.200 mdpl sesuai varietas': '0 to 1,200 m asl depending on variety',
  'Teratur; genangan memicu busuk akar.': 'Regular; waterlogging triggers root rot.',
  'Panen 2 sampai 3 tahun setelah tanam saat kulit kuning merata dan sedikit lunak; potong tangkai dengan gunting.': 'Harvest 2 to 3 years after planting when the skin is evenly yellow and slightly soft; cut the stem with secateurs.',
  'Pangkas bentuk dan buang tunas air.': 'Prune for shape and remove water shoots.',
  'Jaga kelembapan stabil saat pembuahan.': 'Keep moisture stable at fruit set.',
  'Panen dengan gunting saat warna merata.': 'Harvest with secateurs once the colour is even.',
  'Daun kuning belang, buah kecil keras.': 'Mottled yellow leaves, small hard fruit.',
  'Daun menguning dari tajuk bawah.': 'Leaves yellowing from the lower canopy.',
  'Drainase baik, fungisida bila perlu.': 'Good drainage; fungicide if needed.',
  'Buah Naga': 'Dragon fruit',
  'Tanaman kaktus hemat air; tiang panjat wajib disiapkan.': 'A water-saving cactus; a climbing post is essential.',
  'Bantu penyerbukan manual bila sedikit bunga yang menjadi buah.': 'Hand-pollinate if few of the flowers set fruit.',
  'Panen saat sisik berubah merah dan buah agak lunak.': 'Harvest when the scales turn red and the fruit softens slightly.',
  'Lempung berpasir gembur dengan drainase sangat baik.': 'Loose sandy loam with very good drainage.',
  'Sedikit; tanaman kaktus tahan kering.': 'Low; the cactus tolerates drought.',
  '250 × 250 cm per tiang panjat': '250 x 250 cm per climbing post',
  'Panen mulai umur 1,5 tahun saat sisik merah merata dan buah agak lunak; potong menyertakan tangkai pendek.': 'Harvest from 1.5 years old when the scales are evenly red and the fruit is slightly soft; cut with a short stem.',
  'Ikat sulur pada tiang dan pangkas sulur tidak produktif.': 'Tie the stems to the post and prune unproductive ones.',
  'Bantu penyerbukan manual pada bunga yang mekar malam.': 'Hand-pollinate the night-blooming flowers.',
  'Tipiskan buah, sisakan dua sampai tiga per sulur.': 'Thin the fruit, leaving two or three per stem.',
  '10 sampai 20 kg per tiang per tahun.': '10 to 20 kg per post per year.',
  '0,5 sampai 1 kg per tiang per tahun.': '0.5 to 1 kg per post per year.',
  'Batang lembek kecokelatan.': 'Soft brownish stems.',
  'Drainase baik, potong bagian sakit.': 'Good drainage; cut out diseased parts.',
  'Bercak cokelat pada batang dan buah.': 'Brown spots on stems and fruit.',
  'Seledri': 'Celery',
  'Suka tanah lembap kaya organik dan suhu sejuk.': 'Likes moist organic-rich soil and cool temperatures.',
  'Panen daun luar bertahap atau cabut utuh satu rumpun.': 'Harvest outer leaves in stages or pull a whole plant.',
  'Naungan ringan menjaga daun tetap hijau muda dan renyah.': 'Light shade keeps the leaves pale green and crisp.',
  'Banyak dan merata; tidak tahan kering.': 'High and even; intolerant of drought.',
  '25 × 20 cm': '25 x 20 cm',
  'Panen 60 sampai 90 hari setelah tanam; petik daun luar bertahap atau cabut rumpun utuh.': 'Harvest 60 to 90 days after planting; pick outer leaves in stages or pull whole plants.',
  'Siram pagi dan sore pada musim kering.': 'Water morning and evening in the dry season.',
  'Siangi gulma dengan tangan karena akar dangkal.': 'Weed by hand because the roots are shallow.',
  'Panen daun luar atau cabut utuh satu rumpun.': 'Harvest the outer leaves or pull a whole plant.',
  '150 sampai 250 kg per ha diberikan bertahap.': '150 to 250 kg per ha applied in stages.',
  'Bercak cokelat pada daun dan tangkai.': 'Brown spots on leaves and stalks.',
  'Pangkal batang lembek dan layu.': 'Soft, wilting stem base.',
  'Brokoli': 'Broccoli',
  'Suhu sejuk dataran tinggi membentuk bunga padat dan manis.': 'Cool highland temperatures form dense, sweet heads.',
  'Panen saat kuncup rapat sebelum bunga mekar kuning.': 'Harvest while the buds are tight, before they open yellow.',
  'Sisakan batang setelah panen utama untuk tunas samping.': 'Leave the stem after the main harvest for side shoots.',
  'Lempung subur kaya organik, drainase baik.': 'Fertile organic-rich loam with good drainage.',
  'Teratur dan merata.': 'Regular and even.',
  'Panen 55 sampai 70 hari setelah tanam saat kuncup rapat; potong bunga dengan tangkai, tunas samping menyusul.': 'Harvest 55 to 70 days after planting while the buds are tight; cut the head with its stem, side shoots follow.',
  'Jaga kelembapan stabil agar bunga padat.': 'Keep moisture stable so the head stays dense.',
  'Potong bunga utama dengan tangkai 10 cm.': 'Cut the main head with a 10 cm stem.',
  '250 sampai 350 kg per ha diberikan bertahap.': '250 to 350 kg per ha applied in stages.',
  'Busuk lunak': 'Soft rot',
  'Bunga berlendir dan berbau.': 'Slimy, smelly heads.',
  'Hindari luka, rotasi, sanitasi.': 'Avoid wounds; rotate crops, keep clean.',
  'Bunga berlubang dan kotor.': 'Heads holed and dirty.',
  'Bercak hitam': 'Black spot',
  'Bercak hitam pada daun dan bunga.': 'Black spots on leaves and heads.',
  'Pala': 'Nutmeg',
  'Dua produk bernilai dari satu buah: biji pala dan fuli.': 'Two valuable products from one fruit: nutmeg seed and mace.',
  'Butuh pohon peneduh dan perlindungan angin saat muda.': 'Needs shade trees and wind protection when young.',
  'Panen saat buah pecah alami lalu pisahkan biji dan fuli.': 'Harvest when the fruit splits open, then separate seed and mace.',
  'Lempung vulkanis dalam, subur, drainase baik.': 'Deep, fertile volcanic loam with good drainage.',
  '900 × 900 cm': '900 x 900 cm',
  'Panen 6 sampai 8 tahun setelah tanam saat buah pecah alami; pisahkan biji, fuli, dan daging lalu jemur terpisah.': 'Harvest 6 to 8 years after planting when the fruit splits naturally; separate seed, mace and flesh, then sun-dry each apart.',
  'Beri naungan dan penahan angin saat muda.': 'Provide shade and windbreaks when young.',
  'Sisakan satu pohon jantan per sepuluh pohon betina.': 'Keep one male tree for every ten females.',
  'Kumpulkan buah pecah setiap hari saat musim panen.': 'Collect split fruit daily during the harvest season.',
  'Daun menguning lalu gugur.': 'Leaves yellow, then fall.',
  'Bercak cokelat pada daun muda.': 'Brown spots on young leaves.',
  'Kelapa': 'Coconut',
  'Pilih varietas sesuai tujuan: dalam untuk kopra, genjah untuk buah muda.': 'Match the variety to the goal: tall types for copra, dwarf types for young nuts.',
  'Pemupukan kalium menentukan jumlah dan isi buah.': 'Potassium feeding determines fruit number and kernel fill.',
  'Panen buah tua untuk kopra atau buah muda untuk air dan daging.': 'Harvest mature nuts for copra or young nuts for water and flesh.',
  'Lempung berpasir dalam; toleran wilayah pesisir.': 'Deep sandy loam; tolerant of coastal sites.',
  'Sedang sampai banyak; tahan kering sebentar.': 'Moderate to high; tolerates short dry spells.',
  '800 × 800 cm pola segitiga': '800 x 800 cm in a triangular layout',
  'Panen 5 sampai 6 tahun setelah tanam; buah tua 12 bulan untuk kopra atau buah muda 7 sampai 8 bulan untuk air.': 'Harvest 5 to 6 years after planting; mature nuts at 12 months for copra or young nuts at 7 to 8 months for water.',
  'Bersihkan piringan bawah pohon dari gulma.': 'Keep the weeded circle under the palm clear.',
  'Kembalikan sabut dan janur sebagai mulsa.': 'Return husks and fronds to the soil as mulch.',
  'Sesuaikan umur panen dengan tujuan: buah muda atau tua.': 'Match the harvest age to the goal: young or mature nuts.',
  '1 sampai 3 kg per pohon per tahun untuk isi buah.': '1 to 3 kg per palm per year for kernel fill.',
  'Busuk pucuk': 'Bud rot',
  'Pucuk membusuk dan mudah tercabut.': 'The spear rots and pulls out easily.',
  'Drainase baik, sanitasi tanaman sakit.': 'Good drainage, removing diseased palms.',
  'Kumbang badak': 'Rhinoceros beetle',
  'Pucuk berlubang dan pelepah patah.': 'Holed spears and broken fronds.',
  'Sanitasi sarang, perangkap.': 'Clear breeding sites, use traps.',
  'Salak': 'Salak palm',
  'Sisakan satu pohon jantan per sepuluh betina untuk penyerbukan.': 'Keep one male plant per ten females for pollination.',
  'Tipiskan buah muda untuk ukuran besar dan rasa manis.': 'Thin young fruit for larger size and sweeter taste.',
  'Panen dengan memotong tangkai dompol memakai pisau tajam.': 'Harvest by cutting the bunch stem with a sharp knife.',
  'Lempung kaya organik, lembap, drainase baik.': 'Organic-rich loam, moist, well drained.',
  '100 sampai 700 mdpl': '100 to 700 m asl',
  'Banyak dan merata; tidak tahan genangan lama.': 'High and even; intolerant of prolonged waterlogging.',
  'Teduh parsial hingga penuh saat dewasa.': 'Partial to full shade when mature.',
  '250 × 250 cm': '250 x 250 cm',
  'Panen 3 sampai 4 tahun setelah tanam saat kulit cokelat kekuningan dan duri jarang; potong tangkai dompol.': 'Harvest 3 to 4 years after planting when the skin is yellowish brown and the spines have spread; cut the bunch stem.',
  'Tipiskan buah muda, sisakan dua sampai tiga per dompol.': 'Thin young fruit, leaving two or three per bunch.',
  'Bantu penyerbukan dengan serbuk sari pohon jantan.': 'Assist pollination with pollen from a male plant.',
  'Pangkas pelepah tua untuk akses panen.': 'Prune old fronds for harvest access.',
  'Buah lembek berbau saat lembap.': 'Soft, smelly fruit in humid weather.',
  'Sanitasi, drainase, penjarangan buah.': 'Sanitation, drainage, fruit thinning.',
  'Bercak cokelat pada daun tua.': 'Brown spots on old leaves.',
  'Markisa': 'Passion fruit',
  'Rambatan kuat dan sinar cukup membuat buah lebat.': 'A sturdy trellis and enough light give heavy cropping.',
  'Buah jatuh alami adalah tanda matang terbaik.': 'Naturally fallen fruit is the best sign of ripeness.',
  'Kumpulkan buah jatuh setiap pagi sebelum kulit keriput parah.': 'Collect fallen fruit every morning before the skin wrinkles badly.',
  'Lempung berpasir subur dengan drainase baik.': 'Fertile sandy loam with good drainage.',
  'Teratur; stres air merontokkan buah.': 'Regular; water stress drops the fruit.',
  '300 × 300 cm dengan rambatan': '300 x 300 cm with a trellis',
  'Panen 1 sampai 1,5 tahun setelah tanam saat buah jatuh alami atau warna ungu penuh; kumpulkan tiap pagi.': 'Harvest 1 to 1.5 years after planting when the fruit falls naturally or turns full purple; collect every morning.',
  'Atur sulur pada rambatan agar cahaya merata.': 'Train the stems on the trellis for even light.',
  'Pangkas sulur tidak produktif setelah panen.': 'Prune unproductive stems after harvest.',
  'Kumpulkan buah jatuh setiap pagi.': 'Collect fallen fruit every morning.',
  'Bercak cokelat lalu buah rontok.': 'Brown spots, then the fruit drops.',
  'Virus BWV': 'BWV virus',
  'Daun belang dan buah belang keras.': 'Mottled leaves and hard, mottled fruit.',
  'Bibit bebas virus, cabut tanaman sakit.': 'Virus-free planting material; pull out diseased plants.',
  'Jambu Biji': 'Guava',
  'Penjarangan dan pembungkusan buah menjaga mutu dan bebas ulat.': 'Thinning and bagging keep quality high and worms out.',
  'Tanaman pekarangan produktif sepanjang tahun bila air cukup.': 'Yard trees crop all year when water is sufficient.',
  'Panen saat kulit hijau kekuningan untuk rasa manis segar.': 'Harvest at yellowish green skin for a fresh, sweet taste.',
  'Toleran; lempung subur sampai liat berdrainase baik.': 'Tolerant; from fertile loam to well-drained clay.',
  'Panen 2 sampai 3 tahun setelah tanam saat kulit hijau kekuningan; potong dengan tangkai, jangan ditarik.': 'Harvest 2 to 3 years after planting at yellowish green skin; cut with the stem, do not pull.',
  'Pangkas tajuk agar cahaya masuk dan panen mudah.': 'Prune the canopy so light gets in and harvesting is easy.',
  'Bungkus buah muda dengan plastik atau kertas.': 'Bag young fruit in plastic or paper.',
  'Jarangkan buah untuk ukuran merata.': 'Thin the fruit for even size.',
  'Belatung di dalam buah lalu rontok.': 'Maggots inside the fruit, which then drops.',
  'Pare': 'Bitter melon',
  'Perlu lanjaran; buah menggantung lurus dan mulus.': 'Needs a trellis so the fruit hangs straight and smooth.',
  'Panen buah muda agar pahit tidak berlebihan dan tekstur renyah.': 'Harvest young fruit so it is not too bitter and stays crisp.',
  'Petik setiap dua sampai tiga hari karena panen sangat bertahap.': 'Pick every two to three days because the harvest is very gradual.',
  'Lempung gembur kaya bahan organik.': 'Loose loam rich in organic matter.',
  '100 × 60 cm dengan lanjaran': '100 x 60 cm with trellises',
  'Panen 45 sampai 60 hari setelah tanam saat buah muda hijau kencang; potong menyertakan tangkai pendek.': 'Harvest 45 to 60 days after planting while the young fruit is firm and green; cut with a short stem.',
  'Pasang lanjaran dan atur sulur merata.': 'Set trellises and spread the stems evenly.',
  'Petik buah muda tiap 2 sampai 3 hari.': 'Pick young fruit every 2 to 3 days.',
  'Buang daun tua bagian bawah untuk sirkulasi.': 'Remove lower old leaves for air flow.',
  'Perangkap, sanitasi buah terserang.': 'Traps; remove infested fruit.',
  'Cabai Hijau': 'Green chilli',
  'Cabai Hijau Besar': 'Large green chilli',
  'Panen hijau memberi perputaran cepat dan risiko antraknosa lebih kecil.': 'Harvesting green gives a fast turnover and lower anthracnose risk.',
  'Gunakan mulsa dan ajir untuk menjaga kelembapan dan batang tegak.': 'Use mulch and stakes to hold moisture and keep the stems upright.',
  'Petik dengan tangkai agar buah tidak cepat layu.': 'Pick with the stem so the fruit does not wilt quickly.',
  'Teratur; tidak tahan tanah becek.': 'Regular; intolerant of waterlogged soil.',
  'Panen 75 sampai 90 hari setelah tanam saat buah hijau penuh dan kencang; petik menyertakan tangkai.': 'Harvest 75 to 90 days after planting when the fruit is fully green and firm; pick with the stem.',
  'Pasang mulsa plastik dan ajir.': 'Lay plastic mulch and set stakes.',
  'Pangkas tunas bawah sampai percabangan utama.': 'Prune the lower shoots up to the main fork.',
  'Petik hijau besar setiap 3 sampai 4 hari.': 'Pick large green chillies every 3 to 4 days.',
  // -------------------------------------------- kredit foto dokumentasi pribadi
  'Dokumentasi pribadi Agrinexa': 'Agrinexa personal documentation',
  'Dokumentasi pribadi': 'Personal documentation',
  'Dibagikan langsung ke Agrinexa oleh pemilik foto.': 'Shared directly with Agrinexa by the photo owner.',
  'Lisensi Pexels': 'Pexels licence',
  // ------------------------------------------------ kalkulator pupuk
  'Kalkulator Pupuk': 'Fertiliser calculator',
  'Tanaman': 'Crop',
  'Luas lahan (m²)': 'Land area (m²)',
  'Jumlah tanaman (opsional)': 'Plant count (optional)',
  'kosongkan untuk hitung dari jarak tanam': 'leave blank to compute from plant spacing',
  'Jumlah tanaman': 'Plant count',
  'Jarak tanam': 'Row spacing',
  'Umur panen': 'Days to harvest',
  'Rencana pupuk {0}': 'Fertiliser plan for {0}',
  '{0} m² = {1} ha': '{0} m² = {1} ha',
  '{0} batang': '{0} plants',
  'belum tentu dari jarak tanam': 'not clear from the row spacing',
  'sekitar {0} karung @50 kg': 'about {0} bags @50 kg',
  'Tambahan tanpa dosis tetap': 'Extras without a fixed dose',
  'Tutup penjelasan': 'Hide the explanation',
  'Kenapa dan bagaimana': 'Why and how',
  'Jadwal pemberian': 'When to apply',
  'Cara aplikasi': 'How to apply',
  'Bila kekurangan': 'If too little',
  'Bila terlalu banyak': 'If too much',
  'Batas aman': 'Safe limit',
  'sebelum tanam': 'before planting',
  'minggu ke-{0}–{1}': 'week {0}–{1}',
  'Panduan tanaman ini belum mencantumkan dosis angka, jadi hitungannya belum bisa dibuat. Lihat daftar tambahan di bawah.':
      'This crop guide has no numeric dose yet, so no calculation can be made. See the extras listed below.',
  'Angka ini dihitung dari dosis anjuran umum dan luas lahan Anda. Uji tanah dan penyuluh (PPL) setempat lebih akurat karena mereka melihat tanah Anda langsung. Beri lebih sedikit daripada membuang pupuk: kelebihan tidak membuat panen lebih banyak.':
      'These figures come from general recommended doses and your land area. A soil test and your local extension officer are more accurate because they see your soil. Under-feed rather than waste fertiliser: more does not mean a bigger harvest.',
  'Bandingkan Komoditas 📊': 'Compare commodities 📊',
  'Pilih 2–3 komoditas dari daftar untuk membandingkannya.':
      'Pick 2–3 commodities from the list to compare them.',
  'Grafik Radar Perbandingan': 'Comparison radar chart',
  '{0} tanggal · {1} perubahan harga tercatat di Supabase':
      '{0} dates · {1} price changes recorded in Supabase',
  '{0} tanggal · {1} perubahan harga di Supabase, angkanya masih contoh':
      '{0} dates · {1} price changes in Supabase, but the figures are still placeholders',
  'Baru ada harga hari ini — riwayat perubahan belum tercatat':
      'Only today has a price — no change history recorded yet',
  'Grafik masih simulasi — belum ada riwayat nyata':
      'Chart is still a simulation — no real history yet',
  'Perbandingan Detail': 'Detailed comparison',
  'Kriteria': 'Criteria',
  'Target & Pencapaian 🎯': 'Goals & achievements 🎯',
  'Update Pencapaian': 'Update progress',
  'Tambah Target': 'Add goal',
  'Pencapaian 🏅': 'Achievements 🏅',
  'Target Musim Tanam': 'Planting season goals',
  '📊': '📊',
  'Ringkasan Semua Target': 'Summary of all goals',
  '🏆 Tercapai': '🏆 Achieved',
  'Target Baru 🎯': 'New goal 🎯',
  'Nama target (misalnya: "Musim cabai Nov-Jan")':
      'Goal name (for example: "Chili season Nov-Jan")',
  'Nama musim tanam atau target': 'Season or goal name',
  'Target penghasilan': 'Income target',
  'Tetapkan Target': 'Set goal',
  'Jurnal Kebun 📔': 'Farm journal 📔',
  'Tulis': 'Write',
  'Catat Hari Ini': 'Log today',
  'Catatan Hari Ini': "Today's log",
  'Kondisi kebun': 'Farm condition',
  'Data hari ini, panen esok 🌾': "Today's data, tomorrow's harvest 🌾",

  // ------------------------------------ data: nama 30 hama & penyakit tambahan
  'Busuk Kelabu Stroberi (Botrytis)': 'Strawberry Grey Mould (Botrytis)',
  'CVPD / Huanglongbing Jeruk': 'Citrus CVPD / Huanglongbing',
  'Karat Daun Kopi (Hemileia)': 'Coffee Leaf Rust (Hemileia)',
  'Penggerek Buah Kakao (PBK)': 'Cocoa Pod Borer (PBK)',
  'Layu Fusarium / Penyakit Panama': 'Fusarium Wilt / Panama Disease',
  'Lalat Buah Mangga': 'Mango Fruit Fly',
  'Busuk Umbi Singkong': 'Cassava Tuber Rot',
  'Penggerek Pucuk & Batang Tebu': 'Sugarcane Shoot and Stem Borer',
  'Ulat Tanah & Kutu Tembakau': 'Cutworms and Aphids on Tobacco',
  'Busuk Putih Bawang Putih': 'Garlic White Rot',
  'Bercak Daun Wortel (Alternaria)': 'Carrot Leaf Blight (Alternaria)',
  'Karat Daun Buncis (Uromyces)': 'Bean Rust (Uromyces)',
  'Ulat & Kutu pada Kangkung-Bayam': 'Caterpillars and Aphids on Water Spinach',
  'Busuk Buah Labu & Timun (Phytophthora)':
      'Pumpkin and Cucumber Fruit Rot (Phytophthora)',
  'Virus Mosaik & Kutu pada Paprika': 'Mosaic Virus and Aphids on Bell Pepper',
  'Busuk Batang & Akar Durian (Phytophthora)':
      'Durian Stem and Root Rot (Phytophthora)',
  'Busuk Buah & Getah Kuning Manggis': 'Mangosteen Fruit Rot and Yellow Sap',
  'Busuk Batang Vanili (Fusarium)': 'Vanilla Stem Rot (Fusarium)',
  'Kepik Helopeltis (Pengisap Buah)': 'Helopeltis Bug (Fruit Sucker)',
  'Blister Blight & Cacar Daun Teh': 'Tea Blister Blight and Leaf Scab',
  'Busuk Bunga & Gugur Daun Cengkeh': 'Clove Flower Rot and Leaf Fall',
  'Busuk Pangkal Batang (Ganoderma)': 'Basal Stem Rot (Ganoderma)',
  'Jamur Upas & Alur Sadap Karet': 'Pink Disease and Rubber Tapping Panel Rot',
  'Kudis & Busuk Buah Apel': 'Apple Scab and Fruit Rot',
  'Embun Tepung & Busuk Buah Anggur': 'Grape Powdery Mildew and Bunch Rot',
  'Busuk Hati & Bintik Nanas': 'Pineapple Heart Rot and Fruit Spot',
  'Kutu Perisai & Busuk Pangkal Lada': 'Scale Insects and Pepper Base Rot',
  'Ulat Bulu & Busuk Buah Sirsak': 'Hairy Caterpillars and Soursop Fruit Rot',
  'Layu Bakteri (Ralstonia)': 'Bacterial Wilt (Ralstonia)',
  'Embun Bulu (Downy Mildew)': 'Downy Mildew',

  // ------------------------------- data: ringkasan 30 hama & penyakit tambahan
  'Jamur abu-abu pada buah matang di cuaca lembap.':
      'Grey fuzzy mould on ripe fruit in humid weather.',
  'Penyakit bakteri mematikan jeruk, dibawa kutu Diaphorina.':
      'A deadly citrus bacterial disease carried by Diaphorina psyllids.',
  'Bubuk oranye di bawah daun kopi penyebab gugur daun.':
      'Orange powder under coffee leaves that makes them fall.',
  'Ulat menggerek biji kakao dari dalam buah.':
      'A larva that bores cocoa beans from inside the pod.',
  'Jamur tular tanah mematikan pada pisang.':
      'A deadly soil-borne fungus on banana.',
  'Belatung dalam buah mangga menjelang matang.':
      'Maggots inside mango fruit as it ripens.',
  'Jamur / bakteri pembusuk umbi saat panen dan simpan.':
      'Fungal or bacterial tuber rot at harvest and in storage.',
  'Ulat menggerek pucuk dan ruas batang tebu.':
      'A larva that bores sugarcane shoots and stem internodes.',
  'Pemotong bibit dan pengisap daun tembakau.':
      'Seedling cutters and leaf suckers on tobacco.',
  'Jamur Sclerotium dengan miselium putih pada umbi.':
      'A Sclerotium fungus with white mycelium on the bulbs.',
  'Bercak cokelat pada daun wortel menurunkan fotosintesis.':
      'Brown spots on carrot leaves reduce photosynthesis.',
  'Bintik karat cokelat pada daun buncis dan kacang.':
      'Rusty brown spots on bean and legume leaves.',
  'Pemakan daun cepat pada sayuran daun panen pendek.':
      'Fast leaf eaters on short-cycle leafy vegetables.',
  'Busuk basah pada buah cucurbitaceae di tanah basah.':
      'Watery rot on cucurbit fruit lying on wet soil.',
  'Mosaik daun dan buah belang akibat virus bawaan kutu.':
      'Mottled leaves and striped fruit from an aphid-borne virus.',
  'Jamur pembusuk batang dan akar pada durian dan manggis.':
      'A stem and root rot fungus on durian and mangosteen.',
  'Getah kuning dan busuk buah menurunkan mutu ekspor.':
      'Yellow sap and fruit rot that lower export grade.',
  'Jamur pembusuk batang merambat pada vanili.':
      'A stem rot fungus on climbing vanilla vines.',
  'Kepik pengisap buah dan pucuk pada kakao, teh, dan jambu.':
      'A sucking bug on young fruit and shoots of cocoa, tea and guava.',
  'Jamur penyebab cacar dan lepuh pada daun teh muda.':
      'A fungus causing scabs and blisters on young tea leaves.',
  'Jamur penyebab gugur bunga dan daun cengkeh.':
      'A fungus that makes clove flowers and leaves drop.',
  'Jamur mematikan pangkal batang kelapa sawit dan karet.':
      'A deadly basal rot fungus on oil palm and rubber.',
  'Jamur pada cabang dan luka sadap pohon karet.':
      'A fungus on branches and tapping wounds of rubber trees.',
  'Kudis daun dan busuk buah pada apel dataran tinggi.':
      'Leaf scab and fruit rot on highland apple.',
  'Lapisan putih tepung dan busuk tandan anggur.':
      'A powdery white coating and rotting grape bunches.',
  'Busuk hati dan bercak buah pada nanas.':
      'Heart rot and fruit spots on pineapple.',
  'Kutu pengisap dan jamur pembusuk pangkal lada.':
      'Sucking scales and a basal rot fungus on pepper vines.',
  'Pemakan daun dan busuk buah pada sirsak dan belimbing.':
      'Leaf eaters and fruit rot on soursop and starfruit.',
  'Layu mendadak akibat bakteri tular tanah pada sayuran.':
      'Sudden wilt from a soil-borne bacterium on vegetables.',
  'Jamur embun bulu pada daun timun dan sayuran daun.':
      'A downy mildew fungus on cucumber and leafy vegetable leaves.',

  // -------------------- data: gejala, pencegahan & penanganan 30 hama tambahan
  'Buah matang berbulu abu-abu dan lembek dari ujung.':
      'Ripe fruit turns grey-fuzzy and soft from the tip.',
  'Bunga mengering dan mati sebelum jadi buah.':
      'Flowers dry up and die before setting fruit.',
  'Menyebar cepat saat hujan berkepanjangan dan tajuk rapat.':
      'Spreads fast during prolonged rain and in a dense canopy.',
  'Mulsa plastik / jerami agar buah tidak menyentuh tanah basah.':
      'Plastic or straw mulch so fruit never touches wet soil.',
  'Jarak tanam longgar dan pangkas daun tua rutin.':
      'Loose spacing and routine removal of old leaves.',
  'Siram pagi ke tanah, hindari membasahi buah dan bunga.':
      'Water the soil in the morning; keep fruit and flowers dry.',
  'Petik buah terinfeksi tiap pagi, buang jauh dari lahan.':
      'Pick infected fruit every morning and dispose of it far from the field.',
  'Fungisida berbahan aktif berbeda bergantian saat lembap tinggi.':
      'Rotate fungicide active ingredients when humidity is high.',
  'Belang kuning tidak simetris pada daun (bukan kuning seragam).':
      'Asymmetric yellow blotches on leaves, not uniform yellowing.',
  'Buah kecil, miring, dan masam dengan biji kempis.':
      'Small, lopsided, sour fruit with shrivelled seeds.',
  'Tunas baru kaku, pendek, dan menguning seperti roset.':
      'New shoots stiff, short and yellowed like a rosette.',
  'Gunakan bibit bersertifikat bebas CVPD.':
      'Use certified CVPD-free seedlings.',
  'Kendalikan vektor kutu Diaphorina dengan insektisida terjadwal.':
      'Control the Diaphorina vector with scheduled insecticide.',
  'Cabut segera pohon tertular agar tidak jadi sumber penularan.':
      'Uproot infected trees at once so they are not a source of spread.',
  'Belum ada obat; bongkar dan bakar pohon positif.':
      'There is no cure yet; dig out and burn positive trees.',
  'Sanitasi kebun dan kontrol vektor ketat pada tanaman sehat.':
      'Sanitate the orchard and control vectors strictly on healthy trees.',
  'Bercak kuning di permukaan daun, bubuk oranye di baliknya.':
      'Yellow spots on the leaf surface, orange powder underneath.',
  'Daun gugur dini sehingga cabang gundul dari bawah.':
      'Leaves fall early, leaving branches bare from below.',
  'Produksi turun drastis pada musim hujan berkepanjangan.':
      'Yield drops sharply in a prolonged rainy season.',
  'Tanam varietas tahan (mis. sebagian robusta) dan naungan cukup.':
      'Plant tolerant varieties, for example some robusta, with enough shade.',
  'Pangkas teratur agar tajuk tidak lembap dan rapat.':
      'Prune regularly so the canopy is not damp and dense.',
  'Pupuk berimbang; tanaman stres lebih rentan.':
      'Balanced fertiliser; stressed plants are more susceptible.',
  'Fungisida tembaga (Cu) saat awal musim hujan.':
      'Copper fungicide at the start of the rainy season.',
  'Kumpulkan dan bakar daun gugur untuk menekan inokulum.':
      'Collect and burn fallen leaves to reduce inoculum.',
  'Buah muda belang-belang dan bentuk tidak normal.':
      'Young pods turn mottled and misshapen.',
  'Biji lengket satu sama lain dan berwarna cokelat kehitaman.':
      'Beans stick to one another and turn dark brown.',
  'Lubang keluar kecil pada kulit buah saat ulat dewasa keluar.':
      'Small exit holes on the pod skin when mature larvae leave.',
  'Panen sering (tiap 7 hari) dan sanitasi buah terserang.':
      'Harvest often, every 7 days, and sanitise attacked pods.',
  'Pangkas dan atur naungan agar tajuk tidak terlalu rimbun.':
      'Prune and manage shade so the canopy is not too dense.',
  'Sarang semut hitam (Dolichoderus) sebagai musuh alami.':
      'Black ant (Dolichoderus) nests act as natural enemies.',
  'Kumpulkan dan benamkan buah terserang > 30 cm.':
      'Collect attacked pods and bury them deeper than 30 cm.',
  'Insektisida hanya pada ambang ekonomi, rotasi bahan aktif.':
      'Insecticide only above threshold; rotate active ingredients.',
  'Daun tua menguning dari tepi lalu layu dan patah pada pelepah.':
      'Old leaves yellow from the edge, then wilt and snap at the petiole.',
  'Belahan batang dalam berwarna cokelat kemerahan.':
      'The inner pseudostem turns reddish brown.',
  'Tanaman mati meski tanah lembap; menyebar lewat air dan alat.':
      'Plants die even in moist soil; it spreads via water and tools.',
  'Bibit kultur jaringan bebas penyakit, bukan anakan dari kebun sakit.':
      'Tissue-culture seedlings free of disease, not suckers from sick fields.',
  'Rotasi lahan dan drainase baik; hindari lahan endemik.':
      'Rotate the land and drain it well; avoid endemic areas.',
  'Sterilkan alat kerja antar blok kebun.':
      'Sterilise tools between field blocks.',
  'Bongkar dan bakar rumpun sakit termasuk bonggolnya.':
      'Dig out and burn sick clumps together with the corm.',
  'Taburi dolomit / Trichoderma pada lubang bekas untuk menekan jamur.':
      'Apply dolomite or Trichoderma in the hole to suppress the fungus.',
  'Titik tusukan hitam pada kulit buah muda.':
      'Black sting points on the skin of young fruit.',
  'Daging buah berlubang dan busuk dari dalam saat matang.':
      'Flesh holed and rotting from inside once ripe.',
  'Buah jatuh sebelum waktunya dengan belatung di dalamnya.':
      'Fruit drops early with maggots inside.',
  'Bungkus buah dengan kertas sejak pentil sebesar telur.':
      'Bag the fruit with paper from egg size onward.',
  'Perangkap metil eugenol 10–20 per hektar.':
      'Methyl eugenol traps, 10 to 20 per hectare.',
  'Bersihkan buah jatuh harian untuk memutus siklus.':
      'Clear fallen fruit daily to break the cycle.',
  'Kumpulkan buah terserang, kubur atau rendam air garam.':
      'Collect attacked fruit, then bury it or soak it in salt water.',
  'Umpan protein + insektisida pada titik hinggap sore hari.':
      'Protein bait plus insecticide on resting spots in the evening.',
  'Umbi berbau asam dan berlendir cokelat saat dibelah.':
      'Tubers smell sour and turn slimy brown when cut open.',
  'Daun layu mendadak meski hujan cukup.':
      'Leaves wilt suddenly even when rain is adequate.',
  'Bercak hitam cekung pada kulit umbi di lahan.':
      'Sunken black spots on tuber skin in the field.',
  'Stek dari batang sehat; rendam fungisida sebelum tanam.':
      'Cuttings from healthy stems; dip in fungicide before planting.',
  'Panen tepat umur, jangan tunda saat tanah basah.':
      'Harvest on time; do not delay while the soil is wet.',
  'Keringkan umbi sebelum disimpan; hindari luka mekanis.':
      'Dry tubers before storage and avoid mechanical wounds.',
  'Buang umbi busuk dari gudang agar tidak menular.':
      'Remove rotten tubers from the store so it does not spread.',
  'Rotasi 2 musim dengan tanaman bukan inang pada lahan endemik.':
      'Rotate two seasons with non-host crops on endemic land.',
  'Pucuk mati dan mengering (dead heart) mudah dicabut.':
      'Dead heart: the shoot dries up and pulls out easily.',
  'Lubang gerek pada ruas dengan serbuk gerek di sekitarnya.':
      'Bore holes on internodes with frass around them.',
  'Batang berbobot ringan dan kadar gula turun.':
      'Canes turn light and sugar content drops.',
  'Tanam varietas tahan dan bibit sehat.':
      'Plant resistant varieties and healthy seedlings.',
  'Lepaskan parasit Trichogramma saat awal musim.':
      'Release Trichogramma parasitoids early in the season.',
  'Sanitasi sisa tanaman dan gulma inang.':
      'Sanitate crop residues and host weeds.',
  'Insektisida sistemik pada fase tunas bila serangan di atas ambang.':
      'Systemic insecticide at shoot stage when attack passes threshold.',
  'Cabut dan bakar pucuk mati untuk mengurangi sumber ulat.':
      'Pull and burn dead hearts to cut the larval source.',
  'Bibit terpotong pangkalnya pada malam hari.':
      'Seedlings are cut at the base overnight.',
  'Daun berlubang dan keriting akibat isapan kutu.':
      'Leaves turn holed and curled from aphid feeding.',
  'Pertumbuhan terhambat dan daun bawah menguning.':
      'Growth stalls and lower leaves yellow.',
  'Olah tanah baik dan sanitasi gulma sebelum tanam.':
      'Good tillage and weed sanitation before planting.',
  'Perangkap cahaya untuk memantau ngengat ulat tanah.':
      'Light traps to monitor cutworm moths.',
  'Jaga jarak tanam agar daun tidak saling lembap.':
      'Keep spacing so leaves do not stay damp against each other.',
  'Tabur insektisida granula di sekitar pangkal bibit sore hari.':
      'Spread granular insecticide around seedling bases in the evening.',
  'Semprot insektisida kontak pada daun bila populasi kutu naik.':
      'Spray contact insecticide on leaves when aphid numbers rise.',
  'Miselium putih seperti kapas pada pangkal batang dan umbi.':
      'Cotton-like white mycelium on the stem base and bulb.',
  'Umbi lunak berair lalu mengering dan berongga.':
      'Bulbs turn soft and watery, then dry and hollow.',
  'Bintik hitam kecil (sklerotia) pada sisa tanaman di tanah.':
      'Small black sclerotia on crop residue in the soil.',
  'Umbi bibit sehat dan rotasi 3–4 tahun dengan bukan bawang-bawangan.':
      'Healthy seed bulbs and a 3 to 4 year rotation with non-alliums.',
  'Drainase baik; hindari tanah terlalu basah berkepanjangan.':
      'Good drainage; avoid soil that stays too wet.',
  'Solarisasi tanah atau biofungisida sebelum tanam.':
      'Soil solarisation or biofungicide before planting.',
  'Cabut tanaman sakit beserta tanah sekitarnya, bakar.':
      'Uproot sick plants with the surrounding soil and burn them.',
  'Fungisida pada infeksi awal hanya memperlambat, bukan menyembuhkan.':
      'Fungicide on early infection only slows it, it does not cure.',
  'Bercak cokelat tua berbatas kuning pada tepi daun.':
      'Dark brown spots with yellow margins on the leaf edges.',
  'Daun mengering dari pinggir dan tanaman tampak gosong.':
      'Leaves dry from the edge and plants look scorched.',
  'Umbi kecil karena daun rusak mengurangi pengisian.':
      'Roots stay small because damaged leaves reduce filling.',
  'Benih bersertifikat dan perlakuan benih fungisida.':
      'Certified seed plus a fungicide seed treatment.',
  'Jarak tanam cukup dan irigasi ke tanah, bukan daun.':
      'Enough spacing and irrigation to the soil, not the leaves.',
  'Rotasi 2 musim dengan tanaman beda famili.':
      'Rotate two seasons with a different plant family.',
  'Fungisida kontak (mancozeb) saat gejala pertama muncul.':
      'Contact fungicide (mancozeb) when the first symptoms appear.',
  'Buang daun terinfeksi berat dari lahan.':
      'Remove heavily infected leaves from the field.',
  'Bintik kecil cokelat-karat menonjol di bawah daun.':
      'Small raised rust-brown pustules under the leaves.',
  'Daun menguning lalu gugur sebelum waktunya.':
      'Leaves yellow then fall before their time.',
  'Polong kecil dan biji tidak penuh pada serangan berat.':
      'Small pods and unfilled seeds under heavy attack.',
  'Varietas tahan dan jarak tanam longgar.':
      'Resistant varieties and loose spacing.',
  'Hindari penyiraman overhead sore hari.':
      'Avoid overhead watering in the evening.',
  'Rotasi tanaman dan sanitasi sisa panen.':
      'Crop rotation and sanitation of harvest residue.',
  'Fungisida berbahan aktif berbeda bergantian tiap 7–10 hari.':
      'Rotate fungicide active ingredients every 7 to 10 days.',
  'Petik dan buang daun terinfeksi awal.':
      'Pick and remove the first infected leaves.',
  'Lubang tidak beraturan pada daun muda.': 'Irregular holes on young leaves.',
  'Kotoran ulat hitam menempel di permukaan daun.':
      'Black caterpillar frass sticking to the leaf surface.',
  'Koloni kutu hijau di balik daun membuat daun keriting.':
      'Green aphid colonies under leaves make them curl.',
  'Jaring halus sejak semai untuk menghalangi ngengat bertelur.':
      'Fine netting from seeding, to block moths laying eggs.',
  'Rotasi cepat dan sanitasi sisa panen.':
      'Fast rotation and sanitation of harvest residue.',
  'Tanam serempak per bedengan agar panen bersamaan.':
      'Plant each bed at once so harvest is simultaneous.',
  'Semprot Bt atau insektisida nabati karena panen dekat.':
      'Spray Bt or a botanical insecticide since harvest is near.',
  'Kumpulkan ulat manual pagi hari pada lahan kecil.':
      'Collect caterpillars by hand in the morning on small plots.',
  'Bercak basah kebasahan pada sisi buah menyentuh tanah.':
      'Water-soaked spots on the fruit side touching the soil.',
  'Busuk meluas cepat dengan bau tanah pada cuaca lembap.':
      'Rot spreads fast with an earthy smell in humid weather.',
  'Daun layu mendadak meski air cukup (infeksi pangkal).':
      'Leaves wilt suddenly despite enough water, from crown infection.',
  'Mulsa dan ajir agar buah tidak menempel tanah basah.':
      'Mulch and trellis so fruit never lies on wet soil.',
  'Drainase baik dan irigasi tetes, hindari genangan.':
      'Good drainage and drip irrigation; avoid puddles.',
  'Rotasi 2–3 musim dengan bukan cucurbitaceae.':
      'Rotate two or three seasons with non-cucurbits.',
  'Buang buah terinfeksi jauh dari lahan.':
      'Dispose of infected fruit far from the field.',
  'Fungisida sistemik (metalaksil) pada infeksi awal pangkal batang.':
      'Systemic fungicide (metalaxyl) on early crown infection.',
  'Belang hijau-muda/kuning tidak beraturan pada daun.':
      'Irregular light green and yellow mottling on leaves.',
  'Daun keriput, mengecil, dan tanaman kerdil.':
      'Wrinkled, shrunken leaves and stunted plants.',
  'Buah belang dan bentuk tidak normal.': 'Mottled, misshapen fruit.',
  'Bibit bebas virus dan sanitasi alat serta tangan pekerja.':
      'Virus-free seedlings plus sanitation of tools and hands.',
  'Kendalikan vektor kutu daun dan thrips sejak pembibitan.':
      'Control aphid and thrips vectors from the nursery stage.',
  'Cabut tanaman bergejala awal agar tidak jadi sumber.':
      'Uproot early symptomatic plants so they are not a source.',
  'Tidak ada obat virus; bongkar tanaman tertular.':
      'There is no cure for the virus; remove infected plants.',
  'Fokus pada pengendalian vektor untuk tanaman sehat.':
      'Focus on vector control to protect healthy plants.',
  'Bercak basah cokelat pada pangkal batang, sering keluar lendir.':
      'Wet brown lesions on the trunk base, often oozing.',
  'Daun menguning dari tajuk bawah lalu gugur.':
      'Leaves yellow from the lower canopy then fall.',
  'Akar halus membusuk dan berbau tanah saat digali.':
      'Fine roots rot and smell earthy when dug up.',
  'Drainase baik; jangan menimbun tanah terlalu tinggi di pangkal.':
      'Drain well; do not pile soil too high at the base.',
  'Bibit dari entres sehat dan lahan tidak tergenang.':
      'Seedlings from healthy scions on land that never floods.',
  'Hindari luka mekanis pada pangkal batang saat pemeliharaan.':
      'Avoid mechanical wounds on the trunk base during care.',
  'Kerok jaringan sakit lalu oles fungisida sistemik pada luka.':
      'Scrape out sick tissue, then paint systemic fungicide on the wound.',
  'Suntik / kocor fungisida fosfit pada pohon berharga tinggi.':
      'Inject or drench phosphite fungicide on high-value trees.',
  'Getah kuning mengeras pada kulit dan daging buah.':
      'Hardened yellow sap on the skin and in the flesh.',
  'Bercak cokelat cekung pada kulit buah menjelang panen.':
      'Sunken brown spots on fruit skin nearing harvest.',
  'Buah busuk dari dalam meski kulit tampak normal.':
      'Fruit rots from inside while the skin looks normal.',
  'Kurangi stres air: irigasi teratur saat pengisian buah.':
      'Reduce water stress: irrigate regularly during fruit fill.',
  'Sanitasi buah jatuh dan pangkas cabang sakit.':
      'Sanitate fallen fruit and prune sick branches.',
  'Panen tepat masak dengan gunting, hindari buah jatuh.':
      'Harvest at the right maturity with shears; never drop the fruit.',
  'Sortir ketat; buah bergetah tidak layak jual.':
      'Sort strictly; sap-stained fruit cannot be sold.',
  'Fungisida protektif saat musim hujan pada tajuk buah.':
      'Protective fungicide on the fruiting canopy in the rainy season.',
  'Bercak cokelat kehitaman memanjang pada ruas batang.':
      'Lengthwise blackish brown lesions on the stem nodes.',
  'Batang mengering dari titik infeksi ke atas.':
      'The stem dries upward from the infection point.',
  'Daun menguning lalu rontok pada ruas terserang.':
      'Leaves yellow then drop on attacked nodes.',
  'Naungan cukup dan sirkulasi udara baik di para-para.':
      'Enough shade and good air flow on the trellis.',
  'Stek bibit sehat; hindari luka saat pengikatan.':
      'Healthy cuttings; avoid wounds when tying the vines.',
  'Sanitasi bagian sakit segera setelah terlihat.':
      'Sanitate sick parts as soon as you see them.',
  'Potong batang sakit 10 cm di bawah bercak, bakar.':
      'Cut the sick stem 10 cm below the lesion and burn it.',
  'Oles / semprot fungisida pada bekas potongan dan sekitarnya.':
      'Paint or spray fungicide on the cut and its surroundings.',
  'Bercak cekung hitam pada buah muda dan pucuk.':
      'Sunken black spots on young fruit and shoots.',
  'Pucuk mati dan cabang berbentuk seperti sapu.':
      'Dead shoots and branches shaped like a broom.',
  'Buah muda gugur atau berbentuk tidak normal.':
      'Young fruit drops or grows misshapen.',
  'Naungan teratur mengurangi populasi kepik.':
      'Regular shade keeps bug populations down.',
  'Sanitasi dan panen sering memutus sumber makanan.':
      'Sanitation and frequent harvest cut off the food source.',
  'Konservasi musuh alami (semut, laba-laba).':
      'Conserve natural enemies such as ants and spiders.',
  'Semprot insektisida kontak sore hari saat populasi naik.':
      'Spray contact insecticide in the evening when numbers rise.',
  'Fokus pada buah muda dan pucuk sebagai sasaran.':
      'Aim at young fruit and shoots as the target.',
  'Bercak transparan lalu lepuh putih pada daun muda.':
      'Translucent spots then white blisters on young leaves.',
  'Daun muda melengkung dan mati sebelum dipetik.':
      'Young leaves curl and die before plucking.',
  'Produksi pucuk turun pada musim hujan lembap.':
      'Shoot production drops in the humid rainy season.',
  'Pangkas naungan agar cahaya dan udara masuk.':
      'Prune the shade so light and air get in.',
  'Petik sering agar daun muda tidak menumpuk.':
      'Pluck often so young leaves do not pile up.',
  'Hindari kebun terlalu rapat dan lembap.':
      'Avoid a plantation that is too dense and damp.',
  'Fungisida tembaga saat awal musim hujan.':
      'Copper fungicide at the start of the rainy season.',
  'Buang pucuk terinfeksi saat pemetikan.':
      'Remove infected shoots while plucking.',
  'Bunga menghitam dan gugur sebelum panen.':
      'Flowers blacken and fall before harvest.',
  'Bercak cokelat pada daun lalu gugur massal.':
      'Brown spots on leaves, then mass leaf fall.',
  'Tajuk menipis dan produksi turun drastis.':
      'The canopy thins and production drops drastically.',
  'Naungan cukup pada tanaman muda dan drainase baik.':
      'Enough shade for young trees and good drainage.',
  'Sanitasi bunga dan daun gugur di bawah tajuk.':
      'Sanitate fallen flowers and leaves under the canopy.',
  'Pupuk berimbang agar tanaman tidak stres.':
      'Balanced fertiliser so the trees are not stressed.',
  'Fungisida kontak saat awal musim berbunga lembap.':
      'Contact fungicide at the start of a humid flowering season.',
  'Kumpulkan dan bakar sisa bunga gugur.':
      'Collect and burn fallen flower residue.',
  'Daun tombak (spear) tidak membuka dan menguning.':
      'Spear leaves fail to open and turn yellow.',
  'Tubuh buah jamur seperti kipas pada pangkal batang.':
      'Fan-shaped fungal fruiting bodies at the trunk base.',
  'Pangkal batang berongga dan tanaman miring lalu roboh.':
      'The trunk base hollows out; the tree tilts then collapses.',
  'Sanitasi tunggul dan sisa kayu saat pembukaan lahan.':
      'Sanitate stumps and wood residue when clearing land.',
  'Aplikasi Trichoderma pada lubang tanam dan sekitar pangkal.':
      'Apply Trichoderma in planting holes and around the base.',
  'Hindari luka mekanis pada pangkal batang.':
      'Avoid mechanical wounds on the trunk base.',
  'Bongkar dan bakar tanaman sakit beserta akarnya.':
      'Dig out and burn sick plants together with their roots.',
  'Isolasi area dengan parit agar miselium tidak menjalar.':
      'Isolate the area with a trench so mycelium cannot spread.',
  'Lapisan putih-merah muda seperti sarang pada cabang.':
      'A pinkish white crust like a nest on the branches.',
  'Cabang mati dan daun menggantung cokelat.':
      'Dead branches with brown leaves still hanging.',
  'Panel sadap busuk dan alur tidak pulih.':
      'The tapping panel rots and the groove never recovers.',
  'Jarak tanam dan pangkas agar tajuk tidak lembap.':
      'Spacing and pruning so the canopy stays dry.',
  'Sadap sesuai aturan agar luka tidak terlalu dalam.':
      'Tap by the rules so the wound is not too deep.',
  'Oles fungisida pada panel sadap saat musim hujan.':
      'Paint fungicide on tapping panels in the rainy season.',
  'Kerok jaringan jamur lalu oles fungisida pada luka.':
      'Scrape off the fungal tissue, then paint fungicide on the wound.',
  'Potong cabang terinfeksi berat dan bakar.':
      'Cut and burn heavily infected branches.',
  'Bercak hijau-zaitun berbulu pada daun dan buah muda.':
      'Fuzzy olive-green spots on leaves and young fruit.',
  'Buah bercak gabus dan bentuk tidak normal.':
      'Corky spots and misshapen fruit.',
  'Busuk cokelat melingkar pada buah matang di simpan.':
      'Circular brown rot on ripe fruit in storage.',
  'Pangkas tajuk agar cepat kering setelah hujan.':
      'Prune the canopy so it dries quickly after rain.',
  'Varietas tahan dan sanitasi daun gugur.':
      'Resistant varieties and sanitation of fallen leaves.',
  'Fungisida protektif terjadwal saat musim hujan.':
      'Scheduled protective fungicide during the rainy season.',
  'Fungisida sistemik + kontak bergantian saat gejala awal.':
      'Alternate systemic and contact fungicide at early symptoms.',
  'Sortir buah bercak sebelum penyimpanan.':
      'Sort spotted fruit before storage.',
  'Lapisan putih seperti tepung pada daun dan buah muda.':
      'A flour-like white coating on leaves and young fruit.',
  'Daun keriting dan mengering dari tepi.':
      'Leaves curl and dry from the edge.',
  'Tandan buah berjamur abu-abu dan rontok.':
      'Bunches turn grey-mouldy and shatter.',
  'Pangkas dan atur kanopi agar udara lancar.':
      'Prune and manage the canopy so air flows.',
  'Hindari penyiraman overhead; siram ke tanah.':
      'Avoid overhead watering; water the soil instead.',
  'Buang daun dan tandan terinfeksi awal.':
      'Remove the first infected leaves and bunches.',
  'Fungisida belerang / sistemik saat gejala pertama.':
      'Sulphur or systemic fungicide at the first symptoms.',
  'Ulangi 7–10 hari pada musim lembap.':
      'Repeat every 7 to 10 days in the humid season.',
  'Daun pusat mudah dicabut dan berbau busuk.':
      'Central leaves pull out easily and smell rotten.',
  'Bercak cokelat cekung pada kulit buah.': 'Sunken brown spots on fruit skin.',
  'Buah kecil dan rasa hambar pada serangan berat.':
      'Small fruit and a bland taste under heavy attack.',
  'Drainase baik; nanas tidak tahan genangan.':
      'Drain well; pineapple cannot stand waterlogging.',
  'Bibit sehat dan perlakuan fungisida sebelum tanam.':
      'Healthy seedlings and fungicide treatment before planting.',
  'Sanitasi sisa panen dan gulma inang.':
      'Sanitate harvest residue and host weeds.',
  'Buang tanaman busuk hati beserta akarnya.':
      'Remove heart-rot plants together with their roots.',
  'Fungisida pada infeksi awal hanya memperlambat.':
      'Fungicide on early infection only slows it down.',
  'Bintik cokelat menempel seperti perisai pada daun dan batang.':
      'Brown shield-like dots stuck on leaves and stems.',
  'Daun menguning dan rontok dari bawah.': 'Leaves yellow and fall from below.',
  'Pangkal batang membusuk dan tanaman layu mendadak.':
      'The stem base rots and plants wilt suddenly.',
  'Naungan dan drainase baik; hindari tanah tergenang.':
      'Good shade and drainage; avoid waterlogged soil.',
  'Sanitasi gulma dan sisa tanaman di sekitar tiang panjat.':
      'Sanitate weeds and residue around the support posts.',
  'Kendalikan semut yang memelihara kutu.':
      'Control the ants that farm the scales.',
  'Semprot minyak nimba / sabun pada koloni kutu.':
      'Spray neem oil or soap solution on scale colonies.',
  'Kocor fungisida pada pangkal tanaman terinfeksi awal.':
      'Drench fungicide at the base of early-infected vines.',
  'Daun berlubang dan tersisa tulang daunnya.':
      'Leaves are holed until only the veins remain.',
  'Ulat berbulu menempel berkelompok di balik daun.':
      'Hairy caterpillars cluster under the leaves.',
  'Buah bercak cokelat dan busuk dari titik luka.':
      'Fruit shows brown spots and rots from the wound.',
  'Kumpulkan kelompok telur dan ulat secara manual.':
      'Collect egg clusters and caterpillars by hand.',
  'Sanitasi buah jatuh dan pangkas cabang rapat.':
      'Sanitate fallen fruit and prune dense branches.',
  'Konservasi predator dan parasitoid alami.':
      'Conserve natural predators and parasitoids.',
  'Semprot Bt atau insektisida nabati pada koloni muda.':
      'Spray Bt or a botanical insecticide on young colonies.',
  'Buang buah busuk jauh dari lahan.':
      'Dispose of rotten fruit far from the field.',
  'Tanaman layu mendadak siang hari meski tanah lembap.':
      'Plants wilt suddenly at midday even in moist soil.',
  'Daun tetap hijau saat layu (beda dengan layu fusarium).':
      'Leaves stay green while wilting, unlike fusarium wilt.',
  'Lendir putih keluar dari potongan batang yang direndam air.':
      'White ooze from a stem cut left soaking in water.',
  'Rotasi 2–3 musim dengan tanaman bukan inang (jagung/padi).':
      'Rotate two or three seasons with non-hosts such as maize or rice.',
  'Bedengan tinggi dan drainase baik; hindari luka akar.':
      'High beds and good drainage; avoid root wounds.',
  'Bibit sehat dan sanitasi alat kerja antar bedengan.':
      'Healthy seedlings and tool sanitation between beds.',
  'Cabut dan bakar tanaman sakit beserta tanah sekitarnya.':
      'Uproot and burn sick plants with the surrounding soil.',
  'Bakterisida tembaga hanya menekan penularan, tidak menyembuhkan.':
      'Copper bactericide only suppresses spread, it does not cure.',
  'Bercak kuning bersudut di permukaan daun, dibatasi tulang daun.':
      'Angular yellow spots on the leaf surface, bounded by veins.',
  'Lapisan abu-ungu seperti bulu di balik daun saat lembap.':
      'A grey-purple downy layer under the leaves when humid.',
  'Daun mengering dari tepi dan tanaman gundul sebelum panen.':
      'Leaves dry from the edge and plants go bare before harvest.',
  'Jarak tanam longgar dan ajir agar daun cepat kering.':
      'Loose spacing and trellising so leaves dry fast.',
  'Irigasi ke tanah pagi hari, hindari daun basah sore.':
      'Irrigate the soil in the morning; keep leaves dry in the evening.',
  'Fungisida kontak + sistemik bergantian tiap 7 hari saat lembap.':
      'Alternate contact and systemic fungicide every 7 days when humid.',
};
