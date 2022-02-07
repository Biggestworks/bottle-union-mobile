import 'package:eight_barrels/helper/app-localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/provider/auth/login_provider.dart';
import 'package:eight_barrels/provider/auth/register_provider.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/provider/splash/splash_provider.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/auth/register_screen.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/splash/splash_screen.dart';
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
      await prefs.setString(KeyHelper.KEY_LOCALE, "id");
      return Locale("id");
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
    return GetMaterialApp(
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
          page: () => ChangeNotifierProvider<RegisterProvider>(
            create: (context) => RegisterProvider(),
            child: StartScreen(),
          ),
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
          name: HomeScreen.tag,
          page: () => ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider(),
            child: HomeScreen(),
          ),
        ),
      ],
    );
  }
}