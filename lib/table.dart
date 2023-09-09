import 'package:live_one_day/add_schedule.dart';
import 'package:live_one_day/config.dart';

import 'package:flutter/material.dart';


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
Map<String, List<TableItem>> tmp_data = {
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
    required this.timeline,
    required this.isTmp
  });

  final Timeline timeline;
  final bool isTmp;

  @override
  State<TableItem> createState() => _TableItemState();
}
class _TableItemState extends State<TableItem> {

  // 일정 보여주기
  void _showSchedule(Timeline timeline) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) => AlertDialog(
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.all(0),
        title: Container(
          width: MediaQuery.of(ctx).size.width,
          alignment: Alignment.centerLeft,
          child: Text(timeline.name, style: TextStyle(fontSize: 24))
        ),
        content: Container(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timeline.day
                    + timeline.getTimetoStr(true)
                    + " - "
                    + timeline.getTimetoStr(false)),
                Text(timeline.place),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    Map<String, dynamic> tmp = {};
                    tmp["name"] = timeline.name;
                    tmp["time_and_place"] = fixSchedule(timeline.name);
                    Navigator.pop(context);
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context)
                        => AddSchedulePage(data: tmp))
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text("수정하기"),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    fixedSize: Size(MediaQuery.of(ctx).size.width, 50))
                ),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    removeSchedule(timeline.name);
                    decreaseNum();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete_forever),
                  label: Text("삭제하기"),
                  style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      fixedSize: Size(MediaQuery.of(ctx).size.width, 50))
                )
              ]
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.timeline.top,
        left: 1,
        child: GestureDetector(
          onTap: () => _showSchedule(widget.timeline),
          child: Container(
              width: (widget.timeline.isSunday() && widget.timeline.top > 1425)
                  ? widget.timeline.w - widget.timeline.top + 1420
                  : widget.timeline.w,
              height: widget.timeline.h,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(4, 2, 2, 2),
              decoration: BoxDecoration(
                  color: widget.isTmp ? Color(tmp_color) : widget.timeline.getColortoWidget(),
                  borderRadius: (widget.timeline.isSunday() && widget.timeline.top + widget.timeline.h >= 1425)
                      ? BorderRadius.only(bottomRight: Radius.circular(widget.timeline.top + widget.timeline.h - 1425))
                      : null
              ),
              child: Wrap(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.timeline.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: medium,
                            color: Colors.white)),
                    SizedBox(height: 4),
                    Text(widget.timeline.place,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: regular,
                          color: Colors.white))
                  ]
                )
              ])
          )
        )
    );
  }
}
List<Widget> createTableItem(bool b) {
  return ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
      .map((e) => Container(
      width: item_width,
      child: Stack(children: b ? table_data[e]! : tmp_data[e]!)
  )).toList();
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
  const WeekSchedule({super.key, required this.touchable});

  final bool touchable;

  @override
  State<WeekSchedule> createState() => _WeekScheduleState();
}
class _WeekScheduleState extends State<WeekSchedule> {

  late List<Widget> vertical_lines;
  late List<Widget> horizontal_lines;
  late List<Widget> column_labels;
  late List<Widget> row_labels;
  late List<Widget> main_item;
  late List<Widget> tmp_item;

  // 스트림 수용자
  final Stream<bool> table_stream = table_sctr.stream;

  // 테이블 업데이트
  void _updateTable(bool b) {
    if (b) {
      setState(() {
        printForTest("call true");
        main_item = createTableItem(true);
        ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
            .forEach((day) => tmp_data[day]!.clear());
        tmp_item.clear();
      });
    }
    else {
      setState(() {
        printForTest("call false");
        tmp_item = createTableItem(false);
      });
    }
  }

  @override
  void initState() {
    table_stream.listen((event) => _updateTable(event));

    vertical_lines = createLine(true, item_width);
    horizontal_lines = createLine(false, item_width);
    column_labels = createLabel(true, item_width);
    row_labels = createLabel(false, item_width);
    main_item = createTableItem(true);
    tmp_item = [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IgnorePointer(
        ignoring: !widget.touchable,
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
                      child: Column(children: vertical_lines)
                  )
              ),
              // 가로 구분선
              Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 24 + item_height * item_count,
                      child: Row(children: horizontal_lines)
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
                    child: Row(mainAxisSize: MainAxisSize.max, children: main_item)
                )
              ),
              // 일정 추가 때만 보이는 박스
              if (!widget.touchable)
                Positioned(
                  top: 24,
                  left: 22,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 42,
                      height: item_height * item_count,
                      child: Row(mainAxisSize: MainAxisSize.max, children: tmp_item)
                  )
                )
            ])
        ),
      ),
    );
  }
}