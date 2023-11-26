import 'package:flutter/widgets.dart';

extension GlobalKeyExtensions on GlobalKey {
  Offset get offset {
    final RenderBox renderBox = currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}
