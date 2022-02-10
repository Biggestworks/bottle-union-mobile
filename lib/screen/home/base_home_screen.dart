import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BaseHomeScreen extends StatelessWidget {
  static String tag = '/base-home-screen';

  const BaseHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<BaseHomeProvider>(context, listen: false);

    return Scaffold(
      body: PersistentTabView(
        context,
        items: _provider.navBarItem,
        screens: _provider.screenList(),
        navBarStyle: NavBarStyle.style7,
        backgroundColor: CustomColor.MAIN,
        confineInSafeArea: true,
        hideNavigationBarWhenKeyboardShows: true,
      ),
    );
  }
}
