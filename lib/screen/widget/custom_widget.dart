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
  
  static Widget productCard({
    required BuildContext context, 
    required Data data,
    required void function(),
    void wishlistFunc()?,
    void cartFunc()?,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: InkWell(
          onTap: () => function(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: data.image1 ?? '',
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name ?? '-', style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.solidStar, color: Colors.orangeAccent, size: 16,),
                              SizedBox(width: 5,),
                              Text(data.rating != null ? data.rating.toString() : '0', style: TextStyle(
                                fontSize: 12,
                              ),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Flexible(
                            child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColor.MAIN_TXT,
                              fontSize: 16,
                            ),),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Stock: ${data.stock ?? '0'}', style: TextStyle(
                              color: CustomColor.GREY_TXT,
                            ),),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => cartFunc!(),
                                    child: Icon(FontAwesomeIcons.shoppingCart, color: CustomColor.GREY_ICON, size: 18,),
                                  ),
                                  SizedBox(width: 15,),
                                  GestureDetector(
                                    onTap: () => wishlistFunc!(),
                                    child: Icon(FontAwesomeIcons.heart, color: CustomColor.GREY_ICON, size: 18,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

}