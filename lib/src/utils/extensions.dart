import 'package:flutter/widgets.dart';

extension KeyExtensions on GlobalKey {
  Offset get widgetOffset {
    final RenderBox containerRenderBox =
        this.currentContext!.findRenderObject() as RenderBox;
    return containerRenderBox.localToGlobal(Offset.zero);
  }

  Size get widgetSize {
    final RenderBox containerRenderBox =
        this.currentContext!.findRenderObject() as RenderBox;
    return containerRenderBox.size;
  }
}

extension ContextExtensions on BuildContext {
  Size get screenSize {
    return MediaQuery.of(this).size;
  }
}
