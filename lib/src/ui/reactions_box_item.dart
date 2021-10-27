import 'dart:async';

import 'package:flutter/material.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';

typedef OnReactionClick = void Function(Reaction?);

class ReactionsBoxItem extends StatefulWidget {
  final OnReactionClick onReactionClick;

  final Reaction reaction;

  final int itemsCount;

  final Stream<DragData?> dragStream;

  const ReactionsBoxItem({
    Key? key,
    required this.reaction,
    required this.onReactionClick,
    required this.itemsCount,
    required this.dragStream,
  }) : super(key: key);

  @override
  _ReactionsBoxItemState createState() => _ReactionsBoxItemState();
}

class _ReactionsBoxItemState extends State<ReactionsBoxItem>
    with TickerProviderStateMixin {
  final GlobalKey _widgetKey = GlobalKey();

  late AnimationController _scaleController;

  late Tween<double> _scaleTween;

  late Animation<double> _scaleAnimation;

  static const double _DELTA_SCALE = .2;

  double _minScale = 1;

  double _normalScale = 1;

  double _maxScale = 1 + _DELTA_SCALE;

  double _scale = 1;

  double? _width;

  void _onSelected() {
    _scaleController.reverse();
    widget.onReactionClick.call(widget.reaction);
  }

  late VoidCallback _listener;

  void _updateAnimation({double? begin, double? end}) {
    _scaleTween = Tween(begin: begin ?? _normalScale, end: end ?? _maxScale);
    _scaleAnimation = _scaleTween.animate(_scaleController);
    _scaleAnimation
      ..removeListener(_listener)
      ..addListener(_listener);
  }

  @override
  void initState() {
    super.initState();

    // Calculating how much we should scale down unselected items
    _minScale = 1 - (_DELTA_SCALE / widget.itemsCount);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _listener = () {
      _scale = _scaleAnimation.value;
    };

    _updateAnimation(begin: _normalScale, end: _maxScale);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.reaction.enabled,
      child: StreamBuilder<DragData?>(
        stream: widget.dragStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final dragData = snapshot.data;
            final Offset currentOffset = dragData?.offset ?? Offset.zero;
            final widgetSize = _widgetKey.widgetSize;
            if (_width == null) {
              _width = widgetSize.width;
            }
            final deltaOffset = currentOffset - _widgetKey.widgetOffset;
            final isHovered = widgetSize.width * widgetSize.height >=
                    deltaOffset.distanceSquared &&
                widget.reaction.enabled;
            if (isHovered) {
              bool isSelected = snapshot.data?.isDragEnd ?? false;
              if (isSelected) {
                _onSelected();
              } else {
                _scaleController.forward();
              }
            } else {
              bool isDraggingEnded = dragData?.isDragEnd ?? false;
              if (isDraggingEnded)
                _updateAnimation(begin: _normalScale, end: _maxScale);
              else
                _updateAnimation(begin: _minScale);

              WidgetsBinding.instance?.addPostFrameCallback((_) {
                _scaleController.reset();
              });
            }
          } else {
            _updateAnimation(begin: _minScale);
            _scaleController.reverse();
          }

          return FittedBox(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              child: FittedBox(
                key: _widgetKey,
                child: widget.reaction.previewIcon,
              ),
              builder: (_, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: AnimatedContainer(
                    width: _width != null ? _width! * _scale : null,
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: _scale == _maxScale ? 1 : 0,
                          child: FittedBox(
                            fit: BoxFit.none,
                            child: widget.reaction.title,
                          ),
                        ),
                        child!,
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
