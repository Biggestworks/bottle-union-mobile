import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/cart/base_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseCartScreen extends StatefulWidget {
  static String tag = '/base-cart-screen';

  const BaseCartScreen({Key? key}) : super(key: key);

  @override
  _BaseCartScreenState createState() => _BaseCartScreenState();
}

class _BaseCartScreenState extends State<BaseCartScreen> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<BaseCartProvider>(context, listen: false);

    Widget _tabBar = Consumer<BaseCartProvider>(
      builder: (context, provider, skeleton) {
        return TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: CustomColor.MAIN,
          indicatorWeight: 2,
          labelColor: CustomColor.BROWN_TXT,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: CustomColor.BROWN_LIGHT_TXT,
          // onTap: (value) => provider.onSelectTab(value),
          tabs: [
            new Tab(
              text: AppLocalizations.instance.text('TXT_LBL_CHECKOUT'),
            ),
            new Tab(
              text: AppLocalizations.instance.text('TXT_LBL_TRACK_ORDER'),
            ),
          ],
        );
      },
    );

    Widget _mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Text(AppLocalizations.instance.text('TXT_HEADER_ORDER'), style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
        ),
        _tabBar,
        Flexible(
          child: TabBarView(children: _provider.screenList()),
        ),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.BG,
          elevation: 0,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20,),
              child: SizedBox(
                width: 120,
                child: Image.asset('assets/images/ic_logo_bu.png',),
              ),
            ),
          ],
        ),
        body: _mainContent,
      ),
    );
  }
}
