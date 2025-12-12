# LAPORAN PROJECT
# PORTAL BERITA DENGAN FIREBASE

**Mata Kuliah:** Pemrograman Web Praktik  
**Semester:** 3 (Tiga)  
**Tanggal:** 12 Desember 2024

---

## DAFTAR ISI

1. [Pendahuluan](#1-pendahuluan)
2. [Persiapan dan Setup](#2-persiapan-dan-setup)
3. [Implementasi Firebase Authentication](#3-implementasi-firebase-authentication)
4. [Perancangan & Implementasi Data](#4-perancangan--implementasi-data)
5. [Implementasi Fitur Utama](#5-implementasi-fitur-utama)
6. [Tampilan Antarmuka (UI)](#6-tampilan-antarmuka-ui)
7. [Penggunaan AI](#7-penggunaan-ai)
8. [File ENV](#8-file-env)
9. [Kesimpulan](#9-kesimpulan)

---

## 1. PENDAHULUAN

### 1.1 Studi Kasus yang Dipilih

Studi kasus yang dipilih dalam project ini adalah **Portal Berita** - sebuah aplikasi mobile berbasis Flutter yang memungkinkan pengguna untuk:
- Membaca berita terkini dari berbagai kategori
- Mendaftar dan login untuk akses fitur lengkap
- Mengelola profil pengguna
- Menambah, mengedit, dan menghapus berita (untuk pengguna yang terautentikasi)

### 1.2 Tujuan Aplikasi

Tujuan utama dari aplikasi Portal Berita ini adalah:

1. **Menyediakan platform informasi** - Memberikan akses mudah kepada pengguna untuk membaca berita dari berbagai kategori (Politik, Ekonomi, Teknologi, Olahraga, Hiburan, Kesehatan, Pendidikan).

2. **Implementasi Firebase** - Mendemonstrasikan penggunaan layanan Firebase (Authentication dan Cloud Firestore) dalam aplikasi Flutter.

3. **Autentikasi Pengguna** - Menerapkan sistem login/registrasi yang aman menggunakan Firebase Authentication.

4. **Manajemen Data Real-time** - Menggunakan Cloud Firestore untuk penyimpanan dan pengambilan data secara real-time.

5. **User Experience yang Baik** - Memberikan pengalaman pengguna yang menarik dengan desain UI modern dan navigasi yang intuitif.

---

## 2. PERSIAPAN DAN SETUP

### 2.1 Pembuatan Project Flutter

**Langkah-langkah pembuatan project Flutter:**

1. **Membuka terminal dan menjalankan perintah:**
   ```bash
   flutter create portal_berita
   cd portal_berita
   ```

2. **Struktur folder project:**
   ```
   portal_berita/
   ├── lib/
   │   ├── main.dart
   │   ├── firebase_options.dart
   │   ├── models/
   │   │   ├── berita_model.dart
   │   │   └── user_model.dart
   │   ├── screens/
   │   │   ├── home_screen.dart
   │   │   ├── login_screen.dart
   │   │   ├── register_screen.dart
   │   │   ├── profile_screen.dart
   │   │   ├── detail_berita_screen.dart
   │   │   └── form_berita_screen.dart
   │   ├── services/
   │   │   ├── auth_service.dart
   │   │   ├── berita_service.dart
   │   │   └── user_service.dart
   │   ├── utils/
   │   │   └── app_theme.dart
   │   └── widgets/
   │       ├── berita_card.dart
   │       └── shimmer_loading.dart
   └── pubspec.yaml
   ```

3. **Menambahkan dependencies di `pubspec.yaml`:**
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     cupertino_icons: ^1.0.8
     
     # Firebase
     firebase_core: ^3.8.1
     cloud_firestore: ^5.5.1
     firebase_auth: ^5.3.4
     
     # UI & Utils
     google_fonts: ^6.2.1
     intl: ^0.20.1
     cached_network_image: ^3.4.1
     shimmer: ^3.0.0
   ```

4. **Install dependencies:**
   ```bash
   flutter pub get
   ```

### 2.2 Pembuatan Project di Firebase Console

**Langkah-langkah setup Firebase:**

1. **Buka Firebase Console** di https://console.firebase.google.com
2. **Klik "Add project"** dan beri nama project: `portal-berita-tugas`
3. **Aktifkan Google Analytics** (opsional)
4. **Tunggu proses pembuatan project selesai**

**Setup Firebase Authentication:**
1. Di Firebase Console, pilih **Build > Authentication**
2. Klik **"Get Started"**
3. Aktifkan **Email/Password** sebagai sign-in method

**Setup Cloud Firestore:**
1. Di Firebase Console, pilih **Build > Firestore Database**
2. Klik **"Create Database"**
3. Pilih lokasi server dan mode **Test Mode** untuk development

### 2.3 Integrasi Firebase dengan Flutter

**Langkah-langkah integrasi:**

1. **Install FlutterFire CLI:**
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Jalankan konfigurasi FlutterFire:**
   ```bash
   flutterfire configure --project=portal-berita-tugas
   ```

3. **File `firebase_options.dart` akan otomatis terbuat** dengan konfigurasi:
   ```dart
   class DefaultFirebaseOptions {
     static FirebaseOptions get currentPlatform {
       if (kIsWeb) return web;
       switch (defaultTargetPlatform) {
         case TargetPlatform.android: return android;
         case TargetPlatform.iOS: return ios;
         // ... platform lainnya
       }
     }

     static const FirebaseOptions web = FirebaseOptions(
       apiKey: 'AIzaSyAftFDXWOFZL6gA7-s5wky-EVvNW_n13p4',
       appId: '1:30243407640:web:e001cfde9249e51b20006d',
       messagingSenderId: '30243407640',
       projectId: 'portal-berita-tugas',
       authDomain: 'portal-berita-tugas.firebaseapp.com',
       storageBucket: 'portal-berita-tugas.firebasestorage.app',
     );
     // ... konfigurasi platform lain
   }
   ```

4. **Inisialisasi Firebase di `main.dart`:**
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // Initialize Firebase
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     
     // Initialize date formatting for Indonesian locale
     await initializeDateFormatting('id_ID', null);
     
     runApp(const PortalBeritaApp());
   }
   ```

---

## 3. IMPLEMENTASI FIREBASE AUTHENTICATION

### 3.1 Alur Login/Registrasi

**Alur autentikasi dalam aplikasi:**

```
┌─────────────────────────────────────────────────────────────────┐
│                        APP START                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   AuthWrapper (main.dart)                        │
│     Mendengarkan perubahan status autentikasi Firebase           │
└───────────────────────────┬─────────────────────────────────────┘
                            │
            ┌───────────────┴───────────────┐
            │                               │
            ▼                               ▼
    ┌───────────────┐               ┌───────────────┐
    │  User NULL    │               │ User LOGGED IN │
    │ (Belum Login) │               │   (Ada User)   │
    └───────┬───────┘               └───────┬───────┘
            │                               │
            ▼                               ▼
    ┌───────────────┐               ┌───────────────┐
    │  LoginScreen  │               │MainNavigation │
    │               │               │ (Home+Profile)│
    └───────────────┘               └───────────────┘
```

### 3.2 AuthWrapper - Pengecekan Status Login

**Lokasi:** `lib/main.dart`

```dart
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Mendengarkan perubahan status autentikasi
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Tampilkan loading saat memeriksa status auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Handle error
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        // Jika user sudah login, tampilkan halaman utama
        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigationScreen();
        }

        // Jika belum login, tampilkan halaman login
        return const LoginScreen();
      },
    );
  }
}
```

**Penjelasan:**
- `StreamBuilder<User?>` digunakan untuk mendengarkan perubahan status autentikasi secara real-time
- `authStateChanges()` memberikan stream yang akan emit setiap kali status auth berubah
- Jika `snapshot.hasData` berarti user sudah login, jika tidak maka tampilkan LoginScreen

### 3.3 Fungsi Register

**Lokasi:** `lib/services/auth_service.dart`

```dart
Future<UserCredential> registerWithEmail({
  required String email,
  required String password,
  required String nama,
}) async {
  try {
    // 1. Buat user di Firebase Auth
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // 2. Buat profil user di Firestore
    if (result.user != null) {
      final userProfile = UserProfile(
        uid: result.user!.uid,
        email: email.trim(),
        nama: nama.trim(),
        tanggalDibuat: DateTime.now(),
      );

      await _usersCollection.doc(result.user!.uid).set(userProfile.toMap());

      // 3. Update display name di Firebase Auth
      await result.user!.updateDisplayName(nama.trim());
    }

    return result;
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}
```

**Penjelasan:**
1. Fungsi menerima parameter `email`, `password`, dan `nama`
2. `createUserWithEmailAndPassword` membuat akun baru di Firebase Auth
3. Setelah akun terbuat, profil user disimpan di Firestore collection `users`
4. Display name juga diupdate di Firebase Auth untuk kemudahan akses

### 3.4 Fungsi Login

**Lokasi:** `lib/services/auth_service.dart`

```dart
Future<UserCredential> signInWithEmail({
  required String email,
  required String password,
}) async {
  try {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}
```

**Penjelasan:**
- Fungsi sederhana yang memanggil `signInWithEmailAndPassword` dari Firebase Auth
- Email di-trim untuk menghapus spasi kosong
- Error ditangani dan diubah ke pesan bahasa Indonesia

### 3.5 Handler Login di Screen

**Lokasi:** `lib/screens/login_screen.dart`

```dart
Future<void> _handleLogin() async {
  // Validasi form terlebih dahulu
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    await _authService.signInWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
    );
    
    // Navigasi akan di-handle otomatis oleh AuthWrapper di main.dart
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(e.toString())),
            ],
          ),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

**Penjelasan:**
1. Validasi form menggunakan `GlobalKey<FormState>`
2. Set `_isLoading = true` untuk menampilkan loading indicator
3. Panggil `signInWithEmail` dengan data dari form
4. Jika berhasil, `AuthWrapper` akan otomatis mendeteksi dan navigasi ke home
5. Jika gagal, tampilkan error message dengan SnackBar

### 3.6 Fungsi Reset Password

```dart
Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email.trim());
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}
```

### 3.7 Error Handler dengan Pesan Indonesia

```dart
String _handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return 'Email tidak terdaftar';
    case 'wrong-password':
      return 'Password salah';
    case 'email-already-in-use':
      return 'Email sudah digunakan';
    case 'weak-password':
      return 'Password terlalu lemah (minimal 6 karakter)';
    case 'invalid-email':
      return 'Format email tidak valid';
    case 'user-disabled':
      return 'Akun telah dinonaktifkan';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Coba lagi nanti';
    case 'invalid-credential':
      return 'Email atau password salah';
    default:
      return e.message ?? 'Terjadi kesalahan autentikasi';
  }
}
```

---

## 4. PERANCANGAN & IMPLEMENTASI DATA

### 4.1 Gambaran Umum Struktur Data

Aplikasi ini menggunakan **Cloud Firestore** dengan 2 collection utama:

```
Firestore Database
├── users (Collection)
│   └── {userId} (Document)
│       ├── uid: string
│       ├── email: string
│       ├── nama: string
│       ├── bio: string (optional)
│       ├── fotoUrl: string (optional)
│       ├── noTelp: string (optional)
│       ├── alamat: string (optional)
│       ├── tanggalDibuat: timestamp
│       └── tanggalDiubah: timestamp (optional)
│
└── berita (Collection)
    └── {beritaId} (Document)
        ├── judul: string
        ├── isi: string
        ├── kategori: string
        ├── penulis: string
        ├── gambarUrl: string (optional)
        ├── tanggalDibuat: timestamp
        └── tanggalDiubah: timestamp (optional)
```

### 4.2 Model Berita

**Lokasi:** `lib/models/berita_model.dart`

```dart
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

  // Convert object ke Map untuk Firestore
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

  // Buat object dari Firestore document
  factory Berita.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Berita(
      id: doc.id,
      judul: data['judul'] ?? '',
      isi: data['isi'] ?? '',
      kategori: data['kategori'] ?? 'Umum',
      penulis: data['penulis'] ?? 'Anonim',
      gambarUrl: data['gambarUrl'],
      tanggalDibuat: (data['tanggalDibuat'] as Timestamp?)?.toDate() 
          ?? DateTime.now(),
      tanggalDiubah: (data['tanggalDiubah'] as Timestamp?)?.toDate(),
    );
  }
}

// Daftar kategori berita
class KategoriBerita {
  static const List<String> daftar = [
    'Umum', 'Politik', 'Ekonomi', 'Teknologi',
    'Olahraga', 'Hiburan', 'Kesehatan', 'Pendidikan',
  ];
}
```

### 4.3 Model User Profile

**Lokasi:** `lib/models/user_model.dart`

```dart
class UserProfile {
  final String? id;
  final String uid;      // Firebase Auth UID
  final String email;
  final String nama;
  final String? bio;
  final String? fotoUrl;
  final String? noTelp;
  final String? alamat;
  final DateTime tanggalDibuat;
  final DateTime? tanggalDiubah;

  // ... constructor dan methods

  // Get initials untuk avatar
  String get initials {
    if (nama.isEmpty) return email[0].toUpperCase();
    final parts = nama.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nama[0].toUpperCase();
  }
}
```

### 4.4 Berita Service - CRUD Operations

**Lokasi:** `lib/services/berita_service.dart`

**CREATE - Tambah Berita:**
```dart
Future<DocumentReference> tambahBerita(Berita berita) async {
  try {
    return await _beritaCollection.add(berita.toMap());
  } catch (e) {
    throw Exception('Gagal menambah berita: $e');
  }
}
```

**READ - Ambil Semua Berita (Stream/Realtime):**
```dart
Stream<List<Berita>> getSemuaBerita() {
  return _beritaCollection
      .orderBy('tanggalDibuat', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Berita.fromFirestore(doc)).toList();
  });
}
```

**READ - Filter Berdasarkan Kategori:**
```dart
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
```

**UPDATE - Update Berita:**
```dart
Future<void> updateBerita(String id, Berita berita) async {
  try {
    Map<String, dynamic> data = berita.toMap();
    data['tanggalDiubah'] = Timestamp.fromDate(DateTime.now());
    await _beritaCollection.doc(id).update(data);
  } catch (e) {
    throw Exception('Gagal mengupdate berita: $e');
  }
}
```

**DELETE - Hapus Berita:**
```dart
Future<void> hapusBerita(String id) async {
  try {
    await _beritaCollection.doc(id).delete();
  } catch (e) {
    throw Exception('Gagal menghapus berita: $e');
  }
}
```

**SEARCH - Cari Berita:**
```dart
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
```

### 4.5 Penggunaan Stream untuk Real-time Update

Aplikasi menggunakan `StreamBuilder` untuk menampilkan data secara real-time:

```dart
StreamBuilder<List<Berita>>(
  stream: _beritaService.getSemuaBerita(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const ShimmerLoading(); // Loading state
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final beritaList = snapshot.data ?? [];
    
    if (beritaList.isEmpty) {
      return Center(child: Text('Belum ada berita'));
    }

    return ListView.builder(
      itemCount: beritaList.length,
      itemBuilder: (context, index) {
        return BeritaCard(berita: beritaList[index]);
      },
    );
  },
)
```

---

## 5. IMPLEMENTASI FITUR UTAMA

### 5.1 Fitur Autentikasi

**a. Login dengan Email & Password**
- Validasi email dan password
- Error handling dengan pesan bahasa Indonesia
- Fitur "Lupa Password" untuk reset via email

**b. Registrasi User Baru**
- Input: Nama, Email, Password, Konfirmasi Password
- Checkbox persetujuan syarat & ketentuan
- Otomatis membuat profil di Firestore

### 5.2 Fitur Home Screen

```dart
class HomeScreen extends StatefulWidget {
  // ...
}

class _HomeScreenState extends State<HomeScreen> {
  final BeritaService _beritaService = BeritaService();
  String _selectedKategori = 'Semua';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header dengan greeting user
          SliverAppBar(...),
          
          // Search bar
          SliverToBoxAdapter(child: TextField(...)),
          
          // Filter kategori (horizontal scroll)
          SliverToBoxAdapter(child: ListView(...)),
          
          // Daftar berita dengan StreamBuilder
          StreamBuilder<List<Berita>>(...),
        ],
      ),
      // FAB untuk tambah berita (hanya jika login)
      floatingActionButton: currentUser != null 
          ? FloatingActionButton.extended(
              onPressed: _navigateToAdd,
              label: Text('Tambah Berita'),
            )
          : null,
    );
  }
}
```

**Fitur utama Home Screen:**
- Greeting berdasarkan waktu (Pagi/Siang/Sore/Malam)
- Search berita berdasarkan judul/isi
- Filter berdasarkan kategori
- Daftar berita dengan card yang menarik
- Shimmer loading effect saat memuat data

### 5.3 Fitur Profile Screen

```dart
class ProfileScreen extends StatefulWidget {
  // ...
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserProfile?>(
        stream: _userService.streamCurrentUserProfile(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          
          return CustomScrollView(
            slivers: [
              // Header dengan avatar dan info user
              SliverAppBar(expandedHeight: 280, ...),
              
              // Informasi pribadi
              _buildInfoCard(user),
              
              // Bio
              _buildBioCard(user),
              
              // Menu pengaturan
              _buildActionsCard(),
              
              // Tombol logout
              _buildLogoutButton(),
            ],
          );
        },
      ),
    );
  }
}
```

**Fitur Profile:**
- Menampilkan foto profil (dari URL) atau initials
- Informasi: Nama, Email, Telepon, Alamat
- Edit profil via bottom sheet
- Ubah password (via email reset)
- Ubah foto profil (via URL)
- Logout dan hapus akun

### 5.4 Fitur CRUD Berita

**Tambah/Edit Berita:**
```dart
class FormBeritaScreen extends StatefulWidget {
  final Berita? berita; // null untuk tambah, ada nilai untuk edit
  
