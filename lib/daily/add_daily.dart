import 'package:flutter/material.dart';
import 'package:live_one_day/config.dart';

class AddDaySchedulePage extends StatelessWidget {
  const AddDaySchedulePage({super.key});

  final double appbar_size = 22;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                                  onTap: () => Navigator.pop(context),
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
                                    onTap: () {},
                                    child: Icon(Icons.arrow_circle_up, size: 32)))
                          ])
                      )
                    ]
                ),
              ),
            ),
          )
      )
    );
  }
}
