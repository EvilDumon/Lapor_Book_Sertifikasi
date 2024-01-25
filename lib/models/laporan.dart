class Laporan {
  final String uid;
  final String docId;
  final String judul;
  final String instansi;
  String? deskripsi;
  String? foto;
  final String pelapor;
  final String status;
  final DateTime tgl_lapor;
  final String koordinat;
  List<Komentar>? komentar;

  Laporan(
      {required this.uid,
      required this.docId,
      required this.judul,
      required this.instansi,
      this.deskripsi,
      this.foto,
      required this.pelapor,
      required this.status,
      required this.tgl_lapor,
      required this.koordinat,
      this.komentar});
}

class Komentar {
  final String uid;
  final String name;
  final String komentar;

  Komentar({required this.uid, required this.name, required this.komentar});
}
