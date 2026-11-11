import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/box.dart';
import 'checkout.dart';

class BoxListPage extends StatelessWidget {
  const BoxListPage({super.key});

  Future<List<Box>> _fetchBoxes(CookieRequest request) async {
    final response = await request.get('$baseUrl/api/order/boxes/');
    return (response as List).map((e) => Box.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Surprise Box')),
      body: FutureBuilder<List<Box>>(
        future: _fetchBoxes(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat paket.'));
          }
          final boxes = snapshot.data!;
          if (boxes.isEmpty) {
            return const Center(child: Text('Belum ada paket tersedia.'));
          }
          return ListView.builder(
            itemCount: boxes.length,
            itemBuilder: (context, i) {
              final box = boxes[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(box.namaPaket),
                  subtitle: Text('${box.restoran}\n${rupiah(box.hargaDiskon)} - stok ${box.stok}'),
                  isThreeLine: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CheckoutPage(box: box)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
