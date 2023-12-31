// ignore_for_file: deprecated_member_use

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/profile/profile_provider.dart';
import 'package:eight_barrels/screen/auth/fp_webview_screen.dart';
import 'package:eight_barrels/screen/auth/tac_webview_screen.dart';
import 'package:eight_barrels/screen/home/choose_country_page.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/profile/address_list_screen.dart';
import 'package:eight_barrels/screen/profile/change_password_screen.dart';
import 'package:eight_barrels/screen/profile/contact_us_screen.dart';
import 'package:eight_barrels/screen/profile/update_profile_screen.dart';
import 'package:eight_barrels/screen/splash/splash_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/profile-screen';
  final bool? isGuest;

  const ProfileScreen({Key? key, this.isGuest}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<ProfileProvider>(context, listen: false).fnGetView(this);
        Provider.of<ProfileProvider>(context, listen: false)
            .fnFetchUserInfo()
            .whenComplete(() =>
                Provider.of<ProfileProvider>(context, listen: false)
                    .fnFetchRegionList());
        Provider.of<ProfileProvider>(context, listen: false).fnFetchLocale();
        Provider.of<ProfileProvider>(context, listen: false)
            .fnFetchAppVersion();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProfileProvider>(context, listen: false);

    _showRegionDialog() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext bc) {
          return ChangeNotifierProvider.value(
            value: Provider.of<ProfileProvider>(context, listen: false),
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.all(10),
                  child: Consumer<ProfileProvider>(
                      child: Container(
                        child: Text('No Data'),
                      ),
                      builder: (context, provider, skeleton) {
                        switch (provider.regionList.data) {
                          case null:
                            return skeleton!;
                          default:
                            return GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                childAspectRatio: 2,
                              ),
                              itemCount: provider.regionList.data?.length,
                              itemBuilder: (context, index) {
                                var _data = provider.regionList.data?[index];
                                return GestureDetector(
                                  onTap: () async => await provider
                                      .fnOnSelectRegion(_data?.id)
                                      .then((_) =>
                                          CustomWidget.showSuccessDialog(
                                            context,
                                            desc: AppLocalizations.instance.text(
                                                'TXT_REGION_PREFERENCE_SUCCESS'),
                                            function: () => Get.offNamedUntil(
                                                SplashScreen.tag,
                                                (route) => false),
                                          )),
                                  child: Card(
                                    color:
                                        _data?.id == provider.selectedRegionId
                                            ? CustomColor.MAIN
                                            : Colors.white,
                                    child: Center(
                                      child: Text(
                                        _data?.name ?? '-',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _data?.id ==
                                                    _provider.selectedRegionId
                                                ? Colors.white
                                                : Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                        }
                      }),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget _headerContent = Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      decoration: BoxDecoration(
        color: CustomColor.MAIN,
        image: DecorationImage(
          image: AssetImage(
            'assets/images/bg_marron_lg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: GestureDetector(
            onTap: () => Get.toNamed(UpdateProfileScreen.tag),
            child: Stack(
              children: [
                Consumer<ProfileProvider>(builder: (context, provider, _) {
                  return CustomWidget.roundedAvatarImg(
                    url: provider.userModel.user?.avatar ?? '',
                    size: 130,
                  );
                }),
                Positioned(
                  bottom: 5,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.edit,
                      color: CustomColor.MAIN,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget _menuContent = Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Text(
                    AppLocalizations.instance.text('TXT_LBL_CHANGE_PASSWORD'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.instance.text('TXT_DESC_CHANGE_PASSWORD'),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.userLock,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () async => await Get.toNamed(ChangePasswordScreen.tag,
                          arguments: ChangePasswordScreen(
                            token: null,
                          ))!
                      .then((value) async {
                    if (value == true) {
                      await CustomWidget.showSnackBar(
                          context: context,
                          content: Text('Success update password'));
                    }
                  }),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    AppLocalizations.instance.text('TXT_LBL_MY_ADDRESS'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.instance.text('TXT_DESC_MY_ADDRESS'),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.locationArrow,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () => Get.toNamed(AddressListScreen.tag),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    AppLocalizations.instance.text('TXT_LBL_WISHLIST'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () => Get.toNamed(WishListScreen.tag),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    AppLocalizations.instance.text('TXT_LBL_REVIEW'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.solidStar,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () {},
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.translate,
                      color: CustomColor.GREY_TXT,
                      size: 20,
                    ),
                  ),
                  title:
                      Text(AppLocalizations.instance.text("TXT_LBL_LANGUAGE")),
                  subtitle: Text(
                      AppLocalizations.instance.text("TXT_LBL_LANG_LOCALE")),
                  trailing: Consumer<ProfileProvider>(
                      builder: (context, provider, _) {
                    return Transform.scale(
                      scale: 1.4,
                      child: Switch(
                        value: provider.switchVal,
                        onChanged: (value) =>
                            CustomWidget.showConfirmationDialog(
                          context,
                          desc:
                              '${AppLocalizations.instance.text('TXT_LANGUAGE_INFO')}${provider.language} ?',
                          function: () async {
                            await provider
                                .fnOnSwitchLanguage(value)
                                .then((_) => CustomWidget.showSuccessDialog(
                                      context,
                                      desc: AppLocalizations.instance
                                          .text('TXT_LANGUAGE_SUCCESS'),
                                      function: () => Get.offNamedUntil(
                                          SplashScreen.tag, (route) => false),
                                    ));
                          },
                        ),
                        activeThumbImage:
                            AssetImage('assets/images/ic_england.png'),
                        inactiveThumbImage:
                            AssetImage('assets/images/ic_indonesia.png'),
                        activeColor: Colors.grey,
                        inactiveTrackColor: Colors.grey,
                      ),
                    );
                  }),
                ),
                Divider(
                  thickness: 1,
                ),
                Consumer<ProfileProvider>(builder: (context, provider, _) {
                  return ListTile(
                    dense: true,
                    title: Row(
                      children: [
                        Text(
                          AppLocalizations.instance
                              .text('TXT_LBL_REGION_PREFERENCE'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChooseCountryPage()));
                          },
                          // onTap: () => CustomWidget.showInfoPopup(context,
                          //     desc: AppLocalizations.instance
                          //         .text('TXT_REGION_PREFERENCE_INFO')),
                          child: Icon(
                            FontAwesomeIcons.questionCircle,
                            size: 18,
                            color: CustomColor.GREY_TXT,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      provider.selectedRegion ?? '-',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        FontAwesomeIcons.mapMarkedAlt,
                        color: CustomColor.GREY_TXT,
                        size: 18,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: CustomColor.GREY_TXT,
                      size: 15,
                    ),
                    // onTap: () => _showRegionDialog(),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseCountryPage()));
                    },
                  );
                }),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Text(
                    AppLocalizations.instance.text('TXT_LBL_CONTACT_US'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.phoneAlt,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () => Get.toNamed(ContactUsScreen.tag),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.userShield,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () => Get.toNamed(TacWebviewScreen.tag),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    'Refund Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.userShield,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () => Get.toNamed(FbWebviewScreen.tag),
                ),
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            elevation: 2,
            child: ListTile(
              dense: true,
              title: Text(
                AppLocalizations.instance.text('TXT_SIGN_OUT'),
                style: TextStyle(
                  color: CustomColor.MAIN,
                  fontSize: 15,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: CustomColor.MAIN,
                  size: 18,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: CustomColor.GREY_TXT,
                size: 15,
              ),
              onTap: () {
                CustomWidget.showConfirmationDialog(
                  context,
                  desc: AppLocalizations.instance.text('TXT_LOGOUT_INFO'),
                  function: () async => await _provider.fnLogout(),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<ProfileProvider>(builder: (context, provider, _) {
                return Text(
                  "App Version ${provider.fullVersion}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColor.GREY_TXT,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );

    Widget _mainContent = SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          _headerContent,
          _menuContent,
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );

    Widget _guestHeaderContent = Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 0,
        color: CustomColor.SECONDARY,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.circleInfo,
                color: CustomColor.BROWN_TXT,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  AppLocalizations.instance.text('TXT_GUEST_ACCOUNT_INFO'),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _guestMenuContent = Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.translate,
                      color: CustomColor.GREY_TXT,
                      size: 20,
                    ),
                  ),
                  title:
                      Text(AppLocalizations.instance.text("TXT_LBL_LANGUAGE")),
                  subtitle: Text(
                      AppLocalizations.instance.text("TXT_LBL_LANG_LOCALE")),
                  trailing: Consumer<ProfileProvider>(
                      builder: (context, provider, _) {
                    return Transform.scale(
                      scale: 1.4,
                      child: Switch(
                        value: provider.switchVal,
                        onChanged: (value) =>
                            CustomWidget.showConfirmationDialog(
                          context,
                          desc:
                              '${AppLocalizations.instance.text('TXT_LANGUAGE_INFO')}${provider.language} ?',
                          function: () async {
                            await provider
                                .fnOnSwitchLanguage(value)
                                .then((_) => CustomWidget.showSuccessDialog(
                                      context,
                                      desc: AppLocalizations.instance
                                          .text('TXT_LANGUAGE_SUCCESS'),
                                      function: () => Get.offNamedUntil(
                                          SplashScreen.tag, (route) => false),
                                    ));
                          },
                        ),
                        activeThumbImage:
                            AssetImage('assets/images/ic_england.png'),
                        inactiveThumbImage:
                            AssetImage('assets/images/ic_indonesia.png'),
                        activeColor: Colors.grey,
                        inactiveTrackColor: Colors.grey,
                      ),
                    );
                  }),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    AppLocalizations.instance.text('TXT_LBL_CONTACT_US'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.phoneAlt,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () => Get.toNamed(ContactUsScreen.tag),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.userShield,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () => Get.toNamed(TacWebviewScreen.tag),
                ),
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            elevation: 2,
            child: ListTile(
              dense: true,
              title: Text(
                AppLocalizations.instance.text('TXT_SIGN_OUT'),
                style: TextStyle(
                  color: CustomColor.MAIN,
                  fontSize: 15,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: CustomColor.MAIN,
                  size: 18,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: CustomColor.GREY_TXT,
                size: 15,
              ),
              onTap: () {
                CustomWidget.showConfirmationDialog(
                  context,
                  desc: AppLocalizations.instance.text('TXT_LOGOUT_INFO'),
                  function: () async => await _provider.fnLogout(),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<ProfileProvider>(builder: (context, provider, _) {
                return Text(
                  "App Version ${provider.fullVersion}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColor.GREY_TXT,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );

    Widget _guestMainContent = SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          _guestHeaderContent,
          _guestMenuContent,
        ],
      ),
    );

    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: CustomColor.BG,
        extendBodyBehindAppBar: provider.isGuest == 'false' ? true : false,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Image.asset(
            'assets/images/bg_marron_lg.png',
            fit: BoxFit.cover,
          ),
          centerTitle: true,
          title: Text(AppLocalizations.instance.text('TXT_MY_ACCOUNT')),
        ),
        body: Consumer<ProfileProvider>(
          child: Container(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.isGuest) {
                  case 'true':
                    return _guestMainContent;
                  default:
                    return _mainContent;
                }
            }
          },
        ),
      );
    });
  }

  @override
  void onProgressFinish() {
    if (mounted) {
      _isLoad = false;
      setState(() {});
    }
  }

  @override
  void onProgressStart() {
    if (mounted) {
      _isLoad = true;
      setState(() {});
    }
  }
}
