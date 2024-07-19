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
