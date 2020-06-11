import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:supercharged/supercharged.dart';
import 'package:simple_animations/simple_animations.dart';

class Bubbles extends StatefulWidget {
  final int numberOfBubbles;

  Bubbles(this.numberOfBubbles);

  @override
  _BubblesState createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> {
  final Random random = Random();

  final List<BubbleModel> bubbles = [];

  @override
  void initState() {
    widget.numberOfBubbles.times(() => bubbles.add(BubbleModel(random)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation(
      tween: ConstantTween(1),
      builder: (context, child, _) {
        _simulateBubbles();
        return CustomPaint(
          painter: BubblePainter(bubbles),
        );
      },
    );
  }

  _simulateBubbles() {
    bubbles.forEach((bubble) => bubble.checkIfBubbleNeedsToBeRestarted());
  }
}

enum _OffsetProps { x, y }

class BubbleModel {
  MultiTween<_OffsetProps> tween;
  double size;
  Duration duration;
  Duration startTime;
  Random random;

  BubbleModel(this.random) {
    _restart();
    _shuffle();
  }

  _restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);

    tween = MultiTween<_OffsetProps>()
      ..add(_OffsetProps.x, startPosition.dx.tweenTo(endPosition.dx))
      ..add(_OffsetProps.y, startPosition.dy.tweenTo(endPosition.dy));

    duration = 3000.milliseconds + random.nextInt(6000).milliseconds;
    startTime = DateTime.now().duration();
    size = 0.1 + random.nextDouble() * 0.4;
  }

  void _shuffle() {
    startTime -= (this.random.nextDouble() * duration.inMilliseconds)
        .round()
        .milliseconds;
  }

  checkIfBubbleNeedsToBeRestarted() {
    if (progress() == 1.0) {
      _restart();
    }
  }

  double progress() {
    return ((DateTime.now().duration() - startTime) / duration)
        .clamp(0.0, 1.0)
        .toDouble();
  }
}

class BubblePainter extends CustomPainter {
  List<BubbleModel> bubbles;

  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withAlpha(50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    bubbles.forEach((bubble) {
      final progress = bubble.progress();
      final MultiTweenValues<_OffsetProps> animation =
          bubble.tween.transform(progress);
      final position = Offset(
        animation.get<double>(_OffsetProps.x) * size.width,
        animation.get<double>(_OffsetProps.y) * size.height,
      );
      canvas.drawCircle(position, size.width * 0.2 * bubble.size, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
