import 'dart:async';

import 'package:flutter/material.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';

typedef OnReactionClick = void Function(Reaction?);

class ReactionsBoxItem extends StatefulWidget {
  final OnReactionClick onReactionSelected;

  final Reaction reaction;

  final double scale;

  final Stream<DragData?> dragStream;

  const ReactionsBoxItem({
    Key? key,
    required this.reaction,
    required this.onReactionSelected,
    required this.scale,
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

  Size? _widgetSize;

  void _onSelected() {
    _scaleController.reverse();
    widget.onReactionSelected.call(widget.reaction);
  }

  bool _isWidgetHovered(DragData? dragData) {
    final Offset currentOffset = dragData?.offset ?? Offset.zero;
    final widgetOffset = _widgetKey.widgetOffset;

    if (_widgetSize == null) {
      _widgetSize = _widgetKey.widgetSize;
    }

    final double deltaX =
        (widgetOffset.dx + _widgetSize!.width / 1.9) - currentOffset.dx;
    final double deltaY = widgetOffset.dy - currentOffset.dy;

    return deltaX.abs() <= _widgetSize!.width / 2 &&
        deltaY.abs() <= _widgetSize!.height * 2 &&
        widget.reaction.enabled;
  }

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleTween = Tween(
      begin: 1,
      end: widget.scale,
    );

    _scaleAnimation = _scaleTween.animate(_scaleController);
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
          bool isHovered = false;
          if (snapshot.hasData) {
            final dragData = snapshot.data;
            isHovered = _isWidgetHovered(dragData);
            if (isHovered) {
              bool isSelected = snapshot.data?.isDragEnd ?? false;
              if (isSelected) {
                _onSelected();
              } else {
                _scaleController.forward();
              }
            } else {
              _scaleController.reverse();
            }
          }

          return FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedBuilder(
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
                    width: _widgetSize != null
                        ? _widgetSize!.width * _scaleAnimation.value
                        : null,
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 50),
                          opacity: isHovered ? 1 : 0,
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
            ),
          );
        },
      ),
    );
  }
}
