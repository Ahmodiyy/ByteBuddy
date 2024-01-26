import 'package:intl/intl.dart';

class Functions {
  static String convertToNaira(dynamic data) {
    NumberFormat formatter = NumberFormat.currency(symbol: '₦');
    return formatter.format(data);
  }
}
