import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/order.dart';
import 'box_list.dart';
import 'order_detail.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  Future<List<Order>> _fetchOrders(CookieRequest request) async {
    final response = await request.get('$baseUrl/api/order/orders/');
    return (response as List).map((e) => Order.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isBuyer = request.jsonData['role'] == 'buyer';
    return Scaffold(
      body: FutureBuilder<List<Order>>(
        future: _fetchOrders(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat pesanan.'));
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('Belum ada pesanan.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(order.namaPaket),
                  subtitle: Text('${order.restoran} - ${order.jumlah} box\n${rupiah(order.total)}'),
                  isThreeLine: true,
                  trailing: Text(order.status.toUpperCase()),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrderDetailPage(order: order)),
                    );
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isBuyer
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const BoxListPage()));
                setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Pesan'),
            )
          : null,
    );
  }
}
