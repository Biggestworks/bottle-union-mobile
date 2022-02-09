import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/register_step_verification.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/widget/BezierPainter.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timelines/timelines.dart';

class AuthProvider extends ChangeNotifier with RegisterStepVerification {

  TextEditingController nameController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final fKeyLogin = new GlobalKey<FormState>();

  List<String> genderList = ['male', 'female'];
  String genderValue = 'male';

  LatLng? currLocation;
  LatLng? selectedLocation;

  AuthService _service = new AuthService();

  List<DropdownMenuItem<String>> regionList = [];
  String? selectedRegion;
  int? selectedRegionId;
  List<Data> regionData = [];

  bool isHidePassRegis = true;
  bool isHidePassRegisConfirm = true;
  bool isHidePassLogin = true;
  String? errEmail;

  List<String> _stepTitle = [
    AppLocalizations.instance.text('TXT_STEP_PERSONAL'),
    AppLocalizations.instance.text('TXT_STEP_ADDRESS'),
    AppLocalizations.instance.text('TXT_STEP_PASSWORD'),
  ];

  LoadingView? _view;

  fnKeyboardUnFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Color fnGetStepColor(int index) {
    if (index <= super.stepIndex) {
      return CustomColor.SECONDARY;
    } else {
      return CustomColor.STEP_PROGRESS;
    }
  }

