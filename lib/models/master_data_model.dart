class MasterData {
  final int id;
  final String kabupaten;
  final String kecamatan;
  final String desa;
  final String dusun;
  final String kodePos;

  MasterData({
    required this.id,
    required this.kabupaten,
    required this.kecamatan,
    required this.desa,
    required this.dusun,
    required this.kodePos,
  });

  factory MasterData.fromJson(Map<String, dynamic> json) {
    return MasterData(
      id: json['id'],
      kabupaten: json['kabupaten'],
      kecamatan: json['kecamatan'],
      desa: json['desa'],
      dusun: json['dusun'],
      kodePos: json['kode_pos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kabupaten': kabupaten,
      'kecamatan': kecamatan,
      'desa': desa,
      'dusun': dusun,
      'kode_pos': kodePos,
    };
  }
}
