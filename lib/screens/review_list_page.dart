import 'package:flutter/material.dart';

// Halaman utama modul Review & Rating.
class ReviewListPage extends StatelessWidget {
  final VoidCallback onViewOrders;

  const ReviewListPage({
    super.key,
    required this.onViewOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.rate_review_outlined,
              size: 72,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Review & Rating',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Bagikan pengalamanmu setelah menikmati '
              'Surprise Box dari restoran favoritmu!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onViewOrders,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Lihat Pesanan'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pilih pesanan yang sudah selesai '
              'untuk memberikan rating dan ulasan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
