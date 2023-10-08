import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button/src/common/position.dart';
import 'package:flutter_reaction_button/src/common/position_notifier.dart';
import 'package:flutter_reaction_button/src/widgets/reactions_box_item.dart';

class ReactionsBox<T> extends StatefulWidget {
  const ReactionsBox({
    super.key,
    required this.buttonOffset,
    required this.itemSize,
    required this.reactions,
    required this.color,
    required this.elevation,
    required this.radius,
    required this.offset,
    required this.boxDuration,
    required this.boxPadding,
    required this.itemSpace,
    required this.itemScale,
    required this.itemScaleDuration,
    required this.onReactionSelected,
    required this.onClose,
    required this.animateBox,
  }) : assert(itemScale > 0.0 && itemScale < 1);

  final Offset buttonOffset;

  final Size itemSize;

  final List<Reaction<T>?> reactions;

  final Color color;

  final double elevation;

  final double radius;

  final Offset offset;

  final Duration boxDuration;

  final EdgeInsetsGeometry boxPadding;

  final double itemSpace;

  final double itemScale;

  final Duration itemScaleDuration;

  final ValueChanged<Reaction<T>?> onReactionSelected;

  final VoidCallback onClose;

  final bool animateBox;

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

  double get boxHeight => widget.itemSize.height + widget.boxPadding.vertical;

  double get boxWidth =>
      (widget.itemSize.width * widget.reactions.length) +
      (widget.itemSpace * (widget.reactions.length - 1)) +
      widget.boxPadding.horizontal;

  bool get shouldStartFromEnd =>
      MediaQuery.sizeOf(context).width - boxWidth < widget.buttonOffset.dx;

  bool get shouldStartFromBottom =>
      widget.buttonOffset.dy < boxHeight + widget.boxPadding.vertical;

  bool _isOffsetOutsideBox(Offset offset) {
    final Rect boxRect = Rect.fromLTWH(0, 0, boxWidth, boxHeight);
    final bool isReleasedOutsideBox = !boxRect.contains(offset);

    if (isReleasedOutsideBox) {
      widget.onClose();
      return true;
    }

    return false;
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
              start: shouldStartFromEnd
                  ? widget.buttonOffset.dx - boxWidth
                  : widget.buttonOffset.dx,
              top: shouldStartFromBottom
                  ? widget.buttonOffset.dy + widget.itemSize.height
                  : widget.buttonOffset.dy -
                      widget.itemSize.height -
                      widget.boxPadding.vertical,
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
                  _isOffsetOutsideBox(point.localPosition);
                },
                onPointerCancel: (point) {
                  _positionNotifier.value = _positionNotifier.value.copyWith(
                    isBoxHovered: false,
                  );
                  _isOffsetOutsideBox(point.localPosition);
                },
                child: Transform.scale(
                  scale: isBoxHovered ? boxScale : 1,
                  child: Material(
                    color: widget.color,
                    elevation: widget.elevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        widget.radius,
                      ),
                    ),
                    child: Container(
                      width: boxWidth,
                      height: boxHeight,
                      padding: widget.boxPadding,
                      child: Row(
                        children: [
                          for (int index = 0;
                              index < widget.reactions.length;
                              index++) ...[
                            if (index > 0) ...{
                              SizedBox(
                                width: widget.itemSpace,
                              ),
                            },
                            AnimatedBuilder(
                              animation: _animation,
                              child: ReactionsBoxItem<T>(
                                index: index,
                                size: widget.itemSize,
                                scale: widget.itemScale,
                                space: widget.itemSpace,
                                animationDuration: widget.itemScaleDuration,
                                reaction: widget.reactions[index]!,
                                fingerPositionNotifier: _positionNotifier,
                                onReactionSelected: (reaction) {
                                  widget.onReactionSelected(reaction);
                                },
                              ),
                              builder: (context, child) {
                                return AnimatedScale(
                                  duration: widget.boxDuration,
                                  scale: _animation.value > index ? 1 : 0,
                                  child: child,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
