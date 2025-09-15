import 'package:flutter/material.dart';
import '../models/student_models.dart';
import '../widgets/student_card.dart';
import 'form_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Student> students = [];

  void _addStudent(Student student) {
    setState(() {
      students.insert(0, student);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          'PPDB Online',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4299E1),
        elevation: 0,
        centerTitle: true,
      ),
      body: students.isEmpty ? _buildEmptyState() : _buildStudentList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPage()),
          );

          if (result != null && result is Student) {
            _addStudent(result);
          }
        },
        backgroundColor: const Color(0xFF4299E1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, size: 80, color: Color(0xFF4299E1)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Data Pendaftar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tekan tombol "Tambah Data" untuk menambahkan\npendaftar baru',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4299E1), Color(0xFF3182CE)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pendaftar',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${students.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return StudentCard(
                student: students[index],
                onTap: () {
                  // TODO: Navigate to detail page
                },
              );
            }, childCount: students.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
