import 'package:alarm_clock/data/enums/menu_type.dart';

class MenuInfo {
  final MenuType menuType;
  final String? title;
  final String? imageSource;

  const MenuInfo(this.menuType, {this.title, this.imageSource});
}
