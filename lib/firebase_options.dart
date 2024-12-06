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
    apiKey: 'AIzaSyBd6vHXJ5vk0apz1AKoA5eh0JjBQwoKrok',
    appId: '1:831360940478:web:cb19738f41c695665f61ef',
    messagingSenderId: '831360940478',
    projectId: 'nutrichild-331f6',
    authDomain: 'nutrichild-331f6.firebaseapp.com',
    storageBucket: 'nutrichild-331f6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBJVdc7C1m82X1BsaAEhslXJG5zpJGbp4',
    appId: '1:831360940478:android:b9382e3d17f535ca5f61ef',
    messagingSenderId: '831360940478',
    projectId: 'nutrichild-331f6',
    storageBucket: 'nutrichild-331f6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAf6hyPfEaUG1YqM1jeUmfNnetQABf-AkA',
    appId: '1:831360940478:ios:66d0da7c8c74f81b5f61ef',
    messagingSenderId: '831360940478',
    projectId: 'nutrichild-331f6',
    storageBucket: 'nutrichild-331f6.firebasestorage.app',
    iosBundleId: 'com.example.nutrichild',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAf6hyPfEaUG1YqM1jeUmfNnetQABf-AkA',
    appId: '1:831360940478:ios:66d0da7c8c74f81b5f61ef',
    messagingSenderId: '831360940478',
    projectId: 'nutrichild-331f6',
    storageBucket: 'nutrichild-331f6.firebasestorage.app',
    iosBundleId: 'com.example.nutrichild',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBd6vHXJ5vk0apz1AKoA5eh0JjBQwoKrok',
    appId: '1:831360940478:web:057ce8ba6059fdee5f61ef',
    messagingSenderId: '831360940478',
    projectId: 'nutrichild-331f6',
    authDomain: 'nutrichild-331f6.firebaseapp.com',
    storageBucket: 'nutrichild-331f6.firebasestorage.app',
  );
}
