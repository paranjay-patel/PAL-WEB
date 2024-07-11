import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

extension DateExtensions on DateTime {
  int weekdayOrdinal() {
    final targetDate = toDateOnly();
    final targetWeekday = targetDate.weekday;
    final startOfMonth = Jiffy(targetDate).startOf(Units.MONTH).dateTime;
    final lastDayOfLastMonth = Jiffy(startOfMonth).subtract(days: 1).dateTime;
    var date = lastDayOfLastMonth;
    var nthWeekdayOfMonth = 0;
    while (true) {
      date = Jiffy(date).add(days: 1).dateTime;
      if (date.weekday == targetWeekday) {
        nthWeekdayOfMonth += 1;
      }
      if (date.day >= targetDate.day) {
        break;
      }
    }
    return nthWeekdayOfMonth;
  }

  bool isWithinTheNextSevenDays(DateTime otherDate) {
    return difference(otherDate).inDays < 7;
  }

  DateTime closestRecurringDate(DateTime otherDate) {
    final numberOfDaysInMonthInOtherDate = Jiffy(otherDate).daysInMonth;

    if (day > numberOfDaysInMonthInOtherDate) {
      return Jiffy(otherDate).endOf(Units.MONTH).dateTime;
    }
    return this;
  }

  DateTime get tomorrow {
    return DateTime(year, month, day + 1);
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }

  bool get isWeekday {
    return [DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday]
        .contains(weekday);
  }

  DateTime get startOfWeek {
    return DateTime(year, month, day - weekday + 1);
  }

  DateTime get endOfWeek {
    return DateTime(year, month, day + DateTime.daysPerWeek - weekday);
  }

  DateTime get sameDayNextWeek {
    return DateTime(year, month, day + DateTime.daysPerWeek);
  }

  DateTime get thisSunday {
    return endOfWeek;
  }

  DateTime get thisSaturday {
    return DateTime(thisSunday.year, thisSunday.month, thisSunday.day - 1);
  }

  String get formatDateAndTime {
    return DateFormat('EE d MMM, hh:mm aa').format(this);
  }
}

extension DateTimeExtensions on DateTime {
  DateTime toDateOnly() => DateTime(year, month, day);
}
