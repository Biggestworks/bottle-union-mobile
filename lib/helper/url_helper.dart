import 'dart:io';

class URLHelper {
  // static const BASE_URL = 'https://bottleunion.com/api'; //PRODUCTION

  // static const String BASE_URL = 'http://10.10.10.120:8001/api'; // LOCAL

  static const String BASE_URL = 'http://127.0.0.1:8001/api'; // LOCAL IOS

  static const LOGIN_URL = BASE_URL + '/login';
  static const REGISTER_URL = BASE_URL + '/register';
  static const REGION_URL = BASE_URL + '/region';
  static const VALIDATE_AGE_URL = BASE_URL + '/validate-age';

}