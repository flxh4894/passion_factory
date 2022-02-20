// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWY8L5-56mL96HQY1Z6avS8x3aIfN9t20',
    appId: '1:443777596998:android:45e1e6e6f72270097b1447',
    messagingSenderId: '443777596998',
    projectId: 'passion-factory-44d1f',
    databaseURL: 'https://passion-factory-44d1f-default-rtdb.firebaseio.com',
    storageBucket: 'passion-factory-44d1f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgdkIIZ6qOwNkTWxs9js5DnSMKX1Fz_mA',
    appId: '1:443777596998:ios:c56cc8cf2edc74497b1447',
    messagingSenderId: '443777596998',
    projectId: 'passion-factory-44d1f',
    databaseURL: 'https://passion-factory-44d1f-default-rtdb.firebaseio.com',
    storageBucket: 'passion-factory-44d1f.appspot.com',
    iosClientId: '443777596998-o12m0dtus0epcdndv2sq3omr65pjogt9.apps.googleusercontent.com',
    iosBundleId: 'com.polymorph.app',
  );
}