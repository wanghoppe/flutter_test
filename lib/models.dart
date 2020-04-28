
import 'package:flutter/cupertino.dart';

class LoadModel extends ChangeNotifier{
  var finished = false;

  void finish(){
    finished = true;
    notifyListeners();
  }
  void start(){
    finished = false;
    notifyListeners();
  }
}