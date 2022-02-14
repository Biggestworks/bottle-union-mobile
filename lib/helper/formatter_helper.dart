import 'package:intl/intl.dart';

class FormatterHelper {

  static moneyFormatter(int? value) {
    final moneyFormatter = new NumberFormat.currency(
      locale: "id_ID",
      symbol: "IDR ",
      decimalDigits: 0,
    );
    return moneyFormatter.format(value);
  }

}