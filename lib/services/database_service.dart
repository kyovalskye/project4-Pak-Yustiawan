import '../config/supabase_config.dart';
import '../models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseException implements Exception {
  final String message;
  final String? details;
  final String type;

  const DatabaseException({
    required this.message,
    this.details,
    required this.type,
  });

  @override
  String toString() {
    return 'DatabaseException: $message${details != null ? ' - $details' : ''}';
  }
}

class DatabaseService {
  static final _client = SupabaseConfig.client;

  // Helper method untuk handle error dari Supabase
  static DatabaseException _handleSupabaseError(dynamic error) {
    if (error is PostgrestException) {
      switch (error.code) {
        case '23505':
          return const DatabaseException(
            message: 'Data yang dimasukkan sudah ada',
            type: 'DUPLICATE_DATA',
            details: 'Periksa kembali NISN atau NIK yang dimasukkan',
          );
        case '23503':
          return const DatabaseException(
            message: 'Data yang direferensikan tidak ditemukan',
            type: 'REFERENCE_ERROR',
            details: 'Pastikan data master alamat sudah tersedia',
          );
        case '42P01':
          return const DatabaseException(
            message: 'Tabel database tidak ditemukan',
            type: 'TABLE_NOT_FOUND',
            details: 'Hubungi administrator untuk memperbarui database',
          );
        case '42703':
          return const DatabaseException(
            message: 'Kolom database tidak ditemukan',
            type: 'COLUMN_NOT_FOUND',
            details: 'Struktur database perlu diperbarui',
          );
        default:
          return DatabaseException(
            message: 'Terjadi kesalahan pada database',
            type: 'DATABASE_ERROR',
            details: error.message,
          );
      }
    } else if (error is AuthException) {
      return const DatabaseException(
        message: 'Masalah otentikasi dengan server',
        type: 'AUTH_ERROR',
        details: 'Periksa koneksi internet dan coba lagi',
      );
    } else if (error.toString().contains('Failed to connect') ||
        error.toString().contains('Network is unreachable') ||
        error.toString().contains('SocketException')) {
      return const DatabaseException(
        message: 'Tidak dapat terhubung ke server',
        type: 'CONNECTION_ERROR',
        details: 'Periksa koneksi internet Anda',
      );
    } else if (error.toString().contains('TimeoutException')) {
      return const DatabaseException(
        message: 'Koneksi timeout',
        type: 'TIMEOUT_ERROR',
        details: 'Server terlalu lama merespons, coba lagi',
      );
    } else {
      return DatabaseException(
        message: 'Terjadi kesalahan tak terduga',
        type: 'UNKNOWN_ERROR',
        details: error.toString(),
      );
    }
  }

  // Test connection to Supabase
  static Future<bool> testConnection() async {
    try {
      await _client.from('siswa').select('id').limit(1);
      return true;
    } catch (e) {
      throw _handleSupabaseError(e);
    }
  }

  // Cek apakah NISN sudah ada
  static Future<bool> isNisnExists(String nisn, {String? excludeId}) async {
    try {
      final query = _client.from('siswa').select('nisn').eq('nisn', nisn);
      if (excludeId != null) {
        query.not('id', 'eq', excludeId);
      }
      final response = await query;
      return response.isNotEmpty;
    } catch (e) {
      throw _handleSupabaseError(e);
    }
  }

  // Master Data Methods
  static Future<List<String>> getAllDusun() async {
    try {
      final response = await _client
          .from('locations')
          .select('dusun')
          .order('dusun');

      final Set<String> dusunSet = response
          .map((item) => item['dusun'] as String?)
          .where((item) => item != null)
          .cast<String>()
          .toSet();

      final List<String> dusunList = dusunSet.toList();

      if (dusunList.isEmpty) {
        throw const DatabaseException(
          message: 'Data dusun tidak tersedia',
          type: 'NO_DATA',
          details: 'Hubungi administrator untuk menambahkan data master',
        );
      }

      return dusunList;
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw _handleSupabaseError(e);
    }
  }

  static Future<Map<String, String>> getAddressDetailsByDusun(
    String dusun,
  ) async {
    try {
      final response = await _client
          .from('locations')
          .select('desa, kecamatan, kabupaten, provinsi, kode_pos')
          .eq('dusun', dusun)
          .maybeSingle();

      if (response == null ||
          response['desa'] == null ||
          response['kecamatan'] == null ||
          response['kabupaten'] == null ||
          response['provinsi'] == null ||
          response['kode_pos'] == null) {
        throw DatabaseException(
          message: 'Detail alamat tidak ditemukan untuk dusun "$dusun"',
          type: 'NO_DATA',
          details: 'Periksa kembali dusun atau hubungi administrator',
        );
      }

      return {
        'desa': response['desa'] as String,
        'kecamatan': response['kecamatan'] as String,
        'kabupaten': response['kabupaten'] as String,
        'provinsi': response['provinsi'] as String,
        'kode_pos': response['kode_pos'] as String,
      };
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw _handleSupabaseError(e);
    }
  }

  // Student CRUD Methods
  static Future<String> insertStudent(Student student) async {
    try {
      await testConnection();
      if (await isNisnExists(student.nisn)) {
        throw const DatabaseException(
          message: 'NISN sudah terdaftar',
          type: 'DUPLICATE_NISN',
          details: 'Gunakan NISN yang berbeda',
        );
      }

      final data = {
        'nisn': student.nisn,
        'namaLengkap': student.namaLengkap,
        'jenisKelamin': student.jenisKelamin,
        'agama': student.agama,
        'tempatLahir': student.tempatLahir,
        'tanggalLahir': student.tanggalLahir.toIso8601String().split('T')[0],
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
      if (e is DatabaseException) rethrow;
      throw _handleSupabaseError(e);
    }
  }

  static Future<void> updateStudent(Student student) async {
    try {
      await testConnection();
      // Only check for duplicate NISN if it has changed
      if (student.nisn != (await getStudentById(student.id))?.nisn) {
        if (await isNisnExists(student.nisn, excludeId: student.id)) {
          throw const DatabaseException(
            message: 'NISN sudah terdaftar untuk siswa lain',
            type: 'DUPLICATE_NISN',
            details: 'Gunakan NISN yang berbeda',
          );
        }
      }

      final data = student.toJson();
      data.remove('id');

      await _client.from('siswa').update(data).eq('id', student.id);
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw _handleSupabaseError(e);
    }
  }

  static Future<List<Student>> getAllStudents() async {
    try {
      await testConnection();
      final response = await _client
          .from('siswa')
          .select('*')
          .order('namaLengkap');

      return response.map<Student>((json) => Student.fromJson(json)).toList();
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw _handleSupabaseError(e);
    }
  }

  static Future<Student?> getStudentById(String id) async {
    try {
      await testConnection();
      final response = await _client
          .from('siswa')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return Student.fromJson(response);
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw _handleSupabaseError(e);
    }
  }

  static Future<void> deleteStudent(String id) async {
    try {
      await testConnection();
      await _client.from('siswa').delete().eq('id', id);
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw _handleSupabaseError(e);
    }
  }
}
