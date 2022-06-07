import 'package:flutter/material.dart';

import '../models/reaction.dart';
import '../utils/reactions_position.dart';
import 'reactions_box.dart';

class ReactionContainer<T> extends StatelessWidget {
  /// This triggers when reaction button value changed.
  final void Function(T?) onReactionChanged;

  /// Previous selected reaction widget
  final Reaction<T>? selectedReaction;

  final List<Reaction<T>?> reactions;

  /// Vertical position of the reactions box relative to the button [default = VerticalPosition.TOP]
  final VerticalPosition boxPosition;

  /// Horizontal position of the reactions box relative to the button [default = HorizontalPosition.START]
  final HorizontalPosition boxHorizontalPosition;

  /// Reactions box color [default = white]
  final Color boxColor;

  /// Reactions box elevation [default = 5]
  final double boxElevation;

  /// Reactions box radius [default = 50]
  final double boxRadius;

  /// Reactions box show/hide duration [default = 200 milliseconds]
  final Duration boxDuration;

  /// Reactions box padding [default = const EdgeInsets.all(0)]
  final EdgeInsets boxPadding;

  /// Scale ratio when item hovered [default = 0.3]
  final double itemScale;

  /// Scale duration while dragging [default = const Duration(milliseconds: 100)]
  final Duration? itemScaleDuration;

  final Widget child;

  ReactionContainer({
    Key? key,
    required this.onReactionChanged,
    required this.reactions,
    this.selectedReaction,
    this.boxPosition = VerticalPosition.TOP,
    this.boxHorizontalPosition = HorizontalPosition.START,
    this.boxColor = Colors.white,
    this.boxElevation = 5,
    this.boxRadius = 50,
    this.boxDuration = const Duration(milliseconds: 200),
    this.boxPadding = const EdgeInsets.all(0),
    this.itemScale = .3,
    this.itemScaleDuration,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (details) => _showReactionsBox(context, details.globalPosition),
      child: child,
    );
  }

  void _showReactionsBox(BuildContext context, Offset buttonOffset) async {
    final reactionButton = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return ReactionsBox(
            buttonOffset: buttonOffset,
            buttonSize: Size.zero,
            reactions: reactions,
            verticalPosition: boxPosition,
            horizontalPosition: boxHorizontalPosition,
            color: boxColor,
            elevation: boxElevation,
            radius: boxRadius,
            duration: boxDuration,
            boxPadding: boxPadding,
            itemScale: itemScale,
            itemScaleDuration: itemScaleDuration,
          );
        },
      ),
    );

    if (reactionButton != null) onReactionChanged.call(reactionButton.value);
  }
}
