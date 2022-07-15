import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/screen/profile/profile_input_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

class ProfileInputProvider extends ChangeNotifier with TextValidation {
  ProfileService _service = new ProfileService();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? flag;
  String? data;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Widget? textField;

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as ProfileInputScreen;
    flag = _args.flag;
    data = _args.data;
    notifyListeners();
  }

  fnGetTextFormField() {
    if (flag == AppLocalizations.instance.text('TXT_LBL_NAME')) {
      fullNameController.text = data!;
      textField = TextFormField(
        controller: fullNameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validateField,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: CustomColor.GREY_BG,),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: CustomColor.GREY_BG,),
          ),
          filled: true,
          fillColor: CustomColor.GREY_BG,
        ),
      );
    } else if (flag == AppLocalizations.instance.text('TXT_LBL_EMAIL')) {
      emailController.text = data!;
      textField = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validateEmail,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: CustomColor.GREY_BG,),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: CustomColor.GREY_BG,),
          ),
          filled: true,
          fillColor: CustomColor.GREY_BG,
        ),
      );
    } else if (flag == AppLocalizations.instance.text('TXT_LBL_PHONE')) {
      phoneController.text = data!;
      textField = TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: validatePhoneNumber,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: CustomColor.GREY_BG,),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: CustomColor.GREY_BG,),
          ),
          filled: true,
          fillColor: CustomColor.GREY_BG,
        ),
      );
    } else {
      textField = Container();
    }
  }

  Future fnUpdateProfile(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var _res = await _service.updateProfile(
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );

      if (_res!.status != null) {
        if (_res.status == true) {
          Get.back(result: true);
        } else {
          await CustomWidget.showSnackBar(context: context, content: Text(_res.errors != null ? _res.errors.toString() : _res.message!));
        }
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      }
    }
  }

}