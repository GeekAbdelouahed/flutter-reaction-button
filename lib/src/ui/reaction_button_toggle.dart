import 'dart:async';

import 'package:flutter/material.dart';

import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box.dart';

class ReactionButtonToggle<T> extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final void Function(T?, bool) onReactionChanged;

  /// Default reaction button widget if [isChecked == false]
  final Reaction<T>? initialReaction;

  /// Default reaction button widget if [isChecked == true]
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

  /// Flag for pre-set reactions if true @link selectedReaction will be
  /// displayed else @link initialReaction will be displayed [default = false]
  final bool isChecked;

  /// Reactions box padding [default = const EdgeInsets.all(0)]
  final EdgeInsets boxPadding;

  /// Scale ratio when item hovered [default = 0.3]
  final double itemScale;

  /// Scale duration while dragging [default = const Duration(milliseconds: 100)]
  final Duration? itemScaleDuration;

  ReactionButtonToggle({
    Key? key,
    required this.onReactionChanged,
    required this.reactions,
    this.initialReaction,
    this.selectedReaction,
    this.boxPosition = Position.TOP,
    this.boxColor = Colors.white,
    this.boxElevation = 5,
    this.boxRadius = 50,
    this.boxDuration = const Duration(milliseconds: 200),
    this.isChecked = false,
    this.boxPadding = const EdgeInsets.all(0),
    this.itemScale = .3,
    this.itemScaleDuration,
  }) : super(key: key);

  @override
  _ReactionButtonToggleState createState() => _ReactionButtonToggleState<T>();
}

class _ReactionButtonToggleState<T> extends State<ReactionButtonToggle<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  Reaction<T>? _selectedReaction;

  Timer? _timer;

  bool _isChecked = false;

  void _init() {
    _isChecked = widget.isChecked;
    _selectedReaction =
        _isChecked ? widget.selectedReaction : widget.initialReaction;
  }

  @override
  void didUpdateWidget(ReactionButtonToggle<T> oldWidget) {
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
    return Listener(
      key: _buttonKey,
      onPointerDown: (_) {
        _onTapReactionButton();
      },
      onPointerUp: (_) {
        if (_timer?.isActive ?? false) {
          _timer?.cancel();
          _timer = null;
          _onClickReactionButton();
        }
      },
      child: (_selectedReaction ?? widget.reactions[0])!.icon,
    );
  }

  void _onTapReactionButton() {
    if (_timer != null) return;
    _timer = Timer(Duration(milliseconds: 100), () {
      _timer = null;
      _showReactionsBox();
    });
  }

  void _onClickReactionButton() {
    _isChecked = !_isChecked;
    _updateReaction(
      _isChecked
          ? widget.selectedReaction ?? widget.reactions[0]
          : widget.initialReaction,
    );
  }

  void _showReactionsBox() async {
    final buttonOffset = _buttonKey.widgetPosition;
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

    if (reactionButton != null) _updateReaction(reactionButton, true);
  }

  void _updateReaction(
    Reaction<T>? reaction, [
    bool isSelectedFromDialog = false,
  ]) {
    _isChecked =
        isSelectedFromDialog ? true : reaction != widget.initialReaction;
    widget.onReactionChanged.call(
      reaction?.value,
      _isChecked,
    );
    setState(() {
      _selectedReaction = reaction;
    });
  }
}
