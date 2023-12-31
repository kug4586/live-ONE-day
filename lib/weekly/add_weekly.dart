import 'dart:async';

import 'package:live_one_day/config.dart';
import 'package:live_one_day/weekly/weekly_schedule.dart';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';



const double _appbar_size = 22;  // 상단바 크기
final TextEditingController _name_ctr = TextEditingController();  // 이름 입력란 컨트롤러

// 시간과 장소 객체
Map<int, _Data> time_place = {};
class _Data {
  _Data(this.key, this.timeline);

  final int key;
  final Timeline timeline;
}

// 메인
class AddWeekSchedulePage extends StatelessWidget {
  const AddWeekSchedulePage({super.key, this.data = null});

  final Map<String, dynamic>? data;

  // 뒤로가기
  Future<void> _back(BuildContext ctx) async {
    print("call [back]");
    if (data != null) _register(ctx);
    Navigator.pop(ctx);
  }

  // 주간 일정 등록 매서드
  void _register(BuildContext context) {
    if (_name_ctr.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "이름을 등록해 주세요",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
    }
    else if (time_place.length == 0) {
      Fluttertoast.showToast(
          msg: "시간 및 장소를 등록해주세요",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
    }
    else {
      bool check = true;
      List<_Data> tmps = time_place.values.toList();
      Set<String> days = time_place.values.map((e) => e.timeline.day).toSet();

      for (int i=0 ; i < days.length ; i++) {
        double s = tmps[i].timeline.calculateStart();
        double e = s + tmps[i].timeline.calculateDuration();
        if (scheduleIsEmpty(days.elementAt(i), s, e) == false) {
          check = false;
          break;
        }
      }

      if (check) {
        // 색 지정
        Color c = getRandomColor();
        // 데이터 추가
        printForTest(tmps.toString());
        tmps.forEach((item) {
          // 마지막 설정
          item.timeline.name = _name_ctr.text;
          item.timeline.color = c.value;

          // Timeline 데이터 추가
          week_time[item.timeline.day]?.add(item.timeline);

          // 테이블 아이템 추가
          table_data[item.timeline.day]?.add(TableItem(timeline: item.timeline, isTmp: false));
        });
        week_time.forEach((key, value) => printForTest("${key} : ${value.length}"));
        table_data.forEach((key, value) => printForTest("${key} : ${value.length}"));
        // 캐시 삭제
        time_place.clear();
        _name_ctr.clear();
        // 테이블 반영
        table_sctr.add(true);
        // Add Schedule 페이지 삭제
        Navigator.pop(context);
      }
      else Fluttertoast.showToast(
          msg: "이미 일정이 있습니다",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
    }
  }

  // 수정할 경우
  void setInit() {
    int tmp = 0;
    _name_ctr.text = data!["name"];
    (data!["time_and_place"] as List<Timeline>)
        .forEach((e) => time_place[tmp] = _Data(tmp++, e));
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) setInit();
    return WillPopScope(
      onWillPop: () async {
        await _back(context);
        return false;
      },
      child: Scaffold(
          body: Container(
            child: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child:  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // 앱 바
                      Container(
                          height: 50,
                          child: Stack(children: [
                            // 뒤로가기 버튼
                            Positioned(
                              bottom: 5, left: 15,
                              child: GestureDetector(
                                  onTap: () {
                                    if (data != null) _register(context);
                                    else {
                                      time_place.clear();
                                      _name_ctr.clear();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Icon(Icons.close, size: _appbar_size)),
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
                                    onTap: () {
                                      if (FocusScope.of(context).hasFocus)
                                        FocusScope.of(context).unfocus();
                                      _register(context);
                                    },
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
                            child: const WeekSchedule(tmp_display: true),
                          )
                      ),
                      // 입력란
                      Flexible(
                          flex: 6,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 20),
                              child: const InputTP()
                          )
                      )
                    ]
                ),
              ),
            ),
          )
      ),
    );
  }
}

// 입력란
class InputTP extends StatefulWidget {
  const InputTP({super.key});

  @override
  State<InputTP> createState() => _InputTPState();
}
class _InputTPState extends State<InputTP> {

  final ScrollController scr_ctr = ScrollController();
  final Stream<int> remove_stream = remove_sctr.stream;

  int length = 0;
  List<TimeAndPlace> _ary = [];

  // 입력란 삭제 매서드
  void _removeInputTP(int idx) {
    if (mounted)
      setState(() {
        time_place.remove(idx);
        _ary.removeWhere((e) => (e.key as ValueKey<int>).value == idx);
      });
  }

