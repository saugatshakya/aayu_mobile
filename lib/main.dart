import 'package:aayu_mobile/authscreens/login.dart';
import 'package:aayu_mobile/authscreens/welcome.dart';
import 'package:aayu_mobile/home/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aayu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "Welcome": (context) => SafeArea(child: Welcome()),
        "Login": (context) => SafeArea(child: Login()),
        "Main": (context) => SafeArea(child: MainP())
      },
      home: SafeArea(child: MainP()),
    );
  }
}
