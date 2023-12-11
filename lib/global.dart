// import 'package:feather_jhomlala/core/dependency_injection.dart';
import 'package:alarm_clock/data/core/utils/local_notifications.dart';
import 'package:alarm_clock/data/core/utils/timezone.dart';
import 'package:flutter/material.dart';

/// 全局静态数据
class Global {
  /// 初始化
  static Future<void> init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    // 设备方向
    // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // 时区初始化
    configureLocalTimeZone();
    // 初始化本地通知
    await LocalNotifications.init();

    // 依赖注入
    // await DependencyInjection.init();
  }
}
