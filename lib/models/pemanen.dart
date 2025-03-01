class Pemanen {
  String nama;
  int? barisAwal;
  int? barisAkhir;
  bool hadir;
  String? pengganti;
  List<String> statusBaris = [];  // Tambahan
  int? startBaris;                 // Tambahan

  Pemanen({
    required this.nama,
    this.barisAwal,
    this.barisAkhir,
    this.hadir = true,
    this.pengganti,
    List<String>? statusBaris,
    this.startBaris,
  }) : statusBaris = statusBaris ?? [];

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'barisAwal': barisAwal,
    'barisAkhir': barisAkhir,
    'hadir': hadir,
    'pengganti': pengganti,
    'statusBaris': statusBaris,
    'startBaris': startBaris,
  };

  static Pemanen fromJson(Map<String, dynamic> json) => Pemanen(
    nama: json['nama'],
    barisAwal: json['barisAwal'],
    barisAkhir: json['barisAkhir'],
    hadir: json['hadir'],
    pengganti: json['pengganti'],
    statusBaris: List<String>.from(json['statusBaris'] ?? []),
    startBaris: json['startBaris'],
  );
}
