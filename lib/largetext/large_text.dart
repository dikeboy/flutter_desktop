import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_desktop/base/BasicPage.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'PositionChangeNotify.dart';

import 'dart:math' as Math;


class  LargeTextPage extends BasicState {
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
    final size =MediaQuery.of(context).size;
    final width =size.width;
    return  Container(child: getProgressBar(),width: width,);

  }
  @override
  void initState() {
    super.initState();
    model.readFile();


  }
  double posX = 0;
  double posY =0;
  bool startDrag = false;
  Widget getProgressBar(){
    double pWidth  = 400;
    double pHeight = 600;
    return ChangeNotifierProvider(
            create: (context) => model,
            child: Consumer<PositionChangeNotify>(builder: (context, cart, child) {
              print("load");
              return SingleChildScrollView(
                  controller:controller,
                  child:
                  Padding(
                    padding: EdgeInsets.only(left: 0,top:0,right:10,bottom: 0),
                    child:_splitEnglish(model.content),
                  ));
              return  Stack(
                            children: [
                              GestureDetector(
                                onPanDown: onPanDown,
                                onPanUpdate:onPanUpdate,
                                onPanEnd: onPanEnd,
                              ),
                              CustomPaint(painter: new SignaturePainter(pWidth,pHeight,model)),
                            ],
              );}));
  }

  onPanDown(DragDownDetails details){

  }
  onPanUpdate(DragUpdateDetails details) {
  }
  onPanEnd(DragEndDetails details){

  }

  Widget getChild() {
    return TextField(
      controller: urlController,
    );
  }


  int getCurrent(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<dynamic> goToPage(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }

  Widget _splitEnglish(String name) {
    final size =MediaQuery.of(context).size;
    List<TextSpan> spans = [];
    //split 截出来
    //正常文本
    TextStyle _normalStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
      letterSpacing: 0
    );
    var text ="jskdlfjskdlfj是大家看法伦敦上空发射东风萨克利夫军事对抗疗法是地方都     nameage text          slkdjflksdjf 卢卡斯京东方考虑实际得分山卡拉地方四道口附近都是付款就       是反抗类毒素解放收到发四道口附近士大夫";
    var textSpan =  TextSpan(text:text,style: _normalStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    print("size:${textPainter.size}  line=${textPainter.computeLineMetrics()} max=${textPainter.maxLines}");
    spans.add(textSpan);
    return SelectableText.rich(
      TextSpan(children: spans),
      showCursor: true,
    );
  }
}


class SignaturePainter extends CustomPainter  {
  SignaturePainter(this.width, this.height,this.model);
  double cWidth = 15;  //clip square width
  double cHeight = 40;  //clip square height
  double width;  //total width
  double height; //total height
  PositionChangeNotify model;

  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.bevel;
    // canvas.drawRect(Rect.fromLTWH(0,0,width,height), paint);


    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final textSpan = TextSpan(
      text: model.content,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: width,
    );
    final offset = Offset(50, 100);
    textPainter.paint(canvas, offset);
  }
  bool shouldRepaint(SignaturePainter other){
    return true;
  }

}