  // Form dengan validasi untuk:
  // - Judul (wajib)
  // - Isi/konten (wajib)
  // - Kategori (dropdown)
  // - Penulis (wajib)
  // - URL Gambar (opsional)
}
```

**Hapus Berita:**
- Konfirmasi dialog sebelum menghapus
- Feedback dengan SnackBar setelah berhasil/gagal

---

## 6. TAMPILAN ANTARMUKA (UI)

### 6.1 Screenshot Halaman Utama

#### A. Halaman Login

![Login Screen](screenshot_login_screen.png)

**Deskripsi:**
- Background dengan gradient biru (indigo)
- Logo aplikasi di bagian atas
- Card form login dengan field Email dan Password
- Tombol "Masuk" dengan loading indicator
- Link "Lupa Password?" untuk reset
- Link "Daftar Sekarang" untuk registrasi

#### B. Halaman Register

![Register Screen](screenshot_register_screen.png)

**Deskripsi:**
- Desain serupa dengan login screen
- Field: Nama Lengkap, Email, Password, Konfirmasi Password
- Checkbox persetujuan syarat & ketentuan
- Validasi real-time pada setiap field

#### C. Halaman Home/Berita

![Home Screen](screenshot_home_screen.png)

**Deskripsi:**
- App bar dengan greeting dan avatar user
- Search bar untuk mencari berita
- Chip kategori yang dapat di-scroll horizontal
- Card berita dengan gambar, judul, kategori, tanggal
- Floating Action Button untuk tambah berita

#### D. Halaman Profile

![Profile Screen](screenshot_profile_screen.png)

**Deskripsi:**
- Header gradient dengan foto profil dan nama user
- Info pribadi dalam card terstruktur
- Section bio pengguna
- Menu pengaturan akun
- Tombol logout dan hapus akun

#### E. Halaman Detail Berita

![Detail Screen](screenshot_detail_screen.png)

**Deskripsi:**
- Gambar berita full-width di bagian atas
- Judul, penulis, dan tanggal
- Badge kategori
- Isi berita lengkap
- Tombol edit/hapus (jika login)

### 6.2 Alur Navigasi Aplikasi

```
┌─────────────────────────────────────────────────────────────────┐
│                        SPLASH SCREEN                            │
└───────────────────────────┬─────────────────────────────────────┘
                            │ (Check Auth)
            ┌───────────────┴───────────────┐
            ▼                               ▼
    ┌───────────────┐               ┌───────────────────┐
    │  LOGIN SCREEN │◀──────────────│ MAIN NAVIGATION   │
    └───────┬───────┘   (Logout)    │ ┌──────┬──────┐   │
            │                       │ │ Home │Profile│   │
            │ (Login Success)       │ └──────┴──────┘   │
            │                       └─────┬─────┬───────┘
            │                             │     │
    ┌───────┴───────┐                     │     │
    │REGISTER SCREEN│                     │     │
    └───────────────┘                     ▼     ▼
                                    ┌─────────────────┐
                                    │ Detail Berita   │
                                    │ Form Berita     │
                                    │ Edit Profile    │
                                    └─────────────────┘
