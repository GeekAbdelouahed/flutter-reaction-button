import 'package:flutter/material.dart';
import 'reactions_position.dart';
import './reactions_box.dart';
import './reaction.dart';
import './utils.dart';

class FlutterReactionButton extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final Function(Reaction) onReactionChanged;

  /// Default reaction button widget
  final Reaction initialReaction;

  final List<Reaction> reactions;

  /// Position reactions box for the button [default = TOP]
  final Position position;

  /// Reactions box color [default = white]
  final Color color;

  /// Reactions box elevation [default = 5]
  final double elevation;

  /// Reactions box radius [default = 50]
  final double radius;

  /// Reactions box show/hide duration [default = 200 milliseconds]
  final Duration duration;

  FlutterReactionButton({
    Key key,
    @required this.onReactionChanged,
    @required this.reactions,
    this.initialReaction,
    this.position = Position.TOP,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
  })  : assert(reactions != null),
        super(key: key);

  @override
  _FlutterReactionButtonState createState() =>
      _FlutterReactionButtonState(initialReaction);
}

class _FlutterReactionButtonState extends State<FlutterReactionButton> {
  final GlobalKey _buttonKey = GlobalKey();

  Reaction _selectedReaction;

  _FlutterReactionButtonState(this._selectedReaction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: () => _showReactionButtons(context),
      child: (_selectedReaction ?? widget.reactions[0]).icon,
    );
  }

  void _showReactionButtons(BuildContext context) async {
    final buttonOffset = getButtonOffset(_buttonKey);
    final buttonSize = getButtonSize(_buttonKey);
    final reactionButton = await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, _, __) => ReactionsBox(
              buttonOffset: buttonOffset,
              buttonSize: buttonSize,
              reactions: widget.reactions,
              position: widget.position,
              color: widget.color,
              elevation: widget.elevation,
              radius: widget.radius,
              duration: widget.duration,
            )));
    if (reactionButton != null) {
      _updateReaction(reactionButton);
    }
  }

  void _updateReaction(Reaction reaction) {
    widget.onReactionChanged(reaction);
    setState(() {
      _selectedReaction = reaction;
    });
  }
}
