import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_one_day/config.dart';

// 레이아웃
class DailySchedule extends StatelessWidget {
  const DailySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // 일정 리스트
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                  itemCount: 100,
                  itemBuilder: (context, idx) => Container(
                    height: 20,
                    margin: EdgeInsets.all(5),
                    color: Colors.redAccent,
                  )
              ),
            ),
          ),
          // 스케줄바
          Flexible(
            flex: 2,
            child: DailyScheduleBar()
          )
        ]
      ),
    );
  }
}

// 일정 리스트

// 스케줄바
class DailyScheduleBar extends StatelessWidget {
  const DailyScheduleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(builder: (context, constrains) =>
        Container(
          width: constrains.maxWidth,
          height: constrains.maxHeight,
          child: Stack(children: [
            // 막대기
            Positioned(
                top: 15,
                right: 40,
                child: Container(
                  width: 20,
                  height: constrains.maxHeight - 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)
                  )
                )
            ),
            // 스케줄 로프
            Positioned(
              top: 15,
              right: 40,
              child: Bits(),
            ),
            // 타임 포인터
            Positioned(
              top: 15,
              right: 37.5,
              child: _TimePointer()
            )
          ]),
        ),
    );;
  }
}

class Bits extends StatefulWidget {
  const Bits({super.key});

  @override
  State<Bits> createState() => _BitsState();
}
class _BitsState extends State<Bits> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TimePointer extends StatefulWidget {
  const _TimePointer({super.key});

  @override
  State<_TimePointer> createState() => _TimePointerState();
}
class _TimePointerState extends State<_TimePointer> {

  // 위치
  double pos = 0;
  // 시간
  DateFormat format = DateFormat.Hm();
  late DateTime t;

  // 업데이트
  Stream<bool> stream = time_sctr.stream;
  void _update(bool init) {
    setState(() {
      // 처음인 위젯이 생긴 경우
      if (init) {
        DateTime now = DateTime.now();
        int time = now
            .difference(DateTime(now.year, now.month, now.day))
            .inMinutes;
        pos = HPT * time;
      }
      // 아닌 경우
      else {
        t = t.add(Duration(minutes: 1));
        pos = (pos + HPT) % (MediaQuery.of(context).size.height - 122);
      }
      printForTest(t.toString());
    });
  }

  @override
  void initState() {
    // 스트림 활성화
    stream.listen((event) => _update(event));
    time_sctr.add(true);

    // 정밀한 타이머 설정
    t = DateTime.now();
    Timer.periodic(
      Duration(microseconds: t.difference(DateTime(t.year, t.month, t.day, t.hour, t.minute)).inMicroseconds),
      (timer) {
        startTimer();
        printForTest(t.toString());
        t = DateTime(t.year, t.month, t.day, t.hour, t.minute);
        time_sctr.add(false);
        timer.cancel();
      }
    );

    super.initState();
  }

  @override
  void dispose() {
    // 타이머 종료
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: pos),
      child: Row(children: [
        // 시간 표시
        Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text(format.format(t),
            style: TextStyle(color: Colors.white))
        ),
        // 포인터
        RotationTransition(
          turns: AlwaysStoppedAnimation(45 / 360),
          child: Container(
            width: 25,
            height: 25,
            color: Colors.blueAccent,
          ),
        )
      ])
    );
  }
}
