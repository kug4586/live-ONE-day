import 'package:live_one_day/config.dart';

import 'package:flutter/material.dart';

// 테이블 아이템 사이즈
late double item_width;
const double item_height = 5;
const double item_count = 288;

// 테이블 데이터
Map<String, List<TableItem>> table_data = {
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
    required this.timeline
  });

  final Timeline timeline;

  @override
  State<TableItem> createState() => _TableItemState();
}
class _TableItemState extends State<TableItem> {

  @override
  Widget build(BuildContext context) {

    double tmp = widget.timeline.top + widget.timeline.h - 1425;
    print(tmp);

    return Positioned(
        top: widget.timeline.top,
        left: 1,
        child: Container(
            width: (widget.timeline.isSunday() && widget.timeline.top > 1425)
                ? widget.timeline.w - widget.timeline.top + 1420
                : widget.timeline.w,
            height: widget.timeline.h,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
                color: widget.timeline.getColor(),
                borderRadius: (widget.timeline.isSunday() && widget.timeline.top + widget.timeline.h >= 1425)
                    ? BorderRadius.only(bottomRight: Radius.circular(tmp))
                    : null
            ),
            child: Wrap(children: [
              Column(children: [
                Text(widget.timeline.name,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: bold,
                        color: Colors.white)),
                SizedBox(height: 4),
                Text(widget.timeline.place,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: regular,
                      color: Colors.white))
              ])
            ])
        )
    );
  }
}

// 구분선 만드는 메서드
List<Widget> createLine(bool verORhor, double w) {
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
      ret.add(SizedBox(width: w));
      ret.add(VerticalDivider(width: 0, thickness: 1, color: Color(line_color)));
    }
  }
  return ret;
}

// 행과 열의 라벨 만드는 메서드
List<Widget> createLabel(bool colORrow, double w) {
  List<Widget> ret = [];
  // 열 라벨 생성
  if (colORrow) {
    <String>["월", "화", "수", "목", "금", "토", "일"]
        .forEach((day) {
      ret.add(
          Container(
              width: w,
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

  @override
  Widget build(BuildContext context) {

    item_width = (MediaQuery.of(context).size.width - 42) / 7;

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
                    child: Column(children: createLine(true, item_width))
                )
            ),
            // 가로 구분선
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 24 + item_height * item_count,
                    child: Row(children: createLine(false, item_width))
                )
            ),
            // 열의 라벨
            Positioned(
                top: 0,
                left: 22,
                width: MediaQuery.of(context).size.width - 20,
                height: 24,
                child: Row(children: createLabel(true, item_width))
            ),
            // 행의 라벨
            Positioned(
                top: 24,
                left: 0,
                width: 22,
                height: item_height * item_count,
                child: Column(children: createLabel(false, item_width))
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
                            width: item_width,
                            child: Stack(children: table_data["월요일"]!)),
                        Container(
                          width: item_width,
                          child: Stack(children: table_data["화요일"]!),
                        ),
                        Container(
                          width: item_width,
                          child: Stack(children: table_data["수요일"]!),
                        ),
                        Container(
                          width: item_width,
                          child: Stack(children: table_data["목요일"]!),
                        ),
                        Container(
                          width: item_width,
                          child: Stack(children: table_data["금요일"]!),
                        ),Container(
                          width: item_width,
                          child: Stack(children: table_data["토요일"]!),
                        ),
                        Container(
                          width: item_width,
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