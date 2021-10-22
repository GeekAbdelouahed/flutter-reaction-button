import 'package:flutter/cupertino.dart';

class DragData {
  final Offset offset;
  final bool isEnd;

  DragData({
    required this.offset,
    this.isEnd = false,
  });

  DragData copyWith({
    Offset? offset,
    bool? isEnd,
  }) {
    if (isEnd == null) isEnd = this.isEnd;
    return DragData(
      offset: offset ?? this.offset,
      isEnd: isEnd,
    );
  }
}
