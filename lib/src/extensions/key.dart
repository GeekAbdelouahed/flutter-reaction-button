import 'package:flutter/widgets.dart';

extension GlobalKeyExtensions on GlobalKey {
  Offset get offset {
    final renderBox = currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}
