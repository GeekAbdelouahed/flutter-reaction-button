import 'dart:ui';

import 'package:flutter/material.dart';

Offset getButtonOffset(GlobalKey globalKey) {
  final RenderBox containerRenderBox =
      globalKey.currentContext.findRenderObject();
  return containerRenderBox.localToGlobal(Offset.zero);
}

Size getButtonSize(GlobalKey globalKey) {
  final RenderBox containerRenderBox =
      globalKey.currentContext.findRenderObject();
  return containerRenderBox.size;
}

Size getScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}
