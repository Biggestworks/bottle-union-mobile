
class URLHelper {
  // static const BASE_URL = 'https://bottleunion.com/api'; //PRODUCTION

  static const BASE_URL = 'http://dev.bottleunion.com/api'; //DEVELOPMENT

  // static const String BASE_URL = 'http://192.168.100.9:8001/api'; // LOCAL

  // static const String BASE_URL = 'http://127.0.0.1:8001/api'; // LOCAL IOS

  /// AUTH
  static const LOGIN_URL = BASE_URL + '/auth/login';
  static const REGISTER_URL = BASE_URL + '/auth/register';
  static const REGION_URL = BASE_URL + '/region';
  static const VALIDATE_AGE_URL = BASE_URL + '/auth/validate/age';
  static const VALIDATE_EMAIL_PHONE_URL = BASE_URL + '/auth/validate/email-phone';
  static const LOGIN_SOCMED_URL = BASE_URL + '/auth/login/socmed';
  static const REGISTER_SOCMED_URL = BASE_URL + '/auth/register/socmed';

  ///PRODUCT
  static const PRODUCT_LIST_URL = BASE_URL + '/product';

}