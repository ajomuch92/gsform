class DateDataModel {
  DateTime dateServerType;
  int timeStamp;
  String showDateStr;

  DateDataModel({required this.dateServerType, required this.timeStamp, required this.showDateStr});
}

class DateDataRangeModel {
  DateTime startDateServerType;
  DateTime endDateServerType;
  int startTimeStamp;
  int endTimeStamp;
  String displayStartDateStr;
  String displayEndDateStr;

  DateDataRangeModel({
    required this.startDateServerType,
    required this.endDateServerType,
    required this.startTimeStamp,
    required this.endTimeStamp,
    required this.displayStartDateStr,
    required this.displayEndDateStr,
  });
}

/// How a picked date is displayed. Rendered with the app's [MaterialLocalizations].
enum GSDateFormatType {
  numeric, // 7/21/2026
  fullText, // Tuesday, July 21, 2026
  mediumText, // Tue, Jul 21
  shortText, // Jul 21, 2026
}

class GSDate {
  int year;

  int month;

  int day;

  GSDate({required this.year, required this.month, required this.day});

  DateTime toDateTime() => DateTime(year, month, day);
}
