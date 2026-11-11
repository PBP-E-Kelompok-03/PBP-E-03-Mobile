class Order {
  final int id;
  final String namaPaket;
  final String restoran;
  final String alamat;
  final String pembeli;
  final int jumlah;
  final double total;
  final String status;
  final String kodePickup;
  final DateTime kedaluwarsaPada;

  Order({
    required this.id,
    required this.namaPaket,
    required this.restoran,
    required this.alamat,
    required this.pembeli,
    required this.jumlah,
    required this.total,
    required this.status,
    required this.kodePickup,
    required this.kedaluwarsaPada,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        namaPaket: json['nama_paket'],
        restoran: json['restoran'],
        alamat: json['alamat'],
        pembeli: json['pembeli'],
        jumlah: json['jumlah'],
        total: double.parse(json['total'].toString()),
        status: json['status'],
        kodePickup: json['kode_pickup'],
        kedaluwarsaPada: DateTime.parse(json['kedaluwarsa_pada']).toLocal(),
      );
}
