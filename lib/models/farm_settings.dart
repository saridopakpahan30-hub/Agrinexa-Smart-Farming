import 'commodity.dart';

/// Data kebun yang dimiliki satu akun: lahan, modal, tujuan, lokasi, dan
/// harga catatan sendiri. Tidak memuat identitas akun maupun mode
/// tampilan/bahasa, karena keduanya merupakan setelan perangkat, bukan isi
/// kebun.
class FarmSettings {
  int landArea;
  int capital;
  String landType;
  String goal;
  String? activeId;
  bool hasInput;
  bool notifOn;
  bool priceAlert;

  double farmLat;
  double farmLon;
  String farmCity;
  bool locationChosen;

  Map<String, double> manualPrices;
  Map<String, double> manualPricesPrev;

  static String get jenisLahanBawaan => landTypes.first;

  FarmSettings({
    this.landArea = 1000,
    this.capital = 5000000,
    required this.landType,
    this.goal = 'Keuntungan',
    this.activeId,
    this.hasInput = false,
    this.notifOn = true,
    this.priceAlert = true,
    this.farmLat = 0,
    this.farmLon = 0,
    this.farmCity = '',
    this.locationChosen = false,
    Map<String, double>? manualPrices,
    Map<String, double>? manualPricesPrev,
  })  : manualPrices = manualPrices ?? {},
        manualPricesPrev = manualPricesPrev ?? {};

  /// Nilai awal ketika akun belum memiliki data tersimpan.
  factory FarmSettings.kosong() => FarmSettings(
        landType: jenisLahanBawaan,
      );

  Map<String, dynamic> toJson() => {
        'area': landArea,
        'capital': capital,
        'landType': landType,
        'goal': goal,
        'active': activeId,
        'hasInput': hasInput,
        'notifOn': notifOn,
        'priceAlert': priceAlert,
        'lat': farmLat,
        'lon': farmLon,
        'city': farmCity,
        'locSet': locationChosen,
        'manualPrices': manualPrices,
        'manualPricesPrev': manualPricesPrev,
      };

  factory FarmSettings.fromJson(Map<String, dynamic> j) {
    final locSet = (j['locSet'] as bool?) ?? false;
    return FarmSettings(
      landArea: (j['area'] as num?)?.toInt() ?? 1000,
      capital: (j['capital'] as num?)?.toInt() ?? 5000000,
      landType: (j['landType'] as String?) ?? jenisLahanBawaan,
      goal: (j['goal'] as String?) ?? 'Keuntungan',
      activeId: j['active'] as String?,
      hasInput: (j['hasInput'] as bool?) ?? false,
      notifOn: (j['notifOn'] as bool?) ?? true,
      priceAlert: (j['priceAlert'] as bool?) ?? true,
      farmLat: (j['lat'] as num?)?.toDouble() ?? 0,
      farmLon: (j['lon'] as num?)?.toDouble() ?? 0,
      farmCity: locSet ? (j['city'] as String? ?? '') : '',
      locationChosen: locSet,
      manualPrices: _numMap(j['manualPrices']),
      manualPricesPrev: _numMap(j['manualPricesPrev']),
    );
  }

  static Map<String, double> _numMap(dynamic v) => {
        for (final e in ((v as Map?) ?? {}).entries)
          e.key.toString(): (e.value as num).toDouble()
      };
}
