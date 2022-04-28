import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart' as key;
import 'package:eight_barrels/helper/network_connection_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/provider/auth/forgot_password_provider.dart';
import 'package:eight_barrels/provider/auth/login_provider.dart';
import 'package:eight_barrels/provider/auth/otp_provider.dart';
import 'package:eight_barrels/provider/auth/register_provider.dart';
import 'package:eight_barrels/provider/cart/cart_list_provider.dart';
import 'package:eight_barrels/provider/checkout/delivery_provider.dart';
import 'package:eight_barrels/provider/checkout/order_finish_provider.dart';
import 'package:eight_barrels/provider/checkout/payment_provider.dart';
import 'package:eight_barrels/provider/checkout/upload_payment_provider.dart';
import 'package:eight_barrels/provider/discussion/add_discussion_provider.dart';
import 'package:eight_barrels/provider/discussion/discussion_provider.dart';
import 'package:eight_barrels/provider/home/banner_detail_provider.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/provider/product/product_by_category_provider.dart';
import 'package:eight_barrels/provider/product/product_by_region_provider.dart';
import 'package:eight_barrels/provider/product/product_detail_provider.dart';
import 'package:eight_barrels/provider/product/product_list_provider.dart';
import 'package:eight_barrels/provider/product/wishlist_provider.dart';
import 'package:eight_barrels/provider/profile/add_address_provider.dart';
import 'package:eight_barrels/provider/profile/address_list_provider.dart';
import 'package:eight_barrels/provider/profile/change_password_provider.dart';
import 'package:eight_barrels/provider/profile/profile_input_provider.dart';
import 'package:eight_barrels/provider/profile/profile_provider.dart';
import 'package:eight_barrels/provider/profile/update_profile_provider.dart';
import 'package:eight_barrels/provider/review/review_input_provider.dart';
import 'package:eight_barrels/provider/splash/splash_provider.dart';
import 'package:eight_barrels/provider/transaction/track_order_provider.dart';
import 'package:eight_barrels/provider/transaction/transaction_detail_provider.dart';
import 'package:eight_barrels/provider/transaction/transaction_provider.dart';
import 'package:eight_barrels/screen/auth/forgot_password_screen.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/auth/otp_screen.dart';
import 'package:eight_barrels/screen/auth/register_screen.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/cart/base_cart_screen.dart';
import 'package:eight_barrels/screen/cart/cart_list_screen.dart';
import 'package:eight_barrels/screen/checkout/delivery_screen.dart';
import 'package:eight_barrels/screen/checkout/midtrans_webview_screen.dart';
import 'package:eight_barrels/screen/checkout/order_finish_screen.dart';
import 'package:eight_barrels/screen/checkout/payment_screen.dart';
import 'package:eight_barrels/screen/checkout/upload_payment_screen.dart';
import 'package:eight_barrels/screen/discussion/add_discussion_screen.dart';
import 'package:eight_barrels/screen/discussion/discussion_screen.dart';
import 'package:eight_barrels/screen/home/banner_detail_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/product/product_by_category_screen.dart';
import 'package:eight_barrels/screen/product/product_by_region_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/product/product_list_screen.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/profile/add_address_screen.dart';
import 'package:eight_barrels/screen/profile/address_list_screen.dart';
import 'package:eight_barrels/screen/profile/change_password_screen.dart';
import 'package:eight_barrels/screen/profile/contact_us_screen.dart';
import 'package:eight_barrels/screen/profile/profile_input_screen.dart';
import 'package:eight_barrels/screen/profile/profile_screen.dart';
import 'package:eight_barrels/screen/profile/update_profile_screen.dart';
import 'package:eight_barrels/screen/review/review_input_screen.dart';
import 'package:eight_barrels/screen/splash/onboarding_screen.dart';
import 'package:eight_barrels/screen/splash/splash_screen.dart';
import 'package:eight_barrels/screen/misc/success_screen.dart';
import 'package:eight_barrels/screen/transaction/track_order_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_detail_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uni_links/uni_links.dart';

