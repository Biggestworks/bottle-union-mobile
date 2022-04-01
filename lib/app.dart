import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/provider/auth/forgot_password_provider.dart';
import 'package:eight_barrels/provider/auth/login_provider.dart';
import 'package:eight_barrels/provider/auth/otp_provider.dart';
import 'package:eight_barrels/provider/auth/register_provider.dart';
import 'package:eight_barrels/provider/cart/cart_list_provider.dart';
import 'package:eight_barrels/provider/checkout/delivery_provider.dart';
import 'package:eight_barrels/provider/checkout/order_finish_provider.dart';
import 'package:eight_barrels/provider/checkout/payment_provider.dart';
import 'package:eight_barrels/provider/discussion/discussion_provider.dart';
import 'package:eight_barrels/provider/home/banner_detail_provider.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/provider/product/product_by_category_provider.dart';
import 'package:eight_barrels/provider/product/product_detail_provider.dart';
import 'package:eight_barrels/provider/product/product_list_provider.dart';
import 'package:eight_barrels/provider/product/wishlist_provider.dart';
import 'package:eight_barrels/provider/profile/add_address_provider.dart';
import 'package:eight_barrels/provider/profile/address_list_provider.dart';
import 'package:eight_barrels/provider/profile/change_password_provider.dart';
import 'package:eight_barrels/provider/profile/profile_input_provider.dart';
import 'package:eight_barrels/provider/profile/profile_provider.dart';
import 'package:eight_barrels/provider/profile/update_profile_provider.dart';
import 'package:eight_barrels/provider/splash/splash_provider.dart';
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
import 'package:eight_barrels/screen/discussion/discussion_screen.dart';
import 'package:eight_barrels/screen/home/banner_detail_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/product/product_by_category_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/product/product_list_screen.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/profile/add_address_screen.dart';
import 'package:eight_barrels/screen/profile/address_list_screen.dart';
import 'package:eight_barrels/screen/profile/change_password_screen.dart';
import 'package:eight_barrels/screen/profile/profile_input_screen.dart';
import 'package:eight_barrels/screen/profile/profile_screen.dart';
import 'package:eight_barrels/screen/profile/update_profile_screen.dart';
import 'package:eight_barrels/screen/splash/splash_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_detail_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  SpecifiedLocalizationDelegate? _localeOverrideDelegate;

  Future<Locale> _getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(KeyHelper.KEY_LOCALE)) {
      return Locale(prefs.getString(KeyHelper.KEY_LOCALE)!);
    } else {
      await prefs.setString(KeyHelper.KEY_LOCALE, "en");
      return Locale("en");
    }
  }

  @override
  void initState() {
    _getLocale().then((Locale myLocale) => {
      setState(() {
        _localeOverrideDelegate = new SpecifiedLocalizationDelegate(myLocale);
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BaseHomeProvider>(
          create: (context) => BaseHomeProvider(),
        ),
        // ChangeNotifierProvider<BaseCartProvider>(
        //   create: (context) => BaseCartProvider(),
        // ),
      ],
      child: GetMaterialApp(
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
              child: BaseHomeScreen(),
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
        ],
      ),
    );
  }
}