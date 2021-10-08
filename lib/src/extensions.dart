import 'package:flutter/widgets.dart';

extension KeyExtensions on GlobalKey {
  Offset get buttonOffset {
    final RenderBox containerRenderBox = this.currentContext!.findRenderObject() as RenderBox;
    return containerRenderBox.localToGlobal(Offset.zero);
  }

  Size get buttonSize {
    final RenderBox containerRenderBox = this.currentContext!.findRenderObject() as RenderBox;
    return containerRenderBox.size;
  }
}

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}
