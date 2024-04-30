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
    apiKey: 'AIzaSyDybz_-olpRJYKwuw15Q0IoHJfYSd1r-wM',
    appId: '1:368195787132:web:91d3c9dcbe5a5100e92cf9',
    messagingSenderId: '368195787132',
    projectId: 'videomobileapp-8c0b3',
    authDomain: 'videomobileapp-8c0b3.firebaseapp.com',
    storageBucket: 'videomobileapp-8c0b3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEC6ABX8NmsxKVF_uYMMltH-mmPI_iY28',
    appId: '1:368195787132:android:689d4eafc5a3a898e92cf9',
    messagingSenderId: '368195787132',
    projectId: 'videomobileapp-8c0b3',
    storageBucket: 'videomobileapp-8c0b3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCuMMfDUSY_YKKa_lVsTT450a9uKUR_BR0',
    appId: '1:368195787132:ios:386daeb4e65fd18be92cf9',
    messagingSenderId: '368195787132',
    projectId: 'videomobileapp-8c0b3',
    storageBucket: 'videomobileapp-8c0b3.appspot.com',
    iosBundleId: 'com.example.mobileProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCuMMfDUSY_YKKa_lVsTT450a9uKUR_BR0',
    appId: '1:368195787132:ios:386daeb4e65fd18be92cf9',
    messagingSenderId: '368195787132',
    projectId: 'videomobileapp-8c0b3',
    storageBucket: 'videomobileapp-8c0b3.appspot.com',
    iosBundleId: 'com.example.mobileProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDybz_-olpRJYKwuw15Q0IoHJfYSd1r-wM',
    appId: '1:368195787132:web:07dce47086ba840ce92cf9',
    messagingSenderId: '368195787132',
    projectId: 'videomobileapp-8c0b3',
    authDomain: 'videomobileapp-8c0b3.firebaseapp.com',
    storageBucket: 'videomobileapp-8c0b3.appspot.com',
  );
}