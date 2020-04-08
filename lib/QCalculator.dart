import 'dart:math';
import 'dart:ui';

import 'QCalHolder.dart';
import 'QCalModel.dart';

class QCalculator {
  /// 根据当前日期，生成对应月份数据
  static List<Week> generate(Date date) {
    DateTime firstDateInMon = DateTime(date.year, date.month, 1);
    int offset2FirstWeekDay =
        (firstDateInMon.weekday + DAYS_PERWEEK - firstDayInWeek) % DAYS_PERWEEK;
    DateTime firstDate =
        firstDateInMon.subtract(Duration(days: offset2FirstWeekDay));
    List<Week> monthDate = [];
    for (int weekIndex = 0; weekIndex < WEEK_IN_MONTH; weekIndex++) {
      Week week = Week();
      for (int dayIndex = 0; dayIndex < DAYS_PERWEEK; dayIndex++) {
        week.add(Date.from(firstDate.add(Duration(days: weekIndex * 7 + dayIndex))));
      }
      monthDate.add(week);
    }
    // print("generateMonthDate: ${date}, ${firstDateInMon.weekday}, offset: ${offset2FirstWeekDay}, ${firstDate}");
    return monthDate;
  }

  /// 获取偏移月份数offset后的日期
  static Date offsetMonthTo(Date baseDate, int offset) {
    DateTime toMonthMaxDate =
        DateTime(baseDate.year, baseDate.month + offset + 1, 1)
            .subtract(Duration(days: 1));
    return Date.from(DateTime(baseDate.year, baseDate.month + offset,
        min(toMonthMaxDate.day, baseDate.date)));
  }

  /// 获取偏移周数offset后的日期
  static Date offsetWeekTo(Date baseDate, int offset) {
    return baseDate + Duration(days: offset * DAYS_PERWEEK);
//    return Date.from(baseDate.toDateTime().add(Duration(days: offset * DAYS_PERWEEK)));
  }

  /// 根据当前偏移x,y轴位置，计算点击的日期
  static Date calcFocusDateByOffset(
      Offset offset, Size size, QCalHolder model, List<Week> weeks) {
    int indexDay = offset.dx ~/ (size.width / DAYS_PERWEEK);
    int indexWeek = getFocusIndex(model.focusDateTime, weeks);
    if (model.mode != Mode.WEEK)
      indexWeek = offset.dy ~/ (size.height / WEEK_IN_MONTH);
    return weeks[indexWeek].dates[indexDay];
  }

  static int getFocusIndex(Date focusDate, List<Week> weeks) {
    int focusIndexOfWeek = 0;
    for (int i = 0; i < WEEK_IN_MONTH; i++) {
      Week week = weeks[i];
      if (week.hasDate(focusDate)) {
        focusIndexOfWeek = i;
        break;
      }
    }
    return focusIndexOfWeek;
  }

  /// 根据当前偏移x,y轴位置，计算点击的日期
  static Date calcFocusDate(
      Offset offset, Size size, QCalHolder model, List<Week> weeks) {
    int indexDay = offset.dx ~/ (size.width / DAYS_PERWEEK);
    int indexWeek = getFocusIndex(model.focusDateTime, weeks);
    switch (model.mode) {
      case Mode.WEEK:
        break;
      default:
        indexWeek = offset.dy ~/ (size.height / WEEK_IN_MONTH);
    }
    return weeks[indexWeek].dates[indexDay];
  }
}
