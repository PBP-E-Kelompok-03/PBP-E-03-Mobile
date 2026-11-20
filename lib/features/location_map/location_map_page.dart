import 'package:flutter/material.dart';

import '../../config.dart';

/// Isi tab Peta; AppBar dan navigasi utama disediakan oleh HomePage.
class LocationMapPage extends StatefulWidget {
  const LocationMapPage({super.key});

  @override
  State<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  static const _categories = ['Semua', 'Roti & pastry', 'Bento & box', 'Kopi'];

  final _searchController = TextEditingController();
  String _selectedCategory = _categories.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              decoration: const BoxDecoration(
                color: kDarkGreen,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Senopati, Jakarta Selatan',
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Lokasi contoh',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    style: textTheme.bodyMedium?.copyWith(color: kDarkGreen),
                    decoration: InputDecoration(
                      hintText: 'Cari restoran atau lokasi...',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: kDarkGreen.withAlpha(150),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: kGreen),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Hapus pencarian',
                              icon: const Icon(Icons.close, color: kGreen),
                              onPressed: () {
                                setState(() => _searchController.clear());
                              },
                            ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kGreen, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Kategori restoran',
                    style: textTheme.titleMedium?.copyWith(
                      color: kDarkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final category in _categories)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: _selectedCategory == category,
                              onSelected: (_) {
                                setState(() => _selectedCategory = category);
                              },
                              showCheckmark: false,
                              selectedColor: kGreen,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _selectedCategory == category
                                    ? Colors.white
                                    : kDarkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: _selectedCategory == category
                                    ? kGreen
                                    : kGreen.withAlpha(50),
                              ),
                              shape: const StadiumBorder(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pencarian dan kategori belum menyaring daftar contoh.',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  const _MapPlaceholder(),
                  const SizedBox(height: 24),
                  Text(
                    'Contoh restoran',
                    style: textTheme.titleLarge?.copyWith(
                      color: kDarkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Data contoh untuk pratinjau. Nama, alamat, dan jarak '
                    'di bawah ini hanya ilustrasi.',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  // Data lokal untuk UI, bukan model atau respons API.
                  const _RestaurantPreviewCard(
                    name: 'Roti Pagi',
                    category: 'Roti & pastry',
                    distance: '0,4 km',
                    address: 'Jl. Senopati No. 12, Jakarta Selatan',
                    icon: Icons.bakery_dining_outlined,
                  ),
                  const SizedBox(height: 12),
                  const _RestaurantPreviewCard(
                    name: 'Dapur Bento',
                    category: 'Bento & box',
                    distance: '0,8 km',
                    address: 'Jl. Suryo No. 8, Jakarta Selatan',
                    icon: Icons.lunch_dining_outlined,
                  ),
                  const SizedBox(height: 12),
                  const _RestaurantPreviewCard(
                    name: 'Kopi Sore',
                    category: 'Kopi',
                    distance: '1,2 km',
                    address: 'Jl. Wolter Monginsidi No. 24, Jakarta Selatan',
                    icon: Icons.local_cafe_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ganti widget ini dengan peta interaktif pada tahap integrasi berikutnya.
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 240),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kGreen.withAlpha(12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kGreen.withAlpha(45)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kGreen.withAlpha(24),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 40,
              color: kGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Peta segera hadir',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: kDarkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lokasi restoran akan ditampilkan di sini. '
            'Integrasi peta dikembangkan pada tahap berikutnya.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _RestaurantPreviewCard extends StatelessWidget {
  final String name;
  final String category;
  final String distance;
  final String address;
  final IconData icon;

  const _RestaurantPreviewCard({
    required this.name,
    required this.category,
    required this.distance,
    required this.address,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: kDarkGreen.withAlpha(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kGreen.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: kGreen, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.titleMedium?.copyWith(
                      color: kDarkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Text(category, style: textTheme.bodySmall),
                      Text(
                        distance,
                        style: textTheme.bodySmall?.copyWith(
                          color: kGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(address, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
