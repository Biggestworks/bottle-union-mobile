import 'package:flutter/services.dart';

class XenditMethod {
  static const platform = MethodChannel('bottle.union/xendit');

  static Future<String> xenditCreateToken({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvn,
  }) async {
    try {
      final dynamic result =
          await platform.invokeMethod('xenditCreateToken', <String, dynamic>{
        'card_number': cardNumber,
        'exp_month': expMonth,
        'exp_year': expYear,
        'cvn': cvn,
      });

      return result.toString();
      print(result);
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> xenditCreateAuthentication({
    required String tokenId,
    required int amount,
  }) async {
    final dynamic result = await platform
        .invokeMethod('xenditCreateAuthentication', <String, dynamic>{
      'token_id': tokenId,
      'amount': amount,
    });

    return result.toString();
  }
}
