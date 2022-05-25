

import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class PositionChangeNotify extends ChangeNotifier{
  var content = "test";

  void readFile(){
    String filepath = "C:\\Users\\lindonghao\\Desktop\\kotlin.txt";
    File file = File(filepath);
    var contents = file.readAsBytesSync();
    var res = Utf8Decoder(allowMalformed: true).convert(contents);
    content = res;
    notifyListeners();
  }
}