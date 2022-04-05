import 'package:intl/intl.dart';

class FormatterHelper {

  static moneyFormatter(int? value) {
    final moneyFormatter = new NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    );
    return moneyFormatter.format(value);
  }

  static String interpolateString(String string, List<String> params) {

    String result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceAll('%$i\$', params[i-1]);
    }

    return result;
  }

}