```

**Penjelasan Navigasi:**
1. Aplikasi dimulai dengan Splash Screen sambil mengecek status autentikasi
2. Jika belum login → Login Screen → dapat navigasi ke Register Screen
3. Jika sudah login → Main Navigation dengan Bottom Nav (Home & Profile)
4. Dari Home dapat navigasi ke Detail Berita atau Form Berita
5. Dari Profile dapat mengedit profil, ubah password, atau logout

---

## 7. PENGGUNAAN AI

### 7.1 AI yang Digunakan

Dalam pengembangan project ini, digunakan bantuan **AI berikut**:

| AI | Kegunaan |
|-----|----------|
| **ChatGPT** | Membantu penulisan struktur kode dan debugging |
| **GitHub Copilot** | Auto-complete kode saat development |
| **Gemini (Claude)** | Membantu menyusun dokumentasi dan laporan |

### 7.2 Bagian yang Dibantu AI

1. **Struktur Project**
   - Membantu menentukan arsitektur folder (models, services, screens, widgets)
   - Menyarankan pattern pemisahan logic dan UI

2. **Implementasi Firebase**
   - Contoh kode untuk Firebase Authentication
   - Cara menggunakan StreamBuilder dengan Firestore
   - Error handling untuk Firebase exceptions

3. **Desain UI**
   - Inspirasi desain modern dengan gradient dan card
   - Implementasi animasi fade dan slide
   - Shimmer loading effect

4. **Penulisan Kode**
   - Template untuk model class (toMap, fromFirestore)
   - Boilerplate untuk StatefulWidget
   - Validasi form

5. **Dokumentasi**
   - Penyusunan struktur laporan
   - Penulisan penjelasan kode
   - Membuat diagram alur

---

## 8. FILE ENV

### 8.1 Konfigurasi Firebase

Project ini **tidak menggunakan file `.env`** karena konfigurasi Firebase disimpan langsung di file `lib/firebase_options.dart` yang di-generate oleh FlutterFire CLI.

**Konfigurasi Firebase yang digunakan:**

```dart
// File: lib/firebase_options.dart

