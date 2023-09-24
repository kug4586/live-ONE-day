import 'package:live_one_day/config.dart';
import 'package:live_one_day/daily/add_daily.dart';
import 'package:live_one_day/daily/daily_schedule.dart';
import 'package:live_one_day/weekly/add_weekly.dart';
import 'package:live_one_day/weekly/weekly_schedule.dart';
import 'package:live_one_day/setting_page.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainFrame extends StatefulWidget with WidgetsBindingObserver {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}
class _MainFrameState extends State<MainFrame> {

  // 상단바 크기
  static double appbar_size = 32;

  // 표시할 콘텐츠
  int _idx = 0;
  List<String> _titles = ["주간 일정", "일일 일정"];
  List<Widget> _contents = [
    WeekSchedule(tmp_display: false),
    DailySchedule()
  ];
  List<Widget> _add_pages = [
    AddWeekSchedulePage(),
    AddDaySchedulePage()
  ];
  void openAddPage() =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => _add_pages[_idx]));

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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(_titles[_idx],
                                    style: TextStyle(
                                        color: Color(text_color_1),
                                        fontSize: 22,
                                        fontWeight: medium)),
                                IconButton(
                                    onPressed: () {
                                      setState(() => _idx = (++_idx) % 2);
                                    },
                                    padding: EdgeInsets.only(left: 5, bottom: 10),
                                    constraints: BoxConstraints(maxWidth: 28, maxHeight: 28),
                                    icon: Icon(Icons.autorenew, size: 28)
                                )
                              ]
                            )
                        ),
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
                                onTap: openAddPage,
                                child: Icon(Icons.add_box_outlined,
                                    size: appbar_size))),
                      ])),
                  // 시간표
                  Expanded(child: _contents[_idx])
                ]))
        )
    );
  }
}