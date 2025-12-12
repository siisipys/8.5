import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/berita_model.dart';

class BeritaService {
  final CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('berita');

  // Data dummy berita untuk seeding
  static final List<Map<String, dynamic>> _dummyBerita = [
    {
      'judul': 'Indonesia Raih Medali Emas di Olimpiade Paris 2024',
      'isi': '''Tim bulu tangkis Indonesia berhasil meraih medali emas di Olimpiade Paris 2024. Prestasi gemilang ini diraih setelah mengalahkan lawan dari China dalam pertandingan final yang berlangsung sangat ketat.

Pertandingan berlangsung selama 3 set dengan skor akhir 21-19, 18-21, 21-17. Para pemain menunjukkan permainan yang luar biasa dan semangat juang yang tinggi.

"Ini adalah hasil kerja keras selama bertahun-tahun. Kami sangat bangga bisa membawa medali emas untuk Indonesia," ujar pelatih tim nasional.

Presiden RI memberikan ucapan selamat melalui akun media sosialnya dan menjanjikan bonus bagi para atlet berprestasi.''',
      'kategori': 'Olahraga',
      'penulis': 'Ahmad Wijaya',
      'gambarUrl': 'https://images.unsplash.com/photo-1461896836934- voices-podcast?w=800',
    },
    {
      'judul': 'Apple Meluncurkan iPhone 16 dengan Fitur AI Canggih',
      'isi': '''Apple resmi meluncurkan iPhone 16 series dengan berbagai fitur kecerdasan buatan (AI) yang revolusioner. Smartphone terbaru ini hadir dengan chip A18 Bionic yang diklaim 40% lebih cepat dari generasi sebelumnya.

Fitur unggulan iPhone 16 meliputi:
- Apple Intelligence untuk asisten AI personal
- Kamera 48MP dengan Night Mode yang ditingkatkan
- Baterai tahan hingga 2 hari pemakaian normal
- Dynamic Island yang lebih interaktif

"iPhone 16 adalah lompatan besar dalam teknologi smartphone. Kami telah mengintegrasikan AI ke dalam setiap aspek pengalaman pengguna," kata Tim Cook, CEO Apple.

iPhone 16 akan tersedia di Indonesia mulai bulan depan dengan harga mulai dari Rp 18 juta.''',
      'kategori': 'Teknologi',
      'penulis': 'Siti Rahma',
      'gambarUrl': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800',
    },
    {
      'judul': 'Bank Indonesia Pertahankan Suku Bunga Acuan di 6%',
      'isi': '''Rapat Dewan Gubernur (RDG) Bank Indonesia memutuskan untuk mempertahankan suku bunga acuan BI Rate di level 6%. Keputusan ini diambil untuk menjaga stabilitas nilai tukar rupiah dan mengendalikan inflasi.

Gubernur BI Perry Warjiyo menjelaskan bahwa keputusan ini mempertimbangkan kondisi ekonomi global yang masih penuh ketidakpastian.

"Kami akan terus memantau perkembangan ekonomi dan siap mengambil langkah yang diperlukan untuk menjaga stabilitas," ujarnya dalam konferensi pers.

Inflasi Indonesia tercatat sebesar 2,5% year-on-year, masih dalam rentang target 2-4%. Nilai tukar rupiah stabil di kisaran Rp 15.500 per dolar AS.''',
      'kategori': 'Ekonomi',
      'penulis': 'Budi Santoso',
      'gambarUrl': 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800',
    },
    {
      'judul': 'Pemilu 2024: KPU Umumkan Hasil Rekapitulasi Nasional',
      'isi': '''Komisi Pemilihan Umum (KPU) telah mengumumkan hasil rekapitulasi suara nasional Pemilu 2024. Proses penghitungan suara berlangsung selama beberapa minggu dan melibatkan ribuan petugas di seluruh Indonesia.

Ketua KPU menyampaikan bahwa proses pemilu berjalan dengan lancar dan demokratis. Partisipasi pemilih mencapai 82%, meningkat dari pemilu sebelumnya.

"Kami mengapresiasi partisipasi aktif masyarakat Indonesia dalam pesta demokrasi ini. Pemilu 2024 menjadi bukti kedewasaan demokrasi bangsa kita," ungkap Ketua KPU.

Hasil resmi akan segera ditetapkan setelah proses verifikasi dan penanganan sengketa di Mahkamah Konstitusi selesai.''',
      'kategori': 'Politik',
      'penulis': 'Dewi Lestari',
      'gambarUrl': 'https://images.unsplash.com/photo-1540910419892-4a36d2c3266c?w=800',
    },
    {
      'judul': 'Film Indonesia "Ngeri-Ngeri Sedap" Raih Penghargaan Internasional',
      'isi': '''Film Indonesia "Ngeri-Ngeri Sedap" berhasil meraih penghargaan Best Feature Film di Festival Film Asia Pasifik. Film yang disutradarai oleh Bene Dion Rajagukguk ini mengisahkan tentang keluarga Batak yang tinggal di Sumatera Utara.

Film ini mendapat pujian dari kritikus internasional karena berhasil mengangkat nilai-nilai kekeluargaan dengan cara yang menghibur dan menyentuh hati.

Para pemain utama termasuk Arswendy Bening Swara, Tika Panggabean, dan Gading Marten turut hadir dalam acara penghargaan di Seoul, Korea Selatan.

"Penghargaan ini membuktikan bahwa film Indonesia mampu bersaing di kancah internasional," kata sang sutradara.''',
      'kategori': 'Hiburan',
      'penulis': 'Rina Kartika',
      'gambarUrl': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800',
    },
    {
      'judul': 'Kemenkes Luncurkan Program Vaksinasi Gratis untuk Lansia',
      'isi': '''Kementerian Kesehatan meluncurkan program vaksinasi gratis untuk warga lanjut usia (lansia) di seluruh Indonesia. Program ini mencakup vaksin influenza, pneumonia, dan booster COVID-19.

Menteri Kesehatan menjelaskan bahwa program ini bertujuan untuk melindungi kelompok rentan dari berbagai penyakit menular.

"Lansia memiliki risiko lebih tinggi mengalami komplikasi serius. Dengan program ini, kami berharap dapat meningkatkan kualitas hidup lansia Indonesia," jelasnya.

Program vaksinasi akan dilaksanakan di Puskesmas dan rumah sakit pemerintah mulai bulan ini. Lansia berusia 60 tahun ke atas dapat mendaftar dengan membawa KTP.''',
      'kategori': 'Kesehatan',
      'penulis': 'Dr. Hendra Pratama',
      'gambarUrl': 'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=800',
    },
    {
      'judul': 'Kemendikbud Rilis Kurikulum Merdeka Belajar Versi Terbaru',
      'isi': '''Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi merilis pembaruan Kurikulum Merdeka Belajar. Versi terbaru ini memberikan lebih banyak fleksibilitas bagi sekolah dalam mengembangkan pembelajaran.

Mendikbudristek menyampaikan bahwa kurikulum baru ini fokus pada pengembangan kompetensi abad 21, termasuk berpikir kritis, kreativitas, kolaborasi, dan komunikasi.

Fitur baru dalam kurikulum ini meliputi:
- Proyek Penguatan Profil Pelajar Pancasila
- Pembelajaran berbasis teknologi
- Asesmen diagnostik untuk memahami kebutuhan siswa
- Pelatihan guru secara berkelanjutan

"Kurikulum ini dirancang untuk mempersiapkan generasi muda menghadapi tantangan masa depan," ujar Mendikbudristek.''',
      'kategori': 'Pendidikan',
      'penulis': 'Prof. Sumarno',
      'gambarUrl': 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
    },
    {
      'judul': 'Harga BBM Turun, Pertamina Umumkan Penyesuaian Tarif',
      'isi': '''PT Pertamina (Persero) mengumumkan penurunan harga bahan bakar minyak (BBM) non-subsidi. Penyesuaian ini mengikuti tren penurunan harga minyak dunia dalam beberapa minggu terakhir.

Daftar harga BBM terbaru:
- Pertamax: Rp 12.500/liter (turun Rp 500)
- Pertamax Turbo: Rp 13.900/liter (turun Rp 600)
- Dexlite: Rp 13.200/liter (turun Rp 400)
- Pertamina Dex: Rp 14.100/liter (turun Rp 500)

Direktur Utama Pertamina menyatakan bahwa penurunan harga ini diharapkan dapat membantu meringankan beban masyarakat.

"Kami berkomitmen untuk memberikan harga terbaik sesuai dengan kondisi pasar global," tegasnya.''',
      'kategori': 'Ekonomi',
      'penulis': 'Agus Setiawan',
      'gambarUrl': 'https://images.unsplash.com/photo-1611605698335-8b1569810432?w=800',
    },
    {
      'judul': 'Gempa Bumi M 5.8 Guncang Sulawesi Tengah',
      'isi': '''Gempa bumi berkekuatan 5.8 magnitudo mengguncang wilayah Sulawesi Tengah pada Senin pagi. Pusat gempa berada di kedalaman 10 km dengan lokasi 45 km barat daya Palu.

BMKG menyatakan gempa ini tidak berpotensi tsunami. Namun, masyarakat diminta tetap waspada terhadap gempa susulan.

Berdasarkan laporan awal, tidak ada korban jiwa akibat gempa ini. Beberapa bangunan mengalami kerusakan ringan, terutama di daerah yang dekat dengan pusat gempa.

BNPB telah mengerahkan tim untuk melakukan assessment dan memberikan bantuan kepada warga yang terdampak.

"Kami mengimbau masyarakat untuk tetap tenang dan mengikuti arahan dari pihak berwenang," kata Kepala BNPB.''',
      'kategori': 'Umum',
      'penulis': 'Tim Redaksi',
      'gambarUrl': 'https://images.unsplash.com/photo-1545153996-e01b20500a29?w=800',
    },
    {
      'judul': 'Startup Indonesia Raih Pendanaan Seri B Senilai Rp 500 Miliar',
      'isi': '''Startup teknologi finansial (fintech) asal Indonesia berhasil meraih pendanaan Seri B senilai Rp 500 miliar dari konsorsium investor global. Pendanaan ini dipimpin oleh venture capital ternama dari Silicon Valley.

CEO startup tersebut menjelaskan bahwa dana segar ini akan digunakan untuk ekspansi ke negara-negara Asia Tenggara lainnya dan pengembangan produk baru.

"Indonesia memiliki potensi besar di sektor fintech. Dengan pendanaan ini, kami siap membawa layanan kami ke level berikutnya," ujarnya.

Startup ini telah melayani lebih dari 5 juta pengguna di Indonesia dan mencatatkan pertumbuhan transaksi 300% dalam setahun terakhir.

Investor menyatakan keyakinannya terhadap prospek bisnis startup Indonesia di tengah pertumbuhan ekonomi digital yang pesat.''',
      'kategori': 'Teknologi',
      'penulis': 'Fadli Rahman',
      'gambarUrl': 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=800',
    },
  ];

