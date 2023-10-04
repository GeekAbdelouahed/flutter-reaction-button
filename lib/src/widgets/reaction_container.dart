import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button/src/widgets/reactions_box.dart';

class ReactionContainer<T> extends StatefulWidget {
  const ReactionContainer({
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
    this.animateBox = true,
    required this.child,
  });

  /// This triggers when reaction button value changed.
  final ValueChanged<T?> onReactionChanged;

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

  final Widget child;

  @override
  State<ReactionContainer<T>> createState() => _ReactionContainerState<T>();
}

class _ReactionContainerState<T> extends State<ReactionContainer<T>> {
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayState?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        _onLongPress(details.globalPosition);
      },
      child: widget.child,
    );
  }

  void _onLongPress(Offset offset) {
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return ReactionsBox<T>(
          buttonOffset: offset,
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
            widget.onReactionChanged.call(reaction?.value);
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
}
