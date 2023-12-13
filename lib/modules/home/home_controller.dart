import 'package:alarm_clock/data/enums/menu_type.dart';
import 'package:alarm_clock/data/models/menu_info.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<MenuInfo> menuInfo = const MenuInfo(
    MenuType.clock,
    title: 'Clock',
    imageSource: 'assets/clock_icon.png',
  ).obs;


  void changeMenu(MenuInfo newMenu) {
    menuInfo.value = newMenu;
  }
}
