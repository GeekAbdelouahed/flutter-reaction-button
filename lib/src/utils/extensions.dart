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

  Offset get widgetPosition {
    final renderBox = currentContext?.findRenderObject();
    var translation = renderBox?.getTransformTo(null).getTranslation();
    if (renderBox != null && translation != null) {
      return renderBox.paintBounds
          .shift(Offset(translation.x, translation.y))
          .center;
    } else {
      return widgetOffset;
    }
  }
}

extension ContextExtensions on BuildContext {
  Size get screenSize {
    return MediaQuery.of(this).size;
  }
}
