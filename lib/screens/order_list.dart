import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/order.dart';
import '../widgets/order_card.dart';
import 'box_list.dart';
import 'order_detail.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late Future<List<Order>> _orders = _fetchOrders();

  Future<List<Order>> _fetchOrders() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('$baseUrl/api/order/orders/');
    return (response as List).map((json) => Order.fromJson(json)).toList();
  }

  Future<void> _refresh() async {
    setState(() => _orders = _fetchOrders());
    await _orders.catchError((_) => <Order>[]);
  }

  Widget _message(String text) {
    return ListView(
      children: [Padding(padding: const EdgeInsets.all(32), child: Center(child: Text(text)))],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBuyer = context.watch<CookieRequest>().jsonData['role'] == 'buyer';
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Order>>(
          future: _orders,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _message('Gagal memuat pesanan. Tarik ke bawah untuk mencoba lagi.');
            }
            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return _message('Belum ada pesanan.');
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, i) => OrderCard(
                order: orders[i],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderDetailPage(order: orders[i])),
                  );
                  _refresh();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: isBuyer
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const BoxListPage()));
                _refresh();
              },
              icon: const Icon(Icons.add),
              label: const Text('Pesan'),
            )
          : null,
    );
  }
}
