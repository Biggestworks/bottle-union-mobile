import 'dart:io';

class URLHelper {
  // static const BASE_URL = 'https://bottleunion.com/api'; //DEVELOPMENT

  // static const BASE_URL = 'https://helpdesk.erakomp.co.id/api'; //PRODUCTION

  // static const String BASE_URL = 'http://10.10.10.120:8001/api'; // LOCAL

  static const String BASE_URL = 'http://127.0.0.1:8001/api'; // LOCAL IOS

  static const SSO_BASE_URL = 'https://www.erakomp.co.id:4443/api/';

  static getAddressListUrl(String id) {
    return BASE_URL + '/users/$id/addresses';
  }

  static getAddressDetailUrl(String id, String addressId) {
    return BASE_URL + '/users/$id/addresses/$addressId';
  }

  static getAddAddressUrl(String id) {
    return BASE_URL + '/users/$id/addresses';
  }

  static getUpdateAddressUrl(String id, String addressId) {
    return BASE_URL + '/users/$id/addresses/$addressId';
  }

  static const BRAND_LIST_URL = BASE_URL + '/brands';

  static const PRODUCT_LIST = BASE_URL + '/products';

  static const CREATE_PRODUCT_URL = BASE_URL + '/products';

  static const CSO_NUMBER_URL = BASE_URL + '/newcsonumber';

  static const CREATE_REPAIR = BASE_URL + '/repairs';

  static getUpdateRepairUrl(String repairId) {
    return BASE_URL + '/repairs/$repairId';
  }

  static getAddProductToRepairUrl(String repairId) {
    return BASE_URL + '/repairs/$repairId/products';
  }

  static getUpdateProductInRepairUrl(String repairId, String productId) {
    return BASE_URL + '/repairs/$repairId/products/$productId';
  }

  static const REPAIR_LIST = BASE_URL + '/repairs';

  static const REPAIR_TRACKING = BASE_URL + '/services/check';

  static const LOGIN_URL = BASE_URL + '/login';

  static const REGISTER_URL = BASE_URL + '/register';

  static getCustomerUrl(String id) {
    return BASE_URL + '/customers?per_page=1000&user_id=$id';
  }

  static const GET_USER_URL = BASE_URL + '/auth/user';

  static createRepairHistoryUrl(String repairId) {
    return BASE_URL + '/repairs/$repairId/histories';
  }

  static const UPLOAD_IMAGE_URL = BASE_URL + '/uploads/helpdesk';

  static const FCM_URL = 'https://fcm.googleapis.com/fcm/send';

  static const MAP_URL = 'https://timeline.chunchiawjap.com/api/signedMapUrl';

  static deleteRepairHistoryUrl(String repairId) {
    return BASE_URL + '/repairs/$repairId';
  }

  static const RESET_PASSWORD_SSO_URL = SSO_BASE_URL + 'user/reset';

  static updateUser(String uid) {
    return BASE_URL + '/users/$uid';
  }

  static updateCustomer(String uid) {
    return BASE_URL + '/customers/$uid';
  }

  static uploadAvatar(String uid) {
    return BASE_URL + '/uploads/avatar/$uid';
  }

  static const CHANGE_PASSWORD_URL = BASE_URL + '/auth/password';

  static uploadRepairProductImage(String repairId, String productId) {
    return BASE_URL + '/uploads/repairs/$repairId/products/$productId';
  }

  static const FORGOT_PASSWORD = BASE_URL + '/auth/forgot';

  static const CHAT_LIST = BASE_URL + '/chat';

  static whatsUpUrl(String flag, {String? trackingId}) {
    if (flag == 'tracking') {
      return 'https://wa.me/0216349318?text=Halo%20Persada,%20Saya%20ingin%20bertanya%20tentang%20order%20dengan%20nomor%20$trackingId';
    } else if (flag == 'order') {
      return 'https://wa.me/0216349318?text=Halo%20Persada,%20Saya%20ingin%20bertanya%20tentang%20cara%20untuk%20order%20';
    } else {
      return null;
    }
  }

  static const CATEGORY_LIST_URL = BASE_URL + '/categories';

  static const NOTIFICATION_ORDER_URL = BASE_URL + '/notification/order';

  static const TRANSACTION_HISTORY_URL = BASE_URL + '/transactions';

}