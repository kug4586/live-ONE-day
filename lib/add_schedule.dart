import 'dart:async';

import 'package:live_one_day/config.dart';
import 'package:live_one_day/table.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';



const double appbar_size = 22;  // 상단바 크기
const double item_height = 60;  // 리스트 높이

// 시간과 장소 객체
class _Data {
  _Data(this.key);

  final int key;
  String day = "월";
  DateTime start = DateTime(0,1,1, 12, 0);
  DateTime end = DateTime(0,1,1, 13, 0);
  String place = "";

  void setDay(String d) => day = d;
  String getDay() { return day + "요일"; }

  void setStart(DateTime t) => start = t;
  DateTime getStart() { return start; }
  String getStartToStr() { return DateFormat("Hm").format(start); }

  void setEnd(DateTime t) => end = t;
  void setEndToZero(DateTime t) => end = DateTime(t.year, t.month, t.day+1);
  DateTime getEnd() { return end; }
  String getEndToStr() { return DateFormat("Hm").format(end); }

  void setPlace(String p) => place = p;
  String getPlace() { return place; }

  double calculateStart() {
    DateTime tmp = DateTime(start.year, start.month, start.day);
    return start.difference(tmp).inMinutes * 1.0;
  }

  double calculateDuration() {
    return end.difference(start).inMinutes * 1.0;
  }
}

// 데이터
Map<int, _Data> time_place = {};



// 메인
class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}
class _AddSchedulePageState extends State<AddSchedulePage> {

  // 이름 입력란 컨트롤러
  final TextEditingController _text_ctr = TextEditingController();

  // 스트림 수용자
  final Stream<int> remove_stream = remove_sctr.stream;

  // 리스트 길이
  int length = 0;

  // 입력란 리스트
  Map<int, TimeAndPlace> _input_fields = {};

  // 입력란 삭제 매서드
  void _removeInputField(int idx) {
    setState(() {
      time_place.remove(idx);
      _input_fields.remove(idx);
    });
  }

  // 데이터 입력칸
  List<Widget> _setInputField() {
    List<Widget> ret = [
      Container(
          height: item_height,
          child: TextField(
              controller: _text_ctr,
              decoration: InputDecoration(
                  hintText: "이름",
                  hintStyle: TextStyle(
                      fontWeight: medium,
                      fontSize: font_size[1],
                      color: Color(text_color_2)))
          )
      )
    ];
    if (_input_fields.length > 0)
      _input_fields.values.forEach((e) => ret.add(e));
    ret.add(Container(
        height: item_height,
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
            onTap: () {
              setState(() {
                if (FocusScope.of(context).hasFocus)
                  FocusScope.of(context).unfocus();
                time_place[length] = _Data(length);
                _input_fields[length] = TimeAndPlace(key: ValueKey<int>(length++));
              });
            },
            child: Text(
                "시간 및 장소 추가",
                style: TextStyle(
                    fontSize: font_size[1],
                    fontWeight: regular,
                    color: Colors.red)))
    ));
    return ret;
  }

  // 주간 일정 등록 매서드
  void _register() {
    if (FocusScope.of(context).hasFocus)
      FocusScope.of(context).unfocus();

    if (_text_ctr.text.isEmpty) {
      print("이름을 등록해 주세요");
    }
    else if (time_place.length == 0) {
      print("시간 및 장소를 등록해주세요");
    }
    else {
      bool check = true;
      List<_Data> tmps = time_place.values.toList();
      Set<String> days = time_place.values.map((e) => e.getDay()).toSet();

      for (int i=0 ; i < days.length ; i++) {
        if (scheduleIsEmpty(days.elementAt(i), tmps[i].calculateStart()) == false)
        {
          check = false;
          break;
        }
      }

      if (check) {
        Color c = UniqueColorGenerator.getColor();
        tmps.forEach((item) {
          Timeline _value = Timeline(
              top: item.calculateStart(),
              w: item_width,
              h: item.calculateDuration(),
              day: item.getDay(),
              start: item.getStart(),
              end: item.getEnd(),
              name: _text_ctr.text,
              place: item.getPlace(),
              color: c.value
          );

          // Timeline 데이터 추가
          week_time[item.getDay()]!.add(_value);

          // 테이블 아이템 추가
          table_data[item.getDay()]?.add(TableItem(timeline: _value));
        });
        time_place.clear();
        table_sctr.add(true);
        Navigator.pop(context);
      }
      else { print("이미 일정이 있습니다"); }
    }
  }

  @override
  void initState() {
    remove_stream.listen((int idx) => _removeInputField(idx));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // 앱 바
                Flexible(
                  flex: 1,
                  child: Stack(children: [
                    // 뒤로가기 버튼
                    Positioned(
                      bottom: 5, left: 15,
                      child: GestureDetector(
                          onTap: () {
                            time_place.clear();
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close, size: appbar_size)),
                    ),
                    // 타이틀
                    Positioned(
                      bottom: 5, left: 45,
                      child: Text(
                        "일정 생성",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: medium,
                          fontSize: font_size[1]))),
                    // 생성하기 버튼
                    Positioned(
                      bottom: 2, right: 15,
                      child: GestureDetector(
                          onTap: _register,
                          child: Icon(Icons.arrow_circle_up, size: 32)))
                  ])
                ),
                // 테이블
                Flexible(
                  flex: 7,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: WeekSchedule(),
                  )
                ),
                // 세부 내용
                Flexible(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _setInputField()
                      )
                    )
                  )
                )
              ]
            ),
          ),
        ),
      )
    );
  }
}



