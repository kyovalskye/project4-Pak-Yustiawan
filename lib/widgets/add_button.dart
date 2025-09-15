// lib/widgets/floating_tambah_button.dart
import 'package:flutter/material.dart';

class FloatingTambahButton extends StatelessWidget {
  final VoidCallback onPressed; // callback saat tombol ditekan

  const FloatingTambahButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
      backgroundColor: Colors.blue,
      tooltip: 'Tambah Data',
    );
  }
}