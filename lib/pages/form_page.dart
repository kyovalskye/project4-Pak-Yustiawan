import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/student_model.dart';
import '../services/database_service.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/custom_autocomplete.dart';
import '../widgets/error_dialog.dart'; // Import dialog error

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form keys
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  // Controllers
  final _nisnController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _nikController = TextEditingController();
  final _jalanController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();
  final _namaAyahController = TextEditingController();
  final _namaIbuController = TextEditingController();
  final _namaWaliController = TextEditingController();
  final _alamatWaliController = TextEditingController();
  final _dusunController = TextEditingController();

  String? _jenisKelamin;
  String? _agama;
  DateTime? _tanggalLahir;

  // Address values
  String? _selectedDusun;
  String? _selectedDesa;
  String? _selectedKecamatan;
  String? _selectedKabupaten;
  String _provinsi = '';
  String _kodePos = '';

  // Address dropdown lists
  List<String> _dusunList = [];

  bool _isLoading = false;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _loadAllDusun();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nisnController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _noTelpController.dispose();
    _nikController.dispose();
    _jalanController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _namaWaliController.dispose();
    _alamatWaliController.dispose();
    _dusunController.dispose();
    super.dispose();
  }

  // Address loading methods
  Future<void> _loadAllDusun() async {
    try {
      setState(() => _isLoadingAddress = true);
      final dusun = await DatabaseService.getAllDusun();
      setState(() {
        _dusunList = dusun;
        _isLoadingAddress = false;
      });
    } catch (e) {
      setState(() => _isLoadingAddress = false);
      if (mounted) {
        showErrorDialog(context, e); // Gunakan dialog error
      }
    }
  }

  Future<void> _loadAddressDetailsByDusun(String? dusun) async {
    if (dusun == null || dusun.isEmpty) {
      setState(() {
        _selectedDesa = null;
        _selectedKecamatan = null;
        _selectedKabupaten = null;
        _provinsi = '';
        _kodePos = '';
        _isLoadingAddress = false;
      });
      return;
    }

    try {
      setState(() => _isLoadingAddress = true);
      final details = await DatabaseService.getAddressDetailsByDusun(dusun);
      setState(() {
        _selectedDesa = details['desa'] ?? '';
        _selectedKecamatan = details['kecamatan'] ?? '';
        _selectedKabupaten = details['kabupaten'] ?? '';
        _provinsi = details['provinsi'] ?? '';
        _kodePos = details['kode_pos'] ?? '';
        _isLoadingAddress = false;
      });
    } catch (e) {
      setState(() {
        _selectedDesa = null;
        _selectedKecamatan = null;
        _selectedKabupaten = null;
        _provinsi = '';
        _kodePos = '';
        _isLoadingAddress = false;
      });
      if (mounted) {
        showErrorDialog(context, e); // Gunakan dialog error
      }
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitForm();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey1.currentState?.validate() ?? false;
      case 1:
        return _formKey2.currentState?.validate() ?? false;
      case 2:
        return _formKey3.currentState?.validate() ?? false;
      case 3:
        return _formKey4.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  void _submitForm() async {
    if (!_validateCurrentStep()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final student = Student(
        id: '',
        nisn: _nisnController.text,
        namaLengkap: _namaController.text,
        jenisKelamin: _jenisKelamin!,
        agama: _agama!,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahir!,
        noTelp: _noTelpController.text,
        nik: _nikController.text,
        jalan: _jalanController.text,
        rt: _rtController.text,
        rw: _rwController.text,
        dusun: _selectedDusun ?? _dusunController.text,
        desa: _selectedDesa ?? '',
        kecamatan: _selectedKecamatan ?? '',
        kabupaten: _selectedKabupaten ?? '',
        provinsi: _provinsi,
        kodePos: _kodePos,
        namaAyah: _namaAyahController.text,
        namaIbu: _namaIbuController.text,
        namaWali: _namaWaliController.text,
        alamatWali: _alamatWaliController.text,
      );

      final id = await DatabaseService.insertStudent(student);
      final savedStudent = student.copyWith(id: id);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pop(context, savedStudent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showErrorDialog(context, e); // Gunakan dialog error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Form Pendaftaran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: FormProgressIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),
          ),
          if (_isLoadingAddress)
            Container(
              color: Colors.blue[50],
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Memuat data alamat...',
                    style: TextStyle(color: Colors.blue[700], fontSize: 12),
                  ),
                ],
              ),
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
              ],
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Pribadi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lengkapi data pribadi siswa',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nisnController,
              label: 'NISN',
              icon: Icons.badge_outlined,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NISN harus diisi';
                }
                if (value.length != 10) {
                  return 'NISN harus 10 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _namaController,
              label: 'Nama Lengkap',
              icon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama lengkap harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              label: 'Jenis Kelamin',
              icon: Icons.wc_outlined,
              value: _jenisKelamin,
              items: const ['Laki-laki', 'Perempuan'],
              onChanged: (value) {
                setState(() {
                  _jenisKelamin = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jenis kelamin harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              label: 'Agama',
              icon: Icons.person_3,
              value: _agama,
              items: const [
                'Islam',
                'Kristen',
                'Katolik',
                'Hindu',
                'Buddha',
                'Konghucu',
              ],
              onChanged: (value) {
                setState(() {
                  _agama = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Agama harus dipilih';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Kelahiran & Kontak',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan tempat tanggal lahir dan kontak',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _tempatLahirController,
              label: 'Tempat Lahir',
              icon: Icons.location_on_outlined,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tempat lahir harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DatePickerField(
              label: 'Tanggal Lahir',
              icon: Icons.calendar_today_outlined,
              selectedDate: _tanggalLahir,
              onDateSelected: (date) {
                setState(() {
                  _tanggalLahir = date;
                });
              },
              validator: (value) {
                if (_tanggalLahir == null) {
                  return 'Tanggal lahir harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _noTelpController,
              label: 'No. Telepon',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'No. telepon harus diisi';
                }
                if (value.length < 10) {
                  return 'No. telepon minimal 10 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _nikController,
              label: 'NIK',
              icon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIK harus diisi';
                }
                if (value.length != 16) {
                  return 'NIK harus 16 digit';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alamat Domisili',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lengkapi alamat tempat tinggal saat ini (pilih Dusun)',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _jalanController,
              label: 'Nama Jalan',
              icon: Icons.home_outlined,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama jalan harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _rtController,
                    label: 'RT',
                    icon: Icons.home_work_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'RT harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _rwController,
                    label: 'RW',
                    icon: Icons.home_work_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'RW harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomAutocomplete(
              controller: _dusunController,
              label: 'Dusun',
              icon: Icons.landscape_outlined,
              suggestions: _dusunList,
              onSelected: (value) {
                setState(() {
                  _selectedDusun = value;
                  _dusunController.text = value!;
                });
                _loadAddressDetailsByDusun(value);
              },
              validator: (value) {
                if ((_selectedDusun ?? _dusunController.text).isEmpty) {
                  return 'Dusun harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(text: _selectedDesa ?? ''),
              label: 'Desa',
              icon: Icons.nature_outlined,
              enabled: false,
              validator: (value) {
                if (_selectedDesa == null || _selectedDesa!.isEmpty) {
                  return 'Desa harus terisi otomatis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(text: _selectedKecamatan ?? ''),
              label: 'Kecamatan',
              icon: Icons.location_city_outlined,
              enabled: false,
              validator: (value) {
                if (_selectedKecamatan == null || _selectedKecamatan!.isEmpty) {
                  return 'Kecamatan harus terisi otomatis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(text: _selectedKabupaten ?? ''),
              label: 'Kabupaten',
              icon: Icons.business_outlined,
              enabled: false,
              validator: (value) {
                if (_selectedKabupaten == null || _selectedKabupaten!.isEmpty) {
                  return 'Kabupaten harus terisi otomatis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(text: _provinsi),
              label: 'Provinsi',
              icon: Icons.public_outlined,
              enabled: false,
              validator: (value) {
                if (_provinsi.isEmpty) {
                  return 'Provinsi harus terisi otomatis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(text: _kodePos),
              label: 'Kode Pos',
              icon: Icons.markunread_mailbox_outlined,
              enabled: false,
              validator: (value) {
                if (_kodePos.isEmpty) {
                  return 'Pilih dusun untuk mendapatkan kode pos';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Orang Tua/Wali',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan data orang tua atau wali siswa',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _namaAyahController,
              label: 'Nama Ayah',
              icon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama ayah harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _namaIbuController,
              label: 'Nama Ibu',
              icon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama ibu harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _namaWaliController,
              label: 'Nama Wali (Opsional)',
              icon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _alamatWaliController,
              label: 'Alamat Wali (Opsional)',
              icon: Icons.home_outlined,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sebelumnya',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == _totalSteps - 1
                          ? 'Simpan'
                          : 'Selanjutnya',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