  // CREATE - Tambah berita baru
  Future<DocumentReference> tambahBerita(Berita berita) async {
    try {
      return await _beritaCollection.add(berita.toMap());
    } catch (e) {
      throw Exception('Gagal menambah berita: $e');
    }
  }

  // READ - Ambil semua berita (Stream untuk realtime)
  Stream<List<Berita>> getSemuaBerita() {
    return _beritaCollection
        .orderBy('tanggalDibuat', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Berita.fromFirestore(doc)).toList();
    });
  }

  // READ - Ambil berita berdasarkan kategori (filter client-side untuk menghindari index)
  Stream<List<Berita>> getBeritaByKategori(String kategori) {
    return _beritaCollection
        .orderBy('tanggalDibuat', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Berita.fromFirestore(doc))
          .where((berita) => berita.kategori == kategori)
          .toList();
    });
  }

  // READ - Ambil satu berita berdasarkan ID
  Future<Berita?> getBeritaById(String id) async {
    try {
      DocumentSnapshot doc = await _beritaCollection.doc(id).get();
      if (doc.exists) {
        return Berita.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil berita: $e');
    }
  }

  // UPDATE - Update berita
  Future<void> updateBerita(String id, Berita berita) async {
    try {
      Map<String, dynamic> data = berita.toMap();
      data['tanggalDiubah'] = Timestamp.fromDate(DateTime.now());
      await _beritaCollection.doc(id).update(data);
    } catch (e) {
      throw Exception('Gagal mengupdate berita: $e');
    }
  }

  // DELETE - Hapus berita
  Future<void> hapusBerita(String id) async {
    try {
      await _beritaCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus berita: $e');
    }
  }

  // SEARCH - Cari berita berdasarkan judul
  Stream<List<Berita>> cariBerita(String keyword) {
    return _beritaCollection
        .orderBy('tanggalDibuat', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Berita.fromFirestore(doc))
          .where((berita) =>
              berita.judul.toLowerCase().contains(keyword.toLowerCase()) ||
              berita.isi.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  // SEED - Tambah data dummy berita
  // Set forceReload = true untuk hapus data lama dan muat ulang
  Future<int> seedDummyData({bool forceReload = false}) async {
    try {
      // Jika force reload, hapus semua data dulu
      if (forceReload) {
        await clearAllData();
      } else {
        // Cek apakah sudah ada data
        final snapshot = await _beritaCollection.limit(1).get();
        if (snapshot.docs.isNotEmpty) {
          return 0; // Data sudah ada, tidak perlu seed
        }
      }

      int count = 0;
      for (var data in _dummyBerita) {
        final berita = Berita(
          judul: data['judul'],
          isi: data['isi'],
          kategori: data['kategori'],
          penulis: data['penulis'],
          gambarUrl: data['gambarUrl'],
          tanggalDibuat: DateTime.now().subtract(Duration(days: count * 2)),
        );
        await _beritaCollection.add(berita.toMap());
        count++;
      }
      return count;
    } catch (e) {
      throw Exception('Gagal menambah data dummy: $e');
    }
  }

  // Cek apakah ada data berita
  Future<bool> hasData() async {
    final snapshot = await _beritaCollection.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  // Hapus semua data (untuk reset)
  Future<void> clearAllData() async {
    final snapshot = await _beritaCollection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Get total count berita
  Future<int> getTotalBerita() async {
    final snapshot = await _beritaCollection.get();
    return snapshot.docs.length;
  }
}
