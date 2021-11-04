import 'dart:async';

import 'package:flutter/material.dart';

import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box.dart';

class ReactionContainer<T> extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final void Function(T?) onReactionChanged;

  /// Previous selected reaction widget
  final Reaction<T>? selectedReaction;

  final List<Reaction<T>?> reactions;

  /// Position reactions box for the button [default = TOP]
  final Position boxPosition;

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
    this.boxPosition = Position.TOP,
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
  _ReactionContainerState createState() => _ReactionContainerState<T>();
}

class _ReactionContainerState<T> extends State<ReactionContainer<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: _buttonKey,
      onPointerDown: (_) {
        _onTapReactionButton();
      },
      onPointerUp: (_) {
        if (_timer?.isActive ?? false) {
          _timer?.cancel();
          _timer = null;
        }
      },
      child: widget.child,
    );
  }

  void _onTapReactionButton() {
    if (_timer != null) return;
    _timer = Timer(Duration(milliseconds: 100), () {
      _timer = null;
      _showReactionsBox();
    });
  }

  void _showReactionsBox() async {
    final buttonOffset = _buttonKey.widgetPositionOffset;
    final buttonSize = _buttonKey.widgetSize;
    final reactionButton = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return ReactionsBox(
            buttonOffset: buttonOffset,
            buttonSize: buttonSize,
            reactions: widget.reactions,
            position: widget.boxPosition,
            color: widget.boxColor,
            elevation: widget.boxElevation,
            radius: widget.boxRadius,
            duration: widget.boxDuration,
            boxPadding: widget.boxPadding,
            itemScale: widget.itemScale,
            itemScaleDuration: widget.itemScaleDuration,
          );
        },
      ),
    );

    if (reactionButton != null)
      widget.onReactionChanged.call(reactionButton.value);
  }
}
