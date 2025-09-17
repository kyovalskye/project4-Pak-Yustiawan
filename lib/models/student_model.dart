class Student {
  final String id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String noTelp;
  final String nik;
  final String jalan;
  final String rt;
  final String rw;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String kodePos;
  final String namaAyah;
  final String namaIbu;
  final String namaWali;
  final String alamatWali;

  Student({
    required this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.noTelp,
    required this.nik,
    required this.jalan,
    required this.rt,
    required this.rw,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.namaAyah,
    required this.namaIbu,
    required this.namaWali,
    required this.alamatWali,
  });

  Student copyWith({
    String? id,
    String? nisn,
    String? namaLengkap,
    String? jenisKelamin,
    String? agama,
    String? tempatLahir,
    DateTime? tanggalLahir,
    String? noTelp,
    String? nik,
    String? jalan,
    String? rt,
    String? rw,
    String? dusun,
    String? desa,
    String? kecamatan,
    String? kabupaten,
    String? provinsi,
    String? kodePos,
    String? namaAyah,
    String? namaIbu,
    String? namaWali,
    String? alamatWali,
  }) {
    return Student(
      id: id ?? this.id,
      nisn: nisn ?? this.nisn,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      agama: agama ?? this.agama,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      noTelp: noTelp ?? this.noTelp,
      nik: nik ?? this.nik,
      jalan: jalan ?? this.jalan,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      dusun: dusun ?? this.dusun,
      desa: desa ?? this.desa,
      kecamatan: kecamatan ?? this.kecamatan,
      kabupaten: kabupaten ?? this.kabupaten,
      provinsi: provinsi ?? this.provinsi,
      kodePos: kodePos ?? this.kodePos,
      namaAyah: namaAyah ?? this.namaAyah,
      namaIbu: namaIbu ?? this.namaIbu,
      namaWali: namaWali ?? this.namaWali,
      alamatWali: alamatWali ?? this.alamatWali,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nisn': nisn,
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'agama': agama,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'noTelp': noTelp,
      'nik': nik,
      'jalan': jalan,
      'rt': rt,
      'rw': rw,
      'dusun': dusun,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'kodePos': kodePos,
      'namaAyah': namaAyah,
      'namaIbu': namaIbu,
      'namaWali': namaWali,
      'alamatWali': alamatWali,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      nisn: json['nisn'] ?? '',
      namaLengkap: json['namaLengkap'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? '',
      agama: json['agama'] ?? '',
      tempatLahir: json['tempatLahir'] ?? '',
      tanggalLahir: json['tanggalLahir'] != null
          ? DateTime.parse(json['tanggalLahir'])
          : DateTime.now(),
      noTelp: json['noTelp'] ?? '',
      nik: json['nik'] ?? '',
      jalan: json['jalan'] ?? '',
      rt: json['rt'] ?? '',
      rw: json['rw'] ?? '',
      dusun: json['dusun'] ?? '',
      desa: json['desa'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
      provinsi: json['provinsi'] ?? '',
      kodePos: json['kodePos'] ?? '',
      namaAyah: json['namaAyah'] ?? '',
      namaIbu: json['namaIbu'] ?? '',
      namaWali: json['namaWali'] ?? '',
      alamatWali: json['alamatWali'] ?? '',
    );
  }

  String get alamatLengkap {
    return '$jalan RT $rt RW $rw, $dusun, $desa, $kecamatan, $kabupaten, $provinsi $kodePos';
  }
}
