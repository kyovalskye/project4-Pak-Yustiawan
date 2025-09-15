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
  final String rtRw;
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
  final DateTime tanggalSubmit;

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
    required this.rtRw,
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
    required this.tanggalSubmit,
  });

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
      'rtRw': rtRw,
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
      'tanggalSubmit': tanggalSubmit.toIso8601String(),
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      nisn: json['nisn'],
      namaLengkap: json['namaLengkap'],
      jenisKelamin: json['jenisKelamin'],
      agama: json['agama'],
      tempatLahir: json['tempatLahir'],
      tanggalLahir: DateTime.parse(json['tanggalLahir']),
      noTelp: json['noTelp'],
      nik: json['nik'],
      jalan: json['jalan'],
      rtRw: json['rtRw'],
      dusun: json['dusun'],
      desa: json['desa'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      provinsi: json['provinsi'],
      kodePos: json['kodePos'],
      namaAyah: json['namaAyah'],
      namaIbu: json['namaIbu'],
      namaWali: json['namaWali'],
      alamatWali: json['alamatWali'],
      tanggalSubmit: DateTime.parse(json['tanggalSubmit']),
    );
  }
}
