import 'dart:io';

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else if (Platform.isIOS || Platform.isMacOS) {
      return ios;
    } else {
      return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
     
  apiKey: "AIzaSyDm0QJYbKrmwcTK5cv2cKvUt0PNxy1jXgo",
  authDomain: "gs-kanjanapisek.firebaseapp.com",
  projectId: "gs-kanjanapisek",
  storageBucket: "gs-kanjanapisek.firebasestorage.app",
  messagingSenderId: "450309644778",
  appId: "1:450309644778:web:69e1bd56ae876b3f5bd293");

  static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyBk0XV_GwteoRiqKFMVnApBSo6ORk51RUo',
  appId: '1:450309644778:android:c877d5e0b2480a505bd293',
  messagingSenderId: '450309644778',
  projectId: 'gs-kanjanapisek',
  storageBucket: 'gs-kanjanapisek.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-ios-messaging-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-storage-bucket',
    iosClientId: 'your-ios-client-id',
    iosBundleId: 'your-ios-bundle-id',
  );
}
