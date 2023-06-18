// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCj68ocLPHusdlah8xk-cEUdt6sgBxeBBM',
    appId: '1:814832995516:web:ad72bf3f38f3c108b394b9',
    messagingSenderId: '814832995516',
    projectId: 'packagevision-5a71a',
    authDomain: 'packagevision-5a71a.firebaseapp.com',
    storageBucket: 'packagevision-5a71a.appspot.com',
    measurementId: 'G-RGHJJMKM4B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCyPbQzOHgIQTzDtGHKFA52ZnSAk-J4K48',
    appId: '1:814832995516:android:42f52ba79c39e69db394b9',
    messagingSenderId: '814832995516',
    projectId: 'packagevision-5a71a',
    storageBucket: 'packagevision-5a71a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6Zb1lAcDRIXVg86wgp4LXMCTxAYg9GFE',
    appId: '1:814832995516:ios:775b698fc32f6af3b394b9',
    messagingSenderId: '814832995516',
    projectId: 'packagevision-5a71a',
    storageBucket: 'packagevision-5a71a.appspot.com',
    iosClientId: '814832995516-dvt3l71q76c9ojmje2gua6rbro4p34c8.apps.googleusercontent.com',
    iosBundleId: 'dev.steenbakker.qr',
  );
}
