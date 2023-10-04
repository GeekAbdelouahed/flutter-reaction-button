import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button/src/common/position_notifier.dart';

class ReactionsBoxItem<T> extends StatefulWidget {
  const ReactionsBoxItem({
    Key? key,
    required this.reaction,
    required this.onReactionSelected,
    required this.scale,
    required this.index,
    required this.size,
    required this.space,
    required this.scaleDuration,
    required this.fingerPositionNotifier,
  }) : super(key: key);

  final ValueChanged<Reaction<T>?> onReactionSelected;

  final Reaction<T> reaction;

  final double scale;

  final int index;

  final Duration scaleDuration;

  final Size size;

  final double space;

  final PositionNotifier fingerPositionNotifier;

  @override
  State<ReactionsBoxItem<T>> createState() => _ReactionsBoxItemState<T>();
}

class _ReactionsBoxItemState<T> extends State<ReactionsBoxItem<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    lowerBound: 1,
    upperBound: 1 + widget.scale,
    duration: const Duration(milliseconds: 200),
    reverseDuration: const Duration(milliseconds: 200),
  );

  void _listener() {
    final Offset fingerOffset = widget.fingerPositionNotifier.value.offset;
    final Offset topLeft =
        Offset((widget.size.width + widget.space) * widget.index, 0);
    final Offset bottomRight = Offset(
      (widget.size.width + widget.space) * (widget.index + 1),
      widget.size.height,
    );
    final Rect rect = Rect.fromPoints(topLeft, bottomRight);
    final bool selected = rect.contains(fingerOffset);

    if (selected) {
      final bool isBoxHovered =
          widget.fingerPositionNotifier.value.isBoxHovered;
      if (!isBoxHovered) {
        widget.onReactionSelected(widget.reaction);
      }
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.fingerPositionNotifier.addListener(_listener);
  }

  @override
  void dispose() {
    widget.fingerPositionNotifier.removeListener(_listener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final bool showTitle =
            _animationController.value == _animationController.upperBound &&
                widget.reaction.title != null;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: _animationController.value,
              child: SizedBox.fromSize(
                size: widget.size,
                child: widget.reaction.previewIcon,
              ),
            ),
            if (widget.reaction.title != null) ...{
              Positioned(
                top: -(widget.size.height * _animationController.value) / 2,
                child: AnimatedOpacity(
                  opacity: showTitle ? 1 : 0,
                  duration: widget.scaleDuration,
                  child: widget.reaction.title!,
                ),
              )
            },
          ],
        );
      },
    );
  }
}
