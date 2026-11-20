import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password1 = TextEditingController();
  final _password2 = TextEditingController();
  String _role = 'buyer';

  Future<void> _register(CookieRequest request) async {
    if (!_formKey.currentState!.validate()) return;
    final response = await request.postJson(
      '$baseUrl/api/auth/register/',
      jsonEncode({
        'username': _username.text.trim(),
        'password1': _password1.text,
        'password2': _password2.text,
        'role': _role,
      }),
    );
    if (!mounted) return;
    if (response['status'] == true) {
      showSnack(context, 'Akun berhasil dibuat. Silakan masuk.');
      Navigator.pop(context);
    } else {
      showSnack(context, errorMessage(response));
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? 'Username tidak boleh kosong!' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password1,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Password tidak boleh kosong!' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password2,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Konfirmasi password', border: OutlineInputBorder()),
                validator: (value) => value != _password1.text ? 'Konfirmasi password tidak sama!' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Peran', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'buyer', child: Text('Pembeli')),
                  DropdownMenuItem(value: 'partner', child: Text('Mitra Restoran')),
                ],
                onChanged: (value) => setState(() => _role = value!),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: () => _register(request), child: const Text('Daftar')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
