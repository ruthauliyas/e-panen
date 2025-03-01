class Pemanen {
  String nama;
  int barisAwal;
  int barisAkhir;
  bool hadir;
  String? pengganti; // null kalau dia hadir

  Pemanen({
    required this.nama,
    required this.barisAwal,
    required this.barisAkhir,
    this.hadir = true,
    this.pengganti,
  });

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'barisAwal': barisAwal,
    'barisAkhir': barisAkhir,
    'hadir': hadir,
    'pengganti': pengganti,
  };

  static Pemanen fromJson(Map<String, dynamic> json) => Pemanen(
    nama: json['nama'],
    barisAwal: json['barisAwal'],
    barisAkhir: json['barisAkhir'],
    hadir: json['hadir'],
    pengganti: json['pengganti'],
  );
}
