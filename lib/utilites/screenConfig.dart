import 'package:flutter/widgets.dart';

class SizeConfig {
  static double? _screenWidth;
  static double? _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double? textMultiplier;
  static double? widthMultiplier;
  static double? heightMultiplier;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    _blockSizeHorizontal = _screenWidth! / 100;
    _blockSizeVertical = _screenHeight! / 100;

    textMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;

    print(_blockSizeVertical);
    print(_blockSizeHorizontal);
  }
}
