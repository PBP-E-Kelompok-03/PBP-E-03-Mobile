import 'package:flutter/material.dart';

import '../config.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(order.namaPaket),
        subtitle: Text('${order.restoran} - ${order.jumlah} box\n${rupiah(order.total)}'),
        isThreeLine: true,
        trailing: Text(
          statusLabel(order.status),
          style: TextStyle(color: statusColor(order.status), fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
