import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import 'login.dart';
import 'order_list.dart';
import 'placeholder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 2;

  static const _titles = ['Food', 'Peta', 'Pesanan', 'Ulasan'];

  Future<void> _logout(CookieRequest request) async {
    await request.logout('$baseUrl/api/auth/logout/');
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final pages = [
      const PlaceholderPage(title: 'Food & Restaurant', owner: 'Kapitra'),
      const PlaceholderPage(title: 'Location & Map', owner: 'Akbar'),
      const OrderListPage(),
      const PlaceholderPage(title: 'Review & Rating', owner: 'Khansa'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => _logout(request))],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Food'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Peta'),
          NavigationDestination(icon: Icon(Icons.shopping_bag), label: 'Pesanan'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Ulasan'),
        ],
      ),
    );
  }
}
