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
    required this.onClose,
  }) : assert(itemScale > 0.0 && itemScale < 1);

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

  final VoidCallback onClose;

  @override
  State<ReactionsBox<T>> createState() => _ReactionsBoxState<T>();
}

class _ReactionsBoxState<T> extends State<ReactionsBox<T>> {
  final PositionNotifier _positionNotifier = PositionNotifier();

  double get boxHeight =>
      widget.itemSize.height + widget.boxPadding.vertical / 2;
  double get boxWidth =>
      (widget.itemSize.width * widget.reactions.length) +
      (widget.itemSpace * (widget.reactions.length - 1));

  bool _isLastPositionOutsideBox(Offset localOffset) {
    final Rect boxRect = Rect.fromPoints(
      Offset.zero,
      Offset(boxWidth, boxHeight),
    );

    final bool isReleasedOutsideBox = !boxRect.contains(localOffset);

    if (isReleasedOutsideBox) {
      widget.onClose();
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _positionNotifier.dispose();
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
                  color: Colors.transparent,
                ),
              ),
            ),
            PositionedDirectional(
              start: widget.buttonOffset.dx,
              top: widget.buttonOffset.dy -
                  widget.itemSize.height -
                  widget.boxPadding.vertical,
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
                    height: widget.itemSize.height + widget.boxPadding.vertical,
                    padding: widget.boxPadding,
                    child: Listener(
                      onPointerDown: (point) {
                        _positionNotifier.value = PositionData(
                          offset: point.localPosition,
                          isBoxHovered: true,
                        );
                      },
                      onPointerMove: (point) {
                        _positionNotifier.value =
                            _positionNotifier.value.copyWith(
                          offset: point.localPosition,
                          isBoxHovered: true,
                        );
                      },
                      onPointerUp: (point) {
                        _positionNotifier.value =
                            _positionNotifier.value.copyWith(
                          isBoxHovered: false,
                        );
                        _isLastPositionOutsideBox(point.localPosition);
                      },
                      onPointerCancel: (point) {
                        _positionNotifier.value =
                            _positionNotifier.value.copyWith(
                          isBoxHovered: false,
                        );
                        _isLastPositionOutsideBox(point.localPosition);
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
                              index: index,
                              size: widget.itemSize,
                              scale: widget.itemScale,
                              space: widget.itemSpace,
                              scaleDuration: widget.itemScaleDuration,
                              reaction: widget.reactions[index]!,
                              fingerPositionNotifier: _positionNotifier,
                              onReactionSelected: (reaction) {
                                widget.onReactionSelected(reaction);
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
