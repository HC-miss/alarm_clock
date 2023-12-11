import 'dart:async';

import 'package:alarm_clock/data/core/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'clock_view.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    var formattedDate = DateFormat("EEE, d MMM").format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timezoneString.startsWith('-')) offsetSign = '+';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            // fit 子项可用空间填充方式
            // FlexFit.loose 允许子项 <= 可用空间
            // FlexFit.tight 子项 == 可用空间
            fit: FlexFit.tight,
            child: Text(
              'Clock',
              style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                fontSize: 24,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigitalClockWidget(),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w300,
                    color: AppColors.primaryTextColor,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.center,
              child: ClockView(
                size: MediaQuery.sizeOf(context).height / 4,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Timezone',
                  style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: AppColors.primaryTextColor,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'UTC$offsetSign$timezoneString',
                      style: TextStyle(
                        fontFamily: 'avenir',
                        color: AppColors.primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DigitalClockWidget extends StatefulWidget {
  const DigitalClockWidget({super.key});

  @override
  State<DigitalClockWidget> createState() => _DigitalClockWidgetState();
}

class _DigitalClockWidgetState extends State<DigitalClockWidget> {
  var formattedTime = DateFormat('HH:mm').format(DateTime.now());
  late Timer timer;

  @override
  void initState() {
    // 每秒检测是否时间发生变化（分钟单位）
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var previousMinute = DateTime.now().add(Duration(seconds: -1)).minute;
      var currentMinute = DateTime.now().minute;
      if (previousMinute != currentMinute) {
        setState(() {
          formattedTime = DateFormat('HH:mm').format(DateTime.now());
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedTime,
      style: TextStyle(
        fontFamily: 'avenir',
        color: AppColors.primaryTextColor,
        fontSize: 64,
      ),
    );
  }
}
