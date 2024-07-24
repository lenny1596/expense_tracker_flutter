// helpful components

// convert string to double
import 'package:intl/intl.dart';

double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

// show numbers in currency format
String changeFormat(double amount) {
  final format =
      NumberFormat.currency(symbol: "\$ ", locale: "en_US", decimalDigits: 2);
  return format.format(amount);
}

// calculate the no. of months between start month and current month
int calculateMonthCount(int startMonth, startYear, currentMonth, currentYear) {
  int monthCount =
      (currentYear - startYear) * 12 + currentMonth - startMonth + 1;

  return monthCount;
}

// get current month name
String currentMonthName() {
  DateTime now = DateTime.now();
  List<String> months = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];
  return months[now.month - 1];
}
