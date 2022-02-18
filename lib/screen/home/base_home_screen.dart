import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseHomeScreen extends StatelessWidget {
  static String tag = '/base-home-screen';

  const BaseHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<BaseHomeProvider>(context, listen: false);

    return Scaffold(
      body: Consumer<BaseHomeProvider>(
        builder: (context, provider, _) => provider.screenList(),
      ),
      bottomNavigationBar: Consumer<BaseHomeProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          switch (provider.navBarItems().length) {
            case (0):
              return skeleton!;
            default:
              return Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: CustomColor.MAIN,
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  currentIndex: provider.pageIndex,
                  items: provider.navBarItems(),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  showUnselectedLabels: false,
                  iconSize: 18,
                  selectedFontSize: 14,
                  onTap: provider.fnOnNavBarSelected,
                ),
              );
          }
        },
      ),
    );
  }
}
