import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/screens/notification_list_page.dart';
import 'bloc/notification_provider.dart';
import 'notification_object.dart';
import 'notification_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'notification_checker.dart';
import 'notification_service.dart';
import 'constants.dart';

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding
      .ensureInitialized(); // Убедиться, что Flutter был инициализирован
  runApp(
    FutureBuilder<List<NotificationObject>>(
      future: NotificationPreferences.getNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Показывает индикатор загрузки пока уведомления загружаются
        } else if (snapshot.hasError) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
                child: Text(
                    'Ошибка: ${snapshot.error}')), // Показывает ошибку, если что-то пошло не так
          );
        } else {
          final notificationProvider = NotificationProvider(snapshot.data!);
          final notificationService = NotificationService(notificationProvider);
          final notificationChecker = NotificationChecker(notificationProvider);

          notificationService.initialize();
          notificationChecker.startChecking();

          return BlocProvider(
            create: (context) => notificationProvider,
            child: const MyApp(),
          );
        }
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Уведомления',
      theme: appThemeData,
      home: const NotificationListPage(),
    );
  }
}
