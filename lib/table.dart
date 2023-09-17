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

// 메인 테이블 데이터
class TableData extends StatefulWidget {
  const TableData({super.key, required this.isTmp});

  final bool isTmp;

  @override
  State<TableData> createState() => _TableDataState();
}
class _TableDataState extends State<TableData> {

  // 테이블 아이템 리스트 생성
  List<Widget> _createTableItem(bool b) {
    return ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
        .map((e) => Container(
        width: item_width,
        child: Stack(children: b ? table_data[e]! : tmp_data[e]!)
    )).toList();
  }

  // 테이블 업데이트
  void _updateTable(bool b) {
    if (mounted) {
      setState(() {
        if (b) {
          printForTest("call updateTable - true");
          ary = _createTableItem(true);
          ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
              .forEach((day) => tmp_data[day]!.clear());
        }
        else {
          printForTest("call updateTable - false");
          ary = _createTableItem(false);
          <String>["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
              .forEach((day) => printForTest(tmp_data[day]!.length.toString()));
        }
      });
    }
  }

  // 이 위젯의 핵심 변수들
  final Stream<bool> table_stream = table_sctr.stream;
  List<Widget> ary = [];

  @override
  void initState() {
    table_stream.listen((event) => _updateTable(event));
    ary = _createTableItem(!widget.isTmp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 42,
        height: item_height * item_count,
        child: Row(children: ary)
    );
  }
}

// 테이블 아이템
class TableItem extends StatelessWidget {
  const TableItem({
    super.key,
    required this.timeline,
    required this.isTmp
  });

  final Timeline timeline;
  final bool isTmp;

  // 일정 보여주기
  void _showSchedule(Timeline timeline, BuildContext context) {
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

                    ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
                        .forEach((day) {
                          table_data[day]!.removeWhere(
                                  (item) => timeline.name == timeline.name);
                        });

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
        top: timeline.top,
        child: GestureDetector(
          onTap: () => _showSchedule(timeline, context),
          child: Container(
              width: (timeline.isSunday() && timeline.top > 1425)
                  ? timeline.w - timeline.top + 1420
                  : timeline.w,
              height: timeline.h,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(4, 2, 2, 2),
              decoration: BoxDecoration(
                  color: isTmp ? Color(tmp_color) : timeline.getColortoWidget(),
                  borderRadius: (timeline.isSunday() && timeline.top + timeline.h >= 1425)
                      ? BorderRadius.only(bottomRight: Radius.circular(timeline.top + timeline.h - 1425))
                      : null
              ),
              child: Wrap(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isTmp ? "" : timeline.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: medium,
                            color: Colors.white)),
                    SizedBox(height: 4),
                    Text(isTmp ? "" : timeline.place,
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

// 구분선
class VerticalLine extends StatelessWidget {
  const VerticalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 24 + item_height * item_count,
        child: Column(children: List.generate(24, (index) {
          return Container(
            width: MediaQuery.of(context).size.width - 20,
            height: index == 0 ? 24 : 60,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(line_color)))),
          );
        }))
    );
  }
}
class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        height: 24 + item_height * item_count,
        child: Row(children: List.generate(7, (index) {
          return Container(
            width: index == 0 ? 22 : item_width,
            height: 24 + item_height * item_count,
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Color(line_color)))),
          );
        }))
    );
  }
}

// 라벨
class ColumnLabel extends StatelessWidget {
  const ColumnLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 42,
        height: 24,
        child: Row(
            children: <String>["월", "화", "수", "목", "금", "토", "일"]
                .map((day) {
              return Container(
                  width: item_width,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(day,
                      style: TextStyle(
                          fontWeight: regular,
                          fontSize: font_size[0],
                          color: Color(text_color_2)))
              );
            })
                .toList()
        )
    );
  }
}
class RowLabel extends StatelessWidget {
  const RowLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 22,
        height: item_height * item_count,
        child: Column(children: List.generate(24, (index) {
          return Container(
              width: 22,
              height: item_height,
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 2, right: 2),
              child: Text(index.toString(),
                  style: TextStyle(
                      fontWeight: regular,
                      fontSize: font_size[0],
                      color: Color(text_color_2)))
          );
        }))
    );
  }
}

// 레이아웃
class WeekSchedule extends StatelessWidget {
  const WeekSchedule({super.key, required this.tmp_display});
  
  final bool tmp_display;

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
            const Positioned(
                top: 0,
                left: 0,
                child: VerticalLine()
            ),
            // 가로 구분선
            const Positioned(
                top: 0,
                left: 0,
                child: HorizontalLine()
            ),
            // 열의 라벨
            const Positioned(
              top: 0,
              left: 22,
              child: ColumnLabel(),
            ),
            // 행의 라벨
            const Positioned(
              top: 24,
              left: 0,
              child: RowLabel(),
            ),
            // 테이블 데이터
            Positioned(
                top: 24,
                left: 22,
                child: IgnorePointer(
                  ignoring: tmp_display,
                  child: TableData(isTmp: false)
                )
            ),
            // 테이블 데이터
            if (tmp_display)
              const Positioned(
                  top: 24,
                  left: 22,
                  child: IgnorePointer(
                    ignoring: true,
                    child: TableData(isTmp: true)
                  )
              )
          ])
      )
    );
  }
}