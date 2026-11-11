class Box {
  final int id;
  final String namaPaket;
  final String restoran;
  final String alamat;
  final double hargaNormal;
  final double hargaDiskon;
  final int stok;

  Box({
    required this.id,
    required this.namaPaket,
    required this.restoran,
    required this.alamat,
    required this.hargaNormal,
    required this.hargaDiskon,
    required this.stok,
  });

  factory Box.fromJson(Map<String, dynamic> json) => Box(
        id: json['id'],
        namaPaket: json['nama_paket'],
        restoran: json['restoran'],
        alamat: json['alamat'],
        hargaNormal: double.parse(json['harga_normal'].toString()),
        hargaDiskon: double.parse(json['harga_diskon'].toString()),
        stok: json['stok'],
      );
}
