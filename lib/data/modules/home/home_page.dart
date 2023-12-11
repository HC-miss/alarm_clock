import 'package:alarm_clock/data/core/values/app_colors.dart';
import 'package:alarm_clock/data/enums/menu_type.dart';
import 'package:alarm_clock/data/models/alarm_info.dart';
import 'package:alarm_clock/data/models/menu_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import 'widgets/alarm_page.dart';
import 'widgets/clock_page.dart';

List<MenuInfo> menuItems = const [
  MenuInfo(MenuType.clock,
      title: 'Clock', imageSource: 'assets/clock_icon.png'),
  MenuInfo(MenuType.alarm,
      title: 'Alarm', imageSource: 'assets/alarm_icon.png'),
  MenuInfo(MenuType.timer,
      title: 'Timer', imageSource: 'assets/timer_icon.png'),
  MenuInfo(MenuType.stopwatch,
      title: 'Stopwatch', imageSource: 'assets/stopwatch_icon.png'),
];

List<AlarmInfo> alarms = [
  AlarmInfo(
    alarmDateTime: DateTime.now().add(Duration(hours: 1)),
    title: 'Office',
    gradientColorIndex: 0,
  ),
  AlarmInfo(
    alarmDateTime: DateTime.now().add(Duration(hours: 2)),
    title: 'Sport',
    gradientColorIndex: 1,
  ),
];

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menuItems.map((currentMenuInfo) {
              return buildMenuButton(currentMenuInfo);
            }).toList(),
          ),
          VerticalDivider(
            color: AppColors.dividerColor,
            width: 1,
          ),
          Expanded(
            child: Obx(
              () {
                MenuInfo menuInfo = controller.menuInfo.value;
                switch (menuInfo.menuType) {
                  case MenuType.clock:
                    return ClockPage();
                  case MenuType.alarm:
                    return AlarmPage();
                  default:
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(text: 'Upcoming Tutorial\n'),
                          TextSpan(
                            text: menuInfo.title,
                            style: TextStyle(fontSize: 48),
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Obx(
      () {
        return ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                ),
              ),
            ),
            padding: MaterialStatePropertyAll(
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
            ),
            backgroundColor: MaterialStatePropertyAll(
              currentMenuInfo.menuType == controller.menuInfo.value.menuType
                  ? AppColors.menuBackgroundColor
                  : AppColors.pageBackgroundColor,
            ),
          ),
          onPressed: () {
            controller.changeMenu(currentMenuInfo);
          },
          child: Column(
            children: [
              Image.asset(
                currentMenuInfo.imageSource!,
                scale: 1.5,
              ),
              SizedBox(height: 16),
              Text(
                currentMenuInfo.title ?? '',
                style: TextStyle(
                  fontFamily: 'avenir',
                  color: AppColors.primaryTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
