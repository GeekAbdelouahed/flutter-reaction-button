import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'reactions_position.dart';
import 'reactions_box.dart';
import 'reaction.dart';
import 'utils.dart';

class FlutterReactionButtonCheck extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final Function(Reaction, int, bool) onReactionChanged;

  /// Default reaction button widget if [isChecked == false]
  final Reaction initialReaction;

  /// Default reaction button widget if [isChecked == true]
  final Reaction selectedReaction;

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

  FlutterReactionButtonCheck({
    Key key,
    @required this.onReactionChanged,
    @required this.reactions,
    this.initialReaction,
    this.selectedReaction,
    this.position = Position.TOP,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
  })  : assert(reactions != null),
        super(key: key);

  @override
  _FlutterReactionButtonCheckState createState() =>
      _FlutterReactionButtonCheckState();
}

class _FlutterReactionButtonCheckState
    extends State<FlutterReactionButtonCheck> {
  final GlobalKey _buttonKey = GlobalKey();

  final int _maxTick = 2;

  Timer _timer;

  Reaction _selectedReaction;

  bool _isChecked = false;

  _FlutterReactionButtonCheckState();

  @override
  void initState() {
    super.initState();
    _selectedReaction = widget.initialReaction;
  }

  @override
  Widget build(BuildContext context) => InkWell(
        key: _buttonKey,
        onTap: () {
          _onClickReactionButton();
        },
        onLongPress: () {
          _onTapReactionButton(context);
        },
        child: (_selectedReaction ?? widget.reactions[0]).icon,
      );

  void _onTapReactionButton(BuildContext context) {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_timer.tick >= _maxTick) {
        _showReactionButtons(context);
        _timer.cancel();
      }
      return _timer;
    });
  }

  void _onClickReactionButton() {
    _isChecked = !_isChecked;
    _updateReaction(
      _isChecked
          ? (widget.selectedReaction ?? widget.reactions[0])
          : widget.initialReaction,
    );
  }

  void _showReactionButtons(BuildContext context) async {
    final buttonOffset = getButtonOffset(_buttonKey);
    final buttonSize = getButtonSize(_buttonKey);
    final reactionButton = await Navigator.of(context).push(
      PageRouteBuilder(
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
        ),
      ),
    );
    if (reactionButton != null) {
      _updateReaction(reactionButton, true);
    }
  }

  void _updateReaction(Reaction reaction, [bool isSelectedFromDialog = false]) {
    _isChecked =
        isSelectedFromDialog ? true : !reaction.equals(widget.initialReaction);
    final selectedIndex = widget.reactions.indexOf(reaction);
    widget.onReactionChanged(reaction, selectedIndex, _isChecked);
    setState(() {
      _selectedReaction = reaction;
    });
  }
}
