import 'package:flutter_dotenv/flutter_dotenv.dart';

class URLHelper {
  ///BASE URL
  static final baseUrl = dotenv.get('BASE_URL', fallback: 'BASE_URL not found');

  ///AUTH
  static final loginUrl = baseUrl + '/auth/login';
  static final registerUrl = baseUrl + '/auth/register';
  static final regionUrl = baseUrl + '/region';
  static final validateAgeUrl = baseUrl + '/auth/validate/age';
  static final validateEmailPhoneUrl = baseUrl + '/auth/validate/email-phone';
  static final loginSocMedUrl = baseUrl + '/auth/login/socmed';
  static final registerSocMedUrl = baseUrl + '/auth/register/socmed';

  ///PRODUCT
  static final productListUrl = baseUrl + '/product/publish';
  static final brandListUrl = baseUrl + '/brand/publish';
  static final categoryListUrl = baseUrl + '/category-product/publish';
  static productDetailUrl(String id) => baseUrl + '/product/show/$id';
  static final popularProductListUrl = baseUrl + '/product/home';
  static final productByRegionUrl = baseUrl + '/product/recommend-from-region';

  ///WISHLIST
  static final wishlistUrl = baseUrl + '/wishlist';
  static final checkWishlistUrl = baseUrl + '/wishlist/check';
  static final deleteWishlistUrl = baseUrl + '/wishlist/delete';

  ///CART
  static final cartUrl = baseUrl + '/cart';
  static final updateCartQtyUrl = baseUrl + '/cart/update-qty';
  static final deleteCartUrl = baseUrl + '/cart/delete';
  static final selectCartUrl = baseUrl + '/cart/selected';
  static final totalCartUrl = baseUrl + '/cart/total';

  ///BANNER
  static final bannerUrl = baseUrl + '/banner';

  ///USER
  static final userUrl = baseUrl + '/auth/user';
  static final updateProfileUrl = baseUrl + '/user/update-profile';
  static final updateAvatarUrl = baseUrl + '/user/update-avatar';
  static final newPasswordUrl = baseUrl + '/user/password/new';
  static final resetPasswordUrl = baseUrl + '/user/password/reset';
  static final deleteAccountUrl = baseUrl + '/user/delete-account/confirmation';
  static final updateIdCardUrl = baseUrl + '/user/upload-identity';

  ///OTP
  static final sendOtpUrl = baseUrl + '/verification/send';
  static final validateOtpUrl = baseUrl + '/verification/validation';

  ///RAJAONGKIR
  static final roProvinceUrl = baseUrl + '/ro/province';
  static roCityUrl(String id) => baseUrl + '/ro/province/$id';

  ///ADDRESS
  static final addressUrl = baseUrl + '/address';
  static final storeAddressUrl = baseUrl + '/address/store';
  static final deleteAddressUrl = baseUrl + '/address/delete';
  static final updateAddressUrl = baseUrl + '/address/update';
  static final selectAddressUrl = baseUrl + '/address/selected';

  ///DISCUSSION
  static discussionUrl(String id) => baseUrl + '/discussion/$id';
  static final storeDiscussionUrl = baseUrl + '/discussion/store';
  static deleteDiscussionUrl(String id) => baseUrl + '/discussion/delete/$id';
  static final storeDiscussionReplyUrl = baseUrl + '/discussion/reply/store';
  static deleteDiscussionReplyUrl(String id) =>
      baseUrl + '/discussion/reply/delete/$id';

  ///DELIVERY
  static final courierUrl = baseUrl + '/courier';
  static final chooseCourierUrl = baseUrl + '/courier/choose';

  ///PAYMENT
  static final paymentMethodUrl = baseUrl + '/enabled-payment';
  static final midtransPaymentUrl = baseUrl + '/midtrans/payment';

  ///ORDER
  static final orderSummaryUrl = baseUrl + '/orders/summary';
  static final checkoutUrl = baseUrl + '/orders/checkout/';
  static final storeOrderCartUrl = checkoutUrl + 'cart';
  static final storeOrderNowUrl = checkoutUrl + 'now';
  static final finishOrderUrl = baseUrl + '/orders/finish';

  ///LOG
  static final productLogUrl = baseUrl + '/log/product';

  ///TRANSACTION
  static final transactionUrl = baseUrl + '/transactions';
  static final transactionDetailUrl = baseUrl + '/transactions/detail';
  static final uploadPaymentUrl =
      baseUrl + '/transactions/upload-proof-transfer';
  static final trackOrderUrl = baseUrl + '/transactions/tracking';

  ///PRODUCT REVIEW
  static final reviewUrl = baseUrl + '/reviews';
  static final storeReviewUrl = baseUrl + '/reviews/store';
  static reviewDetailUrl(String id) => baseUrl + '/reviews/show/$id';

  ///XENDIT URL
  static final xenditUrl = baseUrl + '/xendit';
  static final tokenIdUrl = xenditUrl + '/getTokenId';
  static final authorizationIdUrl = xenditUrl + '/getAuthorized';
  static final chargeV2Url = xenditUrl + '/v2/charge';
}
