import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/box.dart';
import '../models/order.dart';
import 'order_detail.dart';

class CheckoutPage extends StatefulWidget {
  final Box box;

  const CheckoutPage({super.key, required this.box});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const _maxPerOrder = 3;
  int _jumlah = 1;

  Future<void> _submit(CookieRequest request) async {
    final response = await request.postJson(
      '$baseUrl/api/order/orders/',
      jsonEncode({'box_id': widget.box.id, 'jumlah': _jumlah}),
    );
    if (!mounted) return;
    if (response['id'] == null) {
      showSnack(context, errorMessage(response));
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailPage(order: Order.fromJson(response))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final box = widget.box;
    final maxQty = box.stok < _maxPerOrder ? box.stok : _maxPerOrder;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(box.namaPaket, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('${box.restoran} - ${box.alamat}'),
            const SizedBox(height: 16),
            Text('Harga normal: ${rupiah(box.hargaNormal)}',
                style: const TextStyle(decoration: TextDecoration.lineThrough)),
            Text('Harga diskon: ${rupiah(box.hargaDiskon)}'),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Jumlah'),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _jumlah > 1 ? () => setState(() => _jumlah--) : null,
                ),
                Text('$_jumlah', style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _jumlah < maxQty ? () => setState(() => _jumlah++) : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Total: ${rupiah(box.hargaDiskon * _jumlah)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: () => _submit(request), child: const Text('Pesan Sekarang')),
            ),
          ],
        ),
      ),
    );
  }
}
