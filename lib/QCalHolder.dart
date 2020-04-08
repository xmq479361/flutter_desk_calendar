import 'dart:ui';

import 'package:flutter/material.dart';

import 'QCalModel.dart';
import 'QCalNotification.dart';
import 'QCalculator.dart';

typedef DateTime CalcDateTime(int offset);
enum Mode { WEEK, MONTH, DETAIL }

const int maxSize = 200;
const int offsetMid = maxSize >> 1;
const double ITEM_HEIGHT_DEFAULT = 50;

class QCalHolder {
  Mode mode;
  int currPage = offsetMid;
  Date focusedDate = Date.from(DateTime.now());
  double fullHeight, centerHeight = ITEM_HEIGHT_DEFAULT*WEEK_IN_MONTH, minHeight = ITEM_HEIGHT_DEFAULT;

  QCalHolder({this.mode = Mode.WEEK}) {
    fullHeight = window.physicalSize.height / window.devicePixelRatio;
  }

  focusDateByPage(BuildContext context,int page) {
    focusedDate = getDateTime(currPage = page);
    QCalNotification.dispatchTo(context, this);
  }

  focusDate(BuildContext context,Date date) {
    focusedDate = date;
    QCalNotification.dispatchTo(context, this);
  }


  Date getDateTime(int offs) {
    int offset = offs - currPage;
    switch (mode) {
      case Mode.WEEK:
        return QCalculator.offsetWeekTo(focusedDate, offset);
      default:
        return QCalculator.offsetMonthTo(focusedDate, offset);
    }
  }
}
