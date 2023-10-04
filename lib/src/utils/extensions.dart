import 'package:flutter/widgets.dart';

extension KeyExtensions on GlobalKey {
  Offset get offset {
    final renderBox = currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size get size {
    final renderBox = currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  Rect? get rect {
    final RenderObject? renderBox = currentContext?.findRenderObject();
    // print('renderBox: $renderBox');
    final translation = renderBox?.getTransformTo(null).getTranslation();
    return renderBox?.paintBounds
        .shift(Offset(translation?.x ?? 0, translation?.y ?? 0));
  }
}

extension ContextExtensions on BuildContext {
  Size get screenSize {
    return MediaQuery.of(this).size;
  }
}
