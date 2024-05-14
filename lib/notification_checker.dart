import 'dart:async';
import 'bloc/notification_provider.dart';

class NotificationChecker {
  final NotificationProvider notificationProvider;
  Timer? _timer;

  NotificationChecker(this.notificationProvider);

  void startChecking() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      for (var notification in notificationProvider.state) {
        if (!notification.isSent && notification.dateTime.isBefore(now)) {
          notification.markAsSent();
          notificationProvider.add(UpdateNotificationEvent(notification));
        }
      }
    });
  }

  void stopChecking() {
    _timer?.cancel();
  }
}
