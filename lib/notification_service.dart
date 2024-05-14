import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/bloc/notification_provider.dart';
import 'package:notifications/notification_object.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  final NotificationProvider notificationProvider;
  NotificationService(this.notificationProvider);

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidInitializationSettings);

    await _localNotificationService.initialize(settings);
  }

  // void notificationSent(NotificationObject notificationObject) {
  //   // Создайте новый объект уведомления с обновленным значением isSent
  //   NotificationObject updatedNotification = NotificationObject(
  //     id: notificationObject.id,
  //     title: notificationObject.title,
  //     description: notificationObject.description,
  //     dateTime: notificationObject.dateTime,
  //     isSent: true, // Обновите значение isSent
  //   );

  //   // Здесь вы можете вызвать ваш новый метод
  //   notificationProvider.add(UpdateNotificationEvent(updatedNotification));
  // }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_Id', 'channelName',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher');

    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> cancelNotification(int id) async {
    await _localNotificationService.cancel(id);
  }

  Future<void> showScheduledNotification(
      NotificationObject notificationObject) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        notificationObject.id,
        notificationObject.title,
        notificationObject.description,
        tz.TZDateTime.from(notificationObject.dateTime, tz.local),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    // notificationSent(notificationObject);
  }
}
