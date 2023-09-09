import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_one_day/table.dart';
import 'package:path_provider/path_provider.dart';

///
/// 테스트용 출력
///
const bool isTest = true;
void printForTest(String content) {
  if (isTest) print("[@] $content");
}

///
/// 사이즈
///
late double item_width;
const double item_height = 60;
const double item_count = 24;

///
/// 색상
///
const int app_background = 0xFFFBFBFB;
const int line_color = 0xFFCCCCCC;
const int text_color_1 = 0xFF373737;
const int text_color_2 = 0xFF8E8E8E;
const int tmp_color = 0x805D5D5D;
const List<Color> box_colors = [
  Color(0xFFFF6767),
  Color(0xFFFFA125),
  Color(0xFFF3C800),
  Color(0xFF23DA32),
  Color(0xFF5EA1FF),
  Color(0xFFAC72FF),
  Color(0xFFEC69CA),
  Color(0xFFEC3636),
  Color(0xFFF18F0D),
  Color(0xFFD8B706),
  Color(0xFF1EAC29),
  Color(0xFF2B6FD5),
  Color(0xFF7525D8),
  Color(0xFFEA3E9E),
];
int num = 0;
void decreaseNum() => num--;
Color getRandomColor() {
  int tmp = num;
  num = (num + 1) % 14;
  return box_colors[tmp];
}

///
/// 폰트
///
const List<double> font_size = [12, 18, 22];
const FontWeight regular = FontWeight.w300;
const FontWeight medium = FontWeight.w600;
const FontWeight bold = FontWeight.w900;

///
/// 스트림 컨트롤러
///
StreamController<int> remove_sctr = StreamController<int>.broadcast();
StreamController<bool> table_sctr = StreamController<bool>.broadcast();

///
/// Timeline
///
// 시간 데이터 양식
final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");
// 객체
class Timeline {
  Timeline({
    required this.top,
    required this.w,
    required this.h,
    required this.day,
    required this.start,
    required this.end,
    required this.name,
    required this.place,
    required this.color,
  });

  double top;
  double w;
  double h;
  String day;
  DateTime start;
  DateTime end;
  String name;
  String place;
  int color;

  Map<String, dynamic> toJsonStr() {
    return {
      "top" : top,
      "width" : w,
      "height" : h,
      "day" : day,
      "start_time" : _format.format(start),
      "end_time" : _format.format(end),
      "name" : name,
      "place" : place,
      "color" : color
    };
  }
  factory Timeline.fromJson(Map<String, dynamic> data) {
    return Timeline(
        top: data["top"],
        w: data["width"],
        h: data["height"],
        day: data["day"],
        start: DateTime.parse(data["start_time"]),
        end: DateTime.parse(data["end_time"]),
        name: data["name"],
        place: data["place"],
        color: data["color"]
    );
  }

  Color getColortoWidget() { return Color(color); }

  void setDay(String d) => day = d;
  String getDay() { return day; }
  bool isSunday() { return day == "일요일"; }

  void setTime(DateTime t, bool isStart) => isStart ? start = t : end = t;
  void setEndtoZero(DateTime t) => end = DateTime(t.year, t.month, t.day+1);
  String getTimetoStr(bool isStart) { return DateFormat("Hm").format(isStart ? start : end); }

  void setPlace(String p) => place = p;
  String getPlace() { return place; }

