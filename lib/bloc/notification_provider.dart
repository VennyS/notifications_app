import '../notification_object.dart';
import 'package:bloc/bloc.dart';
import '../notification_preferences.dart';
import '../notification_service.dart'; // Импортируйте ваш сервис уведомлений

abstract class NotificationEvent {}

class AddNotificationEvent extends NotificationEvent {
  final NotificationObject notification;

  AddNotificationEvent(this.notification);
}

class DeleteNotificationEvent extends NotificationEvent {
  final int id;

  DeleteNotificationEvent(this.id);
}

class UpdateNotificationEvent extends NotificationEvent {
  final NotificationObject notification;

  UpdateNotificationEvent(this.notification);
}

class LoadNotificationsEvent extends NotificationEvent {}

class NotificationProvider
    extends Bloc<NotificationEvent, List<NotificationObject>> {
  late final NotificationService
      _notificationService; // Создайте экземпляр вашего сервиса уведомлений

  NotificationProvider(List<NotificationObject> initialState)
      : super(initialState) {
    _notificationService = NotificationService(this);
    on<LoadNotificationsEvent>((event, emit) async {
      emit(await NotificationPreferences.getNotifications());
    });

    on<AddNotificationEvent>((event, emit) async {
      List<NotificationObject> updatedList = List.from(state);
      updatedList.add(event.notification);
      NotificationPreferences.saveNotifications(updatedList);
      await _notificationService.initialize();
      _notificationService.showScheduledNotification(
          event.notification); // Планируйте уведомление при добавлении
      emit(updatedList);
    });

    on<DeleteNotificationEvent>((event, emit) async {
      List<NotificationObject> updatedList =
          state.where((notification) => notification.id != event.id).toList();
      NotificationPreferences.saveNotifications(updatedList);
      _notificationService
          .cancelNotification(event.id); // Отмените уведомление при удалении
      emit(updatedList);
    });

    on<UpdateNotificationEvent>((event, emit) async {
      List<NotificationObject> updatedList = state
          .map((notification) => notification.id == event.notification.id
              ? event.notification
              : notification)
          .toList();
      NotificationPreferences.saveNotifications(updatedList);
      await _notificationService.initialize();
      _notificationService.showScheduledNotification(
          event.notification); // Перепланируйте уведомление при обновлении
      emit(updatedList);
    });
  }
}
