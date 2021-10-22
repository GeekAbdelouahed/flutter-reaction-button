import 'package:flutter/cupertino.dart';

class DragData {
  final Offset offset;
  final bool isDragEnd;

  DragData({
    required this.offset,
    this.isDragEnd = false,
  });

  DragData copyWith({
    Offset? offset,
    bool? isDragEnd,
  }) {
    if (isDragEnd == null) isDragEnd = this.isDragEnd;
    return DragData(
      offset: offset ?? this.offset,
      isDragEnd: isDragEnd,
    );
  }
}
