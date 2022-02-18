import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidget {
  static Widget roundBtn({
    String label = 'title',
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    bool isBold = false,
    double fontSize = 14,
    double? radius,
    required void function(),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: radius == null
            ? StadiumBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius),),
        primary: btnColor,
      ),
      onPressed: () => function(),
      child: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: fontSize,
      ),),
    );
  }

  static Widget roundOutlinedBtn({
    String label = 'title',
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    bool isBold = false,
    double fontSize = 14,
    double? radius,
    required void function(),
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: radius == null
            ? StadiumBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius),),
        side: BorderSide(
          color: btnColor,
        ),
      ),
      onPressed: () => function(),
      child: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: fontSize,
      ),),
    );
  }

  static Widget roundIconBtn({
    String label = 'title',
    required IconData icon,
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    Color icColor = Colors.white,
    bool isBold = false,
    double fontSize = 14,
    double icSize = 20,
    double? radius,
    required void function(),
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: radius == null
            ? StadiumBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius),),
        primary: btnColor,
      ),
      onPressed: () => function(),
      icon: Icon(icon, color: icColor, size: icSize,),
      label: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: fontSize,
      ),),
    );
  }

  static Widget textIconBtn({
    String label = 'title',
    required IconData icon,
    Color lblColor = Colors.black,
    Color icColor = Colors.white,
    bool isBold = false,
    double fontSize = 14,
    double icSize = 20,
    required void function(),
  }) {
    return TextButton.icon(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => function(),
      icon: Icon(icon, color: icColor, size: icSize,),
      label: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: fontSize,
      ),),
    );
  }

  static showSheet({
    required BuildContext context,
    required Widget child,
    bool isScroll = false,
    bool isRounded = false,}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScroll,
      enableDrag: true,
      shape: isRounded ? RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0)),
      ) : null,
      builder: (BuildContext bc) {
        return child;
      },
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
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  static showSuccessDialog(
      BuildContext context, {
        String title = 'SUCCESS!',
        String desc = '',
        required void function(),
      }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: CustomColor.MAIN,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(MediaQuery.of(context).size.width, 200.0),
                    top: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(desc, textAlign: TextAlign.center,),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.instance.text('TXT_YES'), style: TextStyle(
                color: CustomColor.MAIN,),
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

  static showShimmerGridList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          childAspectRatio: 0.65,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(20),
              ),
              child: Container(),
            ),
          );
        },
      ),
    );
  }

  static showShimmerListView() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20),
            ),
            child: Container(
              height: 150,
            ),
          );
        },
      ),
    );
  }

  static showShimmerProductDetail() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 300,
                color: Colors.white,
              )
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget networkImg(BuildContext context, String? url) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      fit: BoxFit.fill,
      placeholder: (context, url) => Center(
          child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
    );
  }

  static Widget emptyScreen({required String image, String title = 'Title'}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 220,
              width: 220,
              child: Image.asset(image,),
            ),
            Text(title, style: TextStyle(
              color: CustomColor.GREY_TXT,
            ),)
          ],
        ),
      ),
    );
  }

  static Widget underConstructionPage() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset('assets/images/ic_under_construction.jpg'),
          ),
          SizedBox(height: 10,),
          Text('Under Construction ...', style: TextStyle(
            fontSize: 20,
          ),),
        ],
      ),
    );
  }

}