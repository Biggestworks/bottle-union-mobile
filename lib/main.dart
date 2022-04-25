import 'package:eight_barrels/app.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Firebase.initializeApp();
  await PushNotificationManager().showNotification(message.data);
}

Future _loadEnv() async {
  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.production");
  } else {
    await dotenv.load(fileName: ".env.development");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnv();
  await Firebase.initializeApp();
  PushNotificationManager().saveFcmToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(App());
}