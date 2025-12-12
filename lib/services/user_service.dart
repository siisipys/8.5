import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE - Create new user profile
  Future<void> createUserProfile(UserProfile userProfile) async {
    try {
      await _usersCollection.doc(userProfile.uid).set(userProfile.toMap());
    } catch (e) {
      throw Exception('Gagal membuat profil: $e');
    }
  }

  // READ - Get user profile by UID
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil profil: $e');
    }
  }

  // READ - Stream user profile for real-time updates
  Stream<UserProfile?> streamUserProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    });
  }

  // READ - Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return getUserProfile(user.uid);
  }

  // READ - Stream current user profile
  Stream<UserProfile?> streamCurrentUserProfile() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }
    return streamUserProfile(user.uid);
  }

  // UPDATE - Update user profile
  Future<void> updateUserProfile(String uid, UserProfile userProfile) async {
    try {
      Map<String, dynamic> data = userProfile.toMap();
      data['tanggalDiubah'] = Timestamp.fromDate(DateTime.now());
      await _usersCollection.doc(uid).update(data);

      // Update display name in Firebase Auth if changed
      final user = _auth.currentUser;
      if (user != null && user.displayName != userProfile.nama) {
        await user.updateDisplayName(userProfile.nama);
      }
    } catch (e) {
      throw Exception('Gagal mengupdate profil: $e');
    }
  }

  // UPDATE - Update specific fields
  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    try {
      fields['tanggalDiubah'] = Timestamp.fromDate(DateTime.now());
      await _usersCollection.doc(uid).update(fields);
    } catch (e) {
      throw Exception('Gagal mengupdate profil: $e');
    }
  }

  // DELETE - Delete user profile (and optionally Firebase Auth account)
  Future<void> deleteUserProfile(String uid, {bool deleteAuthAccount = false}) async {
    try {
      // Delete Firestore profile
      await _usersCollection.doc(uid).delete();

      // Optionally delete Firebase Auth account
      if (deleteAuthAccount) {
        final user = _auth.currentUser;
        if (user != null && user.uid == uid) {
          await user.delete();
        }
      }
    } catch (e) {
      throw Exception('Gagal menghapus profil: $e');
    }
  }

  // Check if user profile exists
  Future<bool> userProfileExists(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Get all users (admin function)
  Stream<List<UserProfile>> getAllUsers() {
    return _usersCollection
        .orderBy('tanggalDibuat', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserProfile.fromFirestore(doc)).toList();
    });
  }

  // Search users by name
  Stream<List<UserProfile>> searchUsers(String keyword) {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc))
          .where((user) =>
              user.nama.toLowerCase().contains(keyword.toLowerCase()) ||
              user.email.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }
}

