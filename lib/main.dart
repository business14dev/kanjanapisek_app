import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kanjanapisek_app/src/my_app.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
   if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDm0QJYbKrmwcTK5cv2cKvUt0PNxy1jXgo",
        authDomain: "gs-kanjanapisek.firebaseapp.com",
        projectId: "gs-kanjanapisek",
        storageBucket: "gs-kanjanapisek.firebasestorage.app",
        messagingSenderId: "450309644778",
        appId: "1:450309644778:web:69e1bd56ae876b3f5bd293",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

   //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(AppConstant.OneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}
