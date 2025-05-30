// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBKpv0ERC9cys_UfF3W5Nh95eg5l7W-ORM',
    appId: '1:37851029006:web:d9bffb3736ccd23725e65f',
    messagingSenderId: '37851029006',
    projectId: 'petdb-6d1e5',
    authDomain: 'petdb-6d1e5.firebaseapp.com',
    storageBucket: 'petdb-6d1e5.firebasestorage.app',
    measurementId: 'G-6HGLZC6E14',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDM99iSAnxcN5MjMJKDV6JmYh-7OUR87cA',
    appId: '1:37851029006:android:3cb2f5a4acc8676225e65f',
    messagingSenderId: '37851029006',
    projectId: 'petdb-6d1e5',
    storageBucket: 'petdb-6d1e5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqoZ3PRFb7EpWkDeHqCNW7jHNOsOgaemQ',
    appId: '1:37851029006:ios:0528400c3b71daf725e65f',
    messagingSenderId: '37851029006',
    projectId: 'petdb-6d1e5',
    storageBucket: 'petdb-6d1e5.firebasestorage.app',
    iosBundleId: 'com.example.cpdkylescicluna',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAqoZ3PRFb7EpWkDeHqCNW7jHNOsOgaemQ',
    appId: '1:37851029006:ios:0528400c3b71daf725e65f',
    messagingSenderId: '37851029006',
    projectId: 'petdb-6d1e5',
    storageBucket: 'petdb-6d1e5.firebasestorage.app',
    iosBundleId: 'com.example.cpdkylescicluna',
  );

}