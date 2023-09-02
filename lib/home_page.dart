import 'package:live_one_day/config.dart';
import 'package:live_one_day/add_schedule.dart';

import 'package:flutter/material.dart';
import 'package:live_one_day/setting_page.dart';
import 'package:live_one_day/table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver {

  // 상단바 크기
  static double appbar_size = 32;

  // 스트림 수용자
  final Stream<bool> table_stream = table_sctr.stream;

  // 테이블 업데이트
  void _updateTable(bool b) {
    if (b) setState(() {});
  }

  @override
  void initState() {
    table_stream.listen((event) => _updateTable(event));
    super.initState();
  }

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
                            onTap: () {},
                            child: Icon(Icons.settings, size: appbar_size))),
                    Positioned(
                        bottom: 0,
                        right: 40,
                        width: appbar_size,
                        height: appbar_size,
                        child: GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) => AddSchedulePage())),
                            child: Icon(Icons.add_box_outlined, size: appbar_size))),
                  ])),
              // 시간표
              Expanded(child: WeekSchedule())
            ]))
        )
    );
  }
}
