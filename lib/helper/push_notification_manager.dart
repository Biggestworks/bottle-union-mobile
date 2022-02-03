// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/route_manager.dart';
// import 'package:persada_mobile_app/helpers/db_helper.dart';
// import 'package:persada_mobile_app/helpers/user_preferences.dart';
// import 'package:persada_mobile_app/models/notification.dart';
// import 'package:persada_mobile_app/resource/providers/home_providers.dart';
// import 'package:persada_mobile_app/resource/providers/notification_providers.dart';
// import 'package:persada_mobile_app/view/service/service_detail_screen.dart';
// import 'package:provider/provider.dart';
//
// class PushNotificationManager {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
//   static final DbHelper _dbHelper = new DbHelper();
//
//   static _showNotification(Map<String, dynamic> msg) async {
//     try {
//       AndroidNotificationDetails androidNotificationDetails = new AndroidNotificationDetails(
//         'fcm_default_channel',
//         'Channel Title',
//         'Channel Body',
//         importance: Importance.max,
//         priority: Priority.max,
//         visibility: NotificationVisibility.public,
//         ticker: 'ticker',
//         channelShowBadge: true,
//       );
//       IOSNotificationDetails iosNotificationDetails = new IOSNotificationDetails(
//         presentBadge: true,
//         presentAlert: true,
//         presentSound: true,
//       );
//       NotificationDetails notificationDetails = new NotificationDetails(
//         android: androidNotificationDetails,
//         iOS: iosNotificationDetails,
//       );
//       await _flutterLocalNotificationsPlugin.show(
//         msg['data'] != null
//             ? int.parse(msg['data']['id'])
//             : int.parse(msg['id']),
//         msg['notification']['title'] ?? '',
//         msg['notification']['body'] ?? '',
//         notificationDetails,
//         payload: msg['data']?.toString() ?? '',
//       );
//     } catch (e) {
//       print('SHOW NOTIFICATION FAILED: $e');
//     }
//   }
//
//   static Future _onBackgroundMessage(Map<String, dynamic> message) async {
//     debugPrint("myBackgroundMessageHandler message: $message");
//     try {
//       await _showNotification(message);
//       var user = await UserPreferences().getUserData();
//       await _dbHelper.createNotification(items: Notifications(
//         userId: user.id ?? 0,
//         title: message['notification']['title'],
//         body: message['notification']['body'],
//         type: message['data'] != null
//             ? message['data']['type']
//             : message['type'],
//         trackingId: message['data'] != null
//             ? message['data']['tracking_id']
//             : message['tracking_id'],
//         isNew: 1,
//         createdAt: DateTime.now().toString(),
//       ),);
//     } catch (e) {
//       print('BACKGROUND FCM FAILED: $e');
//     }
//   }
//
//   Future _onSelectNotification(String payload) async {
//     print('PAYLOAD DATA: $payload');
//   }
//
//   Future saveFcmToken() async {
//     _firebaseMessaging.getToken().then((token) async {
//       print('FCM TOKEN: $token');
//       await UserPreferences().saveFcmToken(token);
//     });
//   }
//
//   Future initFCM() async {
//     if (Platform.isIOS) {
//       _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(
//             sound: true, badge: true, alert: true, provisional: false),
//       );
//     }
//
//     var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//     var initializationSettingsIOS = IOSInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     var init = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(
//       init,
//       onSelectNotification: _onSelectNotification,
//     );
//
//     _firebaseMessaging.configure(
//       onBackgroundMessage: Platform.isIOS ? null : _onBackgroundMessage,
//       onMessage: (Map<String, dynamic> message) async {
//         debugPrint("onMessage: $message");
//         try {
//           await _showNotification(message);
//
//           var user = await UserPreferences().getUserData();
//           await _dbHelper.createNotification(items: Notifications(
//             userId: user.id ?? 0,
//             title: message['notification']['title'],
//             body: message['notification']['body'],
//             type: message['data'] != null
//                 ? message['data']['type']
//                 : message['type'],
//             trackingId: message['data'] != null
//                 ? message['data']['tracking_id']
//                 : message['tracking_id'],
//             isNew: 1,
//             createdAt: DateTime.now().toString(),
//           ),);
//
//           await Provider.of<NotificationProviders>(navigatorKey.currentContext, listen: false).getNotificationCount();
//
//           if (message['data'] != null) {
//             if (message['data']['type'] == 'order') {
//               Provider.of<HomeProviders>(navigatorKey.currentContext, listen: false).getRepairList().then((_) async {
//                 await Provider.of<HomeProviders>(navigatorKey.currentContext, listen: false).getTracking();
//               });
//             }
//           } else {
//             if (message['type'] == 'order') {
//               Provider.of<HomeProviders>(navigatorKey.currentContext, listen: false).getRepairList().then((_) async {
//                 await Provider.of<HomeProviders>(navigatorKey.currentContext, listen: false).getTracking();
//               });
//             }
//           }
//         } catch (e) {
//           print(e);
//         }
//       },
//       onResume: (Map<String, dynamic> message) async {
//         debugPrint("onResume: $message");
//         if (message['data'] != null) {
//           if (message['data']['type'] == 'order') {
//             Get.toNamed(ServiceDetailScreen.tag, arguments: ServiceDetailScreen(
//               index: null,
//               trackingNumber: message['data']['tracking_id'],
//               type: 'confirm',
//             ));
//           }
//         } else {
//           if (message['type'] == 'order') {
//             Get.toNamed(ServiceDetailScreen.tag, arguments: ServiceDetailScreen(
//               index: null,
//               trackingNumber: message['tracking_id'],
//               type: 'confirm',
//             ));
//           }
//         }
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         debugPrint("onLaunch: $message");
//       },
//     );
//   }
//
// }