import 'home/notification_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  NetworkConnectionHelper _networkConnectionHelper = new NetworkConnectionHelper();
  SpecifiedLocalizationDelegate? _localeOverrideDelegate;
  StreamSubscription<ConnectivityResult>? _connectivitySubs;
  bool _initialURILinkHandled = false;

  StreamSubscription? _linkSubs;

  Future<Locale> _getLocale() async {
    final _storage = new FlutterSecureStorage();
    bool _isExist = await _storage.containsKey(key: key.KeyHelper.KEY_LOCALE);
    if (_isExist) {
      String? _locale = await _storage.read(key: key.KeyHelper.KEY_LOCALE);
      return Locale(_locale!);
    } else {
      await _storage.write(key: key.KeyHelper.KEY_LOCALE, value: "en");
      return Locale("en");
    }
  }

  Future _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      print('Invoked _initURIHandler');
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
      }
    }
  }

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _linkSubs = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
      });
    }
  }

  @override
  void initState() {
    // _networkConnectionHelper.initConnectivity(subscription: _connectivitySubs, context: context);
    _getLocale().then((Locale myLocale) => {
      setState(() {
        _localeOverrideDelegate = new SpecifiedLocalizationDelegate(myLocale);
      })
    });
    _initURIHandler();
    _incomingLinkHandler();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubs?.cancel();
    _linkSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BaseHomeProvider>(
          create: (context) => BaseHomeProvider(),
        ),
      ],
      child: GetMaterialApp(
        // navigatorKey: PushNotificationManager.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Futura',
        ),
        localizationsDelegates: [
          if (_localeOverrideDelegate != null) _localeOverrideDelegate!,
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('id', ''),
        ],
        initialRoute: SplashScreen.tag,
        getPages: [
          GetPage(
            name: SplashScreen.tag,
            page: () => ChangeNotifierProvider<SplashProvider>(
              create: (context) => SplashProvider(),
              child: SplashScreen(),
            ),
          ),
          GetPage(
            name: StartScreen.tag,
            page: () => StartScreen(),
          ),
          GetPage(
            name: LoginScreen.tag,
            page: () => ChangeNotifierProvider<LoginProvider>(
              create: (context) => LoginProvider(),
              child: LoginScreen(),
            ),
          ),
          GetPage(
            name: RegisterScreen.tag,
            page: () => ChangeNotifierProvider<RegisterProvider>(
              create: (context) => RegisterProvider(),
              child: RegisterScreen(),
            ),
          ),
          GetPage(
            name: BaseHomeScreen.tag,
            page: () => MultiProvider(
              providers: [
                ChangeNotifierProvider<HomeProvider>(
                  create: (context) => HomeProvider(),
                ),
                ChangeNotifierProvider<ProductListProvider>(
                  create: (context) => ProductListProvider(),
                ),
                ChangeNotifierProvider<CartListProvider>(
                  create: (context) => CartListProvider(),
                ),
                ChangeNotifierProvider<TransactionProvider>(
                  create: (context) => TransactionProvider(),
                ),
              ],
              child: ShowCaseWidget(
                onFinish: () async {
                  final _storage = new FlutterSecureStorage();
                  await _storage.write(key: key.KeyHelper.KEY_IS_FIRST_TIME, value: 'false');
                },
                builder: Builder(
                  builder: (context) =>  BaseHomeScreen(),
                ),
              ),
            ),
          ),
          GetPage(
            name: HomeScreen.tag,
            page: () => HomeScreen(),
          ),
          GetPage(
            name: ProductListScreen.tag,
            page: () => ProductListScreen(),
          ),
          GetPage(
            name: ProductDetailScreen.tag,
            page: () => ChangeNotifierProvider<ProductDetailProvider>(
              create: (context) => ProductDetailProvider(),
              child: ProductDetailScreen(),
            ),
          ),
          GetPage(
            name: ProductByCategoryScreen.tag,
            page: () => ChangeNotifierProvider<ProductByCategoryProvider>(
              create: (context) => ProductByCategoryProvider(),
              child: ProductByCategoryScreen(),
            ),
          ),
          GetPage(
            name: ProfileScreen.tag,
            page: () => ChangeNotifierProvider<ProfileProvider>(
              create: (context) => ProfileProvider(),
              child: ProfileScreen(),
            ),
          ),
          GetPage(
            name: WishListScreen.tag,
            page: () => ChangeNotifierProvider<WishListProvider>(
              create: (context) => WishListProvider(),
              child: WishListScreen(),
            ),
          ),
          GetPage(
            name: BaseCartScreen.tag,
            page: () => BaseCartScreen(),
          ),
          GetPage(
            name: CartListScreen.tag,
            page: () => CartListScreen(),
          ),
          GetPage(
            name: DeliveryScreen.tag,
            page: () => ChangeNotifierProvider<DeliveryProvider>(
              create: (context) => DeliveryProvider(),
              child: DeliveryScreen(),
            ),
          ),
          GetPage(
            name: UpdateProfileScreen.tag,
            page: () => ChangeNotifierProvider<UpdateProfileProvider>(
              create: (context) => UpdateProfileProvider(),
              child: UpdateProfileScreen(),
            ),
          ),
          GetPage(
            name: ProfileInputScreen.tag,
            page: () => ChangeNotifierProvider<ProfileInputProvider>(
              create: (context) => ProfileInputProvider(),
              child: ProfileInputScreen(),
            ),
          ),
          GetPage(
            name: ChangePasswordScreen.tag,
            page: () => ChangeNotifierProvider<ChangePasswordProvider>(
              create: (context) => ChangePasswordProvider(),
              child: ChangePasswordScreen(),
            ),
          ),
          GetPage(
            name: ForgotPasswordScreen.tag,
            page: () => ChangeNotifierProvider<ForgotPasswordProvider>(
              create: (context) => ForgotPasswordProvider(),
              child: ForgotPasswordScreen(),
            ),
          ),
          GetPage(
            name: OtpScreen.tag,
            page: () => ChangeNotifierProvider<OtpProvider>(
              create: (context) => OtpProvider(),
              child: OtpScreen(),
            ),
          ),
          GetPage(
            name: AddressListScreen.tag,
            page: () => ChangeNotifierProvider<AddressListProvider>(
              create: (context) => AddressListProvider(),
              child: AddressListScreen(),
            ),
          ),
          GetPage(
            name: BannerDetailScreen.tag,
            page: () => ChangeNotifierProvider<BannerDetailProvider>(
              create: (context) => BannerDetailProvider(),
              child: BannerDetailScreen(),
            ),
          ),
          GetPage(
            name: AddAddressScreen.tag,
            page: () => ChangeNotifierProvider<AddAddressProvider>(
              create: (context) => AddAddressProvider(),
              child: AddAddressScreen(),
            ),
          ),
          GetPage(
            name: PaymentScreen.tag,
            page: () => ChangeNotifierProvider<PaymentProvider>(
              create: (context) => PaymentProvider(),
              child: PaymentScreen(),
            ),
          ),
          GetPage(
            name: OrderFinishScreen.tag,
            page: () => ChangeNotifierProvider<OrderFinishProvider>(
              create: (context) => OrderFinishProvider(),
              child: OrderFinishScreen(),
            ),
          ),
          GetPage(
            name: TransactionScreen.tag,
            page: () => TransactionScreen(),
          ),
          GetPage(
            name: MidtransWebviewScreen.tag,
            page: () => MidtransWebviewScreen(),
          ),
          GetPage(
            name: DiscussionScreen.tag,
            page: () => ChangeNotifierProvider<DiscussionProvider>(
              create: (context) => DiscussionProvider(),
              child: DiscussionScreen(),
            ),
          ),
          GetPage(
            name: TransactionDetailScreen.tag,
            page: () => ChangeNotifierProvider<TransactionDetailProvider>(
              create: (context) => TransactionDetailProvider(),
              child: TransactionDetailScreen(),
            ),
          ),
          GetPage(
            name: AddDiscussionScreen.tag,
            page: () => ChangeNotifierProvider<AddDiscussionProvider>(
              create: (context) => AddDiscussionProvider(),
              child: AddDiscussionScreen(),
            ),
          ),
          GetPage(
            name: ProductByRegionScreen.tag,
            page: () => ChangeNotifierProvider<ProductByRegionProvider>(
              create: (context) => ProductByRegionProvider(),
              child: ProductByRegionScreen(),
            ),
          ),
          GetPage(
            name: UploadPaymentScreen.tag,
            page: () => ChangeNotifierProvider<UploadPaymentProvider>(
              create: (context) => UploadPaymentProvider(),
              child: UploadPaymentScreen(),
            ),
          ),
          GetPage(
            name: SuccessScreen.tag,
            page: () => SuccessScreen(),
          ),
          GetPage(
            name: TrackOrderScreen.tag,
            page: () => ChangeNotifierProvider<TrackOrderProvider>(
              create: (context) => TrackOrderProvider(),
              child: TrackOrderScreen(),
            ),
          ),
          GetPage(
            name: OnBoardingScreen.tag,
            page: () => OnBoardingScreen(),
          ),
          GetPage(
            name: ReviewInputScreen.tag,
            page: () => ChangeNotifierProvider<ReviewInputProvider>(
              create: (context) => ReviewInputProvider(),
              child: ReviewInputScreen(),
            ),
          ),
          GetPage(
            name: ContactUsScreen.tag,
            page: () => ContactUsScreen(),
          ),
          GetPage(
            name: NotificationScreen.tag,
            page: () => NotificationScreen(),
          ),
        ],
      ),
    );
  }
}