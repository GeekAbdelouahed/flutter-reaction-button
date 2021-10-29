import 'package:flutter/widgets.dart';

extension KeyExtensions on GlobalKey {
  Offset get widgetOffset {
    final renderBox = this.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size get widgetSize {
    final renderBox = this.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  }
}

extension ContextExtensions on BuildContext {
  Size get screenSize {
    return MediaQuery.of(this).size;
  }
}
