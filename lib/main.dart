import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'screen/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      textStyle: TextStyle(fontSize: 19.0, color: Color(0xFF2E3E5C)),
      backgroundColor: Colors.green,
      child: MaterialApp(
        home: UserListScreen(),
      ),
      animationCurve: Curves.easeIn,
      duration: Duration(seconds: 3),
    );
  }
}
