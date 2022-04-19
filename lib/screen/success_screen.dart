import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class SuccessScreen extends StatefulWidget {
  static String tag = '/success-screen';
  final String? message;
  final String? orderId;

  const SuccessScreen({Key? key, this.message, this.orderId}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as SuccessScreen;

    Widget _mainContent = Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.checkCircle, color: Colors.white, size: 100,),
            SizedBox(height: 20,),
            Text(_args.message ?? '-', style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ), textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              width: 200,
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(_args.orderId ?? '-', style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ), textAlign: TextAlign.center,),
            ),
            // Text('')
          ],
        ),
      ),
    );

    Widget _submitBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: CustomWidget.roundBtn(
          label: AppLocalizations.instance.text('TXT_BACK_TO_HOME'),
          btnColor: Colors.white,
          lblColor: CustomColor.MAIN,
          isBold: true,
          fontSize: 16,
          function: () => Get.offNamedUntil(BaseHomeScreen.tag, (route) => false, arguments: BaseHomeScreen(pageIndex: 3)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.MAIN,
      body: _mainContent,
      floatingActionButton: _submitBtn,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
