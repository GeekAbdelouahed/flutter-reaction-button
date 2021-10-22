import 'dart:async';

import 'package:flutter/material.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box_item.dart';

class ReactionsBox extends StatefulWidget {
  final Offset buttonOffset;

  final Size buttonSize;

  final List<Reaction?> reactions;

  final Position position;

  final Color color;

  final double elevation;

  final double radius;

  final Duration duration;

  final Color? highlightColor;

  final Color? splashColor;

  final AlignmentGeometry alignment;

  final EdgeInsets boxPadding;

  final double boxItemsSpacing;

  const ReactionsBox({
    Key? key,
    required this.buttonOffset,
    required this.buttonSize,
    required this.reactions,
    required this.position,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
    this.highlightColor,
    this.splashColor,
    this.alignment = Alignment.center,
    this.boxPadding = const EdgeInsets.all(0),
    this.boxItemsSpacing = 0,
  }) : super(key: key);

  @override
  _ReactionsBoxState createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends State<ReactionsBox>
    with TickerProviderStateMixin {
  StreamController<DragData> _dragStreamController =
      StreamController<DragData>();
  late Stream<DragData> _dragStream;

  late AnimationController _scaleController;

  late Animation<double> _scaleAnimation;

  double _scale = 0;

  Reaction? _selectedReaction;

  late DragData _dragData;

  @override
  void initState() {
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);

    final Tween<double> startTween = Tween(begin: 0, end: 1);
    _scaleAnimation = startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse)
          Navigator.of(context).pop(_selectedReaction);
      });

    _scaleController.forward();

    _dragStream = _dragStreamController.stream.asBroadcastStream();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _dragStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double top = _getPosition(context);
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Stack(
        alignment: widget.alignment,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (_) => _scaleController.reverse(),
              onVerticalDragUpdate: (_) => _scaleController.reverse(),
              onHorizontalDragUpdate: (_) => _scaleController.reverse(),
            ),
          ),
          Positioned(
            top: top,
            child: Transform.scale(
              scale: _scale,
              child: Material(
                color: widget.color,
                elevation: widget.elevation,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
                child: IgnorePointer(
                  ignoring: true,
                  child: Opacity(
                    opacity: 0,
                    child: _buildDumpItems(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: top,
            child: Transform.scale(
              scale: _scale,
              child: _buildItems(),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildDumpItems() {
    return Padding(
      padding: widget.boxPadding,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _dragData = DragData(offset: details.globalPosition);
          _dragStreamController.add(_dragData);
        },
        onHorizontalDragEnd: (details) {
          _dragData = _dragData.copyWith(isDragEnd: true);
          _dragStreamController.add(_dragData);
        },
        child: Wrap(
          spacing: widget.boxItemsSpacing,
          children: widget.reactions.map((reaction) {
            return reaction!.previewIcon;
          }).toList(),
        ),
      ),
    );
  }

  Padding _buildItems() {
    return Padding(
      padding: widget.boxPadding,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _dragData = DragData(offset: details.globalPosition);
          _dragStreamController.add(_dragData);
        },
        onHorizontalDragEnd: (details) {
          _dragData = _dragData.copyWith(isDragEnd: true);
          _dragStreamController.add(_dragData);
        },
        child: Wrap(
          spacing: widget.boxItemsSpacing,
          children: widget.reactions
              .map(
                (reaction) => ReactionsBoxItem(
                  onReactionClick: (reaction) {
                    _selectedReaction = reaction;
                    _scaleController.reverse();
                  },
                  splashColor: widget.splashColor,
                  highlightColor: widget.highlightColor,
                  reaction: reaction,
                  dragStream: _dragStream,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  double _getPosition(BuildContext context) =>
      (_getTopPosition() - widget.buttonSize.height * 2 < 0)
          ? _getBottomPosition()
          : (_getBottomPosition() + widget.buttonSize.height * 2 >
                  context.screenSize.height)
              ? _getTopPosition()
              : widget.position == Position.TOP
                  ? _getTopPosition()
                  : _getBottomPosition();

  double _getTopPosition() =>
      widget.buttonOffset.dy - widget.buttonSize.height * 3.3;

  double _getBottomPosition() =>
      widget.buttonOffset.dy + widget.buttonSize.height;
}
