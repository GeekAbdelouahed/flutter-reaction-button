import 'package:flutter/material.dart';

class Reaction<T> {
  /// Widget showing as button after selecting preview Icon from box appear.
  final Widget icon;

  /// Widget showing when reactions box appear.
  ///
  /// If it's null will replace by [icon].
  final Widget previewIcon;

  /// Widget that describes the action that will occur when the button is pressed.
  ///
  ///This widget is displayed when the user hover on the button.
  final Widget? title;

  final bool enabled;

  final T? value;

  Reaction({
    required this.icon,
    required this.value,
    Widget? previewIcon,
    this.title,
    this.enabled = true,
  }) : previewIcon = previewIcon ?? icon;

  @override
  bool operator ==(Object? other) {
    return other is Reaction &&
        icon == other.icon &&
        icon.key == other.icon.key &&
        previewIcon == other.previewIcon &&
        previewIcon.key == other.previewIcon.key &&
        title == other.title &&
        title?.key == other.title?.key;
  }

  @override
  int get hashCode {
    return Object.hash(icon, previewIcon, title);
  }
}
