import 'package:live_one_day/config.dart';

import 'package:flutter/material.dart';

// 테이블 아이템 사이즈
const double item_width = 49;
const double item_height = 5;
const double item_count = 288;

// 테이블 데이터
Map<String, List<Widget>> table_data = {
  "월요일" : [],
  "화요일" : [],
  "수요일" : [],
  "목요일" : [],
  "금요일" : [],
  "토요일" : [],
  "일요일" : []
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
      left: 1,
      child: Container(
        width: 49,
        height: widget.h,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: (widget.isSunday && widget.top + widget.h >= 1425)
                ? BorderRadius.only(bottomRight: Radius.circular(widget.top + widget.h - 1425))
                : null
        ),
        child: Column(children: [
          Text(widget.name),
          Text(widget.place)
        ])
      )
    );
  }
}

// 구분선 만드는 메서드
List<Widget> createLine(bool verORhor) {
  List<Widget> ret = [];
  // 가로 구분선 생성
  if (verORhor) {
    ret.add(SizedBox(height: 24));
    ret.add(Divider(height: 0, thickness: 1, color: Color(line_color)));
    for (int i=0 ; i < 23 ; i++) {
      ret.add(SizedBox(height: 60));
      ret.add(Divider(height: 0, thickness: 1, color: Color(line_color)));
    }
  }
  // 세로 구분선 생성
  else {
    ret.add(SizedBox(width: 22));
    ret.add(VerticalDivider(width: 0, thickness: 1, color: Color(line_color)));
    for (int i=0 ; i < 6 ; i++) {
      ret.add(SizedBox(width: 50));
      ret.add(VerticalDivider(width: 0, thickness: 1, color: Color(line_color)));
    }
  }
  return ret;
}

// 행과 열의 라벨 만드는 메서드
List<Widget> createLabel(bool colORrow) {
  List<Widget> ret = [];
  // 열 라벨 생성
  if (colORrow) {
    <String>["월", "화", "수", "목", "금", "토", "일"]
        .forEach((day) {
      ret.add(
          Container(
              width: 50,
              height: 24,
              alignment: Alignment.center,
              child: Text(day,
                  style: TextStyle(
                      fontWeight: regular,
                      fontSize: font_size[0],
                      color: Color(text_color_2))))
      );
    });
  }
  // 행 라벨 생성
  else {
    for (int i=0 ; i < 24 ; i++) {
      ret.add(Container(
          width: 22,
          height: 60,
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(right: 2, top: 2),
          child: Text(i.toString(),
              style: TextStyle(
                  fontWeight: regular,
                  fontSize: font_size[0],
                  color: Color(text_color_2)))
      ));
    }
  }
  return ret;
}


// 메인
class WeekSchedule extends StatefulWidget {
  const WeekSchedule({super.key});

  @override
  State<WeekSchedule> createState() => _WeekScheduleState();
}


class _WeekScheduleState extends State<WeekSchedule> {

  // 구분선
  final List<Widget> vertical_divs = createLine(true);
  final List<Widget> horizontal_divs = createLine(false);

  // 라벨
  final List<Widget> column_labels = createLabel(true);
  final List<Widget> row_labels = createLabel(false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 24 + item_height * item_count,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color(line_color), width: 1)),
          child: Stack(children: [
            // 세로 구분선
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 24 + item_height * item_count,
                child: Column(children: vertical_divs)
              )
            ),
            // 가로 구분선
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 24 + item_height * item_count,
                    child: Row(children: horizontal_divs)
                )
            ),
            // 열의 라벨
            Positioned(
              top: 0,
              left: 22,
              width: MediaQuery.of(context).size.width - 20,
              height: 24,
              child: Row(children: column_labels)
            ),
            // 행의 라벨
            Positioned(
                top: 24,
                left: 0,
                width: 22,
                height: item_height * item_count,
                child: Column(children: row_labels)
            ),
            // 테이블 데이터
            Positioned(
              top: 24,
              left: 22,
              child: Container(
                width: MediaQuery.of(context).size.width - 42,
                height: item_height * item_count,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 50,
                      child: Stack(children: table_data["월요일"]!)),
                    Container(
                      width: 50,
                      child: Stack(children: table_data["화요일"]!),
                    ),
                    Container(
                      width: 50,
                      child: Stack(children: table_data["수요일"]!),
                    ),
                    Container(
                      width: 50,
                      child: Stack(children: table_data["목요일"]!),
                    ),
                    Container(
                      width: 50,
                      child: Stack(children: table_data["금요일"]!),
                    ),Container(
                      width: 50,
                      child: Stack(children: table_data["토요일"]!),
                    ),
                    Container(
                      width: 50,
                      child: Stack(children: table_data["일요일"]!),
                    )
                  ]
                )
              ),
            )
          ])
      ),
    );
  }
}