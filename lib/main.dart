import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:home_management/pages/bills.dart';
import 'package:home_management/pages/home.dart';
import 'package:home_management/services/background_service.dart';
import 'package:home_management/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await BackgroundService.initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "home",
      routes: {
        "home": (context) => HomePage(),
        "bills": (context) => const Bills(),
        "object'sLocation": (context) => const Bills(),
        "documents": (context) => const Bills(),
        "addresses": (context) => const Bills(),
      },
    );
  }
}
