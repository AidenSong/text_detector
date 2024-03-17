import 'package:flutter/material.dart';
import 'package:text_detector/my_home_page.dart';



void main() {

  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: "Flutter Demo Home Page"),
    );
  }
}
