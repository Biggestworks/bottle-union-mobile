import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/auth/tac_webview_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
        backgroundColor: btnColor,
      ),
      onPressed: () => function(),
      child: Text(
        label,
        style: TextStyle(
          color: lblColor,
          fontWeight: isBold ? FontWeight.bold : null,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
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
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
        side: BorderSide(
          color: btnColor,
        ),
      ),
      onPressed: () => function(),
      child: Text(
        label,
        style: TextStyle(
          color: lblColor,
          fontWeight: isBold ? FontWeight.bold : null,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
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
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
        backgroundColor: btnColor,
      ),
      onPressed: () => function(),
      icon: Icon(
        icon,
        color: icColor,
        size: icSize,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: lblColor,
          fontWeight: isBold ? FontWeight.bold : null,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
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
        padding: EdgeInsets.zero,
      ),
      onPressed: () => function(),
      icon: Icon(
        icon,
        color: icColor,
        size: icSize,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: lblColor,
          fontWeight: isBold ? FontWeight.bold : null,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static showSheet({
    required BuildContext context,
    required Widget child,
    bool isScroll = false,
    bool isRounded = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScroll,
      enableDrag: true,
      shape: isRounded
          ? RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0)),
            )
          : null,
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
        backgroundColor: btnColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => function(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          color: icColor,
          size: 20,
        ),
      ),
    );
  }

  static showSnackBar({
    required BuildContext context,
    required Widget content,
    int duration = 1,
    SnackBarAction? action,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        action: action ?? null,
      ),
    );
  }

  static showConfirmationDialog(
    BuildContext context, {
    String desc = '',
    required void function(),
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circleInfo,
                      color: CustomColor.MAIN,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        AppLocalizations.instance.text('TXT_CONFIRMATION'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                  child: Text(
                    desc,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  AppLocalizations.instance.text('TXT_CANCEL'),
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () => Get.back(),
              ),
              TextButton(
                child: Text(
                  AppLocalizations.instance.text('TXT_YES'),
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Get.back();
                  function();
                },
              ),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
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
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: CustomColor.MAIN,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width, 200.0),
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
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    desc,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.instance.text('TXT_UNDERSTAND'),
                style: TextStyle(
                  color: CustomColor.MAIN,
                ),
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

  static showShimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: child,
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
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20),
            ),
            child: Container(),
          );
        },
      ),
    );
  }

  static showShimmerListView({double height = 150}) {
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
              height: height,
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
              )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
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

  static Widget networkImg(BuildContext context, String? url,
      {BoxFit? fit = BoxFit.fill}) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      fit: fit,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.no_photography,
          size: 50,
          color: CustomColor.GREY_ICON,
        ),
      ),
    );
  }

  static Widget roundedAvatarImg(
      {required String url,
      double? size,
      Color borderColor = Colors.white,
      BoxFit fit = BoxFit.cover}) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: size ?? 150,
          height: size ?? 150,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        );
      },
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        width: size ?? 150,
        height: size ?? 150,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white),
          color: Colors.white,
          image: new DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage("assets/images/ic_profile.png"),
          ),
        ),
      ),
    );
  }

  static Widget emptyScreen({
    required String image,
    String title = 'Title',
    double size = 220,
    Color? icColor,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: Image.asset(
                image,
                color: icColor,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: CustomColor.GREY_TXT,
              ),
            ),
            if (action != null)
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  action,
                ],
              )
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
          SizedBox(
            height: 10,
          ),
          Text(
            'Under Construction ...',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  static Widget loadingHud({required bool isLoad, required Widget child}) {
    return ModalProgressHUD(
      inAsyncCall: isLoad,
      progressIndicator: SpinKitFadingCube(
        color: CustomColor.MAIN,
        size: 40,
      ),
      opacity: 0.5,
      child: child,
    );
  }

  static showInfoPopup(
    BuildContext context, {
    String desc = '',
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 20),
          titlePadding: EdgeInsets.all(10),
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Text('Info', style: TextStyle(
              //   color: CustomColor.MAIN,
              // ),),
              GestureDetector(
                onTap: () => Get.back(),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close),
                ),
              ),
            ],
          ),
          content: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Text(
                desc,
                textAlign: TextAlign.center,
              ),
              Positioned(
                top: -80,
                child: CircleAvatar(
                  backgroundColor: CustomColor.MAIN,
                  radius: 30,
                  child: Icon(
                    FontAwesomeIcons.info,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static showCartConfirmationDialog(
    BuildContext context, {
    String desc = '',
    required void fnDeleteCart(),
    required void fnStoreWishlist(),
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          contentPadding: EdgeInsets.fromLTRB(15, 20, 15, 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  desc,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          color: CustomColor.MAIN,
                        ),
                      ),
                      onPressed: () => fnStoreWishlist(),
                      child: Text(
                        AppLocalizations.instance.text('TXT_GOTO_WISHLIST'),
                        style: TextStyle(
                          color: CustomColor.MAIN,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: CustomColor.MAIN,
                      ),
                      onPressed: () => fnDeleteCart(),
                      child: Text(
                        AppLocalizations.instance.text('TXT_DELETE'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget checkoutLoadingPage(GlobalKey<ScaffoldState> scaffoldKey) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: CustomColor.MAIN,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitChasingDots(
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Placing Order...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  static showTacDialog(
    BuildContext context, {
    bool isTacAccepted = false,
    required void fnOnCheckTac(value),
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.instance.text('TXT_TERM_AND_CONDITION'),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Divider(
                  color: CustomColor.MAIN,
                  thickness: 2,
                  height: 30,
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.instance
                        .text('TXT_TERM_AND_CONDITION_INFO_4'),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isTacAccepted,
                    onChanged: (value) => fnOnCheckTac(value),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.blue,
                  ),
                  Flexible(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: AppLocalizations.instance
                              .text('TXT_TERM_AND_CONDITION_INFO_1'),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' ${AppLocalizations.instance.text('TXT_TERM_AND_CONDITION')} ',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(TacWebviewScreen.tag),
                        ),
                        TextSpan(
                          text: AppLocalizations.instance
                              .text('TXT_TERM_AND_CONDITION_INFO_2'),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ]),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static showDeleteAccountDialog(
    BuildContext context, {
    String desc = '',
    required void function(),
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 15, 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Text(
              'Warning',
              style: TextStyle(
                color: CustomColor.MAIN,
                fontWeight: FontWeight.bold,
              ),
            ),
            titlePadding: EdgeInsets.fromLTRB(15, 20, 15, 0),
            content: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        desc,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                color: CustomColor.MAIN,
                              ),
                            ),
                            onPressed: () => Get.back(),
                            child: Text(
                              AppLocalizations.instance.text('TXT_CANCEL'),
                              style: TextStyle(
                                color: CustomColor.MAIN,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: CustomColor.MAIN,
                            ),
                            onPressed: () => function(),
                            child: Text(
                              AppLocalizations.instance
                                  .text('TXT_DELETE_ACCOUNT'),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: -90,
                  child: CircleAvatar(
                    backgroundColor: CustomColor.MAIN,
                    radius: 30,
                    child: Icon(
                      FontAwesomeIcons.info,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
