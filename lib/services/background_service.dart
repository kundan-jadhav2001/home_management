import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:home_management/models/bill.dart';
import 'package:home_management/services/db_helper.dart';
import 'package:home_management/services/notification_service.dart';
import 'package:intl/intl.dart';



class BackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
        ));
    await service.startService();
  }

  static void onStart(ServiceInstance service) async {
    NotificationService().init();
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    Timer.periodic(const Duration(days: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
            title: "My App Service",
            content: "Checking for notifications",
          );
        }
      }

      List<Bill> bills = await DBHelper.getBills();
      for (var bill in bills) {
        DateTime reminderDate = bill.dueDate.subtract(Duration(days: bill.reminder));
        DateTime now = DateTime.now();

        if (now.year == reminderDate.year &&
            now.month == reminderDate.month &&
            now.day == reminderDate.day) {
          NotificationService().showNotification(
            title: "Reminder: ${bill.name}",
            body: "Due on ${DateFormat('dd/MM/yyyy').format(bill.dueDate)} - \$${bill.amount}",
          );
        }
      }
      print("Checking for notifications ${DateTime.now()}");

    });
  }
}