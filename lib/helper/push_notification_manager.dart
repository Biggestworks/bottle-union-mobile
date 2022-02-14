import 'dart:io';

import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationManager {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  UserPreferences _userPreferences = new UserPreferences();

  Future showNotification(Map<String, dynamic> msg) async {
    try {
      AndroidNotificationDetails androidNotificationDetails = new AndroidNotificationDetails(
        'fcm_default_channel',
        'Channel Title',
        importance: Importance.max,
        priority: Priority.max,
        visibility: NotificationVisibility.public,
        ticker: 'ticker',
        channelShowBadge: true,
      );
      IOSNotificationDetails iosNotificationDetails = new IOSNotificationDetails(
        presentBadge: true,
        presentAlert: true,
        presentSound: true,
      );
      NotificationDetails notificationDetails = new NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );
      await _flutterLocalNotificationsPlugin.show(
        1,
        msg['title'] ?? '',
        msg['body'] ?? '',
        notificationDetails,
        payload: msg.toString(),
      );
    } catch (e) {
      print('SHOW NOTIFICATION FAILED: $e');
    }
  }

  Future _onSelectNotification(String? payload) async {
    print('PAYLOAD DATA: $payload');
  }

  Future saveFcmToken() async {
    _firebaseMessaging.getToken().then((token) async {
      await _userPreferences.saveFcmToken(token!);
      print('FCM TOKEN: $token');
    });
  }

  Future initFCM() async {
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false,
      );
    }

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var init = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      init,
      onSelectNotification: _onSelectNotification,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showNotification(message.data);
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

}
