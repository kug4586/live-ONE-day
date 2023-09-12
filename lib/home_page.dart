import 'package:live_one_day/config.dart';
import 'package:live_one_day/table.dart';
import 'package:live_one_day/add_schedule.dart';
import 'package:live_one_day/setting_page.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatelessWidget
    with WidgetsBindingObserver {
  const HomePage({super.key});

  // 상단바 크기
  static double appbar_size = 32;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Color(app_background)),
            child: SafeArea(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  // 상단 bar
                  Container(
                      height: appbar_size,
                      margin: EdgeInsets.fromLTRB(15, 25, 15, 0),
                      child: Stack(children: [
                        Positioned(
                            bottom: 5,
                            left: 5,
                            child: Text("주간 일정",
                                style: TextStyle(
                                    color: Color(text_color_1),
                                    fontSize: font_size[2],
                                    fontWeight: medium))),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                                onTap: () {
                                  Fluttertoast.showToast(
                                    msg: "아직 준비 중 입니다...",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1
                                  );
                                },
                                child: Icon(
                                    Icons.settings, size: appbar_size))),
                        Positioned(
                            bottom: 0,
                            right: 40,
                            width: appbar_size,
                            height: appbar_size,
                            child: GestureDetector(
                                onTap: () =>
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            AddSchedulePage())),
                                child: Icon(Icons.add_box_outlined,
                                    size: appbar_size))),
                      ])),
                  // 시간표
                  Expanded(child: WeekSchedule(touchable: true))
                ]))
        )
    );
  }
}