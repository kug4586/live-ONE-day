import 'package:live_one_day/config.dart';
import 'package:live_one_day/home_page.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  printForTest("앱 실행");
  loadData();
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  onWillPop() {
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '하루살아',
      home: const HomePage()
    );
  }
}
