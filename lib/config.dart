import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_one_day/table.dart';
import 'package:path_provider/path_provider.dart';

///
/// 색상
///
const int app_background = 0xFFFBFBFB;
const int line_color = 0xFFCCCCCC;
const int text_color_1 = 0xFF373737;
const int text_color_2 = 0xFF8E8E8E;
// 랜덤 색상 생성자
class UniqueColorGenerator {
  static List<Color> colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.indigo,
    Colors.amber,
  ];
  static Random random = new Random();
  static Color getColor() {
    if (colorOptions.length > 0) {
      return colorOptions.removeAt(random.nextInt(colorOptions.length));
    } else {
      return Color.fromARGB(random.nextInt(256), random.nextInt(256),
          random.nextInt(256), random.nextInt(256));
    }
  }
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

  final double top;
  final double w;
  final double h;
  final String day;
  final DateTime start;
  final DateTime end;
  final String name;
  final String place;
  final int color;

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

  double getBegin() { return top; }
  double getFinish() { return top + h; }
  Color getColor() { return Color(color); }

  bool isSunday() { return day == "일요일"; }
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
bool scheduleIsEmpty(String day, double s) {
  for (int i=0 ; i < week_time[day]!.length ; i++) {
    if (s < week_time[day]![i].getFinish())
      return false;
  }
  return true;
}

///
/// JSON in local
///
// 파일 제어
class Repository {
  Future<File> _initializeFile() async {
    final localDirectory = await getApplicationDocumentsDirectory();
    final file = File('${localDirectory.path}/data.json');

    if (!await file.exists()) {
      print("파일이 없습니다.");
      await file.create();
      print("파일 생성!");
    }
    else print("이미 파일이 있음: ${file.path}");

    return file;
  }

  Future<String> readFile() async {
    print("step 1");
    final file = await _initializeFile();
    print("step 2");
    return await file.readAsString();
  }

  Future<void> writeToFile(String data) async {
    print("step 1");
    final file = await _initializeFile();
    print("step 2");
    await file.writeAsString(json.encode(data));
    print("step 3");
  }
}
// 데이터 저장
Future<void> _saveData() async {
  Map<String, dynamic> raw_data = {};
  week_time.forEach((key, list) {
    List<String> tmp = [];
    list.forEach((timeline) =>
      tmp.add(jsonEncode(timeline.toJsonStr())));
    raw_data[key] = tmp;
  });
  Repository().writeToFile(jsonEncode(raw_data));
}
// 데이터 불러오기
Future<void> _loadData() async {
  print("불러오기 시작");
  String json_str = await Repository().readFile();
  if (json_str.isEmpty) {
    print("No data");
    return;
  }
  json_str = json.decode(json_str);
  Map raw_data = jsonDecode(json_str);
  raw_data.forEach((key, list) {
    list.forEach((e) {
      Timeline timeline = Timeline.fromJson(jsonDecode(e));
      week_time[key]?.add(timeline);
      table_data[key]?.add(TableItem(timeline: timeline));
    });
  });
  print("불러오기 끝");
  table_sctr.add(true);
  print("반영...");
}

///
/// 생명주기 관찰자
///
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadData();
    else if (state == AppLifecycleState.inactive) _saveData();
  }
}