// Konfigurasi Firebase untuk Portal Berita
// Generated from Firebase Console

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAftFDXWOFZL6gA7-s5wky-EVvNW_n13p4',
    appId: '1:30243407640:web:e001cfde9249e51b20006d',
    messagingSenderId: '30243407640',
    projectId: 'portal-berita-tugas',
    storageBucket: 'portal-berita-tugas.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAftFDXWOFZL6gA7-s5wky-EVvNW_n13p4',
    appId: '1:30243407640:web:e001cfde9249e51b20006d',
    messagingSenderId: '30243407640',
    projectId: 'portal-berita-tugas',
    storageBucket: 'portal-berita-tugas.firebasestorage.app',
    iosBundleId: 'com.tugas.portalBerita',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAftFDXWOFZL6gA7-s5wky-EVvNW_n13p4',
    appId: '1:30243407640:web:e001cfde9249e51b20006d',
    messagingSenderId: '30243407640',
    projectId: 'portal-berita-tugas',
    storageBucket: 'portal-berita-tugas.firebasestorage.app',
    iosBundleId: 'com.tugas.portalBerita',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAftFDXWOFZL6gA7-s5wky-EVvNW_n13p4',
    appId: '1:30243407640:web:e001cfde9249e51b20006d',
    messagingSenderId: '30243407640',
    projectId: 'portal-berita-tugas',
    storageBucket: 'portal-berita-tugas.firebasestorage.app',
  );
}
