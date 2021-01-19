import 'package:flutter/material.dart';

class Reaction {
  /// Widget showing as button after selecting preview Icon from box appear.
  final Widget icon;

  /// Widget showing when reactions box appear.
  ///
  /// If it's null will replace by [icon].
  final Widget previewIcon;

  /// Widget that describes the action that will occur when the button is pressed.
  ///
  ///This widget is displayed when the user hover on the button.
  final Widget title;

  final bool enabled;

  Reaction({
    @required this.icon,
    Widget previewIcon,
    this.title,
    this.enabled = true,
  })  : this.previewIcon = previewIcon ?? icon,
        assert(icon != null);

  @override
  bool operator ==(Object object) =>
      object != null &&
      object is Reaction &&
      icon == object.icon &&
      icon.key == object.icon.key &&
      previewIcon == object.previewIcon &&
      previewIcon?.key == object.previewIcon?.key &&
      title == object.title &&
      title?.key == object.title?.key;

  @override
  int get hashCode => hashValues(icon, previewIcon, title);
}
