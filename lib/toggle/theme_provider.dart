import 'package:currency_converter/toggle/theme_data.dart';
import 'package:flutter/material.dart';



class ThemeProvider with ChangeNotifier{

bool _isSelect=false;
bool get isSelect=>_isSelect;

  ThemeData _themeData=lightmode;
  ThemeData get themeData=>_themeData;

  void toggle(){
    if(_themeData==lightmode)
    {
      _themeData=darkmode;
    }
    else{
      _themeData=lightmode;
    }
    _isSelect=!_isSelect;

    notifyListeners();
  }

}