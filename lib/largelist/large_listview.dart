import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_desktop/base/BasicPage.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'PositionChangeNotify.dart';

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
    for (int i = 0; i < maxLen; i++) list.add(i);

    itemPositionsListener.itemPositions.addListener(() {
      // print("value=${itemPositionsListener.itemPositions}");
      var first =itemPositionsListener.itemPositions.value.first.index;
      var firstPos = first*600/maxLen;
      model.changePosY(firstPos);
      // int pos = (dragX*maxLen/600).toInt();
    });

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   controller.addListener(() {
    //     print('scrolling');
    //   });
    //   controller.position.isScrollingNotifier.addListener(() {
    //     if(!controller.position.isScrollingNotifier.value) {
    //       print('scroll is stopped');
    //     } else {
    //       print('scroll is started');
    //     }
    //   });
    // });
  }
  double posX = 0;
  double posY =0;
  bool startDrag = false;
  Widget getProgressBar(){
    double pWidth  = 20;
    double pHeight = 600;
    return Expanded(
        child: ChangeNotifierProvider(
            create: (context) => model,
            child: Consumer<PositionChangeNotify>(builder: (context, cart, child) {
              return  Container(
                  child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        getList(),
                        Container(
                          width: pWidth,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onPanDown: onPanDown,
                                onPanUpdate:onPanUpdate,
                                onPanEnd: onPanEnd,
                              ),
                              CustomPaint(painter: new SignaturePainter(pWidth,pHeight,model.posX,model.posY)),
                            ],
                          ),
                        ),
                      ]));
            })));

  }

  onPanDown(DragDownDetails details){
    Offset local = details.localPosition;
    print(local);
    if(local.dy>model.posY&&local.dy<model.posY+40){
      startDrag = true;
      print("start drag");
    }
    startTimer();
  }
  int currentTime = 0;
  Offset? lastPost;
  onPanUpdate(DragUpdateDetails details) {
    lastPost = details.localPosition;
  }
  onPanEnd(DragEndDetails details){
    if(lastPost!=null){
      changePost(lastPost!,true);
    }
    startDrag = false;
  }

  void changePost(Offset local,bool force ){
    // print("ondrag $local $startDrag");
    var dragX = local.dy;
    if(dragX<=0)
      dragX = 0;
    else if(dragX>=560)
      dragX = 560;
    if(startDrag){
      int pos = (dragX*maxLen/600).toInt();
      itemScrollController.jumpTo(index: pos);
      model.changePosY(dragX);
    }
    currentTime = getCurrent();
  }
  Widget getChild() {
    return TextField(
      controller: urlController,
    );
  }

  void startTimer(){
    const period = const Duration(milliseconds: 100);
    Timer.periodic(period, (timer) {
      if(lastPost!=null)
        changePost(lastPost!, false);
      if (!startDrag) {
        //取消定时器，避免无限回调
        timer.cancel();
      }
    });
  }

  int getCurrent(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  Widget getList() {
    return  NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification pos) {
          if (pos is ScrollEndNotification) {

          }else if(pos is ScrollStartNotification){

          }
          return true;
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: new ScrollablePositionedList.builder(
            itemCount: list.length,
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (context, index) {
              return new ListTile(
                title: new Text('${list[index]}'),
              );
            },
          ),)

    );

  }

  Future<dynamic> goToPage(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }
}

class SignaturePainter extends CustomPainter  {
  SignaturePainter(this.width, this.height,this.posX,this.posY);
  double cWidth = 15;  //clip square width
  double cHeight = 40;  //clip square height
  double width;  //total width
  double height; //total height
  double posX;
  double posY;

  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.bevel;


    Paint paint2 = new Paint()
      ..color = Colors.grey
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.bevel;
    // canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint2);

    // if(posX>=width-cWidth)
    //   posX = width-cWidth;
    if(posY>=height-cHeight)
      posY = height-cHeight;
    var rect = Rect.fromLTWH(posX,posY, cWidth, cHeight);
    var radis = Math.min(cWidth, cHeight)/2;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radis)), paint);
  }
  bool shouldRepaint(SignaturePainter other){
    return true;
  }

}