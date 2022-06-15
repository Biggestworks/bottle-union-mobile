package com.toras.eight_barrels

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import com.tekartik.sqflite.SqflitePlugin
import io.flutter.plugins.pathprovider.PathProviderPlugin
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
//        createChannel()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin.registerWith(
                registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));

        com.tekartik.sqflite.SqflitePlugin.registerWith(
                registry?.registrarFor("com.tekartik.sqflite.SqflitePlugin"));

        com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.registerWith(
                registry?.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));

        io.flutter.plugins.pathprovider.PathProviderPlugin.registerWith(
                registry?.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));

        io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin.registerWith(
                registry?.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    }

//    private fun createChannel(){
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            // Create the NotificationChannel
//            val name = getString(R.string.default_notification_channel_id)
//            val channel = NotificationChannel(name, "default", NotificationManager.IMPORTANCE_MAX)
//            val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//            notificationManager.createNotificationChannel(channel)
//        }
//    }
}