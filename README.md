# Dibuang Sayang Mobile

Aplikasi mobile (Flutter) untuk **Dibuang Sayang**, platform penyelamat makanan berlebih (*surprise box*) yang mengurangi food waste dan menyediakan pilihan makanan terjangkau. Aplikasi ini adalah versi mobile dari situs web Django kelompok di Proyek Tengah Semester.

Proyek Akhir Semester - Pemrograman Berbasis Platform (CSGE602022), Fasilkom UI, Gasal 2026/2027. Kelompok E-03.

## Anggota Kelompok

| Nama | NPM |
| :--- | :--- |
| Kapitra Fachriza Utomo | 2506623231 |
| Muhammad Akbar Rinaldy | 2506586311 |
| Dyah Zhafira Wibowo | 2506623723 |
| Khansa Nathania Khairunnisa | 2506618061 |

## Deskripsi Aplikasi

**Dibuang Sayang** menghubungkan mitra restoran yang punya stok makanan berlebih dengan pembeli yang ingin makanan berkualitas dengan harga hemat. Pembeli memilih *surprise box*, melakukan reservasi, lalu mengambil pesanan di restoran memakai kode pickup. Mitra restoran menerima atau menolak pesanan dan memverifikasi kode pickup saat pembeli datang.

## Modul dan Pembagian Kerja

| Modul | Anggota | Cakupan di aplikasi mobile |
| :--- | :--- | :--- |
| Food & Restaurant | Kapitra Fachriza Utomo | Daftar restoran dan surprise box |
| Location & Map | Muhammad Akbar Rinaldy | Peta lokasi restoran |
| Pick up / Order (+ Accounts) | Dyah Zhafira Wibowo | Login, registrasi, pilih box, checkout, voucher kode pickup, riwayat pesanan, kelola pesanan masuk (mitra) |
| Review / Rating | Khansa Nathania Khairunnisa | Rating dan ulasan restoran |

## Peran Pengguna

- **Pembeli**: login atau daftar, memilih surprise box, memesan, melihat voucher dan kode pickup, membatalkan pesanan yang masih pending.
- **Mitra Restoran**: melihat pesanan masuk ke restorannya, menerima atau menolak pesanan, dan menyelesaikan pesanan dengan mencocokkan kode pickup.

## Alur Integrasi Data dengan Situs Web (PWS)

Aplikasi tidak menyimpan data sendiri. Semua data berasal dari situs Django (PWS) melalui web service Django REST Framework:

1. Aplikasi Flutter mengirim request HTTP (`CookieRequest` dari paket `pbp_django_auth`) ke endpoint `/api/...` milik situs Django. Sesi login disimpan lewat cookie.
2. Django memproses request (validasi, aturan stok, cek peran), mengakses database, lalu mengembalikan respons **JSON** lewat serializer DRF.
3. Aplikasi memetakan JSON ke model Dart (`Box`, `Order`) dan menampilkannya dengan widget (`FutureBuilder`, `ListView`, dan lainnya).
4. Aksi pengguna (pesan, batalkan, terima, selesaikan) memanggil endpoint `POST` secara asinkron, lalu tampilan diperbarui. Data yang berubah di aplikasi ikut berubah di situs web, begitu juga sebaliknya.

Endpoint modul Pick up / Order:

| Method | Endpoint | Fungsi |
| :--- | :--- | :--- |
| POST | `/api/auth/register/` | Daftar akun |
| POST | `/api/auth/login/` | Login |
| POST | `/api/auth/logout/` | Logout |
| GET | `/api/auth/me/` | Data pengguna login |
| GET | `/api/order/boxes/` | Daftar surprise box yang tersedia |
| GET | `/api/order/orders/` | Daftar pesanan (pembeli: miliknya, mitra: restorannya) |
| POST | `/api/order/orders/` | Buat pesanan |
| GET | `/api/order/orders/<id>/` | Detail pesanan |
| POST | `/api/order/orders/<id>/cancel/` | Pembeli membatalkan pesanan |
| POST | `/api/order/orders/<id>/confirm/` | Mitra menerima pesanan |
| POST | `/api/order/orders/<id>/reject/` | Mitra menolak pesanan |
| POST | `/api/order/orders/<id>/complete/` | Mitra menyelesaikan pesanan dengan kode pickup |

## Desain Figma

TODO: tambahkan tautan Figma.

## Tautan APK

TODO: tambahkan setelah Checkpoint 1.

## Menjalankan Aplikasi

1. Jalankan situs Django: `python manage.py runserver` (butuh `10.0.2.2` di `ALLOWED_HOSTS` untuk emulator Android).
2. Di repo ini, jalankan sekali: `flutter create . --project-name dibuang_sayang_mobile` untuk membuat folder platform, lalu `flutter pub get`.
3. Atur `baseUrl` di `lib/config.dart` (`http://10.0.2.2:8000` untuk emulator, atau URL PWS).
4. `flutter run`.

State management memakai `setState` (widget stateful). `provider` hanya dipakai untuk membagikan satu instance `CookieRequest` ke seluruh aplikasi.
