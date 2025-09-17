import '../config/supabase_config.dart';
import '../models/student_model.dart';

class DatabaseService {
  static final _client = SupabaseConfig.client;

  // Cek apakah NISN sudah ada
  static Future<bool> isNisnExists(String nisn, {String? excludeId}) async {
    try {
      final query = _client.from('siswa').select('nisn').eq('nisn', nisn);

      // Jika sedang mengedit, kecualikan ID siswa yang sedang diedit
      if (excludeId != null) {
        query.not('id', 'eq', excludeId);
      }

      final response = await query;

      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Gagal memeriksa NISN: $e');
    }
  }

  // Master Data Methods
  static Future<List<String>> getKabupaten() async {
    try {
      final response = await _client
          .from('master_siswa')
          .select('kabupaten')
          .order('kabupaten');

      final Set<String> kabupatenSet = {};
      for (final item in response) {
        kabupatenSet.add(item['kabupaten'] as String);
      }

      return kabupatenSet.toList();
    } catch (e) {
      throw Exception('Gagal mengambil data kabupaten: $e');
    }
  }

  static Future<List<String>> getKecamatan(String kabupaten) async {
    try {
      final response = await _client
          .from('master_siswa')
          .select('kecamatan')
          .eq('kabupaten', kabupaten)
          .order('kecamatan');

      final Set<String> kecamatanSet = {};
      for (final item in response) {
        kecamatanSet.add(item['kecamatan'] as String);
      }

      return kecamatanSet.toList();
    } catch (e) {
      throw Exception('Gagal mengambil data kecamatan: $e');
    }
  }

  static Future<List<String>> getDesa(
    String kabupaten,
    String kecamatan,
  ) async {
    try {
      final response = await _client
          .from('master_siswa')
          .select('desa')
          .eq('kabupaten', kabupaten)
          .eq('kecamatan', kecamatan)
          .order('desa');

      final Set<String> desaSet = {};
      for (final item in response) {
        desaSet.add(item['desa'] as String);
      }

      return desaSet.toList();
    } catch (e) {
      throw Exception('Gagal mengambil data desa: $e');
    }
  }

  static Future<List<String>> getDusun(
    String kabupaten,
    String kecamatan,
    String desa,
  ) async {
    try {
      final response = await _client
          .from('master_siswa')
          .select('dusun')
          .eq('kabupaten', kabupaten)
          .eq('kecamatan', kecamatan)
          .eq('desa', desa)
          .order('dusun');

      final Set<String> dusunSet = {};
      for (final item in response) {
        dusunSet.add(item['dusun'] as String);
      }

      return dusunSet.toList();
    } catch (e) {
      throw Exception('Gagal mengambil data dusun: $e');
    }
  }

  static Future<String> getKodePos(
    String kabupaten,
    String kecamatan,
    String desa,
    String dusun,
  ) async {
    try {
      final response = await _client
          .from('master_siswa')
          .select('kode_pos')
          .eq('kabupaten', kabupaten)
          .eq('kecamatan', kecamatan)
          .eq('desa', desa)
          .eq('dusun', dusun)
          .single();

      return response['kode_pos'] as String;
    } catch (e) {
      throw Exception('Gagal mengambil kode pos: $e');
    }
  }

  // Student CRUD Methods
  static Future<String> insertStudent(Student student) async {
    try {
      // Cek apakah NISN sudah ada
      if (await isNisnExists(student.nisn)) {
        throw Exception('NISN sudah terdaftar');
      }

      // Prepare data dengan mapping yang benar
      final data = {
        'nisn': student.nisn,
        'namaLengkap': student.namaLengkap,
        'jenisKelamin': student.jenisKelamin,
        'agama': student.agama,
        'tempatLahir': student.tempatLahir,
        'tanggalLahir': student.tanggalLahir.toIso8601String().split(
          'T',
        )[0], // Format DATE
        'noTelp': student.noTelp,
        'nik': student.nik,
        'jalan': student.jalan,
        'rt': student.rt,
        'rw': student.rw,
        'dusun': student.dusun,
        'desa': student.desa,
        'kecamatan': student.kecamatan,
        'kabupaten': student.kabupaten,
        'provinsi': student.provinsi,
        'kodePos': student.kodePos,
        'namaAyah': student.namaAyah,
        'namaIbu': student.namaIbu,
        'namaWali': student.namaWali.isEmpty ? null : student.namaWali,
        'alamatWali': student.alamatWali.isEmpty ? null : student.alamatWali,
      };

      final response = await _client
          .from('siswa')
          .insert(data)
          .select('id')
          .single();

      return response['id'].toString();
    } catch (e) {
      print('Database Error: $e'); // Debug print
      throw Exception('Gagal menyimpan data siswa: $e');
    }
  }

  static Future<void> updateStudent(Student student) async {
    try {
      // Cek apakah NISN sudah ada (kecuali untuk siswa yang sedang diedit)
      if (await isNisnExists(student.nisn, excludeId: student.id)) {
        throw Exception('NISN sudah terdaftar untuk siswa lain');
      }

      await _client.from('siswa').update(student.toJson()).eq('id', student.id);
    } catch (e) {
      throw Exception('Gagal mengupdate data siswa: $e');
    }
  }

  static Future<List<Student>> getAllStudents() async {
    try {
      final response = await _client
          .from('siswa')
          .select('*')
          .order('namaLengkap');

      return response.map<Student>((json) => Student.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data siswa: $e');
    }
  }

  static Future<Student?> getStudentById(String id) async {
    try {
      final response = await _client
          .from('siswa')
          .select('*')
          .eq('id', id)
          .single();

      return Student.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteStudent(String id) async {
    try {
      await _client.from('siswa').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus data siswa: $e');
    }
  }
}
