// Configuración de Firebase del proyecto "tp5-lugares".
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Esta app está configurada solo para Android y Web.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB628LEqOHwGN5xyP5G7_0mTP0SHBpOxYI',
    appId: '1:378287562786:web:67f4db0873caa4c51aea7b',
    messagingSenderId: '378287562786',
    projectId: 'tp5-lugares',
    authDomain: 'tp5-lugares.firebaseapp.com',
    storageBucket: 'tp5-lugares.firebasestorage.app',
    measurementId: 'G-SH1SERN3VG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB628LEqOHwGN5xyP5G7_0mTP0SHBpOxYI',
    appId: '1:378287562786:android:fadd6b3e1d7d39001aea7b',
    messagingSenderId: '378287562786',
    projectId: 'tp5-lugares',
    storageBucket: 'tp5-lugares.firebasestorage.app',
  );
}
