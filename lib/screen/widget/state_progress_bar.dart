import 'package:flutter/material.dart';

class StateProgressBar extends CustomPainter {
  StateProgressBar({required this.state});

  final int state;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    double endPointsRadius = 7.0;
    double width = size.width;
    int totalState = 2;
    double stepPerPage = width / totalState;

    canvas.drawCircle(Offset.zero, endPointsRadius, paint);
    canvas.drawLine(Offset(endPointsRadius, 0.0), Offset(endPointsRadius  + stepPerPage * state, 0.0), paint);

    // paint.style = PaintingStyle.fill;
    // canvas.drawCircle(Offset(endPointsRadius + stepPerPage * state, 0.0), 7.0, paint);

    paint.style = PaintingStyle.fill;
    paint.color = state >= 1 ? Colors.blue : Colors.grey;
    canvas.drawCircle(Offset((stepPerPage) + endPointsRadius, 0.0), endPointsRadius, paint);

    // paint.style = PaintingStyle.fill;
    // paint.color = state >= 2 ? Colors.blue : Colors.grey;
    // canvas.drawCircle(Offset((stepPerPage * 2) + endPointsRadius, 0.0), endPointsRadius, paint);

    paint.style = PaintingStyle.fill;
    paint.color = state != totalState ? Colors.grey : Colors.blue;
    canvas.drawLine(Offset((endPointsRadius) + stepPerPage * state, 0.0), Offset(stepPerPage * totalState, 0.0), paint);
    canvas.drawCircle(Offset((stepPerPage * totalState) + endPointsRadius, 0.0), endPointsRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}