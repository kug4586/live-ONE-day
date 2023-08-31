import 'package:live_one_day/config.dart';

import 'package:flutter/material.dart';

// 테이블 아이템 사이즈
const double item_width = 49;
const double item_height = 5;
const double item_count = 288;

// 테이블 데이터
Map<String, List<Widget>> table_data = {
  "월요일" : List.generate(23, (index) => Positioned(
    left: 0,
    top: 60.0 * index,
    child: Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1, color: Color(line_color))))
    ),
  )),
  "화요일" : List.generate(23, (index) => Positioned(
    left: 0,
    top: 60.0 * index,
    child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color(line_color))))
    ),
  )),
  "수요일" : List.generate(23, (index) => Positioned(
    left: 0,
    top: 60.0 * index,
    child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color(line_color))))
    ),
  )),
  "목요일" : List.generate(23, (index) => Positioned(
    left: 0,
    top: 60.0 * index,
    child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color(line_color))))
    ),
  )),
  "금요일" : List.generate(23, (index) => Positioned(
    left: 0,
    top: 60.0 * index,
    child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color(line_color))))
    ),
  )),
  "토요일" : List.generate(23, (index) => Positioned(
    left: 0,
    top: 60.0 * index,
    child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color(line_color))))
    ),
  )),
  "일요일" : List.generate(23, (index) => Positioned(
    left: 0,
    top: 60.0 * index,
    child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color(line_color))))
    ),
  ))
};

// 테이블 아이템
class TableItem extends StatefulWidget {
  const TableItem({
    super.key,
    required this.top,
    required this.h,
    required this.start,
    required this.end,
    required this.name,
    required this.place,
    required this.color,
    required this.isSunday
  });

  final double top;
  final double h;
  final DateTime start;
  final DateTime end;
  final String name;
  final String place;
  final Color color;
  final bool isSunday;

  @override
  State<TableItem> createState() => _TableItemState();
}
class _TableItemState extends State<TableItem> {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: 0,
      child: Container(
        width: (MediaQuery.of(context).size.width - 48) / 7,
        height: widget.h,
        decoration: BoxDecoration(color: widget.color),
        child: Column(children: [
          Text(widget.name),
          Text(widget.place)
        ])
      )
    );
  }
}



// 메인
class WeekSchedule extends StatefulWidget {
  const WeekSchedule({super.key});

  @override
  State<WeekSchedule> createState() => _WeekScheduleState();
}
class _WeekScheduleState extends State<WeekSchedule> {

  @override
  Widget build(BuildContext context) {



    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color(line_color), width: 1)),
          child: Column(children: [
            // Column Label
            Container(
                height: 22,
                child: Row(children: [
                  SizedBox(width: 20),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      alignment: Alignment.center,
                      child: Text("월",
                          style: TextStyle(
                              color: Color(text_color_2),
                              fontSize: font_size[0],
                              fontWeight: regular))),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      alignment: Alignment.center,
                      child: Text("화",
                          style: TextStyle(
                              color: Color(text_color_2),
                              fontSize: font_size[0],
                              fontWeight: regular))),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      alignment: Alignment.center,
                      child: Text("수",
                          style: TextStyle(
                              color: Color(text_color_2),
                              fontSize: font_size[0],
                              fontWeight: regular))),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      alignment: Alignment.center,
                      child: Text("목",
                          style: TextStyle(
                              color: Color(text_color_2),
                              fontSize: font_size[0],
                              fontWeight: regular))),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      alignment: Alignment.center,
                      child: Text("금",
                          style: TextStyle(
                              color: Color(text_color_2),
                              fontSize: font_size[0],
                              fontWeight: regular))),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  Container(
                      width: (MediaQuery.of(context).size.width -
                          item_width) /
                          7,
                      alignment: Alignment.center,
                      child: Text("토",
                          style: TextStyle(
                              color: Color(text_color_2),
                              fontSize: font_size[0],
                              fontWeight: regular))),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  Container(
                      width: (MediaQuery.of(context).size.width -
                          item_width) /
                          7,
                      alignment: Alignment.center,
                      child: Text("일",
                          style: TextStyle(
                              color: Color(text_color_2),
                              fontSize: font_size[0],
                              fontWeight: regular)))
                ])),
            Divider(
                height: 1, thickness: 1, color: Color(line_color)),
            Container(
                height: item_height * item_count,
                child: Row(children: [
                  // Row Label
                  Container(
                      width: 20,
                      child: Column(children: List.generate(24,
                              (index) => index < 23
                              ? Container(
                                  width: 20,
                                  height: item_height * 12,
                                  decoration: BoxDecoration(
                                      border: Border(bottom:
                                        BorderSide(color: Color(line_color), width: 1))),
                                  child: Center(
                                      child: Text(index.toString(),
                                          style: TextStyle(
                                              fontWeight: regular,
                                              fontSize: font_size[0],
                                              color: Color(text_color_2))))
                              )
                              : Container(
                                  width: 20,
                                  height: item_height * 12,
                                  child: Center(
                                      child: Text(index.toString(),
                                          style: TextStyle(
                                              fontWeight: regular,
                                              fontSize: font_size[0],
                                              color: Color(text_color_2))))
                              )
                      ))
                  ),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  // Cell - 월
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      child: Stack(children: table_data["월요일"]!)
                  ),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  // Cell - 화
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      child: Container(
                          width: (MediaQuery.of(context).size.width - item_width) / 7,
                          child: Stack(children: table_data["화요일"]!)
                      ),
                  ),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  // Cell - 수
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      child: Container(
                          width: (MediaQuery.of(context).size.width - item_width) / 7,
                          child: Stack(children: table_data["수요일"]!)
                      ),
                  ),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  // Cell - 목
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      child: Container(
                          width: (MediaQuery.of(context).size.width - item_width) / 7,
                          child: Stack(children: table_data["목요일"]!)
                      ),
                  ),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  // Cell - 금
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      child: Container(
                          width: (MediaQuery.of(context).size.width - item_width) / 7,
                          child: Stack(children: table_data["금요일"]!)
                      ),
                  ),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  // Cell - 토
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      child: Container(
                          width: (MediaQuery.of(context).size.width - item_width) / 7,
                          child: Stack(children: table_data["토요일"]!)
                      ),
                  ),
                  VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(line_color)),
                  // Cell - 일
                  Container(
                      width: (MediaQuery.of(context).size.width - item_width) / 7,
                      child: Container(
                          width: (MediaQuery.of(context).size.width - item_width) / 7,
                          child: Stack(children: table_data["일요일"]!)
                      ),
                  ),
                ]))
          ])),
    );
  }
}