  double getBegin() { return top; }
  double getFinish() { return top + h; }
  double calculateStart() {
    DateTime tmp = DateTime(start.year, start.month, start.day);
    return start.difference(tmp).inMinutes * 1.0;
  }
  double calculateDuration() {
    return end.difference(start).inMinutes * 1.0;
  }
}
// 시간표 데이터
Map<String, List<Timeline>> week_time = {
  "월요일" : [],
  "화요일" : [],
  "수요일" : [],
  "목요일" : [],
  "금요일" : [],
  "토요일" : [],
  "일요일" : []
};
// 해당 시간에 일정이 비어있는가?
bool scheduleIsEmpty(String day, double s, double e) {
  for (int i=0 ; i < week_time[day]!.length ; i++) {
    if (s < week_time[day]![i].getFinish() && e > week_time[day]![i].getBegin())
      return false;
  }
  return true;
}
// 일정 수정하기
List<Timeline> fixSchedule(String name) {
  List<Timeline> ret = [];
  ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
      .forEach((day) {
        printForTest(day);
        week_time[day]!.forEach((timeline) {
          if (timeline.name == name) {
            printForTest("${timeline.name} == $name");
            ret.add(timeline);
          }
        });
        printForTest("");
        week_time[day]!.removeWhere((e) => e.name == name);
        table_data[day]!.removeWhere((e) => e.timeline.name == name);
      });
  table_sctr.add(true);
  printForTest("a" + ret.toString());
  printForTest(week_time.toString());
  printForTest(table_data.toString());
  return ret;
}
// 일정 삭제하기
void removeSchedule(String name) {
  ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
      .forEach((day) {
        week_time[day]!.removeWhere((e) => e.name == name);
        table_data[day]!.removeWhere((e) => e.timeline.name == name);
      });
  table_sctr.add(true);
  printForTest(week_time.toString());
  printForTest(table_data.toString());
}

///
/// JSON in local
///
// 파일 제어
class Repository {
  Future<File> _initializeFile() async {
    printForTest("파일 경로 탐색 시작");
    final localDirectory = await getApplicationDocumentsDirectory();
    final file = File('${localDirectory.path}/data.json');

    if (!await file.exists()) {
      printForTest("파일이 없습니다.");
      await file.create();
      printForTest("파일 생성!");
    }
    else printForTest("이미 파일이 있음: ${file.path}");

    return file;
  }

  Future<String> readFile() async {
    final file = await _initializeFile();
    printForTest("데이터 읽는 중...");
    return await file.readAsString();
  }

  Future<void> writeToFile(String data) async {
    final file = await _initializeFile();
    printForTest("데이터 저장 중...");
    await file.writeAsString(json.encode(data));
  }
}
// 데이터 저장
Future<void> saveData() async {
  printForTest("데이터 전처리 시작");
  Map<String, dynamic> raw_data = {};
  raw_data["num"] = num;
  week_time.forEach((key, list) {
    List<String> tmp = [];
    list.forEach((timeline) =>
      tmp.add(jsonEncode(timeline.toJsonStr())));
    raw_data[key] = tmp;
  });
  printForTest("데이터 전처리 종료");
  printForTest(jsonEncode(raw_data));
  printForTest("로컬 폴더에 저장 시작");
  await Repository().writeToFile(jsonEncode(raw_data));
  printForTest("저장 완료");
}
// 데이터 불러오기
Future<void> loadData() async {
  printForTest("데이터 불러오기 시작");
  String json_str = await Repository().readFile();
  if (json_str.isEmpty) {
    printForTest("불러올 데이터가 없음");
    return;
  }
  printForTest("데이터 불러오기 완료");
  printForTest(json_str);

  printForTest("데이터 전처리 시작");
  json_str = json.decode(json_str);
  Map raw_data = jsonDecode(json_str);
  raw_data.forEach((key, value) {
    printForTest(key);
    if (key == "num") {
      printForTest("${key}: ${value}");
      printForTest("");
      num = value;
    }
    else {
      value.forEach((e) {
        Timeline timeline = Timeline.fromJson(jsonDecode(e));
        printForTest("${timeline.name} : ${timeline.getBegin()} ~ ${timeline.getFinish()} / ${timeline.place}");
        week_time[key]?.add(timeline);
        table_data[key]?.add(TableItem(timeline: timeline, isTmp: false));
      });
      printForTest("");
    }
  });
  table_sctr.add(true);
  printForTest(week_time.toString());
  printForTest(table_data.toString());
  printForTest("데이터 전처리 완료");
}

///
/// 생명주기 관찰자
///
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      printForTest("앱 비활성화");
      await saveData();
    }
  }
}