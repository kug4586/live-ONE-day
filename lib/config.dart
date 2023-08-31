import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

///
/// 색상
///
const int app_background = 0xFFFBFBFB;
const int line_color = 0xFFCCCCCC;
const int text_color_1 = 0xFF151515;
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
/// 일정
///

class Time {
  Time({
    required double begin,
    required double duration
  }) {
    this.begin = begin;
    this.finish = begin + duration;
  }

  late double begin, finish;

  double getBegin() { return begin; }
  double getFinish() { return finish; }
}

Map<String, List<Time>> week_time = {
  "월요일" : [],
  "화요일" : [],
  "수요일" : [],
  "목요일" : [],
  "금요일" : [],
  "토요일" : [],
  "일요일" : []
};

bool scheduleIsEmpty(String day, Time t) {
  for (int i=0 ; i < week_time[day]!.length ; i++) {
    if (t.getBegin() < week_time[day]![i].getFinish())
      return false;
  }
  return true;
}