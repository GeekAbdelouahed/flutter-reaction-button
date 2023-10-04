import 'package:flutter/cupertino.dart';

class PositionData {
  const PositionData({
    required this.offset,
    this.isBoxHovered = false,
  });

  final Offset offset;
  final bool isBoxHovered;

  const PositionData.init()
      : offset = Offset.zero,
        isBoxHovered = false;

  PositionData copyWith({
    Offset? offset,
    bool? isBoxHovered,
  }) {
    return PositionData(
      offset: offset ?? this.offset,
      isBoxHovered: isBoxHovered ?? this.isBoxHovered,
    );
  }
}
