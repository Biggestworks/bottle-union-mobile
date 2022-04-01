import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/profile/update_profile_provider.dart';
import 'package:eight_barrels/screen/profile/profile_input_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UpdateProfileScreen extends StatefulWidget {
  static String tag = '/update-profile-screen';
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen>
    with TextValidation, LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<UpdateProfileProvider>(context, listen: false).fnGetView(this);
      Provider.of<UpdateProfileProvider>(context, listen: false).fnFetchUserData()
          .then((value) => Provider.of<UpdateProfileProvider>(context, listen: false).fnFetchRegionList());
    },);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UpdateProfileProvider>(context, listen: false);

    _showDobDialog() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 300,
              padding: EdgeInsets.all(10),
              child: SfDateRangePicker(
                initialDisplayDate: DateTime.parse('${_provider.userModel.user!.dateOfBirth} 00:00:00'),
                onSelectionChanged: (value) async => await _provider.fnOnSelectDate(value, _provider.scaffoldKey.currentContext!),
              ),
            ),
          );
        },
      );
    }

    _showGenderDialog() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 120,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Radio(
                              value: _provider.genderList[0],
                              groupValue: _provider.genderController.text,
                              onChanged: (value) => _provider.fnOnChangeGender(value as String, _provider.scaffoldKey.currentContext!),
                              activeColor: CustomColor.MAIN,
                            ),
                            Text(AppLocalizations.instance.text('TXT_LBL_MALE'), style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio(
                              value: _provider.genderList[1],
                              groupValue: _provider.genderController.text,
                              onChanged: (value) => _provider.fnOnChangeGender(value as String, context),
                              activeColor: CustomColor.MAIN,
                            ),
                            Text(AppLocalizations.instance.text('TXT_LBL_FEMALE'), style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
          );
        },
      );
    }

    _showRegionDialog() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext bc) {
          return ChangeNotifierProvider.value(
            value: Provider.of<UpdateProfileProvider>(context, listen: false),
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
                  child: Consumer<UpdateProfileProvider>(
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
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 2,
                            ),
                            itemCount: provider.regionList.data?.length,
                            itemBuilder: (context, index) {
                              var _data = provider.regionList.data?[index];
                              return GestureDetector(
                                onTap: () async => await provider.fnOnSelectRegion(_data?.id, provider.scaffoldKey.currentContext!),
                                child: Card(
                                  color: _data?.id == provider.regionId ? CustomColor.MAIN : Colors.white,
                                  child: Center(
                                    child: Text(_data?.name ?? '-', style: TextStyle(
                                        fontSize: 14,
                                        color: _data?.id == _provider.regionId ? Colors.white : Colors.black
                                    ),),
                                  ),
                                ),
                              );
                            },
                          );
                      }
                    }
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget _mainContent = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Consumer<UpdateProfileProvider>(
          child: Container(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.userModel.user) {
                  case null:
                    return skeleton!;
                  default:
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async => await provider.fnUpdateAvatar(provider.scaffoldKey.currentContext!),
                          child: Stack(
                            children: [
                              CustomWidget.roundedAvatarImg(url: provider.userModel.user?.avatar ?? '',),
                              Positioned(
                                bottom: 5,
                                right: 0,
                                child: Icon(
                                  CupertinoIcons.pencil_circle_fill,
                                  color: CustomColor.MAIN,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.instance.text('TXT_LBL_NAME'), style: TextStyle(
                              fontSize: 16,
                              color: CustomColor.GREY_TXT,
                            ),),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    controller: provider.fullNameController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: CustomColor.GREY_BG,),
                                      ),
                                      filled: true,
                                      fillColor: CustomColor.GREY_BG,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () async => await Get.toNamed(ProfileInputScreen.tag, arguments: ProfileInputScreen(
                                    flag: AppLocalizations.instance.text('TXT_LBL_NAME'),
                                    data: provider.fullNameController.text,
                                  ))!.then((value) async {
                                    if (value == true) {
                                      await provider.fnFetchUserData();
                                      await CustomWidget.showSnackBar(context: provider.scaffoldKey.currentContext!, content: Text('Success'));
                                    }
                                  }),
                                  child: Text('Change', style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(AppLocalizations.instance.text('TXT_LBL_DOB'), style: TextStyle(
                              fontSize: 16,
                              color: CustomColor.GREY_TXT,
                            ),),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    controller: provider.dobController,
                                    decoration: InputDecoration(
                                      suffixIcon: Consumer<UpdateProfileProvider>(
                                          child: SizedBox(),
                                          builder: (context, provider, skeleton) {
                                            switch (provider.isAgeValid) {
                                              case true:
                                                return Icon(FontAwesomeIcons.solidCheckCircle, size: 24, color: Colors.green,);
                                              case false:
                                                return Icon(FontAwesomeIcons.exclamationCircle, size: 24, color: Colors.red,);
                                              default:
                                                return skeleton!;
                                            }
                                          }
                                      ),
                                      isDense: true,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: CustomColor.GREY_BG,),
                                      ),
                                      filled: true,
                                      fillColor: CustomColor.GREY_BG,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () => _showDobDialog(),
                                  child: Text('Change', style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(AppLocalizations.instance.text('TXT_LBL_GENDER'), style: TextStyle(
                              fontSize: 16,
                              color: CustomColor.GREY_TXT,
                            ),),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    controller: provider.genderController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: CustomColor.GREY_BG,),
                                      ),
                                      filled: true,
                                      fillColor: CustomColor.GREY_BG,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () => _showGenderDialog(),
                                  child: Text('Change', style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Text(AppLocalizations.instance.text('TXT_LBL_EMAIL'), style: TextStyle(
                                  fontSize: 16,
                                  color: CustomColor.GREY_TXT,
                                ),),
                                SizedBox(width: 10,),
                                Text(provider.isVerified!
                                    ? AppLocalizations.instance.text('TXT_VERIFIED')
                                    : AppLocalizations.instance.text('TXT_NOT_VERIFIED'), style: TextStyle(
                                  fontSize: 16,
                                  color: provider.isVerified! ? Colors.green : Colors.red,
                                ),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    controller: provider.emailController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: CustomColor.GREY_BG,),
                                      ),
                                      filled: true,
                                      fillColor: CustomColor.GREY_BG,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () async => await Get.toNamed(ProfileInputScreen.tag, arguments: ProfileInputScreen(
                                    flag: AppLocalizations.instance.text('TXT_LBL_EMAIL'),
                                    data: provider.emailController.text,
                                  ))!.then((value) async {
                                    if (value == true) {
                                      await provider.fnFetchUserData();
                                      await CustomWidget.showSnackBar(context: provider.scaffoldKey.currentContext!, content: Text('Success update profile'));
                                    }
                                  }),
                                  child: Text('Change', style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(AppLocalizations.instance.text('TXT_LBL_PHONE'), style: TextStyle(
                              fontSize: 16,
                              color: CustomColor.GREY_TXT,
                            ),),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    controller: provider.phoneController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: CustomColor.GREY_BG,),
                                      ),
                                      filled: true,
                                      fillColor: CustomColor.GREY_BG,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () async => await Get.toNamed(ProfileInputScreen.tag, arguments: ProfileInputScreen(
                                    flag: AppLocalizations.instance.text('TXT_LBL_PHONE'),
                                    data: provider.phoneController.text,
                                  ))!.then((value) async {
                                    if (value == true) {
                                      await provider.fnFetchUserData();
                                      await CustomWidget.showSnackBar(context: provider.scaffoldKey.currentContext!, content: Text('Success'));
                                    }
                                  }),
                                  child: Text('Change', style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text(AppLocalizations.instance.text('TXT_LBL_REGION'), style: TextStyle(
                              fontSize: 16,
                              color: CustomColor.GREY_TXT,
                            ),),
                            SizedBox(height: 10,),
                            Consumer<UpdateProfileProvider>(
                                builder: (context, provider, _) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          enabled: false,
                                          controller: provider.regionController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: CustomColor.GREY_BG,),
                                            ),
                                            filled: true,
                                            fillColor: CustomColor.GREY_BG,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      GestureDetector(
                                        onTap: () => _showRegionDialog(),
                                        child: Text('Change', style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                        ),),
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ],
                        ),
                      ],
                    );
                }
            }
          },
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        key: _provider.scaffoldKey,
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.MAIN,
          centerTitle: true,
          title: Text('Update Personal Data'),
        ),
        body: _mainContent,
        // bottomNavigationBar: _submitBtn,
      ),
    );
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
