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
  final _username = TextEditingController();
  final _password1 = TextEditingController();
  final _password2 = TextEditingController();
  String _role = 'buyer';

  Future<void> _register(CookieRequest request) async {
    final response = await request.postJson(
      '$baseUrl/api/auth/register/',
      jsonEncode({
        'username': _username.text,
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _username,
            decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password1,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password2,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Konfirmasi password', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _role,
            decoration: const InputDecoration(labelText: 'Peran', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'buyer', child: Text('Pembeli')),
              DropdownMenuItem(value: 'partner', child: Text('Mitra Restoran')),
            ],
            onChanged: (value) => setState(() => _role = value!),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: () => _register(request), child: const Text('Daftar')),
        ],
      ),
    );
  }
}
