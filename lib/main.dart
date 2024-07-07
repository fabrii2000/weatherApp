import 'package:flutter/material.dart';

import 'pages/my_home_page.dart';
import 'utils/global_variable.dart' as global;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        textTheme: TextTheme(
            bodyMedium: TextStyle(
                fontFamily: 'ARCADE CLASSIC',
                fontWeight: FontWeight.w500,
                fontSize: global.height(context) * 0.023)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather'),
    );
  }
}
