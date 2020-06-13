import 'package:flutter/widgets.dart';

extension KeyExtensions on GlobalKey {
  Offset getButtonOffset() {
    final RenderBox containerRenderBox = this.currentContext.findRenderObject();
    return containerRenderBox.localToGlobal(Offset.zero);
  }

  Size getButtonSize() {
    final RenderBox containerRenderBox = this.currentContext.findRenderObject();
    return containerRenderBox.size;
  }
}

extension ContextExtensions on BuildContext {
  Size getScreenSize() => MediaQuery.of(this).size;
}
