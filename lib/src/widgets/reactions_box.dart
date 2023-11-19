import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button/src/common/position.dart';
import 'package:flutter_reaction_button/src/common/position_notifier.dart';
import 'package:flutter_reaction_button/src/widgets/reactions_box_item.dart';

class ReactionsBox<T> extends StatefulWidget {
  const ReactionsBox({
    super.key,
    required this.offset,
    required this.itemSize,
    required this.reactions,
    required this.color,
    required this.elevation,
    required this.radius,
    required this.boxDuration,
    required this.boxPadding,
    required this.itemSpace,
    required this.itemScale,
    required this.itemScaleDuration,
    required this.onReactionSelected,
    required this.onClose,
    required this.animateBox,
    this.direction = ReactionsBoxAlignment.ltr,
  }) : assert(itemScale > 0.0 && itemScale < 1);

  final Offset offset;

  final Size itemSize;

  final List<Reaction<T>?> reactions;

  final Color color;

  final double elevation;

  final double radius;

  final Duration boxDuration;

  final EdgeInsetsGeometry boxPadding;

  final double itemSpace;

  final double itemScale;

  final Duration itemScaleDuration;

  final ValueChanged<Reaction<T>?> onReactionSelected;

  final VoidCallback onClose;

  final bool animateBox;

  final ReactionsBoxAlignment direction;

  @override
  State<ReactionsBox<T>> createState() => _ReactionsBoxState<T>();
}

class _ReactionsBoxState<T> extends State<ReactionsBox<T>>
    with SingleTickerProviderStateMixin {
  final PositionNotifier _positionNotifier = PositionNotifier();

  late final AnimationController _boxAnimationController = AnimationController(
    vsync: this,
    duration: widget.animateBox ? widget.boxDuration : Duration.zero,
  );

  late final Animation _animation;

  double get _boxHeight => widget.itemSize.height + widget.boxPadding.vertical;

  double get _boxWidth =>
      (widget.itemSize.width * widget.reactions.length) +
      (widget.itemSpace * (widget.reactions.length - 1)) +
      widget.boxPadding.horizontal;

  bool get _isWidthOverflow => widget.direction == ReactionsBoxAlignment.ltr
      ? widget.offset.dx + _boxWidth > MediaQuery.sizeOf(context).width
      : widget.offset.dx - _boxWidth < 0;

  bool get _shouldStartFromBottom =>
      widget.offset.dy - _boxHeight - widget.boxPadding.vertical < 0;

  void _checkIsOffsetOutsideBox(Offset offset) {
    final Rect boxRect = Rect.fromLTWH(0, 0, _boxWidth, _boxHeight);
    if (!boxRect.contains(offset)) {
      widget.onClose();
    }
  }

  @override
  void initState() {
    super.initState();
    final Tween tween = IntTween(begin: 0, end: widget.reactions.length);
    _animation = tween.animate(_boxAnimationController);
    _boxAnimationController.forward();
  }

  @override
  void dispose() {
    _positionNotifier.dispose();
    _boxAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PositionData?>(
      valueListenable: _positionNotifier,
      builder: (context, fingerPosition, child) {
        final bool isBoxHovered = fingerPosition?.isBoxHovered ?? false;
        final double boxScale =
            1 - (widget.itemScale / widget.reactions.length);

        final double widthOverflow;
        if (_isWidthOverflow) {
          widthOverflow = widget.direction == ReactionsBoxAlignment.ltr
              ? widget.offset.dx + _boxWidth - MediaQuery.sizeOf(context).width
              : _boxWidth;
        } else {
          widthOverflow = 0;
        }

        final double start = widget.direction == ReactionsBoxAlignment.ltr
            ? widget.offset.dx - widthOverflow
            : widget.offset.dx - _boxWidth + widthOverflow;

        final double top = widget.offset.dy -
            widget.boxPadding.vertical +
            (_shouldStartFromBottom ? 1 : -1) * widget.itemSize.height;

        return Stack(
          children: [
            Positioned.fill(
              child: Listener(
                onPointerDown: (_) {
                  widget.onClose();
                },
                child: Container(
                  key: const ValueKey('outside'),
                  color: Colors.transparent,
                ),
              ),
            ),
            PositionedDirectional(
              start: start,
              top: top,
              child: Listener(
                onPointerDown: (point) {
                  _positionNotifier.value = PositionData(
                    offset: point.localPosition,
                    isBoxHovered: true,
                  );
                },
                onPointerMove: (point) {
                  _positionNotifier.value = _positionNotifier.value.copyWith(
                    offset: point.localPosition,
                    isBoxHovered: true,
                  );
                },
                onPointerUp: (point) {
                  _positionNotifier.value = _positionNotifier.value.copyWith(
                    isBoxHovered: false,
                  );
                  _checkIsOffsetOutsideBox(point.localPosition);
                },
                onPointerCancel: (point) {
                  _positionNotifier.value = _positionNotifier.value.copyWith(
                    isBoxHovered: false,
                  );
                  _checkIsOffsetOutsideBox(point.localPosition);
                },
                child: Transform.scale(
                  scale: isBoxHovered ? boxScale : 1,
                  child: child!,
                ),
              ),
            ),
          ],
        );
      },
      child: Material(
        color: widget.color,
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.radius,
          ),
        ),
        child: Container(
          width: _boxWidth,
          height: _boxHeight,
          padding: widget.boxPadding,
          child: Row(
            children: [
              for (int index = 0; index < widget.reactions.length; index++) ...[
                if (index > 0) ...{
                  SizedBox(
                    width: widget.itemSpace,
                  ),
                },
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return AnimatedScale(
                      duration: widget.boxDuration,
                      scale: _animation.value > index ? 1 : 0,
                      child: child,
                    );
                  },
                  child: ReactionsBoxItem<T>(
                    index: index,
                    fingerPositionNotifier: _positionNotifier,
                    reaction: widget.reactions[index]!,
                    size: widget.itemSize,
                    scale: widget.itemScale,
                    space: widget.itemSpace,
                    animationDuration: widget.itemScaleDuration,
                    onReactionSelected: (reaction) {
                      widget.onReactionSelected(reaction);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
