import 'package:flutter/material.dart';

class Reaction {
  /// Widget showing when reactions box appear.
  ///
  /// If it's null will replace by [icon].
  Widget previewIcon;

  /// Widget showing as button after selecting preview Icon from box appear.
  final Widget icon;

  Reaction({this.previewIcon, @required this.icon}) {
    assert(icon != null);
    this.previewIcon = previewIcon ?? this.icon;
  }

  bool equals(Reaction object) {
    if (object == null) return false;
    return hashCode == object.hashCode;
  }
}
