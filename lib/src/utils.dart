import 'dart:ui';

import 'package:flutter/material.dart';

class Utils {
  Utils._();

  static Offset getButtonOffset(GlobalKey globalKey) {
    final RenderBox containerRenderBox =
        globalKey.currentContext.findRenderObject();
    return containerRenderBox.localToGlobal(Offset.zero);
  }

  static Size getButtonSize(GlobalKey globalKey) {
    final RenderBox containerRenderBox =
        globalKey.currentContext.findRenderObject();
    return containerRenderBox.size;
  }

  static Size getScreenSize(BuildContext context) =>
      MediaQuery.of(context).size;
}
