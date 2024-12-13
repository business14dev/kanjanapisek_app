import 'package:kanjanapisek_app/src/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kanjanapisek_app/src/my_app.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(AppConstant.OneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver(
      (OSEmailSubscriptionStateChanges emailChanges) {
    // Will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });

  runApp(const MyApp());
}
