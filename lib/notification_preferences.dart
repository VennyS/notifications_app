import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'notification_object.dart';

class NotificationPreferences {
  static Future<void> saveNotifications(
      List<NotificationObject> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> stringNotifications = notifications
        .map((notification) => jsonEncode(notification.toJson()))
        .toList();
    prefs.setStringList('notifications', stringNotifications);
  }

  static Future<List<NotificationObject>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> stringNotifications =
        prefs.getStringList('notifications') ?? [];
    return stringNotifications
        .map((item) => NotificationObject.fromJson(jsonDecode(item)))
        .toList();
  }
}
