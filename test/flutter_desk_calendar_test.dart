import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_desk_calendar/QCalculator.dart';
import 'package:flutter_desk_calendar/QCalModel.dart';

void main() {
  test('offsetMonthTo', () {
    expect(QCalculator.offsetMonthTo(Date(2017, 3, 12), 2).toString(),
        "2017-5-12");
    expect(QCalculator.offsetMonthTo(Date(2017, 3, 31), -1).toString(),
        "2017-2-28");
    expect(QCalculator.offsetMonthTo(Date(2020, 3, 12), -7).toString(),
        "2019-8-12");
    expect(QCalculator.offsetMonthTo(Date(2020, 2, 29), 1).toString(),
        "2020-3-29");
  });
  test('offsetWeekTo', () {
    expect(
        QCalculator.offsetWeekTo(Date(2017, 3, 12), 3).toString(), "2017-4-2");
    expect(QCalculator.offsetWeekTo(Date(2012, 3, 12), -7).toString(),
        "2012-1-23");
    expect(
        QCalculator.offsetWeekTo(Date(2020, 3, 1), -1).toString(), "2020-2-23");
  });
  test('Date offset', () {
    expect(Date(2017, 3, 12) + Duration(days: 2 * DAYS_PERWEEK), Date(2017, 3, 26));
    expect((Date(2017, 3, 12) + Duration(days: 2 * DAYS_PERWEEK)).toString(),  "2017-3-26");
  });
  test('offsetWeekTo', () {
    List<Week> month = QCalculator.generate(Date(2020, 4, 1));
    expect(month.length, 6);
    for (Week week in month) {
      expect(week.dates.length, 7);
    }
  });
}
