import 'package:cloud_firestore/cloud_firestore.dart';

import 'farm_backend.dart';
import 'farm_repository.dart';
import 'firestore_skema.dart';

/// Satu operasi tulis (atau hapus bila [isi] bernilai `null`) sebelum
/// dipecah ke dalam batch.
class _TulisDoc {
  const _TulisDoc(this.ref, this.isi);
  final DocumentReference<Map<String, dynamic>> ref;
  final Map<String, Object?>? isi;
}

/// Implementasi sisi server. Ini satu-satunya berkas dalam aplikasi yang
/// bergantung pada cloud_firestore; pemetaan bentuk datanya berada di
/// `firestore_skema.dart`.
class FirestoreFarmBackend implements FarmBackend {
  FirestoreFarmBackend([FirebaseFirestore? db])
      : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  bool get tersedia => true;

  DocumentReference<Map<String, dynamic>> _inti(PemilikData p) =>
      _db.collection(SkemaKebun.users).doc(p.uid);

  @override
  Future<FarmSnapshot?> baca(PemilikData pemilik) async {
    final inti = _inti(pemilik);
    final kepala = await inti.get();
    if (!kepala.exists) return null;
    final koleksi = <String, IsiKoleksi>{};
    for (final nama in SkemaKebun.daftarKoleksi) {
      final hasil = await inti.collection(nama).get();
      koleksi[nama] = {for (final d in hasil.docs) d.id: d.data()};
    }
    return snapshotDariDokumen(
      Map<String, Object?>.from(kepala.data() ?? const {}),
      koleksi,
    );
  }

  @override
  Future<void> tulis(PemilikData pemilik, FarmSnapshot s) async {
    final inti = _inti(pemilik);
    final antrean = <_TulisDoc>[
      // replace, bukan merge: kolom yang tidak lagi digunakan ikut terhapus
      // dari server
      _TulisDoc(inti, {
        ...petaInti(s),
        'uid': pemilik.uid,
        'akun': pemilik.akun,
      }),
    ];
    for (final bagian in petaKoleksi(s).entries) {
      final koleksi = inti.collection(bagian.key);
      final yangAda = await koleksi.get();
      for (final d in yangAda.docs) {
        if (!bagian.value.containsKey(d.id)) {
          antrean.add(_TulisDoc(d.reference, null));
        }
      }
      bagian.value.forEach(
        (id, isi) => antrean.add(_TulisDoc(koleksi.doc(id), isi)),
      );
    }
    // Satu batch terbatas pada 500 operasi, sedangkan riwayat simulasi dapat
    // melampaui jumlah itu; antrean dipecah agar penulisan tidak pernah
    // gagal di tengah jalan.
    for (var i = 0; i < antrean.length; i += _batasBatch) {
      final batch = _db.batch();
      for (final t in antrean.skip(i).take(_batasBatch)) {
        final isi = t.isi;
        if (isi == null) {
          batch.delete(t.ref);
        } else {
          batch.set(t.ref, isi);
        }
      }
      await batch.commit();
    }
  }

  static const _batasBatch = 400;

  @override
  Future<void> simpanKonflik(
    PemilikData pemilik,
    FarmSnapshot yangKalah,
    String penyebab,
  ) =>
      _inti(pemilik)
          .collection(SkemaKebun.konflik)
          .doc('${yangKalah.diubahMs}')
          .set(petaKonflik(yangKalah, penyebab));
}
