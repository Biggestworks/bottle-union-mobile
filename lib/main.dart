import 'package:eight_barrels/helper/db_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/notification/notification_model.dart';
import 'package:eight_barrels/screen/app.dart';
import 'package:eight_barrels/screen/misc/fallBack_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

Future _loadEnv() async =>
  await dotenv.load(fileName: ".env.production");
  // await dotenv.load(fileName: ".env.development");

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _loadEnv();
  await Firebase.initializeApp();
  await PushNotificationManager().showNotification(message.data);
  DbHelper _dbHelper = new DbHelper();
  UserPreferences _userPreferences = new UserPreferences();

  var _user = await _userPreferences.getUserData();

  await _dbHelper.insertNotification(items: NotificationModel(
    userId: _user?.user?.id,
    title: message.data['title'] ?? '',
    body: message.data['body'] ?? '',
    type: message.data['type'] ?? '',
    codeTransaction: message.data['code_transaction'] ?? '',
    regionId: message.data['id_region'] ?? '',
    isNew: 1,
    createdAt: DateTime.now().toString(),
  ),);

  print('Background message: ${message.data}');
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
  await _loadEnv();
  await _checkAppSecurity();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}