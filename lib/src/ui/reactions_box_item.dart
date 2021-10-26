import 'dart:async';

import 'package:flutter/material.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import 'title.dart';

class ReactionsBoxItem extends StatefulWidget {
  final Function(Reaction?) onReactionClick;

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

  OverlayEntry? _overlayEntry;

  void _onSelected() {
    _hideTitle();
    _scaleController.reverse();
    widget.onReactionClick.call(widget.reaction);
  }

  void _showTitle() {
    final size = _widgetKey.widgetSize;
    final offset = _widgetKey.widgetOffset;

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return TitleWidget(
          title: widget.reaction.title,
          parentSize: size,
          parentOffset: offset,
        );
      },
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideTitle() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  late void Function() _listener;

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

      if (_scale == _maxScale && _overlayEntry == null) {
        _showTitle();
      } else if (_scale <= _normalScale) {
        _hideTitle();
      }
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
      key: _widgetKey,
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
            final isHovered =
                _width! * .9 > deltaOffset.distance && widget.reaction.enabled;
            if (isHovered) {
              bool isSelected = snapshot.data?.isDragEnd ?? false;
              if (isSelected) {
                _onSelected();
              } else {
                _scaleController.forward();
              }
            } else {
              bool isDraggingEnded = dragData?.isDragEnd ?? false;
              if (isDraggingEnded) {
                _updateAnimation(begin: _normalScale, end: _maxScale);
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  _scaleController.reset();
                });
              } else {
                _updateAnimation(begin: _minScale);
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  _scaleController.reset();
                });
              }
            }
          } else {
            _updateAnimation(begin: _minScale);
            _scaleController.reverse();
          }

          return AnimatedBuilder(
            animation: _scaleAnimation,
            child: FittedBox(
              child: widget.reaction.previewIcon,
            ),
            builder: (_, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedContainer(
                  width: _width != null ? _width! * _scale : null,
                  duration: const Duration(milliseconds: 250),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
