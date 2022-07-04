import 'package:flutter/material.dart';

class MusicProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final void Function(Duration seekTo) seekTo;
  const MusicProgressBar(
      {required this.position,
      required this.duration,
      required this.seekTo,
      Key? key})
      : super(key: key);

  @override
  State<MusicProgressBar> createState() => _MusicProgressBarState();
}

class _MusicProgressBarState extends State<MusicProgressBar>
    with TickerProviderStateMixin {
  late final AnimationController hoverAnimationController, seekController;
  late final Animation<double> strokeWidth;

  Offset _touchPoint = Offset.zero;
  bool isDragging = false;
  bool isInBox = false;

  @override
  void initState() {
    hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    seekController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    strokeWidth = Tween(begin: 3.0, end: 8.0).animate(CurvedAnimation(
        parent: hoverAnimationController, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    hoverAnimationController.dispose();
    seekController.dispose();
    super.dispose();
  }

  void get _checkTouchPoint {
    if (_touchPoint.dx <= 0) _touchPoint = Offset(0, _touchPoint.dy);
    if (_touchPoint.dx >= context.size!.width) {
      _touchPoint = Offset(context.size!.width, _touchPoint.dy);
    }
  }

  void seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    _touchPoint = box.globalToLocal(globalPosition);
    _checkTouchPoint;
    seekController.value = _touchPoint.dx / box.size.width;
  }

  Duration getDuration(double progress) => Duration(
      milliseconds: (widget.duration.inMilliseconds * progress).toInt());

  double get progress => widget.position.inMilliseconds == 0
      ? 0.0
      : widget.position.inMilliseconds / widget.duration.inMilliseconds;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onHorizontalDragStart: (details) => setState(() => isDragging = true),
        onHorizontalDragUpdate: (details) =>
            seekToRelativePosition(details.globalPosition),
        onHorizontalDragEnd: (details) {
          setState(() => isDragging = false);
          hoverAnimationController.value == hoverAnimationController.upperBound
              ? hoverAnimationController.reverse()
              : null;
          isInBox ? widget.seekTo(getDuration(seekController.value)) : null;
        },
        child: MouseRegion(
          onEnter: (_) {
            isInBox = true;
            hoverAnimationController.forward();
          },
          onExit: (_) {
            isInBox = false;
            if (!isDragging) hoverAnimationController.reverse();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: AnimatedBuilder(
              animation: strokeWidth,
              builder: (context, child) => AnimatedBuilder(
                animation: seekController,
                builder: (context, child) => CustomPaint(
                  painter: ProgressBarPainter(
                      isDragging ? seekController.value : progress,
                      strokeWidth.value),
                ),
              ),
            ),
          ),
        ),
      );
}

class ProgressBarPainter extends CustomPainter {
  final double strokeWidth;
  final double progress;
  ProgressBarPainter(this.progress, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    final centerY = size.height / 2.0;
    final barLength = size.width;

    final progressPoint = Offset(barLength * progress, centerY);

    final startPoint = Offset(0.0 + 1, centerY);
    final endPoint = Offset(size.width - 1, centerY);

    paint.color = Colors.white;
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = Colors.blue[400] ?? Colors.blue;
    paint.strokeWidth = strokeWidth;
    canvas.drawLine(startPoint, progressPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
