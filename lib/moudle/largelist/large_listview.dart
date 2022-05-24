import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_desktop/base/BasicPage.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'draglist_view.dart';
import 'position_notify.dart';

import 'dart:math' as Math;


class  LargeListPage extends BasicState {
  var urlController = TextEditingController();
  var list = [];
  var model = PositionChangeNotify();
  var controller = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  var maxLen = 20000;
  bool showProgressBar = false;

  @override
  Widget createContent() {
    final height = MediaQuery.of(context).size.height;
    print("height=$height");
    return  Column(
            children: [
              getProgressBar(),
            ],
    );
  }
  @override
  void initState() {
    super.initState();
    // urlController.initState();
    for (int i = 0; i < maxLen; i++)
      list.add(i);
  }
  Widget getProgressBar(){
    return  new DragListScrollView(
      itemCount: list.length,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemBuilder: (context, index) {
        return  Container(
            height: 30,
            child:new ListTile(
          title: new Text('${list[index]}'),
        ));
      },
    );
  }

  Widget getChild() {
    return TextField(
      controller: urlController,
    );
  }
}