import 'package:flutter/material.dart';

import 'QCalHolder.dart';
import 'QCalModel.dart';
import 'QCalculator.dart';
import 'QCalendarRender.dart';

typedef RebuildView = void Function();

class QCalendarView extends StatefulWidget {
  final QCalHolder mModel;
  final int pos;
  final QCalendarRender render;
  final RebuildView rebuildView;

  QCalendarView(this.pos, this.mModel, this.render, this.rebuildView);

  @override
  _QCalendarViewState createState() => _QCalendarViewState();
}

class _QCalendarViewState extends State<QCalendarView> {
  final GlobalKey containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (details) {
          print(
              "  >>>onTapUp ${containerKey.currentContext.size}. ${details.localPosition}");
          Date focusDate = QCalculator.calcFocusDateByOffset(
              details.localPosition,
              containerKey.currentContext.size,
              widget.mModel,
              QCalculator.generate(widget.mModel.getDateTime(widget.pos)));
          if (widget.mModel.focusedDate.isEquals(focusDate)) return;
          widget.mModel.focusDate(context, focusDate);
          widget.rebuildView();
        },
        child: Container(
            height: double.infinity,
            key: containerKey,
            child: CustomPaint(
                painter: QCalendarPainter(
                    context, widget.pos, widget.mModel, widget.render))));
  }
}

class QCalendarPainter extends CustomPainter {
  TextPainter textPainter = TextPainter()..textDirection = TextDirection.ltr;
  final QCalHolder mModel;
  final int pos;
  final QCalendarRender render;
  final BuildContext context;

  QCalendarPainter(this.context, this.pos, this.mModel, this.render);

  @override
  void paint(Canvas canvas, Size size) {
    render.render(canvas, size, mModel, QCalculator.generate(mModel.getDateTime(pos)));
  }

  @override
  bool shouldRepaint(QCalendarPainter oldDelegate) => true;
}
