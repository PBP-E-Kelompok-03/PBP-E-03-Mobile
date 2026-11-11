import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/order.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _kode = TextEditingController();
  late String _status = widget.order.status;

  Future<void> _action(CookieRequest request, String action, {Map<String, dynamic>? body}) async {
    final response = await request.postJson(
      '$baseUrl/api/order/orders/${widget.order.id}/$action/',
      jsonEncode(body ?? {}),
    );
    if (!mounted) return;
    if (response['status'] == null) {
      showSnack(context, errorMessage(response));
      return;
    }
    setState(() => _status = response['status']);
    showSnack(context, response['message']);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final order = widget.order;
    final isBuyer = request.jsonData['role'] == 'buyer';
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(order.namaPaket, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('${order.restoran} - ${order.alamat}'),
          const SizedBox(height: 16),
          Text('Pembeli: ${order.pembeli}'),
          Text('Jumlah: ${order.jumlah} box'),
          Text('Total: ${rupiah(order.total)}'),
          Text('Status: ${_status.toUpperCase()}'),
          Text('Berlaku sampai: ${order.kedaluwarsaPada.toString().substring(0, 16)}'),
          const SizedBox(height: 16),
          if (isBuyer)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Kode Pickup'),
                    Text(order.kodePickup,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (isBuyer && _status == 'pending')
            OutlinedButton(onPressed: () => _action(request, 'cancel'), child: const Text('Batalkan Pesanan')),
          if (!isBuyer && _status == 'pending')
            FilledButton(onPressed: () => _action(request, 'confirm'), child: const Text('Terima Pesanan')),
          if (!isBuyer && (_status == 'pending' || _status == 'confirmed'))
            OutlinedButton(onPressed: () => _action(request, 'reject'), child: const Text('Tolak Pesanan')),
          if (!isBuyer && _status == 'confirmed') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _kode,
              decoration: const InputDecoration(labelText: 'Kode pickup pembeli', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _action(request, 'complete', body: {'kode_pickup': _kode.text}),
              child: const Text('Selesaikan Pesanan'),
            ),
          ],
        ],
      ),
    );
  }
}
