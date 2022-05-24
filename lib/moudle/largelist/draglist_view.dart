
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'position_notify.dart';


class DragListScrollView extends StatelessWidget{
  final int itemCount;
  final ItemScrollController? itemScrollController;
  ItemPositionsListener? itemPositionsListener;
  final IndexedWidgetBuilder itemBuilder;
  final Widget? child;
  var model = PositionChangeNotify();
  double posX = 0;
  double posY =0;
  bool startDrag = false;
  var maxLen = 20000;
  final double _scrollbarHeight = 40;

  DragListScrollView({
     required this.itemCount,
     required this.itemBuilder,
     Key? key,
    this.itemScrollController,
    this.itemPositionsListener,
    this.child,
  })  :super(key: key){
    maxLen = itemCount;
    itemPositionsListener?.itemPositions?.addListener(() {
      // print("value=${itemPositionsListener.itemPositions}");
      if(!startDrag){
        var first = itemPositionsListener!.itemPositions.value.first.index;
        var firstPos = first * (model.height-_scrollbarHeight) / maxLen;
        model.changePosY(firstPos);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double pWidth  = 15;
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
                              CustomPaint(painter: SignaturePainter(model.posX,
                                  model.posY,model,10,_scrollbarHeight),
                                  size: Size.infinite),
                              GestureDetector(
                                onPanDown: onPanDown,
                                onPanUpdate:onPanUpdate,
                                onPanEnd: onPanEnd,
                              ),
                            ],
                          ),
                        ),
                      ]));
            })));

  }

  Widget getList(){
    return new ScrollablePositionedList.builder(
      itemCount: itemCount,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemBuilder: itemBuilder,
    );
  }


  onPanDown(DragDownDetails details){
    Offset local = details.localPosition;
    print("local =${local}  posty = ${model.posY}  height=${model.height}");
    if(local.dy>model.posY&&local.dy<=model.posY+_scrollbarHeight){
      startDrag = true;
      model.paddingTop = local.dy-model.posY;
      startTimer();
    }
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
    var dragX = local.dy-model.paddingTop;
    if(dragX<=0)
      dragX = 0;
    else if(dragX>=model.height-_scrollbarHeight)
      dragX = model.height-_scrollbarHeight;
    if(startDrag){
      int pos = (dragX*maxLen/(model.height-_scrollbarHeight)).toInt();
      if(pos>=itemCount)
        pos = itemCount-1;
      var currentFirst = itemPositionsListener!.itemPositions.value.first.index;
      var lastPos = itemPositionsListener!.itemPositions.value.last.index;
      print("pos=${pos} first=${currentFirst}");
      if(currentFirst!=pos){
        itemScrollController?.jumpTo(index: pos);
        model.changePosY(dragX);
      }

    }
    currentTime = getCurrent();
  }


  void startTimer(){
    const period = const Duration(milliseconds: 50);
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

}

class SignaturePainter extends CustomPainter  {
  SignaturePainter(this.posX,this.posY,this.model,this.cWidth,this.cHeight);
  double cWidth = 10;  //clip square width
  double cHeight = 40;  //clip square height
  double posX;
  double posY;
  PositionChangeNotify model;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.bevel;
    model.height = size.height;
    model.width = size.width;

    if(posY>=size.height-cHeight) {
      posY = size.height-cHeight;
    }
    var rect = Rect.fromLTWH(posX,posY, cWidth, cHeight);
    var radis = cWidth/2;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radis)), paint);
  }
  @override
  bool shouldRepaint(SignaturePainter other){
    return true;
  }

}
