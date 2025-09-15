// lib/widgets/form_dialog.dart
import 'package:flutter/material.dart';

Future<void> showFormDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  String? nama;
  String? email;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Form Input'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => nama = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                  onSaved: (value) => email = value,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data tersimpan: $nama, $email')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    },
  );
}