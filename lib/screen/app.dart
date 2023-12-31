import 'dart:async';

import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart' as key;
import 'package:eight_barrels/helper/network_connection_helper.dart';
import 'package:eight_barrels/provider/auth/login_provider.dart';
import 'package:eight_barrels/provider/auth/otp_provider.dart';
import 'package:eight_barrels/provider/auth/register_provider.dart';
import 'package:eight_barrels/provider/cart/cart_list_provider.dart';
import 'package:eight_barrels/provider/checkout/delivery_buy_provider.dart';
import 'package:eight_barrels/provider/checkout/delivery_cart_provider.dart';
import 'package:eight_barrels/provider/checkout/order_finish_provider.dart';
import 'package:eight_barrels/provider/checkout/payment_provider.dart';
import 'package:eight_barrels/provider/checkout/upload_payment_provider.dart';
import 'package:eight_barrels/provider/discussion/add_discussion_provider.dart';
import 'package:eight_barrels/provider/discussion/discussion_provider.dart';
import 'package:eight_barrels/provider/home/banner_detail_provider.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/home/guest_home_provider.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/provider/home/notification_provider.dart';
import 'package:eight_barrels/provider/product/guest_product_detail_provider.dart';
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
import 'package:eight_barrels/screen/auth/fp_webview_screen.dart';
import 'package:eight_barrels/screen/auth/guest_start_screen.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/auth/otp_screen.dart';
import 'package:eight_barrels/screen/auth/register_screen.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/auth/tac_webview_screen.dart';
import 'package:eight_barrels/screen/cart/base_cart_screen.dart';
import 'package:eight_barrels/screen/cart/cart_list_screen.dart';
import 'package:eight_barrels/screen/checkout/delivery_buy_screen.dart';
import 'package:eight_barrels/screen/checkout/delivery_cart_screen.dart';
import 'package:eight_barrels/screen/checkout/midtrans_webview_screen.dart';
import 'package:eight_barrels/screen/checkout/order_finish_screen.dart';
import 'package:eight_barrels/screen/checkout/payment_screen.dart';
import 'package:eight_barrels/screen/checkout/upload_payment_screen.dart';
import 'package:eight_barrels/screen/discussion/add_discussion_screen.dart';
import 'package:eight_barrels/screen/discussion/discussion_screen.dart';
import 'package:eight_barrels/screen/home/banner_detail_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/home/guest_home_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/home/member_loyalty_screen.dart';
import 'package:eight_barrels/screen/id_card/id_card_screen.dart';
import 'package:eight_barrels/screen/misc/success_screen.dart';
import 'package:eight_barrels/screen/product/guest_product_detail_screen.dart';
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
import 'package:eight_barrels/screen/transaction/invoice_webview_screen.dart';
import 'package:eight_barrels/screen/transaction/track_order_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_detail_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uni_links/uni_links.dart';

import 'home/notification_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldMessengerState> _snackBarKey =
      GlobalKey<ScaffoldMessengerState>();
  NetworkConnectionHelper _networkConnectionHelper =
      new NetworkConnectionHelper();
  SpecifiedLocalizationDelegate? _localeOverrideDelegate;
  StreamSubscription<InternetConnectionStatus>? _connectionSubs;
  bool _initialURILinkHandled = false;
  StreamSubscription? _linkSubs;
  List<SingleChildWidget> _providerList = [];

  Future<Locale> _getLocale() async {
    final _storage = new FlutterSecureStorage();
    bool _isExist = await _storage.containsKey(key: key.KeyHelper.KEY_LOCALE);
    if (_isExist) {
      String _locale =
          await _storage.read(key: key.KeyHelper.KEY_LOCALE) ?? "en";
      return Locale(_locale);
    } else {
      await _storage.write(key: key.KeyHelper.KEY_LOCALE, value: "en");
      return Locale("en");
    }
  }

  /// START DEEPLINK CONFIGURATION
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
      }
    }
  }

  Future _incomingLinkHandler() async {
    if (!kIsWeb) {
      _linkSubs = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        if (uri?.queryParameters['product_id'] != null) {
          Get.toNamed(
            ProductDetailScreen.tag,
            arguments: ProductDetailScreen(
              productId: int.parse(uri?.queryParameters['product_id'] ?? ''),
            ),
          );
        }
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
      });
    }
  }

  /// END DEEPLINK CONFIGURATION

  @override
  void initState() {
    Future.delayed(Duration.zero).whenComplete(() async {
      // await getProviderList();
      await _networkConnectionHelper.checkConnection(
          subscription: _connectionSubs, context: context);
      await _getLocale().then((Locale myLocale) => {
            setState(() {
              _localeOverrideDelegate =
                  new SpecifiedLocalizationDelegate(myLocale);
            })
          });
      await _initURIHandler();
      await _incomingLinkHandler();
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectionSubs?.cancel();
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
        scaffoldMessengerKey: _snackBarKey,
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
              // providers: _providerList,
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
                ChangeNotifierProvider<GuestHomeProvider>(
                  create: (context) => GuestHomeProvider(),
                ),
              ],
              child: ShowCaseWidget(
                onFinish: () async {
                  final _storage = new FlutterSecureStorage();
                  await _storage.write(
                      key: key.KeyHelper.KEY_IS_FIRST_TIME, value: 'false');
                },
                builder: Builder(
                  builder: (context) => BaseHomeScreen(),
                ),
              ),
            ),
          ),
          GetPage(
            name: HomeScreen.tag,
            page: () => HomeScreen(),
          ),

          /// get
          GetPage(
            name: IdCardScreen.tag,
            page: () => IdCardScreen(),
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
            name: DeliveryCartScreen.tag,
            page: () => ChangeNotifierProvider<DeliveryCartProvider>(
              create: (context) => DeliveryCartProvider(),
              child: DeliveryCartScreen(),
            ),
          ),
          GetPage(
            name: DeliveryBuyScreen.tag,
            page: () => ChangeNotifierProvider<DeliveryBuyProvider>(
              create: (context) => DeliveryBuyProvider(),
              child: DeliveryBuyScreen(),
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
            page: () => ChangeNotifierProvider<NotificationProvider>(
              create: (context) => NotificationProvider(),
              child: NotificationScreen(),
            ),
          ),
          GetPage(
            name: InvoiceWebviewScreen.tag,
            page: () => InvoiceWebviewScreen(),
          ),
          GetPage(
            name: MemberLoyaltyScreen.tag,
            page: () => MemberLoyaltyScreen(),
          ),
          GetPage(
            name: TacWebviewScreen.tag,
            page: () => TacWebviewScreen(),
          ),
          GetPage(name: FbWebviewScreen.tag, page: () => FbWebviewScreen()),
          GetPage(
            name: GuestHomeScreen.tag,
            page: () => GuestHomeScreen(),
          ),
          GetPage(
            name: GuestStartScreen.tag,
            page: () => GuestStartScreen(),
          ),
          GetPage(
            name: GuestProductDetailScreen.tag,
            page: () => ChangeNotifierProvider<GuestProductDetailProvider>(
              create: (context) => GuestProductDetailProvider(),
              child: GuestProductDetailScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
