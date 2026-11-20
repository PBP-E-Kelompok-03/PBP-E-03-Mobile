import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';

// Halaman Review & Rating sesuai desain Figma.
class ReviewPage extends StatefulWidget {
  final int orderId;

  const ReviewPage({super.key, required this.orderId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int rating = 0;
  final commentController = TextEditingController();
  final Set<String> selectedTags = {};

  // Menandai apakah review sedang dikirim ke Django.
  bool isSubmitting = false;

  // Daftar tag yang dapat dipilih pengguna.
  final List<String> tags = [
    'Roti segar',
    'Porsi banyak',
    'Staf ramah',
    'Tepat waktu',
    'Worth it',
  ];

  // Fungsi untuk mengirim rating dan komentar ke Django API.
  Future<void> submitReview() async {
    // Memastikan pengguna sudah memilih rating dan mengisi komentar.
    if (rating == 0 || commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi rating dan komentar terlebih dahulu'),
        ),
      );
      return;
    }

    // Mengambil sesi login pengguna untuk autentikasi API.
    final request = context.read<CookieRequest>();

    // Menandai bahwa proses pengiriman sedang berlangsung.
    setState(() {
      isSubmitting = true;
    });

    try {
      // Mengirim rating dan komentar berdasarkan ID pesanan.
      final response = await request.postJson(
        '$baseUrl/review/api/create/${widget.orderId}/',
        jsonEncode({
          'rating': rating,
          'comment': commentController.text.trim(),
        }),
      );

      if (!mounted) return;

      // Menampilkan pesan sukses dan kembali ke detail pesanan.
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review berhasil dikirim!'),
          ),
        );

        Navigator.pop(context);
      } else {
        // Menampilkan pesan kesalahan dari Django.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${response['error'] ?? 'Gagal mengirim review'}',
            ),
          ),
        );
      }
    } catch (e) {
      // Menangani kesalahan koneksi atau pengiriman data.
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    } finally {
      // Mengaktifkan kembali tombol setelah pengiriman selesai.
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  // Membersihkan controller ketika halaman ditutup.
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna utama yang digunakan pada halaman Review.
    const green = Color(0xFF006B41);
    const orange = Color(0xFFFF7918);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header halaman Review.
              const Text(
                'Beri Ulasan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // Kartu informasi pesanan dan formulir ulasan.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
                child: Column(
                  children: [
                    // Menampilkan informasi bahwa pesanan selesai.
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE8F7F0),
                      child: Icon(
                        Icons.check_circle,
                        color: green,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Pesanan selesai',
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Informasi restoran dan paket masih berupa contoh UI.
                    const Text(
                      'The Daily Knead Bakery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '1x Mystery Sweet Pastry Box',
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    const Text('Bagaimana pesananmu?'),

                    const SizedBox(height: 10),

                    // Rating bintang interaktif dari 1 sampai 5.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  setState(() {
                                    rating = index + 1;
                                  });
                                },
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: orange,
                            size: 35,
                          ),
                        );
                      }),
                    ),

                    // Menampilkan nilai rating yang dipilih.
                    Text(
                      rating == 0 ? 'Pilih rating' : '$rating dari 5 bintang',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pilihan tag ulasan yang dapat dipilih lebih dari satu.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: tags.map((tag) {
                        return FilterChip(
                          label: Text(tag),
                          selected: selectedTags.contains(tag),
                          selectedColor: const Color(0xFFE8F7F0),
                          onSelected: isSubmitting
                              ? null
                              : (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedTags.add(tag);
                                    } else {
                                      selectedTags.remove(tag);
                                    }
                                  });
                                },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Kolom untuk menulis komentar ulasan.
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        labelText: 'Komentar',
                        hintText:
                            'Tulis komentar tentang rasa makanan atau pelayanan gerai...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tombol untuk mengirim ulasan ke Django API.
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                  ),

                  // Mencegah pengiriman berulang saat loading.
                  onPressed: isSubmitting ? null : submitReview,

                  // Menampilkan loading selama proses pengiriman.
                  child: isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Kirim ulasan'),
                ),
              ),

              const SizedBox(height: 12),

              // Tombol untuk kembali ke halaman detail pesanan.
              TextButton(
                onPressed: isSubmitting
                    ? null
                    : () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                child: const Text(
                  'Kembali ke detail pesanan',
                  style: TextStyle(color: green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
