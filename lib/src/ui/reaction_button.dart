import 'package:flutter/material.dart';

import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box.dart';

class ReactionButton<T> extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final void Function(T?) onReactionChanged;

  /// Default reaction button widget
  final Reaction<T>? initialReaction;

  final List<Reaction<T>> reactions;

  /// Position reactions box according to the button [default = Position.TOP]
  final Position boxPosition;

  /// Reactions box color [default = white]
  final Color boxColor;

  /// Reactions box elevation [default = 5]
  final double boxElevation;

  /// Reactions box radius [default = 50]
  final double boxRadius;

  /// Reactions box show/hide duration [default = 200 milliseconds]
  final Duration boxDuration;

  /// Change initial reaction after selected one [default = true]
  final bool shouldChangeReaction;

  /// Reactions box padding [default = const EdgeInsets.all(0)]
  final EdgeInsets boxPadding;

  /// Scale ratio when item hovered [default = 0.3]
  final double itemScale;

  /// Scale duration while dragging [default = const Duration(milliseconds: 100)]
  final Duration? itemScaleDuration;

  ReactionButton({
    Key? key,
    required this.onReactionChanged,
    required this.reactions,
    this.initialReaction,
    this.boxPosition = Position.TOP,
    this.boxColor = Colors.white,
    this.boxElevation = 5,
    this.boxRadius = 50,
    this.boxDuration = const Duration(milliseconds: 200),
    this.shouldChangeReaction = true,
    this.boxPadding = const EdgeInsets.all(0),
    this.itemScale = .3,
    this.itemScaleDuration,
  }) : super(key: key);

  @override
  _ReactionButtonState createState() => _ReactionButtonState<T>();
}

class _ReactionButtonState<T> extends State<ReactionButton<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  Reaction? _selectedReaction;

  void _init() {
    _selectedReaction = widget.initialReaction;
  }

  @override
  void didUpdateWidget(ReactionButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _buttonKey,
      onTap: _showReactionsBox,
      child: (_selectedReaction ?? widget.reactions[0]).icon,
    );
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

    if (reactionButton != null) _updateReaction(reactionButton);
  }

  void _updateReaction(Reaction<T> reaction) {
    widget.onReactionChanged.call(reaction.value);
    if (widget.shouldChangeReaction)
      setState(() {
        _selectedReaction = reaction;
      });
  }
}
