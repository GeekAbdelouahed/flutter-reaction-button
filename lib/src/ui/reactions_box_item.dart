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

  final double _maxScale = 1 + _DELTA_SCALE;

  final double _normalScale = 1;

  double _minScale = 1;

  double? _width;

  bool _isHovered = false;

  void _onSelected() {
    _scaleController.reverse();
    widget.onReactionClick.call(widget.reaction);
  }

  void _updateAnimation({double? begin, double? end}) {
    _scaleTween = Tween(begin: begin ?? _normalScale, end: end ?? _maxScale);
    _scaleAnimation = _scaleTween.animate(_scaleController);
  }

  bool _isWidgetHovered(DragData? dragData) {
    final Offset currentOffset = dragData?.offset ?? Offset.zero;
    final widgetOffset = _widgetKey.widgetOffset;
    final widgetSize = _widgetKey.widgetSize;

    if (_width == null) {
      _width = widgetSize.width;
    }

    final double deltaX =
        (widgetOffset.dx + widgetSize.width / 1.9) - currentOffset.dx;
    final double deltaY = widgetOffset.dy - currentOffset.dy;

    return deltaX.abs() <= widgetSize.width / 2 &&
        deltaY.abs() <= widgetSize.height * 2 &&
        widget.reaction.enabled;
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
            _isHovered = _isWidgetHovered(dragData);
            if (_isHovered) {
              bool isSelected = snapshot.data?.isDragEnd ?? false;
              if (isSelected) {
                _onSelected();
              } else {
                _scaleController.forward();
              }
            } else {
              bool isDraggingEnded = dragData?.isDragEnd ?? false;
              if (isDraggingEnded) {
                _updateAnimation();
              } else {
                _updateAnimation(begin: _minScale);
              }
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                _scaleController.reset();
              });
            }
          }

          return AnimatedBuilder(
            animation: _scaleAnimation,
            child: FittedBox(
              key: _widgetKey,
              fit: BoxFit.scaleDown,
              child: widget.reaction.previewIcon,
            ),
            builder: (_, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedContainer(
                  width:
                      _width != null ? _width! * _scaleAnimation.value : null,
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 50),
                        opacity: _isHovered ? 1 : 0,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: widget.reaction.title,
                        ),
                      ),
                      child!,
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
