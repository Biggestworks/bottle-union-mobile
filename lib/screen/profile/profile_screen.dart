import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/profile/profile_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      color: CustomColor.MAIN,
      padding: EdgeInsets.only(top: 10),
      child: Center(
        child: Consumer<ProfileProvider>(
          child: Stack(
            children: [
              Container(
                width: 120.0,
                height: 120.0,
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
              Positioned(
                bottom: 5,
                right: 5,
                child: Icon(CupertinoIcons.pencil_circle_fill, color: Colors.grey, size: 30,),
              ),
            ],
          ),
          builder: (context, provider, skeleton) {
            switch (provider.userModel.data) {
              case null:
                return skeleton!;
              default:
                switch (provider.userModel.data!.avatar) {
                  case null:
                    return skeleton!;
                  default:
                    return GestureDetector(
                      // onTap: () => Get.toNamed(ProfileScreen.tag),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: provider.userModel.data!.avatar!,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    )),
                              );
                            },
                            errorWidget: (context, url, error) => skeleton!,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Icon(CupertinoIcons.pencil_circle_fill, color: Colors.white, size: 30,),
                          ),
                        ],
                      ),
                    );
                }

            }
          },
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
                    ),
                  ),
                  subtitle: Text(AppLocalizations.instance.text('TXT_DESC_CHANGE_PASSWORD'), style: TextStyle(
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
                  onTap: () async {
                    // Get.toNamed(ChangePasswordScreen.tag);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text(AppLocalizations.instance.text('TXT_LBL_MY_ADDRESS'), style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(AppLocalizations.instance.text('TXT_DESC_MY_ADDRESS'), style: TextStyle(
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
                  onTap: () async {
                    // Get.toNamed(EditAddressScreen.tag);
                  },
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
                  title: Text(AppLocalizations.instance.text("TXT_LABEL_LANGUAGE")),
                  subtitle: Text(AppLocalizations.instance.text("TXT_LABEL_LANG_LOCALE")),
                  trailing: Consumer<ProfileProvider>(
                    builder: (context, provider, _) {
                      return Transform.scale(
                        scale: 1.4,
                        child: Switch(
                          value: provider.langValue,
                          onChanged: (value) => provider.fnOnSwitchLanguage(context, value),
                          activeThumbImage: AssetImage('assets/images/ic_england.png'),
                          inactiveThumbImage: AssetImage('assets/images/ic_indonesia.png'),
                          activeColor: Colors.grey,
                          inactiveTrackColor: Colors.grey,
                        ),
                      );
                    }
                  ),
                  onTap: () {
                    // choseLanguage(context);
                  },
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
                  icon: Icons.exit_to_app,
                  label: AppLocalizations.instance.text('TXT_SIGN_OUT'),
                  btnColor: CustomColor.MAIN,
                  lblColor: Colors.white,
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

    Widget _mainContent = Container(
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
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_MY_ACCOUNT')),
      ),
      body: _mainContent,
      // body: _mainContent,
    );
  }

}
