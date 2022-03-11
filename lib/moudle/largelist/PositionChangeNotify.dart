

import 'package:flutter/cupertino.dart';

class PositionChangeNotify extends ChangeNotifier{

  double posX = 0;
  double posY =0;

  void changePosY(double posY){
    this.posY = posY;
    notifyListeners();
  }
}