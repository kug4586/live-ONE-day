import 'package:live_one_day/config.dart';
import 'package:live_one_day/main_frame.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  printForTest("앱 초기화");
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  await loadData();
  await Future.delayed(const Duration(milliseconds: 300));
  printForTest("앱 실행");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    item_width = (MediaQuery.of(context).size.width - 42) / 7;
    setHPT(MediaQuery.of(context).size.height - 132);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '하루살아',
      home: MainFrame()
    );
  }
}
