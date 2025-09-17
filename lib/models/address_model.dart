// models/address_model.dart
class Address {
  final String kabupaten;
  final String kecamatan;
  final String desa;
  final String dusun;
  final String kodePos;

  Address({
    required this.kabupaten,
    required this.kecamatan,
    required this.desa,
    required this.dusun,
    required this.kodePos,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      kabupaten: json['kabupaten']?.toString() ?? '',
      kecamatan: json['kecamatan']?.toString() ?? '',
      desa: json['desa']?.toString() ?? '',
      dusun: json['dusun']?.toString() ?? '',
      kodePos:
          json['kodepos']?.toString() ??
          json['kode_pos']?.toString() ??
          '', // cek kedua kemungkinan nama kolom
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kabupaten': kabupaten,
      'kecamatan': kecamatan,
      'desa': desa,
      'dusun': dusun,
      'kodepos':
          kodePos, // sesuai dengan kolom database (bisa kodepos atau kode_pos)
    };
  }

  @override
  String toString() {
    return 'Address(kabupaten: $kabupaten, kecamatan: $kecamatan, desa: $desa, dusun: $dusun, kodePos: $kodePos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.kabupaten == kabupaten &&
        other.kecamatan == kecamatan &&
        other.desa == desa &&
        other.dusun == dusun &&
        other.kodePos == kodePos;
  }

  @override
  int get hashCode {
    return kabupaten.hashCode ^
        kecamatan.hashCode ^
        desa.hashCode ^
        dusun.hashCode ^
        kodePos.hashCode;
  }
}
