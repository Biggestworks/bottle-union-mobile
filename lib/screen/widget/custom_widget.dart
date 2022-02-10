import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class CustomWidget {
  static Widget roundBtn({
    String label = 'title',
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    bool isBold = false,
    required void function(),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: btnColor,
      ),
      onPressed: () => function(),
      child: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: 16,
      ),),
    );
  }

  static Widget roundOutlinedBtn({
    String label = 'title',
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    bool isBold = false,
    required void function(),
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        side: BorderSide(
          color: btnColor,
        ),
      ),
      onPressed: () => function(),
      child: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: 16,
      ),),
    );
  }

  static showSheet(
      {required BuildContext context, required Widget child, bool scroll = false}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: scroll,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0)),
        ),
        builder: (BuildContext bc) {
          return child;
        });
  }

  static Widget roundIconBtn({
    String label = 'title',
    required IconData icon,
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    Color icColor = Colors.white,
    bool isBold = false,
    required void function(),
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: btnColor,
      ),
      onPressed: () => function(),
      icon: Icon(icon, color: icColor,),
      label: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: 16,
      ),),
    );
  }

  static Widget circleIconBtn({
    required IconData icon,
    Color btnColor = Colors.white,
    Color icColor = Colors.white,
    bool isBold = false,
    required void function(),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: btnColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => function(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: icColor, size: 20,),
      ),
    );
  }

  static showSnackBar({
    required BuildContext context,
    required Widget content,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content,));
  }

  static showConfirmationDialog(
      BuildContext context, {
        String desc = '',
        required void function(),
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          content: new Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(FontAwesomeIcons.infoCircle, color: Colors.blue,),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(AppLocalizations.instance.text('TXT_CONFIRMATION'), style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: CustomColor.MAIN,
                  thickness: 2,
                  height: 30,
                ),
                Flexible(
                  child: Text(desc, style: TextStyle(
                    fontSize: 16.0,
                      color: Colors.black,),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.instance.text('TXT_CANCEL'), style: TextStyle(color: Colors.redAccent,),
              ),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text(AppLocalizations.instance.text('TXT_YES'), style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Get.back();
                function();
              },
            ),
          ],
        );
      },
    );
  }

}