import 'package:badges/badges.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BaseHomeScreen extends StatefulWidget {
  static String tag = '/base-home-screen';
  final int? pageIndex;

  const BaseHomeScreen({Key? key, this.pageIndex}) : super(key: key);

  @override
  _BaseHomeScreenState createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<BaseHomeProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<BaseHomeProvider>(context, listen: false).fnGetCartCount();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BaseHomeProvider>(
        builder: (context, provider, _) => provider.screenList(),
      ),
      bottomNavigationBar: Consumer<BaseHomeProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomColor.MAIN,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              currentIndex: provider.pageIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(FontAwesomeIcons.home),
                  ),
                  label: AppLocalizations.instance.text('TXT_NAV_HOME'),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(FontAwesomeIcons.wineBottle),
                  ),
                  label: AppLocalizations.instance.text('TXT_NAV_PRODUCT'),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Consumer<BaseHomeProvider>(
                        builder: (context, provider, _) {
                          return Badge(
                            badgeContent: Text(provider.cartCount.toString(), style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),),
                            badgeColor: CustomColor.BROWN_TXT,
                            padding: EdgeInsets.all(6),
                            child: Icon(FontAwesomeIcons.shoppingCart),
                          );
                        }
                    ),
                  ),
                  label: AppLocalizations.instance.text('TXT_NAV_CART'),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(FontAwesomeIcons.history),
                  ),
                  label: AppLocalizations.instance.text('TXT_NAV_TRANSACTION'),
                ),
              ],
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: false,
              iconSize: 18,
              selectedFontSize: 14,
              onTap: provider.fnOnNavBarSelected,
            ),
          );
        },
      ),
    );
  }
}
