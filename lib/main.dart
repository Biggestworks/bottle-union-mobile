import 'package:eight_barrels/screen/app.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/screen/misc/fallBack_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Firebase.initializeApp();
  await PushNotificationManager().showNotification(message.data);
}

Future _checkAppSecurity() async {
  bool? _isJailBroken;
  bool? _isDeveloperMode;

  try {
    _isJailBroken = await FlutterJailbreakDetection.jailbroken;
    _isDeveloperMode = await FlutterJailbreakDetection.developerMode;
  } on PlatformException {
    _isJailBroken = true;
    _isDeveloperMode = true;
  }

  if (!_isJailBroken || !_isDeveloperMode) {
    runApp(App());
  } else {
    runApp(FallBackScreen());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env.production");
  await dotenv.load(fileName: ".env.development");
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _checkAppSecurity();
}