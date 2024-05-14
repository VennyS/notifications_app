import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_object.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    tz.initializeTimeZones();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(NotificationObject notification) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'First',
      'NotificationApp',
      channelDescription: 'Service for create your personal notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.description,
        _nextInstanceOfDateTime(notification.dateTime),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfDateTime(DateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTime.year,
        dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }
}

// onPressed: () {
//                       context.read<NotificationProvider>().add(
//                           DeleteNotificationEvent(widget.notification!.id));
//                       Navigator.pop(context);
//                     },