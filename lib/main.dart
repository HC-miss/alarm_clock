import 'package:alarm_clock/data/core/theme/app_theme.dart';
import 'package:alarm_clock/data/routes/app_pages.dart';
import 'package:alarm_clock/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await Global.init();
  // 显示布局信息
  debugPaintSizeEnabled = false;
  runApp(const AlarmApp());
}

class AlarmApp extends StatelessWidget {
  const AlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      title: 'Feather',

      theme: AppTheme.themeData,
      // 国际化支持-代理
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // locale: Locale('zh', 'cn'),
      debugShowCheckedModeBanner: false,
    );
  }
}
