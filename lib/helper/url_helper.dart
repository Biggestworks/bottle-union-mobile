
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
  static const PRODUCT_LIST_URL = BASE_URL + '/product/publish';
  static const BRAND_LIST_URL = BASE_URL + '/brand/publish';
  static const CATEGORY_LIST_URL = BASE_URL + '/category-product/publish';
  static productDetailUrl(String id) {
    return BASE_URL + '/product/show/$id';
  }

  ///WISHLIST
  static const WISHLIST_URL = BASE_URL + '/wishlist';
  static const CHECK_WISHLIST_URL = BASE_URL + '/wishlist/check';
  static const DELETE_WISHLIST_URL = BASE_URL + '/wishlist/delete';

  ///CART
  static const CART_URL = BASE_URL + '/cart';
  static const UPDATE_CART_QTY_URL = BASE_URL + '/cart/update-qty';
  static const DELETE_CART_URL = BASE_URL + '/cart/delete';
  static const SELECT_CART_URL = BASE_URL + '/cart/selected';
  static const TOTAL_CART_URL = BASE_URL + '/cart/total';

  ///BANNER
  static const BANNER_URL = BASE_URL + '/banner';


}