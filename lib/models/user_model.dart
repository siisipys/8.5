import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? id;
  final String uid; // Firebase Auth UID
  final String email;
  final String nama;
  final String? bio;
  final String? fotoUrl;
  final String? noTelp;
  final String? alamat;
  final DateTime tanggalDibuat;
  final DateTime? tanggalDiubah;

  UserProfile({
    this.id,
    required this.uid,
    required this.email,
    required this.nama,
    this.bio,
    this.fotoUrl,
    this.noTelp,
    this.alamat,
    required this.tanggalDibuat,
    this.tanggalDiubah,
  });

  // Convert UserProfile object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nama': nama,
      'bio': bio,
      'fotoUrl': fotoUrl,
      'noTelp': noTelp,
      'alamat': alamat,
      'tanggalDibuat': Timestamp.fromDate(tanggalDibuat),
      'tanggalDiubah': tanggalDiubah != null
          ? Timestamp.fromDate(tanggalDiubah!)
          : null,
    };
  }

  // Create UserProfile object from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      nama: data['nama'] ?? 'Pengguna',
      bio: data['bio'],
      fotoUrl: data['fotoUrl'],
      noTelp: data['noTelp'],
      alamat: data['alamat'],
      tanggalDibuat: (data['tanggalDibuat'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tanggalDiubah: (data['tanggalDiubah'] as Timestamp?)?.toDate(),
    );
  }

  // Copy with method for updating
  UserProfile copyWith({
    String? id,
    String? uid,
    String? email,
    String? nama,
    String? bio,
    String? fotoUrl,
    String? noTelp,
    String? alamat,
    DateTime? tanggalDibuat,
    DateTime? tanggalDiubah,
  }) {
    return UserProfile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nama: nama ?? this.nama,
      bio: bio ?? this.bio,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      noTelp: noTelp ?? this.noTelp,
      alamat: alamat ?? this.alamat,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      tanggalDiubah: tanggalDiubah ?? this.tanggalDiubah,
    );
  }

  // Get display name (nama or email prefix)
  String get displayName {
    if (nama.isNotEmpty) return nama;
    return email.split('@').first;
  }

  // Get initials for avatar
  String get initials {
    if (nama.isEmpty) return email[0].toUpperCase();
    final parts = nama.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nama[0].toUpperCase();
  }
}

