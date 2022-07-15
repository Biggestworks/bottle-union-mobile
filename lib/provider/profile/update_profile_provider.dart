import 'dart:io';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/image_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:eight_barrels/service/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UpdateProfileProvider extends ChangeNotifier with TextValidation {
  ProfileService _service = new ProfileService();
  AuthService _authService = new AuthService();
  UserDetailModel userModel = new UserDetailModel();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController regionController = TextEditingController();

  List<Genders> genderList = [
    Genders(gender: 'male', title: AppLocalizations.instance.text('TXT_LBL_MALE')),
    Genders(gender: 'female', title: AppLocalizations.instance.text('TXT_LBL_FEMALE')),
    Genders(gender: 'other', title: AppLocalizations.instance.text('TXT_LBL_OTHER')),
  ];
  RegionListModel regionList = new RegionListModel();
  int? regionId;
  String? avatar;
  bool? isVerified;
  bool? isAgeValid;

  PictureProvider _pictureProvider = new PictureProvider();
  File? imageFile;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnFetchUserData() async {
    _view!.onProgressStart();
    userModel = (await _service.getUser())!;

    if (userModel.user != null) {
      fullNameController.text = userModel.user?.fullname ?? '-';
      emailController.text = userModel.user?.email ?? '-';
      phoneController.text = userModel.user?.phone ?? '';
      dobController.text = DateFormat('dd MMMM yyyy').format(userModel.user?.dateOfBirth != null
          ? DateTime.parse(userModel.user?.dateOfBirth ?? '')
          : DateTime.now());
      genderController.text = userModel.user?.gender ?? 'other';
      regionId = userModel.user?.idRegion;
      avatar = userModel.user?.avatar;
      isVerified = userModel.user?.isVerified == 1 ? true : false;
    }

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnFetchRegionList() async {
    regionList = (await _authService.regionList())!;
    if (regionList.data != null) {
      regionController.text = regionList.data!.singleWhere((i) => i.id == regionId).name.toString();
    }
    notifyListeners();
  }

  Future fnUpdateAvatar(BuildContext context) async {
    final tempImage = await _pictureProvider.showChoiceDialog(context);
    if (tempImage != null) {
      _view!.onProgressStart();
      imageFile = tempImage;
      var _res = await _service.updateUserAvatar(image: imageFile!);

      if (_res!.status != null) {
        if (_res.status == true) {
          await fnFetchUserData();
          await CustomWidget.showSnackBar(context: context, content: Text('Success update avatar'));
          _view!.onProgressFinish();
        } else {
          await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
          _view!.onProgressFinish();
        }
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
        _view!.onProgressFinish();
      }
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSelectRegion(int? value, BuildContext context) async {
    Get.back();
    this.regionId = value;

    var _res = await _service.updateProfile(
      regionId: regionId,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        await fnFetchUserData().then((_) async => await fnFetchRegionList());
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.errors.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    notifyListeners();
  }

  Future fnOnChangeGender(String? value, BuildContext context) async {
    Get.back();
    this.genderController.text = value!;

    var _res = await _service.updateProfile(
      gender: genderController.text,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        await fnFetchUserData();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.errors.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    notifyListeners();
  }

  Future fnOnSelectDate(DateRangePickerSelectionChangedArgs args, BuildContext context) async {
    Get.back();
    this.dobController.text = DateFormat('yyyy-MM-dd').format(args.value);
    isAgeValid = await super.validateAge(dobController.text);
    notifyListeners();

    if (isAgeValid == true) {
      var _res = await _service.updateProfile(
        dob: dobController.text,
      );

      if (_res!.status != null) {
        if (_res.status == true) {
          await fnFetchUserData();
          await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
        } else {
          await CustomWidget.showSnackBar(context: context, content: Text(_res.errors.toString()));
        }
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_AGE_ERROR')));
    }
    notifyListeners();
  }

  Future fnDeleteAccount(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.deleteAccount();
    if (_res?.status != null) {
      if (_res?.status == true) {
        _view!.onProgressFinish();
        await CustomWidget.showSuccessDialog(
          context,
          desc: AppLocalizations.instance.text('TXT_DELETE_ACCOUNT_SUCCESS'),
          function: () => Get.back(),
        );
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text('${_res?.message != null ? _res?.message.toString() : ''}'));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      _view!.onProgressFinish();
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

}

class Genders {
  final String gender;
  final String title;

  Genders({required this.gender, required this.title});
}