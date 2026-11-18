import 'package:material_ui/material_ui.dart';

class LanguageFlag extends StatelessWidget {
  const LanguageFlag({super.key, required this.brazil});
  final bool brazil;
  @override
  Widget build(BuildContext context) => ClipOval(
    child: SizedBox(
      width: 26,
      height: 26,
      child: CustomPaint(painter: _FlagPainter(brazil)),
    ),
  );
}

class _FlagPainter extends CustomPainter {
  _FlagPainter(this.brazil);
  final bool brazil;
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint();
    if (brazil) {
      canvas.drawRect(Offset.zero & s, p..color = const Color(0xff15803d));
      canvas.drawPath(
        Path()
          ..moveTo(s.width / 2, 3)
          ..lineTo(s.width - 2, s.height / 2)
          ..lineTo(s.width / 2, s.height - 3)
          ..lineTo(2, s.height / 2)
          ..close(),
        p..color = const Color(0xfffacc15),
      );
      canvas.drawCircle(
        s.center(Offset.zero),
        6.5,
        p..color = const Color(0xff1e3a8a),
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: s.center(Offset.zero).translate(-1, 3),
          width: 15,
          height: 8,
        ),
        3.4,
        2.3,
        false,
        p
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    } else {
      canvas.drawRect(Offset.zero & s, p..color = const Color(0xff183469));
      for (final color in [Colors.white, const Color(0xffb91c1c)]) {
        p
          ..color = color
          ..strokeWidth = color == Colors.white ? 6 : 2;
        canvas.drawLine(Offset.zero, Offset(s.width, s.height), p);
        canvas.drawLine(Offset(s.width, 0), Offset(0, s.height), p);
      }
      for (final color in [Colors.white, const Color(0xffb91c1c)]) {
        p
          ..color = color
          ..strokeWidth = color == Colors.white ? 9 : 5;
        canvas.drawLine(
          Offset(s.width / 2, 0),
          Offset(s.width / 2, s.height),
          p,
        );
        canvas.drawLine(
          Offset(0, s.height / 2),
          Offset(s.width, s.height / 2),
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FlagPainter old) => old.brazil != brazil;
}
