// import 'package:feather_jhomlala/core/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 全局静态数据
class Global {
  /// 初始化
  static Future<void> init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    // 设备方向
    // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await initFlutterLocalNotifications();

    // 依赖注入
    // await DependencyInjection.init();
  }

  static Future<void> initFlutterLocalNotifications() async {
    var androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: ${notificationResponse.payload}');
        }
      },
    );
  }
}
