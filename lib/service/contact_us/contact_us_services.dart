import 'package:eight_barrels/model/contact_us/contact_us.dart';
import 'package:get/get_connect/connect.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUsServices extends GetConnect {
  static Future<ContactUs> fetchContactUsList() async {
    try {
      final response =
          await http.get(Uri.parse('https://bottleunion.com/contact-us/list'));

      print(response.body);

      return ContactUs.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