  @override
  void initState() {
    remove_stream.listen((int idx) => _removeInputTP(idx));
    time_place.values.forEach(
            (e) => _ary.add(TimeAndPlace(key: ValueKey<int>(length++))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: scr_ctr,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이름 입력
              Container(
                  height: item_height,
                  child: TextField(
                      controller: _name_ctr,
                      decoration: InputDecoration(
                          hintText: "이름",
                          hintStyle: TextStyle(
                              fontWeight: medium,
                              fontSize: font_size[1],
                              color: Color(text_color_2))))
              ),
              // 시간 및 장소 입력
              Column(children: _ary),
              // 아이템 추가 버튼
              Container(
                  height: item_height,
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (FocusScope.of(context).hasFocus)
                            FocusScope.of(context).unfocus();
                          time_place[length] = _Data(
                              length,
                              Timeline(
                                  top: 720,
                                  w: item_width,
                                  h: 60,
                                  day: "월요일",
                                  start: DateTime(0, 1, 1, 12, 0),
                                  end: DateTime(0, 1, 1, 13, 0),
                                  name: "",
                                  place: "",
                                  color: 0xFFFFFFFF
                              )
                          );
                          _ary.add(TimeAndPlace(key: ValueKey<int>(length)));
                          length++;
                        });
                      },
                      child: Text(
                          "시간 및 장소 추가",
                          style: TextStyle(
                              fontSize: font_size[1],
                              fontWeight: regular,
                              color: Colors.red)))
              )
            ]
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

  // 장소 입력란 컨트롤러
  final TextEditingController _place_ctr = TextEditingController();

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
                  children: <String>["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
                      .map((e) => GestureDetector(
                    onTap: () {
                      setState(() {
                        tmp_data[_data.timeline.day]?.removeWhere((e) => (e.key as ValueKey).value == _data.key);
                        _data.timeline.day = e;
                        time_place[_data.key] = _data;
                        tmp_data[_data.timeline.day]?.add(
                            TableItem(key: ValueKey<int>(_data.key), timeline: _data.timeline, isTmp: true));
                        table_sctr.add(false);
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: Text(e,
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
  void _selectTime(bool isStart, DateTime t){
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
                  isStart ? _data.timeline.start = time : _data.timeline.end = time;
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
                    tmp_data[_data.timeline.day]?.removeWhere((e) => (e.key as ValueKey).value == _data.key);

                    // 만약 시작 시간 정하는데, 현재 끝 시간보다 나중이거나 같다면
                    if (isStart && !_data.timeline.start.isBefore(_data.timeline.end)) {
                      // 만약 시작 시간이 23시를 넘겼다면, 끝나는 시간을 24시로 고정
                      if (_data.timeline.start.hour == 23 && _data.timeline.start.minute > 0) {
                        printForTest("가");
                        _data.timeline.setEndtoZero(_data.timeline.start);
                      }
                      // 아니면 1시간 더함
                      else {
                        printForTest("나");
                        _data.timeline.setTime(_data.timeline.start.add(Duration(hours: 1)), false);
                      }
                    }

                    // 만약 끝 시간을 정하는데
                    if (!isStart) {
                      // 만약 24시로 맞추었다면
                      if (_data.timeline.end.hour == 0 && _data.timeline.end.minute == 0) {
                        printForTest("다");
                        _data.timeline.setEndtoZero(_data.timeline.start);
                      }
                      // 아님 만약 현재 시작 시간보다 먼저거나 같다면
                      else if (!_data.timeline.end.isAfter(_data.timeline.start)) {
                        printForTest("라");
                        _data.timeline.setTime(_data.timeline.end.subtract(Duration(hours: 1)), true);
                      }
                    }

                    _data.timeline.top = _data.timeline.calculateStart();
                    _data.timeline.h = _data.timeline.calculateDuration();

                    printForTest(""
                        "start: ${_data.timeline.getTimetoStr(true)}, "
                        "end: ${_data.timeline.getTimetoStr(false)}, "
                        "top: ${_data.timeline.top}, h: ${_data.timeline.h}"
                    );

                    time_place[_data.key] = _data;
                    tmp_data[_data.timeline.day]?.add(
                        TableItem(key: ValueKey<int>(_data.key), timeline: _data.timeline, isTmp: true));
                    table_sctr.add(false);

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
    tmp_data[_data.timeline.day]?.add(
        TableItem(key: ValueKey<int>(_data.key), timeline: _data.timeline, isTmp: true));
    _place_ctr.text = _data.timeline.place;
    table_sctr.add(false);
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
                            child: Text(_data.timeline.day,
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
                  onTap: () => _selectTime(true, _data.timeline.start),
                  child: Container(
                    height: item_height * 0.6,
                    width: 80,
                    child: Stack(children: [
                      Positioned(
                          bottom: 5,
                          left: 0,
                          child: Text(_data.timeline.getTimetoStr(true),
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
                  onTap: () => _selectTime(false, _data.timeline.end),
                  child: Container(
                    height: item_height * 0.6,
                    width: 80,
                    child: Stack(children: [
                      Positioned(
                          bottom: 5,
                          left: 0,
                          child: Text(_data.timeline.getTimetoStr(false),
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
                  controller: _place_ctr,
                  onChanged: (str) {
                    _data.timeline.place = str;
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
                      setState(() {
                        remove_sctr.add((widget.key as ValueKey).value);
                        tmp_data[_data.timeline.day]?.removeWhere((e) => (e.key as ValueKey).value == _data.key);
                        table_sctr.add(false);
                      });
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

