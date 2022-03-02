import 'package:badges/badges.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BaseHomeScreen extends StatelessWidget {
  static String tag = '/base-home-screen';

  const BaseHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> _navBarItems() {
      return [
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
      ];
    }

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
