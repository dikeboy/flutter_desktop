import 'package:flutter/material.dart';

typedef StateCallBack= BasicState Function();

class BasicPage extends StatefulWidget {
  BasicPage({Key? key, required this.title, required this.basicState}) : super(key: key);
  final String title;
  final StateCallBack basicState;

  @override
  State<StatefulWidget> createState() {
    return basicState();
  }
}

abstract class BasicState extends State<BasicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTabName()),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                rightClick();
              },
              child: Text(getRightName()),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body:createContent());
  }

  void rightClick(){

  }
  String getTabName(){
    return "Desktop";
  }

  String getRightName(){
    return "";
  }
  Widget createContent();
}
