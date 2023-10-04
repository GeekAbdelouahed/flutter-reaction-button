import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/src/core/position_notifier.dart';

import '../models/position.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box_item.dart';

class ReactionsBox<T> extends StatefulWidget {
  final Offset buttonOffset;

  final Size itemSize;

  final List<Reaction<T>?> reactions;

  final VerticalPosition verticalPosition;

  final HorizontalPosition horizontalPosition;

  final Color color;

  final double elevation;

  final double radius;

  final Offset offset;

  final Duration duration;

  final EdgeInsetsGeometry boxPadding;

  final double itemSpace;

  final double itemScale;

  final Duration itemScaleDuration;

  final ValueChanged<Reaction<T>?> onReactionSelected;

  const ReactionsBox({
    Key? key,
    required this.buttonOffset,
    required this.itemSize,
    required this.reactions,
    required this.verticalPosition,
    required this.horizontalPosition,
    required this.color,
    required this.elevation,
    required this.radius,
    required this.offset,
    required this.duration,
    required this.boxPadding,
    required this.itemSpace,
    required this.itemScale,
    required this.itemScaleDuration,
    required this.onReactionSelected,
  })  : assert(itemScale > 0.0 && itemScale < 1),
        super(key: key);

  @override
  State<ReactionsBox<T>> createState() => _ReactionsBoxState<T>();
}

class _ReactionsBoxState<T> extends State<ReactionsBox<T>>
    with TickerProviderStateMixin {
  final FingerPositionNotifier _fingerPositionNotifier =
      FingerPositionNotifier();

  late AnimationController _boxSizeController;

  late Animation<Size?> _boxSizeAnimation;

  late Tween<Size?> _boxSizeTween;

  late AnimationController _scaleController;

  FingerPosition? _fingerPosition;

  Reaction<T>? _selectedReaction;

  @override
  void initState() {
    super.initState();

    _boxSizeController =
        AnimationController(vsync: this, duration: widget.duration);
    _boxSizeTween = Tween();
    _boxSizeAnimation = _boxSizeTween.animate(_boxSizeController);

    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);
    Tween(begin: 0, end: 1).animate(_scaleController).addStatusListener(
      (status) {
        if (status == AnimationStatus.reverse) {
          Navigator.of(context).pop(_selectedReaction);
        }
      },
    );

    _scaleController
      ..forward()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _boxSizeController.dispose();
    _fingerPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FingerPosition?>(
      valueListenable: _fingerPositionNotifier,
      builder: (context, position, child) {
        final double boxScale =
            1 - (widget.itemScale / widget.reactions.length);
        return Stack(
          children: [
            Positioned.fill(
              child: Listener(
                onPointerDown: (_) {
                  _scaleController.reverse();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            PositionedDirectional(
              top: _getVerticalPosition(),
              start: _getHorizontalPosition(),
              child: Transform.scale(
                scale: position?.isBoxHovered ?? false ? boxScale : 1,
                child: Material(
                  color: widget.color,
                  elevation: widget.elevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      widget.radius,
                    ),
                  ),
                  child: Container(
                    height: widget.itemSize.height + widget.boxPadding.vertical,
                    alignment: Alignment.center,
                    padding: widget.boxPadding,
                    child: Listener(
                        onPointerDown: (point) {
                          _fingerPosition = FingerPosition(
                            offset: point.localPosition,
                            isBoxHovered: true,
                          );
                          _fingerPositionNotifier.value = _fingerPosition;
                        },
                        onPointerMove: (point) {
                          _fingerPosition = _fingerPosition?.copyWith(
                            offset: point.localPosition,
                            isBoxHovered: true,
                          );
                          _fingerPositionNotifier.value = _fingerPosition;
                        },
                        onPointerUp: (point) {
                          if (_selectedReaction != null) {
                            widget.onReactionSelected(_selectedReaction);
                            return;
                          }
                          _fingerPosition = _fingerPosition?.copyWith(
                            isBoxHovered: false,
                          );
                          _fingerPositionNotifier.value = _fingerPosition;
                        },
                        onPointerCancel: (point) {
                          _fingerPosition = _fingerPosition?.copyWith(
                            isBoxHovered: false,
                          );
                          _fingerPositionNotifier.value = _fingerPosition;
                        },
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
                              ReactionsBoxItem<T>(
                                onReactionSelected: (reaction) {
                                  _selectedReaction = reaction;
                                },
                                index: index,
                                size: widget.itemSize,
                                scale: widget.itemScale,
                                space: widget.itemSpace,
                                scaleDuration: widget.itemScaleDuration,
                                reaction: widget.reactions[index]!,
                                fingerPositionNotifier: _fingerPositionNotifier,
                              ),
                            ],
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getHorizontalPosition() {
    final xOffset = widget.offset.dx;
    final buttonX = widget.buttonOffset.dx;
    final buttonRadius = (widget.itemSize.width / 2);
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = _boxSizeAnimation.value?.width ?? 0;

    if (buttonX + boxWidth < screenWidth) {
      switch (widget.horizontalPosition) {
        case HorizontalPosition.start:
          return buttonX - buttonRadius + xOffset;
        case HorizontalPosition.center:
          return buttonX - boxWidth / 2 + xOffset;
      }
    }

    final value = buttonX + buttonRadius - boxWidth;

    //add this below code.
    if (value.isNegative) {
      return 20 +
          xOffset; // this is 20 horizontal width is fix you can play with it as you want.
    }
    return value + xOffset;
  }

  double _getVerticalPosition() {
    final yOffset = widget.offset.dy;
    final boxHeight = _boxSizeAnimation.value?.height ?? 0;
    final topPosition =
        widget.buttonOffset.dy - widget.itemSize.height - boxHeight;
    final bottomPosition = widget.buttonOffset.dy;

    // check if TOP space not enough for the box
    if (topPosition - widget.itemSize.height * 4.5 < 0) {
      return bottomPosition + yOffset;
    }

    // check if BOTTOM space not enough for the box
    if (bottomPosition + (widget.itemSize.height * 5.5) >
        context.screenSize.height) {
      return topPosition + yOffset;
    }

    if (widget.verticalPosition == VerticalPosition.top) {
      return topPosition + yOffset;
    }

    return bottomPosition + yOffset;
  }
}
