import 'package:flutter/cupertino.dart';

class FingerPosition {
  const FingerPosition({
    required this.offset,
    this.isBoxHovered = false,
  });

  final Offset offset;
  final bool isBoxHovered;

  FingerPosition copyWith({
    Offset? offset,
    bool? isBoxHovered,
  }) {
    return FingerPosition(
      offset: offset ?? this.offset,
      isBoxHovered: isBoxHovered ?? this.isBoxHovered,
    );
  }
}
