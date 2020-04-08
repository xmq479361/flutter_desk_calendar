const int MAX_MONTH = 12;
const int DAYS_PERWEEK = 7;
const int WEEK_IN_MONTH = 6;
const int firstDayInWeek = DateTime.monday;


class Date {
  final int year, month, date;
  bool today;

  DateTime toDateTime() => DateTime(year, month, date);

  Date(this.year, this.month, this.date) {
    today = isEqualsDateTime(DateTime.now());
  }

  Date.from(DateTime dateTime)
      : this(dateTime.year, dateTime.month, dateTime.day);

  @override
  String toString() => "$year-$month-$date";

  bool isBefore(Date date) =>
      date == null || toDateTime().isBefore(date.toDateTime());

  bool isAfter(Date date) =>
      date == null || toDateTime().isAfter(date.toDateTime());

  bool isEquals(Date dates) =>
      dates != null &&
          date == dates.date &&
          month == dates.month &&
          year == dates.year;

  bool isEqualsDateTime(DateTime dates) => dates!=null && date == dates.day && month == dates.month && year == dates.year;
  bool isToday() => today;

  Date operator +(Duration duration) {
    return Date.from(toDateTime().add(duration));
  }
}

class Week {
  List<Date> dates = [];

  Week({this.dates});

  add(Date date) {
    if (dates == null) dates = [];
    dates.add(date);
  }

  hasDate(Date date) {
    return dates.isNotEmpty && !dates.first.isAfter(date) &&
        !dates.last.isBefore(date);
  }
}
