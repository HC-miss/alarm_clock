import 'package:alarm_clock/core/utils/alarm_helper.dart';
import 'package:alarm_clock/core/utils/local_notifications.dart';
import 'package:alarm_clock/core/values/app_colors.dart';
import 'package:alarm_clock/data/models/alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  bool _isRepeatSelected = false;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    // 初始化数据库并加载数据
    _alarmHelper.initializeDatabase().then((value) {
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  Widget _buildHeader() {
    return Text(
      'Alarm',
      style: TextStyle(
        fontFamily: 'avenir',
        fontWeight: FontWeight.w700,
        color: AppColors.primaryTextColor,
        fontSize: 24,
      ),
    );
  }

  Widget _buildAlarmItem(AlarmInfo alarm) {
    var alarmTime = DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
    var gradientColor =
        GradientTemplate.gradientTemplate[alarm.gradientColorIndex!].colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColor.last.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(4, 4),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Icon(
                    Icons.label,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    alarm.title!,
                    style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
                  ),
                ],
              ),
              Switch(
                onChanged: (bool value) {},
                value: true,
                activeColor: Colors.white,
              ),
            ],
          ),
          Text(
            'Mon-Fri',
            style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                alarmTime,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'avenir',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.white,
                onPressed: () {
                  deleteAlarm(alarm.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddBtn() {
    return DottedBorder(
      strokeWidth: 2,
      color: AppColors.clockOutline,
      borderType: BorderType.RRect,
      radius: Radius.circular(24),
      dashPattern: [5, 4],
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.clockBG),
            padding: MaterialStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
          ),
          onPressed: () {
            _alarmTime = DateTime.now();

            Get.bottomSheet(
              backgroundColor: Colors.white,
              useRootNavigator: true,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              StatefulBuilder(
                builder: (
                  BuildContext context,
                  StateSetter setModalState,
                ) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (selectedTime != null) {
                              final now = DateTime.now();
                              var selectedDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              setModalState(() {
                                _alarmTime = selectedDateTime;
                              });
                            }
                          },
                          child: Text(
                            DateFormat('HH:mm').format(_alarmTime!),
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        ListTile(
                          title: Text('Repeat'),
                          trailing: Switch(
                            onChanged: (value) {
                              setModalState(() {
                                _isRepeatSelected = value;
                              });
                            },
                            value: _isRepeatSelected,
                          ),
                        ),
                        ListTile(
                          title: Text('Sound'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          title: Text('Title'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        FloatingActionButton.extended(
                          onPressed: () {
                            onSaveAlarm(_isRepeatSelected);
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Save"),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
            // showModalBottomSheet(
            //   useRootNavigator: true,
            //   context: context,
            //   clipBehavior: Clip.antiAlias,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.vertical(
            //       top: Radius.circular(24),
            //     ),
            //   ),
            //   builder: (context) {
            //     return Text('data');
            //   },
            // );
          },
          child: Column(
            children: [
              Image.asset(
                'assets/add_alarm.png',
                scale: 1.5,
              ),
              SizedBox(height: 8),
              Text(
                'Add Alarm',
                style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSaveAlarm(bool isRepeating) {
    DateTime? scheduleAlarmDateTime;

    if (_alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = _alarmTime;
    } else {
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
    }

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: 'alarm',
    );

    _alarmHelper.insertAlarm(alarmInfo);

    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo, isRepeating: isRepeating);
    }

    if (Get.isBottomSheetOpen != null && Get.isBottomSheetOpen!) {
      Get.back();
    }
    loadAlarms();
  }

  void scheduleAlarm(
    DateTime scheduledNotificationDateTime,
    AlarmInfo alarmInfo, {
    required bool isRepeating,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notify',
      'alarm_notify',
      channelDescription: 'Channel for Alarm notification',
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarmInfo.id!,
      'Office',
      alarmInfo.title,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      platformChannelSpecifics,
      matchDateTimeComponents: isRepeating ? DateTimeComponents.time : null,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    // unsubscribe for notification
    flutterLocalNotificationsPlugin.cancel(id!);
    loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      return _buildAlarmItem(alarm);
                    }).followedBy([
                      if (_currentAlarms!.length < 5)
                        _buildAddBtn()
                      else
                        Center(
                          child: Text(
                            'Only 5 alarms allowed!',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                    ]).toList(),
                  );
                }
                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
