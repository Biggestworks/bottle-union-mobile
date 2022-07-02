import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/register_step_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/model/address/ro_city_model.dart';
import 'package:eight_barrels/model/address/ro_province_model.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/widget/BezierPainter.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/address/address_service.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timelines/timelines.dart';

class RegisterProvider extends ChangeNotifier with RegisterStepInterface, TextValidation {
  AuthService _service = new AuthService();
  AddressService _addressService = new AddressService();

  TextEditingController nameController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();
  TextEditingController provinceController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController regionController = new TextEditingController();

  List<String> genderList = ['male', 'female'];
  String genderValue = 'male';

  LatLng? currLocation;
  LatLng? selectedLocation;

  bool isHidePass = true;
  bool isHidePassConfirm = true;
  String? errEmail;

  List<String> _stepTitle = [
    AppLocalizations.instance.text('TXT_STEP_PERSONAL'),
    AppLocalizations.instance.text('TXT_STEP_ADDRESS'),
    AppLocalizations.instance.text('TXT_STEP_PASSWORD'),
  ];

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RoProvinceModel provinceList = new RoProvinceModel();
  RoCityModel cityList = new RoCityModel();
  RegionListModel regionList = new RegionListModel();
  String? selectedProvinceId;
  String? selectedCityId;
  int? selectedRegionId;

  fnKeyboardUnFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  fnGetView(LoadingView view) {
    this._view = view;
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
      idRegion: selectedRegionId!,
      password: passController.text,
      confirmPassword: confirmPassController.text,
      address: addressController.text,
      provinceId: selectedProvinceId!,
      province: provinceController.text,
      cityId: selectedCityId!,
      city: cityController.text,
      latitude: selectedLocation!.latitude.toString(),
      longitude: selectedLocation!.longitude.toString(),
    );

    if (_res!.status != null) {
      if (_res.status == true && _res.data != null) {
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
    await super.onForwardTransition(context, () async => await _fnRegister(context: scaffoldKey.currentContext!));
    notifyListeners();
  }

  Future fnOnBackTransition(BuildContext context) async {
    await super.onBackTransition(context);
    notifyListeners();
  }

  Future fnShowPlacePicker(BuildContext context) async {
    bool _serviceEnabled;
    LocationPermission _permission;

    try {
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        await CustomWidget.showSnackBar(context: context, content: Text('Location services are disabled.'));
      }

      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
        if (_permission == LocationPermission.denied) {
          await CustomWidget.showSnackBar(context: context, content: Text('Location permissions are denied.'));
        }
      } else if (_permission == LocationPermission.deniedForever) {
        await CustomWidget.showSnackBar(context: context, content: Text('Location permissions are permanently denied, Bottle Union cannot request permissions.'));
      }

      await Geolocator.getCurrentPosition().then((value) {
        currLocation = LatLng(value.latitude, value.longitude);
      });

      if (currLocation != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlacePicker(
              apiKey: dotenv.get('MAP_API_KEY', fallback: 'API_URL not found'),
              enableMapTypeButton: true,
              usePlaceDetailSearch: true,
              onPlacePicked: (result) async {
                Get.back();
                addressController.text = result.formattedAddress!;
                selectedLocation = LatLng(result.geometry!.location.lat, result.geometry!.location.lng);
                notifyListeners();
              },
              region: 'ID',
              initialPosition: currLocation!,
              useCurrentLocation: true,
              enableMyLocationButton: true,
              selectInitialPosition: true,
            ),
          ),
        );
      }

    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future fnFetchRegionList() async {
    regionList = (await _service.regionList())!;
    notifyListeners();
  }

  fnOnSelectRegion({required String name, required int id}) {
    regionController.text = name;
    selectedRegionId = id;
    notifyListeners();
  }

  Future fnFetchProvinceList() async {
    provinceList = (await _addressService.getProvince())!;
    notifyListeners();
  }

  Future fnOnSelectProvince({required String name, required String id}) async {
    provinceController.text = name;
    selectedProvinceId = id;
    cityList = (await _addressService.getCity(provinceId: selectedProvinceId!))!;
    notifyListeners();
  }

  fnOnSelectCity({required String name, required String id}) {
    cityController.text = name;
    selectedCityId = id;
    notifyListeners();
  }

  fnOnChangeGender(String? value) {
    this.genderValue = value!;
    notifyListeners();
  }

  Future fnOnSelectDate(DateRangePickerSelectionChangedArgs args, BuildContext context) async {
    fnKeyboardUnFocus(context);
    this.dobController.text = DateFormat('yyyy-MM-dd').format(args.value);
    await super.validateAgeValid(context, dobController.text);
    notifyListeners();
  }

  fnPassVblRegis(BuildContext context) {
    fnKeyboardUnFocus(context);
    isHidePass = !isHidePass;
    notifyListeners();
  }

  fnPassVblRegisConfirm(BuildContext context) {
    fnKeyboardUnFocus(context);
    isHidePassConfirm = !isHidePassConfirm;
    notifyListeners();
  }

  Future fnValidateEmail(BuildContext context, String value) async {
    errEmail = validateEmail(value);

    if (errEmail == null) {
      super.isEmailValid = await super.validateEmailValid(context, value);
      print(super.isEmailValid);
      if (super.isEmailValid == true) {
        this.errEmail = AppLocalizations.instance.text('TXT_EMAIL_ERROR');
      } else {
        this.errEmail = null;
      }
    } else {
      isEmailValid = null;
    }
    notifyListeners();
  }

  fnOnChangeEmailValid() {
    super.isEmailValid = null;
    notifyListeners();
  }

  fnOnCheckTOC(bool? value) {
    super.isTacAccepted = value ?? false;
    print(super.isTacAccepted);
    notifyListeners();
  }

}