import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student_models.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/progress_stepper.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Form keys untuk validasi per tahap
  final _personalFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _parentFormKey = GlobalKey<FormState>();

  // Controllers
  final _nisnController = TextEditingController();
  final _namaLengkapController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _nikController = TextEditingController();
  final _jalanController = TextEditingController();
  final _rtRwController = TextEditingController();
  final _dusunController = TextEditingController();
  final _desaController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kabupatenController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _kodePosController = TextEditingController();
  final _namaAyahController = TextEditingController();
  final _namaIbuController = TextEditingController();
  final _namaWaliController = TextEditingController();
  final _alamatWaliController = TextEditingController();

  String? _jenisKelamin;
  String? _agama;
  DateTime? _tanggalLahir;
  bool _isLoading = false;

  // Multi-step state
  int currentStep = 0;
  final List<String> stepTitles = [
    'Data Pribadi',
    'Kontak & Identitas',
    'Alamat Lengkap',
    'Data Orang Tua/Wali',
  ];

  @override
  void dispose() {
    _nisnController.dispose();
    _namaLengkapController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _noTelpController.dispose();
    _nikController.dispose();
    _jalanController.dispose();
    _rtRwController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          'Form Pendaftaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF4299E1),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Stepper (tidak ikut scroll)
          ProgressStepper(
            currentStep: currentStep,
            totalSteps: stepTitles.length,
            stepTitles: stepTitles,
          ),
          // Konten Form dengan scroll
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _buildCurrentSection(constraints.maxWidth),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4299E1)),
              )
            : _buildNavigationButtons(),
      ),
    );
  }

  // Render section aktif
  Widget _buildCurrentSection(double maxWidth) {
    final formKey = [
      _personalFormKey,
      _contactFormKey,
      _addressFormKey,
      _parentFormKey,
    ][currentStep];
    return Form(
      key: formKey,
      child: _buildSection(
        stepTitles[currentStep],
        _getIcon(currentStep),
        _buildFields(currentStep, maxWidth),
      ),
    );
  }

  // Ikon untuk setiap tahap
  IconData _getIcon(int step) => [
    Icons.person,
    Icons.contact_phone,
    Icons.location_on,
    Icons.family_restroom,
  ][step];

  // Fields untuk setiap tahap
  List<Widget> _buildFields(int step, double maxWidth) {
    switch (step) {
      case 0:
        return _buildPersonalFields();
      case 1:
        return _buildContactFields();
      case 2:
        return _buildAddressFields(maxWidth);
      case 3:
        return _buildParentFields();
      default:
        return [];
    }
  }

  List<Widget> _buildPersonalFields() => [
    CustomTextField(
      label: 'NISN',
      controller: _nisnController,
      keyboardType: TextInputType.number,
      validator: (value) => value?.isEmpty ?? true
          ? 'NISN harus diisi'
          : value!.length != 10
          ? 'NISN harus 10 digit'
          : null,
    ),
    const SizedBox(height: 8),
    CustomTextField(
      label: 'Nama Lengkap',
      controller: _namaLengkapController,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Nama lengkap harus diisi' : null,
    ),
    const SizedBox(height: 8),
    CustomDropdown(
      label: 'Jenis Kelamin',
      value: _jenisKelamin,
      items: const ['Laki-laki', 'Perempuan'],
      onChanged: (value) => setState(() => _jenisKelamin = value),
      validator: (value) =>
          value == null ? 'Jenis kelamin harus dipilih' : null,
    ),
    const SizedBox(height: 8),
    CustomDropdown(
      label: 'Agama',
      value: _agama,
      items: const [
        'Islam',
        'Kristen',
        'Katolik',
        'Hindu',
        'Buddha',
        'Konghucu',
      ],
      onChanged: (value) => setState(() => _agama = value),
      validator: (value) => value == null ? 'Agama harus dipilih' : null,
    ),
    const SizedBox(height: 8),
    CustomTextField(
      label: 'Tempat Lahir',
      controller: _tempatLahirController,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Tempat lahir harus diisi' : null,
    ),
    const SizedBox(height: 8),
    CustomTextField(
      label: 'Tanggal Lahir',
      controller: _tanggalLahirController,
      readOnly: true,
      onTap: _selectDate,
      suffixIcon: const Icon(Icons.calendar_today, size: 16),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Tanggal lahir harus diisi' : null,
    ),
  ];

  List<Widget> _buildContactFields() => [
    CustomTextField(
      label: 'Nomor Telepon',
      controller: _noTelpController,
      keyboardType: TextInputType.phone,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Nomor telepon harus diisi' : null,
    ),
    const SizedBox(height: 8),
    CustomTextField(
      label: 'NIK',
      controller: _nikController,
      keyboardType: TextInputType.number,
      validator: (value) => value?.isEmpty ?? true
          ? 'NIK harus diisi'
          : value!.length != 16
          ? 'NIK harus 16 digit'
          : null,
    ),
  ];

  List<Widget> _buildAddressFields(double maxWidth) {
    bool isWideScreen = maxWidth > 600;
    return [
      if (isWideScreen)
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Jalan',
                controller: _jalanController,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Jalan harus diisi' : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                label: 'RT/RW',
                controller: _rtRwController,
                hintText: 'Contoh: 001/002',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'RT/RW harus diisi' : null,
              ),
            ),
          ],
        )
      else ...[
        CustomTextField(
          label: 'Jalan',
          controller: _jalanController,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Jalan harus diisi' : null,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: 'RT/RW',
          controller: _rtRwController,
          hintText: 'Contoh: 001/002',
          validator: (value) =>
              value?.isEmpty ?? true ? 'RT/RW harus diisi' : null,
        ),
      ],
      const SizedBox(height: 8),
      CustomTextField(
        label: 'Dusun',
        controller: _dusunController,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Dusun harus diisi' : null,
      ),
      const SizedBox(height: 8),
      CustomTextField(
        label: 'Desa',
        controller: _desaController,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Desa harus diisi' : null,
      ),
      const SizedBox(height: 8),
      CustomTextField(
        label: 'Kecamatan',
        controller: _kecamatanController,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Kecamatan harus diisi' : null,
      ),
      const SizedBox(height: 8),
      CustomTextField(
        label: 'Kabupaten',
        controller: _kabupatenController,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Kabupaten harus diisi' : null,
      ),
      const SizedBox(height: 8),
      if (isWideScreen)
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Provinsi',
                controller: _provinsiController,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Provinsi harus diisi' : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                label: 'Kode Pos',
                controller: _kodePosController,
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Kode pos harus diisi'
                    : value!.length != 5
                    ? 'Kode pos harus 5 digit'
                    : null,
              ),
            ),
          ],
        )
      else ...[
        CustomTextField(
          label: 'Provinsi',
          controller: _provinsiController,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Provinsi harus diisi' : null,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: 'Kode Pos',
          controller: _kodePosController,
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true
              ? 'Kode pos harus diisi'
              : value!.length != 5
              ? 'Kode pos harus 5 digit'
              : null,
        ),
      ],
    ];
  }

  List<Widget> _buildParentFields() => [
    CustomTextField(
      label: 'Nama Ayah',
      controller: _namaAyahController,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Nama ayah harus diisi' : null,
    ),
    const SizedBox(height: 8),
    CustomTextField(
      label: 'Nama Ibu',
      controller: _namaIbuController,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Nama ibu harus diisi' : null,
    ),
    const SizedBox(height: 8),
    CustomTextField(
      label: 'Nama Wali',
      controller: _namaWaliController,
      hintText: 'Kosongkan jika tidak ada',
    ),
    const SizedBox(height: 8),
    CustomTextField(
      label: 'Alamat Wali',
      controller: _alamatWaliController,
      maxLines: 1,
      hintText: 'Alamat wali (opsional)',
    ),
  ];

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4299E1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: const Color(0xFF4299E1), size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep > 0)
          ElevatedButton(
            onPressed: _previousStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sebelumnya', style: TextStyle(fontSize: 13)),
          ),
        const Spacer(),
        ElevatedButton(
          onPressed: currentStep < stepTitles.length - 1
              ? _nextStep
              : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4299E1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            currentStep < stepTitles.length - 1 ? 'Selanjutnya' : 'Submit Data',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _nextStep() async {
    final formKey = [
      _personalFormKey,
      _contactFormKey,
      _addressFormKey,
      _parentFormKey,
    ][currentStep];
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _isLoading = false;
        currentStep++;
      });
    } else {
      _showErrorSnackBar();
    }
  }

  void _previousStep() {
    setState(() => currentStep--);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4299E1)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
        _tanggalLahirController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submitForm() async {
    final formKeys = [
      _personalFormKey,
      _contactFormKey,
      _addressFormKey,
      _parentFormKey,
    ];
    bool allValid = true;
    for (var key in formKeys) {
      if (key.currentState != null && !key.currentState!.validate()) {
        allValid = false;
      }
    }

    if (allValid) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 500));
      final student = Student(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nisn: _nisnController.text,
        namaLengkap: _namaLengkapController.text,
        jenisKelamin: _jenisKelamin!,
        agama: _agama!,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahir!,
        noTelp: _noTelpController.text,
        nik: _nikController.text,
        jalan: _jalanController.text,
        rtRw: _rtRwController.text,
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
        tanggalSubmit: DateTime.now(),
      );

      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text('Berhasil!', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Text(
            'Data pendaftaran atas nama ${student.namaLengkap} berhasil disimpan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, student);
              },
              child: const Text('OK', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      );
    } else {
      setState(() => _isLoading = false);
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mohon lengkapi semua field yang wajib diisi'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
