import 'package:flutter/material.dart';

const String baseUrl = 'https://dyah-zhafira-dibuang-sayang.pws.cs.ui.ac.id';

const Color kGreen = Color(0xFF38761D);
const Color kDarkGreen = Color(0xFF18310C);
const Color kOrange = Color(0xFFF19C34);
const Color kBackground = Color(0xFFF6F6F2);

String statusLabel(String status) => const <String, String>{
      'pending': 'Menunggu',
      'confirmed': 'Diterima',
      'completed': 'Selesai',
      'cancelled': 'Dibatalkan',
      'expired': 'Kedaluwarsa',
    }[status] ??
    status;

Color statusColor(String status) => const <String, Color>{
      'pending': kOrange,
      'confirmed': kGreen,
      'completed': kDarkGreen,
      'cancelled': Colors.red,
      'expired': Colors.grey,
    }[status] ??
    Colors.grey;

String rupiah(num value) => 'Rp ${value.toStringAsFixed(0)}';

String errorMessage(dynamic response) {
  if (response is Map) {
    for (final key in ['error', 'message', 'detail']) {
      if (response[key] != null) return response[key].toString();
    }
    if (response.isNotEmpty) {
      final first = response.values.first;
      return (first is List ? first.first : first).toString();
    }
  }
  return 'Terjadi kesalahan.';
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
