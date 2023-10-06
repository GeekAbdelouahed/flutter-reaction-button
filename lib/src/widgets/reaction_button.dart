import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button/src/enums/reaction.dart';
import 'package:flutter_reaction_button/src/extensions/key.dart';
import 'package:flutter_reaction_button/src/widgets/reactions_box.dart';

class ReactionButton<T> extends StatefulWidget {
  const ReactionButton({
    super.key,
    required this.onReactionChanged,
    required this.reactions,
    this.placeholder,
    this.selectedReaction,
    this.boxOffset = Offset.zero,
    this.boxPosition = VerticalPosition.top,
    this.boxHorizontalPosition = HorizontalPosition.start,
    this.boxColor = Colors.white,
    this.boxElevation = 5,
    this.boxRadius = 50,
    this.boxDuration = const Duration(milliseconds: 200),
    this.isChecked = false,
    this.boxPadding = const EdgeInsets.all(4),
    this.boxReactionSpacing = 8,
    this.itemScale = .3,
    this.itemScaleDuration = const Duration(milliseconds: 100),
    required this.itemSize,
    this.animateBox = true,
    this.toggle = true,
    this.child,
  }) : _type = child != null ? ReactionType.container : ReactionType.button;

  /// This triggers when reaction button value changed.
  final ValueChanged<T?> onReactionChanged;

  /// Default widget when [isChecked == false]
  final Reaction<T>? placeholder;

  /// Default reaction button widget when [isChecked == true]
  final Reaction<T>? selectedReaction;

  final List<Reaction<T>?> reactions;

  /// Offset to add to the placement of the box
  final Offset boxOffset;

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

  /// Reactions box visibility duration [default = 200 milliseconds]
  final Duration boxDuration;

  /// Flag for pre-set reactions if true @link selectedReaction will be
  /// displayed else @link initialReaction will be displayed [default = false]
  final bool isChecked;

  /// Reactions box padding [default = const EdgeInsets.all(0)]
  final EdgeInsetsGeometry boxPadding;

  /// Spacing between the reaction icons in the box
  final double boxReactionSpacing;

  /// Scale ratio when item hovered [default = 0.3]
  final double itemScale;

  /// Scale duration while dragging [default = const Duration(milliseconds: 100)]
  final Duration itemScaleDuration;

  final Size itemSize;

  final bool animateBox;

  final bool toggle;

  final Widget? child;

  final ReactionType _type;

  @override
  State<ReactionButton<T>> createState() => _ReactionButtonState<T>();
}

class _ReactionButtonState<T> extends State<ReactionButton<T>> {
  final GlobalKey _globalKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  late Reaction<T>? _selectedReaction =
      _isChecked ? widget.selectedReaction : widget.placeholder;

  late bool _isChecked = widget.isChecked;

  Timer? _hoverTimer;

  bool get _isContainer => widget._type == ReactionType.container;

  void _onHover(Offset offset) {
    _hoverTimer?.cancel();
    _hoverTimer = Timer(
      const Duration(milliseconds: 400),
      () {
        _onShowReactionsBox(offset);
      },
    );
  }

  void _onCheck() {
    _hoverTimer?.cancel();
    _isChecked = !_isChecked;
    _updateReaction(
      _isChecked
          ? widget.selectedReaction ?? widget.reactions.first
          : widget.placeholder,
    );
  }

  void _onShowReactionsBox([Offset? offset]) {
    _hoverTimer?.cancel();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return ReactionsBox<T>(
          buttonOffset: offset ?? _globalKey.offset,
          itemSize: widget.itemSize,
          reactions: widget.reactions,
          verticalPosition: widget.boxPosition,
          horizontalPosition: widget.boxHorizontalPosition,
          color: widget.boxColor,
          elevation: widget.boxElevation,
          radius: widget.boxRadius,
          offset: widget.boxOffset,
          boxDuration: widget.boxDuration,
          boxPadding: widget.boxPadding,
          itemSpace: widget.boxReactionSpacing,
          itemScale: widget.itemScale,
          itemScaleDuration: widget.itemScaleDuration,
          animateBox: widget.animateBox,
          onReactionSelected: (reaction) {
            _updateReaction(reaction);
            _disposeOverlayEntry();
          },
          onClose: () {
            _disposeOverlayEntry();
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateReaction(Reaction<T>? reaction) {
    _isChecked = reaction != widget.placeholder;
    widget.onReactionChanged.call(reaction?.value);
    setState(() {
      _selectedReaction = reaction;
    });
  }

  void _disposeOverlayEntry() {
    if (_overlayEntry == null) {
      return;
    }
    _overlayEntry
      ?..remove()
      ..dispose();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _disposeOverlayEntry();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (details) {
        if (!_isContainer) {
          _onHover(details.position);
        }
      },
      onExit: (details) {
        _hoverTimer?.cancel();
      },
      child: GestureDetector(
        key: _globalKey,
        onTap: () {
          widget.toggle ? _onCheck() : _onShowReactionsBox();
        },
        onLongPressStart: (details) {
          widget.toggle
              ? _onShowReactionsBox(
                  _isContainer ? details.globalPosition : null)
              : null;
        },
        child: _isContainer
            ? widget.child
            : (_selectedReaction ?? widget.reactions.first)!.icon,
      ),
    );
  }
}
