import 'package:flutter/material.dart';

import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box.dart';

class FlutterReactionButton<T> extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final void Function(T?) onReactionChanged;

  /// Default reaction button widget
  final Reaction<T>? initialReaction;

  final List<Reaction<T>> reactions;

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

  /// Reactions box alignment [default = Alignment.center]
  final AlignmentGeometry boxAlignment;

  /// Change initial reaction after selected one [default = true]
  final bool shouldChangeReaction;

  final EdgeInsets boxPadding;

  FlutterReactionButton({
    Key? key,
    required this.onReactionChanged,
    required this.reactions,
    this.initialReaction,
    this.boxPosition = Position.TOP,
    this.boxColor = Colors.white,
    this.boxElevation = 5,
    this.boxRadius = 50,
    this.boxDuration = const Duration(milliseconds: 200),
    this.boxAlignment = Alignment.center,
    this.shouldChangeReaction = true,
    this.boxPadding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  _FlutterReactionButtonState createState() => _FlutterReactionButtonState<T>();
}

class _FlutterReactionButtonState<T> extends State<FlutterReactionButton<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  Reaction? _selectedReaction;

  void _init() {
    _selectedReaction = widget.initialReaction;
  }

  @override
  void didUpdateWidget(FlutterReactionButton<T> oldWidget) {
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
      onTap: () {
        _showReactionButtons(context);
      },
      child: (_selectedReaction ?? widget.reactions[0]).icon,
    );
  }

  void _showReactionButtons(BuildContext context) async {
    final buttonOffset = _buttonKey.widgetOffset;
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
