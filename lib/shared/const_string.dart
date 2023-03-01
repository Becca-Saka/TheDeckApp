import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//TODO: add a class for all the constants
String calculateAge(String date) {
  final birthDate = DateFormat('yyyy/MM/dd').parse(date);
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age.toString();
}

DateTime parseTimeStamp(Timestamp? timestamp) {
  if (timestamp == null) {
    return DateTime.now();
  } else {
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch);
  }
}

String readTimeStampDaysOnly(timeStamp) {
  var now = DateTime.now();
  final times = parseTimeStamp(timeStamp);
  var diff = now.difference(times);
  final format = DateFormat.yMMMd();
  final formatted = format.format(times);
  if (formatted == format.format(now) && diff.inHours < 24) {
    return 'Today';
  } else if (formatted != format.format(now) && diff.inDays == 0) {
    return 'Yesterday';
  } else {
    return formatted;
  }
}

Timestamp getTimeStamp(DateTime date) => Timestamp.fromDate(date);

/// Checks if string is email.
bool isEmail(String s) => hasMatch(s,
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool hasMatch(String? value, String pattern) {
  return (value == null) ? false : RegExp(pattern).hasMatch(value);
}
