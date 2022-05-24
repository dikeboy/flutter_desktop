

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_desktop/moudle/largelist/large_listview.dart';
import 'package:flutter_desktop/moudle/uno_textfield.dart';
import 'package:flutter_desktop/utils/WindowSizeService.dart';

import 'base/BasicPage.dart';
import 'moudle/largetext/large_text.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows|| Platform.isLinux || Platform.isMacOS) {
    final WindowSizeService windowSizeService =new  WindowSizeService();
    windowSizeService.initialize();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home moudle of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Desktop"),
        ),
        body: Center(
              child: getChild(),
        ));
  }

  Widget getChild(){
    return  Column(
      children: [
        Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bindHomeBtn("Large List", () {return LargeListPage();}),
                bindHomeBtn("UndoTextField", () {return UndoTextField();}),
              ],
            )),
        Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bindHomeBtn("Large Text", () {return LargeTextPage();}),
                bindHomeBtn("UndoTextField", () {return UndoTextField();}),
              ],
            )),
      ],
    );
  }

  Widget bindHomeBtn(String title, StateCallBack stateCallBack) {
    return Expanded(child: GestureDetector(
        child: Container(
            color: Color(0x10000000),
            height: 200, alignment: Alignment.center, child: Text(title)),
        onTap: () {
          goToPage(context,BasicPage(title: title, basicState: stateCallBack));
        }));
  }

  Future<dynamic> goToPage(BuildContext context,Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }


}
