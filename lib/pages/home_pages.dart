import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../widgets/student_card.dart';
import '../widgets/add_button.dart';
import '../services/database_service.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Fungsi untuk memuat data siswa dari database
  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedStudents = await DatabaseService.getAllStudents();
      setState(() {
        students = fetchedStudents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data siswa: $e')));
    }
  }

  void _addStudent(Student student) {
    setState(() {
      students.add(student);
    });
  }

  void _navigateToForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPage()),
    );

    if (result != null && result is Student) {
      _addStudent(result);
    }
  }

  // Callback untuk memperbarui daftar setelah edit atau hapus
  void _onStudentUpdated() {
    _loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'PPDB Online',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? _buildEmptyState()
          : _buildStudentList(),
      floatingActionButton: AddStudentFAB(onPressed: _navigateToForm),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 120, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'Belum ada data siswa',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap tombol + untuk menambah data siswa',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Data Siswa (${students.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StudentCard(
                  student: students[index],
                  onStudentUpdated: _onStudentUpdated,
                ),
              );
            }, childCount: students.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
