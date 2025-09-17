import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student_model.dart';
import '../services/database_service.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onStudentUpdated;

  const StudentCard({Key? key, required this.student, this.onStudentUpdated})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.namaLengkap,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blue[200]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'NISN: ${student.nisn}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'detail') {
                        _showStudentDetail(context, student);
                      } else if (value == 'edit') {
                        _showEditStudentDialog(context, student);
                      } else if (value == 'delete') {
                        _confirmDelete(context, student);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'detail',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 20),
                            SizedBox(width: 8),
                            Text('Lihat Detail'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20),
                            SizedBox(width: 8),
                            Text('Hapus'),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.wc_outlined,
                'Jenis Kelamin',
                student.jenisKelamin,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.cake_outlined,
                'Tanggal Lahir',
                '${student.tempatLahir}, ${DateFormat('dd MMMM yyyy').format(student.tanggalLahir)}',
                Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.phone_outlined,
                'No. Telepon',
                student.noTelp,
                Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Alamat',
                student.alamatLengkap,
                Colors.red,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showStudentDetail(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxHeight: 600),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue[400]!, Colors.blue[600]!],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.namaLengkap,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'NISN: ${student.nisn}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDetailSection('Data Pribadi', [
                    _buildDetailItem('NIK', student.nik),
                    _buildDetailItem('Jenis Kelamin', student.jenisKelamin),
                    _buildDetailItem('Agama', student.agama),
                    _buildDetailItem(
                      'Tempat, Tanggal Lahir',
                      '${student.tempatLahir}, ${DateFormat('dd MMMM yyyy').format(student.tanggalLahir)}',
                    ),
                    _buildDetailItem('No. Telepon', student.noTelp),
                  ]),
                  const SizedBox(height: 16),
                  _buildDetailSection('Alamat', [
                    _buildDetailItem('Alamat Lengkap', student.alamatLengkap),
                  ]),
                  const SizedBox(height: 16),
                  _buildDetailSection('Data Orang Tua/Wali', [
                    _buildDetailItem('Nama Ayah', student.namaAyah),
                    _buildDetailItem('Nama Ibu', student.namaIbu),
                    if (student.namaWali.isNotEmpty)
                      _buildDetailItem('Nama Wali', student.namaWali),
                    if (student.alamatWali.isNotEmpty)
                      _buildDetailItem('Alamat Wali', student.alamatWali),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditStudentDialog(BuildContext context, Student? student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StudentFormDialog(
          student: student,
          onStudentUpdated: onStudentUpdated,
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah Anda yakin ingin menghapus data ${student.namaLengkap}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await DatabaseService.deleteStudent(student.id);
                  Navigator.of(context).pop();
                  if (onStudentUpdated != null) onStudentUpdated!();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data siswa berhasil dihapus'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus data: $e')),
                  );
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentFormDialog extends StatefulWidget {
  final Student? student;
  final VoidCallback? onStudentUpdated;

  const StudentFormDialog({Key? key, this.student, this.onStudentUpdated})
    : super(key: key);

  @override
  _StudentFormDialogState createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nisnController;
  late TextEditingController _namaLengkapController;
  late TextEditingController _nikController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _noTelpController;
  late TextEditingController _jalanController;
  late TextEditingController _rtController;
  late TextEditingController _rwController;
  late TextEditingController _dusunController;
  late TextEditingController _desaController;
  late TextEditingController _kecamatanController;
  late TextEditingController _kabupatenController;
  late TextEditingController _provinsiController;
  late TextEditingController _kodePosController;
  late TextEditingController _namaAyahController;
  late TextEditingController _namaIbuController;
  late TextEditingController _namaWaliController;
  late TextEditingController _alamatWaliController;
  String _jenisKelamin = 'Laki-laki';
  String _agama = 'Islam';
  DateTime _tanggalLahir = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nisnController = TextEditingController(text: widget.student?.nisn ?? '');
    _namaLengkapController = TextEditingController(
      text: widget.student?.namaLengkap ?? '',
    );
    _nikController = TextEditingController(text: widget.student?.nik ?? '');
    _tempatLahirController = TextEditingController(
      text: widget.student?.tempatLahir ?? '',
    );
    _noTelpController = TextEditingController(
      text: widget.student?.noTelp ?? '',
    );
    _jalanController = TextEditingController(text: widget.student?.jalan ?? '');
    _rtController = TextEditingController(text: widget.student?.rt ?? '');
    _rwController = TextEditingController(text: widget.student?.rw ?? '');
    _dusunController = TextEditingController(text: widget.student?.dusun ?? '');
    _desaController = TextEditingController(text: widget.student?.desa ?? '');
    _kecamatanController = TextEditingController(
      text: widget.student?.kecamatan ?? '',
    );
    _kabupatenController = TextEditingController(
      text: widget.student?.kabupaten ?? '',
    );
    _provinsiController = TextEditingController(
      text: widget.student?.provinsi ?? '',
    );
    _kodePosController = TextEditingController(
      text: widget.student?.kodePos ?? '',
    );
    _namaAyahController = TextEditingController(
      text: widget.student?.namaAyah ?? '',
    );
    _namaIbuController = TextEditingController(
      text: widget.student?.namaIbu ?? '',
    );
    _namaWaliController = TextEditingController(
      text: widget.student?.namaWali ?? '',
    );
    _alamatWaliController = TextEditingController(
      text: widget.student?.alamatWali ?? '',
    );
    _jenisKelamin = widget.student?.jenisKelamin ?? 'Laki-laki';
    _agama = widget.student?.agama ?? 'Islam';
    _tanggalLahir = widget.student?.tanggalLahir ?? DateTime.now();
  }

  @override
  void dispose() {
    _nisnController.dispose();
    _namaLengkapController.dispose();
    _nikController.dispose();
    _tempatLahirController.dispose();
    _noTelpController.dispose();
    _jalanController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _dusunController.dispose();
    _desaController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _kodePosController.dispose();
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _namaWaliController.dispose();
    _alamatWaliController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final student = Student(
          id: widget.student?.id ?? '',
          nisn: _nisnController.text,
          namaLengkap: _namaLengkapController.text,
          jenisKelamin: _jenisKelamin,
          agama: _agama,
          tempatLahir: _tempatLahirController.text,
          tanggalLahir: _tanggalLahir,
          noTelp: _noTelpController.text,
          nik: _nikController.text,
          jalan: _jalanController.text,
          rt: _rtController.text,
          rw: _rwController.text,
          dusun: _dusunController.text,
          desa: _desaController.text,
          kecamatan: _kecamatanController.text,
          kabupaten: _kabupatenController.text,
          provinsi: _provinsiController.text,
          kodePos: _kodePosController.text,
          namaAyah: _namaAyahController.text,
          namaIbu: _namaIbuController.text,
          namaWali: _namaWaliController.text,
          alamatWali: _alamatWaliController.text,
        );

        if (widget.student == null) {
          await DatabaseService.insertStudent(student);
        } else {
          await DatabaseService.updateStudent(student);
        }

        Navigator.of(context).pop();
        if (widget.onStudentUpdated != null) widget.onStudentUpdated!();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.student == null
                  ? 'Data siswa berhasil ditambahkan'
                  : 'Data siswa berhasil diperbarui',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student == null ? 'Tambah Siswa' : 'Edit Siswa',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nisnController,
                  decoration: const InputDecoration(labelText: 'NISN'),
                  validator: (value) =>
                      value!.isEmpty ? 'NISN harus diisi' : null,
                ),
                TextFormField(
                  controller: _namaLengkapController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama harus diisi' : null,
                ),
                TextFormField(
                  controller: _nikController,
                  decoration: const InputDecoration(labelText: 'NIK'),
                  validator: (value) =>
                      value!.isEmpty ? 'NIK harus diisi' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _jenisKelamin,
                  decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                  items: ['Laki-laki', 'Perempuan'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _jenisKelamin = value!),
                ),
                DropdownButtonFormField<String>(
                  value: _agama,
                  decoration: const InputDecoration(labelText: 'Agama'),
                  items:
                      [
                        'Islam',
                        'Kristen',
                        'Katolik',
                        'Hindu',
                        'Buddha',
                        'Konghucu',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) => setState(() => _agama = value!),
                ),
                TextFormField(
                  controller: _tempatLahirController,
                  decoration: const InputDecoration(labelText: 'Tempat Lahir'),
                  validator: (value) =>
                      value!.isEmpty ? 'Tempat lahir harus diisi' : null,
                ),
                TextFormField(
                  controller: TextEditingController(
                    text: DateFormat('dd MMMM yyyy').format(_tanggalLahir),
                  ),
                  decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                TextFormField(
                  controller: _noTelpController,
                  decoration: const InputDecoration(labelText: 'No. Telepon'),
                  validator: (value) =>
                      value!.isEmpty ? 'No. Telepon harus diisi' : null,
                ),
                TextFormField(
                  controller: _jalanController,
                  decoration: const InputDecoration(labelText: 'Jalan'),
                ),
                TextFormField(
                  controller: _rtController,
                  decoration: const InputDecoration(labelText: 'RT'),
                ),
                TextFormField(
                  controller: _rwController,
                  decoration: const InputDecoration(labelText: 'RW'),
                ),
                TextFormField(
                  controller: _dusunController,
                  decoration: const InputDecoration(labelText: 'Dusun'),
                ),
                TextFormField(
                  controller: _desaController,
                  decoration: const InputDecoration(labelText: 'Desa'),
                ),
                TextFormField(
                  controller: _kecamatanController,
                  decoration: const InputDecoration(labelText: 'Kecamatan'),
                ),
                TextFormField(
                  controller: _kabupatenController,
                  decoration: const InputDecoration(labelText: 'Kabupaten'),
                ),
                TextFormField(
                  controller: _provinsiController,
                  decoration: const InputDecoration(labelText: 'Provinsi'),
                ),
                TextFormField(
                  controller: _kodePosController,
                  decoration: const InputDecoration(labelText: 'Kode Pos'),
                ),
                TextFormField(
                  controller: _namaAyahController,
                  decoration: const InputDecoration(labelText: 'Nama Ayah'),
                ),
                TextFormField(
                  controller: _namaIbuController,
                  decoration: const InputDecoration(labelText: 'Nama Ibu'),
                ),
                TextFormField(
                  controller: _namaWaliController,
                  decoration: const InputDecoration(labelText: 'Nama Wali'),
                ),
                TextFormField(
                  controller: _alamatWaliController,
                  decoration: const InputDecoration(labelText: 'Alamat Wali'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveStudent,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(widget.student == null ? 'Tambah' : 'Simpan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