static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyAftFDXWOFZL6gA7-s5wky-EVvNW_n13p4',
  appId: '1:30243407640:web:e001cfde9249e51b20006d',
  messagingSenderId: '30243407640',
  projectId: 'portal-berita-tugas',
  authDomain: 'portal-berita-tugas.firebaseapp.com',
  storageBucket: 'portal-berita-tugas.firebasestorage.app',
);
```

> **Catatan:** API Key Firebase untuk client-side apps (mobile/web) bersifat publik dan aman karena akses ke data dikontrol oleh Firebase Security Rules, bukan oleh API key.

---

## 9. KESIMPULAN

### 9.1 Ringkasan Project

Project Portal Berita dengan Firebase telah berhasil diimplementasikan dengan fitur:

✅ **Firebase Authentication** - Login, Register, Reset Password, Logout  
✅ **Cloud Firestore** - CRUD berita dan profil user dengan realtime update  
✅ **UI/UX Modern** - Desain menarik dengan animasi dan gradient  
✅ **State Management** - Menggunakan StreamBuilder untuk realtime data  
✅ **Responsive** - Dapat berjalan di Android, iOS, Web, dan Desktop  

### 9.2 Teknologi yang Digunakan

| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| Flutter | 3.9.2 | Framework UI |
| Firebase Core | 3.8.1 | Core Firebase SDK |
| Cloud Firestore | 5.5.1 | Database NoSQL |
| Firebase Auth | 5.3.4 | Autentikasi |
| Google Fonts | 6.2.1 | Custom fonts |
| Intl | 0.20.1 | Formatting tanggal |
| Cached Network Image | 3.4.1 | Caching gambar |
| Shimmer | 3.0.0 | Loading effect |

### 9.3 Lessons Learned

1. **Firebase Integration** - Proses integrasi Firebase dengan Flutter cukup mudah dengan FlutterFire CLI
2. **Realtime Database** - Stream dari Firestore sangat powerful untuk menampilkan data realtime
3. **State Management** - StreamBuilder cukup untuk aplikasi sederhana, untuk aplikasi kompleks dapat menggunakan Provider/Bloc
4. **Error Handling** - Penting untuk menangani error dengan pesan yang user-friendly

---

**Dibuat oleh:** [Nama Mahasiswa]  
**NIM:** [NIM Mahasiswa]  
**Tanggal:** 12 Desember 2024
