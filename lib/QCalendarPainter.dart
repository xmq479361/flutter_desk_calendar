import 'package:flutter/material.dart';

import 'QCalHolder.dart';
import 'QCalModel.dart';
import 'QCalculator.dart';
import 'QCalendarRender.dart';

class QCalendarPainter extends CustomPainter {
  TextPainter textPainter = TextPainter()..textDirection = TextDirection.ltr;
  final QCalHolder mModel;
  final int pos;
  final QCalendarRender render;
  final BuildContext context;
  QCalendarPainter(this.context, this.pos, this.mModel, this.render);
  @override
  void paint(Canvas canvas, Size size) {
    if (render != null){
      final Date date = mModel.getDateTime(pos);
      render.render(canvas, size, mModel, QCalculator.generate(date));
    }
  }

  @override
  bool shouldRepaint(QCalendarPainter oldDelegate) => true;
}
