import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/src/utils/extensions.dart';

import '../models/reaction.dart';
import '../utils/reactions_position.dart';
import 'reactions_box.dart';

typedef OnReactionToggleChanged<T> = void Function(T?, bool);

class ReactionButtonToggle<T> extends StatefulWidget {
  const ReactionButtonToggle({
    super.key,
    required this.onReactionChanged,
    required this.reactions,
    this.initialReaction,
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
  });

  /// This triggers when reaction button value changed.
  final OnReactionToggleChanged<T> onReactionChanged;

  /// Default reaction button widget if [isChecked == false]
  final Reaction<T>? initialReaction;

  /// Default reaction button widget if [isChecked == true]
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

  /// Reactions box show/hide duration [default = 200 milliseconds]
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

  @override
  State<ReactionButtonToggle<T>> createState() =>
      _ReactionButtonToggleState<T>();
}

class _ReactionButtonToggleState<T> extends State<ReactionButtonToggle<T>> {
  final GlobalKey _globalKey = GlobalKey();

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  Reaction<T>? _selectedReaction;

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
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      behavior: HitTestBehavior.translucent,
      onTap: _onClickReactionButton,
      onLongPress: _showReactionsBox,
      child: (_selectedReaction ?? widget.reactions[0])!.icon,
    );
  }

  void _onClickReactionButton() {
    _isChecked = !_isChecked;
    _updateReaction(
      _isChecked
          ? widget.selectedReaction ?? widget.reactions.first
          : widget.initialReaction,
    );
  }

  void _showReactionsBox() {
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return ReactionsBox<T>(
          buttonOffset: _globalKey.offset,
          itemSize: widget.itemSize,
          reactions: widget.reactions,
          verticalPosition: widget.boxPosition,
          horizontalPosition: widget.boxHorizontalPosition,
          color: widget.boxColor,
          elevation: widget.boxElevation,
          radius: widget.boxRadius,
          offset: widget.boxOffset,
          duration: widget.boxDuration,
          boxPadding: widget.boxPadding,
          itemSpace: widget.boxReactionSpacing,
          itemScale: widget.itemScale,
          itemScaleDuration: widget.itemScaleDuration,
          onReactionSelected: (reaction) {
            _updateReaction(reaction);
            _overlayEntry?.remove();
          },
          onClose: () {
            _overlayEntry?.remove();
          },
        );
      },
    );

    _overlayState!.insert(_overlayEntry!);
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
