import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final Widget? title;
  final Size parentSize;
  final Offset parentOffset;

  const TitleWidget({
    Key? key,
    required this.title,
    required this.parentSize,
    required this.parentOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: parentOffset.dx,
      top: parentOffset.dy - parentSize.height * .5,
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: title ?? const SizedBox(),
      ),
    );
  }
}
