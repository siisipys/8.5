import 'package:cloud_firestore/cloud_firestore.dart';

class Berita {
  final String? id;
  final String judul;
  final String isi;
  final String kategori;
  final String penulis;
  final String? gambarUrl;
  final DateTime tanggalDibuat;
  final DateTime? tanggalDiubah;

  Berita({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.penulis,
    this.gambarUrl,
    required this.tanggalDibuat,
    this.tanggalDiubah,
  });

  // Convert Berita object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'isi': isi,
      'kategori': kategori,
      'penulis': penulis,
      'gambarUrl': gambarUrl,
      'tanggalDibuat': Timestamp.fromDate(tanggalDibuat),
      'tanggalDiubah': tanggalDiubah != null 
          ? Timestamp.fromDate(tanggalDiubah!) 
          : null,
    };
  }

  // Create Berita object from Firestore document
  factory Berita.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Berita(
      id: doc.id,
      judul: data['judul'] ?? '',
      isi: data['isi'] ?? '',
      kategori: data['kategori'] ?? 'Umum',
      penulis: data['penulis'] ?? 'Anonim',
      gambarUrl: data['gambarUrl'],
      tanggalDibuat: (data['tanggalDibuat'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tanggalDiubah: (data['tanggalDiubah'] as Timestamp?)?.toDate(),
    );
  }

  // Copy with method for updating
  Berita copyWith({
    String? id,
    String? judul,
    String? isi,
    String? kategori,
    String? penulis,
    String? gambarUrl,
    DateTime? tanggalDibuat,
    DateTime? tanggalDiubah,
  }) {
    return Berita(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      penulis: penulis ?? this.penulis,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      tanggalDiubah: tanggalDiubah ?? this.tanggalDiubah,
    );
  }
}

// Daftar kategori berita
class KategoriBerita {
  static const List<String> daftar = [
    'Umum',
    'Politik',
    'Ekonomi',
    'Teknologi',
    'Olahraga',
    'Hiburan',
    'Kesehatan',
    'Pendidikan',
  ];
}

