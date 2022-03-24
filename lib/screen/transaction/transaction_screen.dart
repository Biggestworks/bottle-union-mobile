import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  static String tag = '/transaction-screen';
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {

    Widget _mainContent = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(AppLocalizations.instance.text('TXT_HEADER_TRANSACTION'), style: TextStyle(
              color: CustomColor.BROWN_TXT,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
          ),
          SizedBox(height: 5,),
          CustomWidget.underConstructionPage(),
          // _cartListContent,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        elevation: 0,
        // centerTitle: true,
        // title: SizedBox(
        //   width: 150,
        //   child: Image.asset('assets/images/ic_logo_bu_white.png',),
        // ),
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
    );
  }
}
