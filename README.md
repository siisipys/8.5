# Portal Berita - Flutter Firebase Application

Aplikasi Portal Berita dengan Flutter dan Firebase Authentication. Aplikasi ini memungkinkan pengguna untuk membaca, menambah, mengedit, dan menghapus berita dengan sistem autentikasi yang aman.

## Download Project

[![Download ZIP](https://img.shields.io/badge/Download-ZIP-blue?style=for-the-badge&logo=google-drive)](https://drive.google.com/drive/folders/1C_emiQCpoRJp3LPMSBhsOwWAJesAA5dH?usp=sharing)

**[Download Portal Berita (ZIP)](https://drive.google.com/drive/folders/1C_emiQCpoRJp3LPMSBhsOwWAJesAA5dH?usp=sharing)**

Isi file ZIP:
- 📄 **Laporan Project** (PDF)
- 💻 **Source Code** (Flutter Project)
- 📱 **APK** (Android Application)

##  Fitur Utama

### 1. Autentikasi (Firebase Authentication)
- **Login** dengan email dan password
- **Registrasi** akun baru
- **Logout** dari aplikasi
- **Reset Password** via email
- Pengguna yang sudah login memiliki akses fitur CRUD berita

### 2. Manajemen Berita (Cloud Firestore)
- Daftar berita dengan kategori
- Pencarian berita
- Filter berdasarkan kategori
- Detail berita lengkap
- CRUD berita (khusus pengguna login)

### 3. Profil Pengguna (CRUD)
- **Create**: Profil dibuat saat registrasi
- **Read**: Lihat informasi profil
- **Update**: Edit nama, bio, telepon, alamat, foto profil
- **Delete**: Hapus akun secara permanen

### 4. Halaman Aplikasi
- **Halaman Login/Register**: Autentikasi pengguna
- **Halaman Home**: Daftar berita dengan nama pengguna
- **Halaman Detail Berita**: Informasi lengkap berita
- **Halaman Form Berita**: Tambah/edit berita
- **Halaman Profil**: Manajemen profil dengan CRUD

##  Struktur Project

```
lib/
├── main.dart                 # Entry point & Auth wrapper
├── firebase_options.dart     # Firebase configuration
├── models/
│   ├── berita_model.dart     # Model data berita
│   └── user_model.dart       # Model data profil pengguna
├── screens/
│   ├── home_screen.dart      # Halaman utama (daftar berita)
│   ├── login_screen.dart     # Halaman login
│   ├── register_screen.dart  # Halaman registrasi
│   ├── profile_screen.dart   # Halaman profil (CRUD)
│   ├── detail_berita_screen.dart  # Detail berita
│   └── form_berita_screen.dart    # Form tambah/edit berita
├── services/
│   ├── auth_service.dart     # Service autentikasi Firebase
│   ├── berita_service.dart   # Service CRUD berita
│   └── user_service.dart     # Service CRUD profil pengguna
├── utils/
│   └── app_theme.dart        # Tema dan styling aplikasi
└── widgets/
    ├── berita_card.dart      # Widget kartu berita
    └── shimmer_loading.dart  # Widget loading shimmer
```

##  Alur Autentikasi

```
┌─────────────────┐
│  App Starts     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthWrapper    │──── Check Auth State
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐ ┌────────────┐
│ Login │ │ MainScreen │
│ Screen│ │ (Logged In)│
└───────┘ └────────────┘
```

##  Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
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

##  Struktur Data Firebase

### Collection: `users`
```json
{
  "uid": "firebase_auth_uid",
  "email": "user@email.com",
  "nama": "Nama Pengguna",
  "bio": "Bio pengguna",
  "fotoUrl": "https://...",
  "noTelp": "08xxxxxxxxxx",
  "alamat": "Alamat pengguna",
  "tanggalDibuat": Timestamp,
  "tanggalDiubah": Timestamp
}
```

### Collection: `berita`
```json
{
  "judul": "Judul Berita",
  "isi": "Isi berita lengkap...",
  "kategori": "Teknologi",
  "penulis": "Nama Penulis",
  "gambarUrl": "https://...",
  "tanggalDibuat": Timestamp,
  "tanggalDiubah": Timestamp
}
```

##  Cara Menjalankan

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd Portal-Berita-firebase
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Buat project di [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password)
   - Buat Cloud Firestore database
   - Download `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS)
   - Jalankan `flutterfire configure` untuk generate firebase_options.dart

4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

##  Screenshots

### Login & Register
- Tampilan login dengan gradient background
- Form registrasi dengan validasi
- Animasi smooth saat transisi

### Home Screen
- Greeting dengan nama pengguna
- Daftar berita dengan kategori
- Search dan filter

### Profile Screen
- Informasi profil lengkap
- Edit profil dengan bottom sheet
- Logout dan hapus akun

##  Fitur Keamanan

- Password minimal 6 karakter
- Validasi email format
- Akses CRUD berita hanya untuk pengguna login
- Konfirmasi sebelum hapus akun
- Reset password via email

##  Catatan Pengembangan

- Menggunakan StreamBuilder untuk realtime data
- Pattern service untuk business logic
- Separation of concerns (models, services, screens)
- Consistent error handling dengan SnackBar
- Indonesian locale untuk format tanggal

##  Author

Tugas Praktikum Web - Semester 3

---

Made with ❤️ using Flutter & Firebase
# 8.5
# 8.5
