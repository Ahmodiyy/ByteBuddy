import 'package:intl/intl.dart';

class UtilityFunctions {
  static String formatCurrency(num amount) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '₦', // Change symbol to Naira
    ).format(amount);
  }
}
