import 'dart:io';

import 'package:eight_barrels/model/notification/notification_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = new DbHelper.internal();

  DbHelper.internal();

  factory DbHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    _db = await setDB();
    return _db!;
  }

  Future<Database> setDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "BottleUnion");

    var db = await openDatabase(path, version: 1, onCreate: onCreate, onUpgrade: onUpgrade);
    return db;
  }

  onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE IF NOT EXISTS notification ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "user_id INTEGER NOT NULL,"
        "title TEXT NOT NULL,"
        "body TEXT NOT NULL,"
        "type TEXT DEFAULT NULL,"
        "code_transaction TEXT DEFAULT NULL,"
        "region_id INTEGER DEFAULT NULL,"
        "is_new INTEGER DEFAULT 1,"
        "created_at DATETIME NOT NULL)");
  }

  onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      onCreate(db, newVersion);
    }
  }

  Future insertNotification({required NotificationModel items}) async {
    var dbClient = await db;
    int response = await dbClient.insert('notification', items.toJson());
    return response;
  }

  Future<List<NotificationModel>?> getNotification({required String userId}) async {
    var dbClient = await db;
    var query = await dbClient.rawQuery('SELECT * FROM notification WHERE user_id = ? ORDER BY created_at DESC', [userId]);
    List<NotificationModel> _list = [];
    for (var i = 0; i < query.length; i++) {
      _list.add(NotificationModel.fromJson(query[i]));
    }
    return _list;
  }

  Future deleteNotification() async {
    var dbClient = await db;
    var response = await dbClient.delete('notification');
    return response;
  }

  Future updateNotificationStatus({required String notificationId}) async {
    var dbClient = await db;
    var response = await dbClient.rawUpdate('UPDATE notification SET is_new = 0 WHERE id = ?', [notificationId]);
    return response;
  }
}