// 때와 장소
class TimeAndPlace extends StatefulWidget {
  const TimeAndPlace({super.key});

  @override
  State<TimeAndPlace> createState() => _TimeAndPlaceState();
}
class _TimeAndPlaceState extends State<TimeAndPlace> {

  // 데이터
  late _Data _data;

  // 요일 선택창 띄우기
  void _selecteDay() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <String>["월", "화", "수", "목", "금", "토", "일"]
                      .map((e) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _data.setDay(e);
                        time_place[_data.key] = _data;
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: Text(e + "요일",
                            style: TextStyle(
                                fontWeight: regular,
                                fontSize: 18,
                                color: Color(text_color_1)))),
                  ))
                      .toList()
              )
          );
        });
  }

  // 시간 선택창 띄우기
  void _selectTime(bool isStart, DateTime t) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Stack(children: [
              // 깔끔한? UI
              Positioned(
                top: 40,
                left: 58,
                child: Container(
                  width: 40,
                  height: 3,
                  color: Color(line_color),
                ),
              ),
              Positioned(
                top: 40,
                right: 58,
                child: Container(
                  width: 40,
                  height: 3,
                  color: Color(line_color),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 58,
                child: Container(
                  width: 40,
                  height: 3,
                  color: Color(line_color),
                ),
              ),
              Positioned(
                bottom: 40,
                right: 58,
                child: Container(
                  width: 40,
                  height: 3,
                  color: Color(line_color),
                ),
              ),
              // 시간 선택
              TimePickerSpinner(
                time: t,
                is24HourMode: true,
                isShowSeconds: false,
                alignment: Alignment.center,
                minutesInterval: 5,
                normalTextStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.black26,
                ),
                highlightedTextStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.black87
                ),
                spacing: 30,
                itemHeight: 40,
                isForce2Digits: true,
                onTimeChange: (time) {
                  time = DateTime(
                      time.year, time.month, time.day,
                      time.hour, time.minute
                  );
                  isStart ? _data.setStart(time) : _data.setEnd(time);
                }
              )
            ]),
            actions: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text("취소", style: TextStyle(fontSize: 16))
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: GestureDetector(
                  onTap: () {
                    // 만약 시작 시간 정하는데, 현재 끝 시간보다 나중이라면
                    if (isStart && _data.getStart().isAfter(_data.getEnd())) {
                      // 만약 시작 시간이 23시를 넘겼다면, 끝나는 시간을 24시로 고정
                      if (_data.start.hour == 23 && _data.start.minute > 0)
                        _data.setEndToZero(_data.getStart());
                      // 아니면 1시간 더함
                      else _data.setEnd(_data.getStart().add(Duration(hours: 1)));
                    }

                    // 만약 끝 시간을 정하는데
                    if (!isStart) {
                      // 만약 24시로 맞추었다면
                      if (_data.end.hour == 0 && _data.end.minute == 0)
                        _data.setEndToZero(_data.getEnd());
                      // 아님 만약 현재 시작 시간보다 먼저라면
                      else if (_data.getEnd().isBefore(_data.getStart()))
                        _data.setStart(_data.getEnd().subtract(Duration(hours: 1)));
                    }

                    time_place[_data.key] = _data;
                    setState(() => Navigator.pop(context));
                  },
                  child: Text("확인", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    _data = time_place[(widget.key as ValueKey).value]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // 시각
      Container(
          height: item_height,
          decoration: BoxDecoration(color: Color(app_background)),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 요일
                GestureDetector(
                  onTap: () => _selecteDay(),
                  child: Container(
                      height: item_height * 0.6,
                      width: 80,
                      child: Stack(children: [
                        Positioned(
                            bottom: 5,
                            left: 0,
                            child: Text(_data.getDay(),
                              style: TextStyle(
                                color: Color(text_color_1),
                                fontSize: 18,
                                fontWeight: medium))),
                        Positioned(
                          bottom: 5,
                          right: 0,
                          child: Icon(Icons.keyboard_arrow_down))
                      ])
                  ),
                ),
                SizedBox(width: 20),
                // 시작 시각
                GestureDetector(
                  onTap: () => _selectTime(true, _data.getStart()),
                  child: Container(
                    height: item_height * 0.6,
                    width: 80,
                    child: Stack(children: [
                      Positioned(
                          bottom: 5,
                          left: 0,
                          child: Text(_data.getStartToStr(),
                              style: TextStyle(
                                  color: Color(text_color_1),
                                  fontSize: 20,
                                  fontWeight: medium))),
                      Positioned(
                          bottom: 5,
                          right: 0,
                          child: Icon(Icons.keyboard_arrow_down))
                    ])
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: item_height * 0.6,
                  alignment: Alignment.center,
                  child: Text("~",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black))),
                SizedBox(width: 15),
                // 끝 시각
                GestureDetector(
                  onTap: () => _selectTime(false, _data.getEnd()),
                  child: Container(
                    height: item_height * 0.6,
                    width: 80,
                    child: Stack(children: [
                      Positioned(
                          bottom: 5,
                          left: 0,
                          child: Text(_data.getEndToStr(),
                              style: TextStyle(
                                  color: Color(text_color_1),
                                  fontSize: 20,
                                  fontWeight: medium))),
                      Positioned(
                          bottom: 5,
                          right: 0,
                          child: Icon(Icons.keyboard_arrow_down))
                    ])
                  ),
                )
              ]
          )
      ),
      // 장소
      Container(
          height: item_height,
          child: Stack(children: [
            // 장소 입력
            Positioned(
              child: TextField(
                  onChanged: (str) {
                    _data.setPlace(str);
                    time_place[_data.key] = _data;
                  },
                  decoration: InputDecoration(
                      hintText: "장소",
                      hintStyle: TextStyle(
                          fontWeight: medium,
                          fontSize: font_size[1],
                          color: Color(text_color_2)))
              ),
            ),
            // 입력란 삭제 버튼
            Positioned(
                right: 0,
                bottom: 15,
                child: GestureDetector(
                    onTap: () {
                      setState(() => remove_sctr.add((widget.key as ValueKey).value));
                    },
                    child: Icon(
                        Icons.close,
                        size: 28,
                        color: Colors.red))
            )
          ])
      )
    ]);
  }
}

