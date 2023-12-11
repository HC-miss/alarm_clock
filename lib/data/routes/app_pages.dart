import 'package:alarm_clock/data/modules/home/home_binding.dart';
import 'package:alarm_clock/data/modules/home/home_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.homePage;

  static final routes = [
    // main
    GetPage(
      name: AppRoutes.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
    )
  ];
}
