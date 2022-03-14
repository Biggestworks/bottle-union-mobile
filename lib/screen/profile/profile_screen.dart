import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/profile/profile_provider.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/profile/address_list_screen.dart';
import 'package:eight_barrels/screen/profile/change_password_screen.dart';
import 'package:eight_barrels/screen/profile/update_profile_screen.dart';
import 'package:eight_barrels/screen/splash/splash_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/profile-screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProfileProvider>(context, listen: false);

    Widget _headerContent = Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      // color: CustomColor.MAIN,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_marron.png',),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () => Get.toNamed(UpdateProfileScreen.tag),
          child: Stack(
            children: [
              Consumer<ProfileProvider>(
                builder: (context, provider, _) {
                  return CustomWidget.roundedAvatarImg(
                    url: provider.userModel.user?.avatar ?? '',
                    size: 120,
                  );
                }
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  CupertinoIcons.pencil_circle_fill,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _menuContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            elevation: 4,
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Text(AppLocalizations.instance.text('TXT_LBL_CHANGE_PASSWORD'), style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                  ),),
                  subtitle: Text(AppLocalizations.instance.text('TXT_DESC_CHANGE_PASSWORD'), style: TextStyle(
                      fontSize: 14,
                  ),),
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
                  onTap: () async => await Get.toNamed(ChangePasswordScreen.tag, arguments: ChangePasswordScreen(token: null,))!.then((value) async {
                    if (value == true) {
                      await CustomWidget.showSnackBar(context: context, content: Text('Success update password'));
                    }
                  }),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(AppLocalizations.instance.text('TXT_LBL_MY_ADDRESS'), style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                  ),),
                  subtitle: Text(AppLocalizations.instance.text('TXT_DESC_MY_ADDRESS'), style: TextStyle(
                      fontSize: 14,
                  ),),
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
                  title: Text(AppLocalizations.instance.text('TXT_LBL_WISHLIST'), style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),),
                  subtitle: Text(AppLocalizations.instance.text('TXT_DESC_WISHLIST'), style: TextStyle(
                    fontSize: 14,
                  ),),
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
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.translate,
                      color: CustomColor.GREY_TXT,
                      size: 20,
                    ),
                  ),
                  title: Text(AppLocalizations.instance.text("TXT_LBL_LANGUAGE")),
                  subtitle: Text(AppLocalizations.instance.text("TXT_LBL_LANG_LOCALE")),
                  trailing: Consumer<ProfileProvider>(
                    builder: (context, provider, _) {
                      return Transform.scale(
                        scale: 1.4,
                        child: Switch(
                          value: provider.switchVal,
                          onChanged: (value) => CustomWidget.showConfirmationDialog(
                            context,
                            desc: '${AppLocalizations.instance.text('TXT_LANGUAGE_INFO')}${provider.language} ?',
                            function: () async {
                              await provider.fnOnSwitchLanguage(value)
                                  .then((_) => CustomWidget.showSuccessDialog(
                                context,
                                desc: AppLocalizations.instance.text('TXT_LANGUAGE_SUCCESS'),
                                function: () => Get.offNamedUntil(SplashScreen.tag, (route) => false),
                              ));
                            },
                          ),
                          activeThumbImage: AssetImage('assets/images/ic_england.png'),
                          inactiveThumbImage: AssetImage('assets/images/ic_indonesia.png'),
                          activeColor: Colors.grey,
                          inactiveTrackColor: Colors.grey,
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            elevation: 4,
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Text(AppLocalizations.instance.text('TXT_LBL_CONTACT_US'), style: TextStyle(
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
                  onTap: () {
                    // Get.toNamed(ContactUsScreen.tag);
                    // ReusableWidget.showSnackBar('Under Construction', context);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(AppLocalizations.instance.text('TXT_LBL_HELP'), style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.question,
                      color: CustomColor.GREY_TXT,
                      size: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColor.GREY_TXT,
                    size: 15,
                  ),
                  onTap: () {
                    // ReusableWidget.showSnackBar('Under Construction', context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: CustomWidget.roundIconBtn(
                  icon: FontAwesomeIcons.signOutAlt,
                  label: AppLocalizations.instance.text('TXT_SIGN_OUT'),
                  btnColor: CustomColor.MAIN,
                  lblColor: Colors.white,
                  fontSize: 16,
                  function: () => CustomWidget.showConfirmationDialog(
                    context,
                    desc: AppLocalizations.instance.text('TXT_LOGOUT_INFO'),
                    function: () async => await _provider.fnLogout(),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Consumer<ProfileProvider>(
                  builder: (context, provider, _) {
                    return Text("Version ${provider.fullVersion}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),);
                  }
              ),
            ],
          ),
          SizedBox(height: 100,),
        ],
      ),
    );

    Widget _mainContent = SingleChildScrollView(
      child: Column(
        children: [
          _headerContent,
          SizedBox(height: 20,),
          _menuContent
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: CustomColor.MAIN,
        flexibleSpace: Image.asset('assets/images/bg_marron.png', fit: BoxFit.cover,),
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_MY_ACCOUNT')),
      ),
      body: _mainContent,
      // body: _mainContent,
    );
  }

}
