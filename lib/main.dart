import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:EnerQuiz/views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnerQuiz',
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff4682b4)),
      home: HomeScreen(),
    );
  }
}