  Widget stepProgressBar({required BuildContext context}) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space: 25.0,
            thickness: 5.0,
          ),
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / _stepTitle.length,
          contentsBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(_stepTitle[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: fnGetStepColor(index),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
          indicatorBuilder: (_, index) {
            var color;
            var child;
            if (index == super.stepIndex) {
              color = CustomColor.SECONDARY;
              child = Center(
                child: Text('${index+1}', style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              );
            } else if (index < super.stepIndex) {
              color = CustomColor.SECONDARY;
              child = Icon(
                Icons.check,
                color: CustomColor.MAIN,
                size: 15.0,
              );
            } else {
              color = CustomColor.STEP_PROGRESS;
            }

            if (index <= super.stepIndex) {
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(25.0, 25.0),
                    painter: BezierPainter(
                      color: color,
                      drawStart: index > 0,
                      drawEnd: index < super.stepIndex,
                    ),
                  ),
                  DotIndicator(
                    size: 25.0,
                    color: color,
                    child: child,
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(25.0, 25.0),
                    painter: BezierPainter(
                      color: color,
                      drawEnd: index < _stepTitle.length - 1,
                    ),
                  ),
                  DotIndicator(
                    color: color,
                    size: 25,
                    child: Center(
                      child: Text('${index+1}', style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                ],
              );
            }
          },
          connectorBuilder: (_, index, type) =>
              SolidLineConnector(
                color: fnGetStepColor(index),
              ),
          itemCount: _stepTitle.length,
        ),
      ),
    );
  }

  fnInitAnimation(TickerProvider vsync) {
    super.initAnimation(vsync);
    notifyListeners();
  }
  
  Future fnOnForwardTransition(BuildContext context) async {
    await super.onForwardTransition(context, () async => await _fnRegister(context: context));
    notifyListeners();
  }

  Future fnOnBackTransition(BuildContext context) async {
    await super.onBackTransition(context);
    notifyListeners();
  }

  Future fnShowPlacePicker(BuildContext context) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    try {
      await Geolocator.getCurrentPosition().then((value) {
        currLocation = LatLng(value.latitude, value.longitude);
      });
    } catch (e) {
      print(e);
      currLocation = null;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: KeyHelper.API_KEY,
          enableMapTypeButton: true,
          usePlaceDetailSearch: true,
          onPlacePicked: (result) {
            Get.back();
            addressController.text = result.formattedAddress!;
            selectedLocation = LatLng(result.geometry!.location.lat, result.geometry!.location.lng);
            notifyListeners();
          },
          region: 'ID',
          initialPosition: currLocation!,
          useCurrentLocation: true,
          enableMyLocationButton: true,
        ),
      ),
    );

  }

  Future fnFetchRegionList() async {
    var _response = await _service.regionList();

    regionData = _response!.data!;

    List.generate(_response.data!.length, (i) {
      regionList.add(
        DropdownMenuItem(
          child: Text(_response.data![i].name!, style: TextStyle(
            color: Colors.black,
          ),),
          value: _response.data![i].id!.toString(),
          onTap: () => selectedRegionId = _response.data![i].id!,
        ),
      );
    });
  }

  fnOnChangeRadio(String? value) {
    this.genderValue = value!;
    notifyListeners();
  }

  fnOnSelectRegion(String? value) {
    this.selectedRegion = value;
    notifyListeners();
  }

  Future fnOnSelectDate(DateRangePickerSelectionChangedArgs args, BuildContext context) async {
    fnKeyboardUnFocus(context);
    this.dobController.text = DateFormat('yyyy-MM-dd').format(args.value);
    await super.validateAge(context, dobController.text);
    notifyListeners();
  }

  fnPassVblRegis(BuildContext context) {
    fnKeyboardUnFocus(context);
    isHidePassRegis = !isHidePassRegis;
    notifyListeners();
  }

  fnPassVblRegisConfirm(BuildContext context) {
    fnKeyboardUnFocus(context);
    isHidePassRegisConfirm = !isHidePassRegisConfirm;
    notifyListeners();
  }

  fnPassVblLogin(BuildContext context) {
    fnKeyboardUnFocus(context);
    isHidePassLogin = !isHidePassLogin;
    notifyListeners();
  }

  Future fnValidateEmail(BuildContext context, String value) async {
    isEmailValid = await super.validateEmail(context, value);
    if (isEmailValid == true) {
      this.errEmail = AppLocalizations.instance.text('TXT_EMAIL_ERROR');
    } else {
      this.errEmail = null;
    }
    notifyListeners();
  }

  Future _fnRegister({required BuildContext context}) async {
    fnKeyboardUnFocus(context);
    _view!.onProgressStart();

    final _res = await _service.register(
      fullName: nameController.text,
      dob: dobController.text,
      email: emailController.text,
      phone: phoneController.text,
      gender: genderValue,
      address: addressController.text,
      latitude: selectedLocation!.latitude.toString(),
      longitude: selectedLocation!.longitude.toString(),
      idRegion: selectedRegionId!,
      password: passController.text,
      confirmPassword: confirmPassController.text,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        await Get.offAllNamed(LoginScreen.tag, arguments: LoginScreen(isRegister: true,));
      } else {
        _view!.onProgressFinish();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res.message.toString()}')));
      }
    } else {
      _view!.onProgressFinish();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
    }
    _view!.onProgressFinish();
  }

  Future fnLogin({required BuildContext context}) async {
    fnKeyboardUnFocus(context);
    if (fKeyLogin.currentState!.validate()) {
      _view!.onProgressStart();

      final _res = await _service.login(
        username: usernameController.text,
        password: passwordController.text,
      );

      if (_res!.status != null) {
        if (_res.status == true) {
          _view!.onProgressFinish();
          Get.offAllNamed(BaseHomeScreen.tag);
        } else {
          _view!.onProgressFinish();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res.message.toString()}')));
        }
      } else {
        _view!.onProgressFinish();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
      }
      _view!.onProgressFinish();
    }
  }

  Future fnAuthGoogle(BuildContext context, {bool isLogin = false}) async {
    _view!.onProgressStart();
    await _service.authGoogle().then((value) async {
      if (value != null) {
        /// USER LOGIN SOCMED
        if (isLogin) {
          var _res = await _service.loginSocmed(
            email: value.user!.providerData.single.email,
            fullName: value.user!.providerData.single.displayName,
            phone: value.user!.providerData.single.phoneNumber,
            avatar: value.user!.providerData.single.photoURL,
            providerId: value.user!.providerData.single.providerId,
            providerUid: value.user!.providerData.single.uid,
          );

          if (_res!.status != null) {
            if (_res.status == true) {
              _view!.onProgressFinish();
              Get.offAllNamed(BaseHomeScreen.tag);
            } else {
              _view!.onProgressFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res.message.toString()}')));
            }
          } else {
            _view!.onProgressFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
          }
        }
        /// USER REGISTER SOCMED
        else {
          bool? _isValid = await _service.validateEmailPhone(value: value.user!.providerData.single.email!);

          if (_isValid == false) {
            var _res = await _service.registerSocmed(
              email: value.user!.providerData.single.email,
              fullName: value.user!.providerData.single.displayName,
              phone: value.user!.providerData.single.phoneNumber,
              avatar: value.user!.providerData.single.photoURL,
              providerId: value.user!.providerData.single.providerId,
              providerUid: value.user!.providerData.single.uid,
            );

            if (_res!.status == true) {
              _view!.onProgressFinish();
              Get.offAndToNamed(LoginScreen.tag, arguments: LoginScreen(
                providerId: value.user!.providerData.single.providerId,
                isRegister: true,)
              );
            } else {
              _view!.onProgressFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
            }
          } else {
            _view!.onProgressFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_EMAIL_ERROR'))));
          }
        }
      } else {
        _view!.onProgressFinish();
      }
    });
    _view!.onProgressFinish();
  }

  Future fnAuthFacebook(BuildContext context, {bool isLogin = false}) async {
    _view!.onProgressStart();
    await _service.authFacebook().then((value) async {
      if (value != null) {
        /// USER LOGIN SOCMED
        if (isLogin) {
          var _res = await _service.loginSocmed(
            email: value.user!.providerData.single.email,
            fullName: value.user!.providerData.single.displayName,
            phone: value.user!.providerData.single.phoneNumber,
            avatar: value.user!.providerData.single.photoURL,
            providerId: value.user!.providerData.single.providerId,
            providerUid: value.user!.providerData.single.uid,
          );

          if (_res!.status != null) {
            if (_res.status == true) {
              _view!.onProgressFinish();
              Get.offAllNamed(BaseHomeScreen.tag);
            } else {
              _view!.onProgressFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res.message.toString()}')));
            }
          } else {
            _view!.onProgressFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
          }
        }
        /// USER REGISTER SOCMED
        else {
          bool? _isValid = await _service.validateEmailPhone(value: value.user!.providerData.single.email!);

          if (_isValid == false) {
            var _res = await _service.registerSocmed(
              email: value.user!.providerData.single.email,
              fullName: value.user!.providerData.single.displayName,
              phone: value.user!.providerData.single.phoneNumber,
              avatar: value.user!.providerData.single.photoURL,
              providerId: value.user!.providerData.single.providerId,
              providerUid: value.user!.providerData.single.uid,
            );

            if (_res!.status == true) {
              _view!.onProgressFinish();
              Get.offAndToNamed(LoginScreen.tag, arguments: LoginScreen(
                providerId: value.user!.providerData.single.providerId,
                isRegister: true,)
              );
            } else {
              _view!.onProgressFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
            }
          } else {
            _view!.onProgressFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_EMAIL_ERROR'))));
          }
        }
      }
    });
    _view!.onProgressFinish();
  }
}