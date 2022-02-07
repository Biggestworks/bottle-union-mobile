
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app-localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/widget/BezierPainter.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timelines/timelines.dart';

class RegisterProvider extends ChangeNotifier {
  TextEditingController nameController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  List<String> genderList = ['male', 'female'];
  String genderValue = 'male';
  int stepIndex = 0;
  
  AnimationController? animationController;
  Animation<Offset>? offsetAnimation;

  LatLng? currLocation;
  LatLng? selectedLocation;

  AuthService _service = new AuthService();

  List<DropdownMenuItem<String>> regionList = [];
  String? selectedRegion;
  int? selectedRegionId;
  List<Data> regionData = [];

  bool isHidePassword = true;
  bool isHidePassword2 = true;
  bool? isAgeValid;

  final fKeyPersonal = new GlobalKey<FormState>();
  final fKeyAddress = new GlobalKey<FormState>();
  final fKeyPassword = new GlobalKey<FormState>();

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Color fnGetStepColor(int index) {
    if (index <= stepIndex) {
      return CustomColor.SECONDARY;
    } else {
      return CustomColor.STEP_PROGRESS;
    }
  }

  final _stepTitle = [
    AppLocalizations.instance.text('TXT_STEP_PERSONAL'),
    AppLocalizations.instance.text('TXT_STEP_ADDRESS'),
    AppLocalizations.instance.text('TXT_STEP_PASSWORD'),
  ];

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
            if (index == stepIndex) {
              color = CustomColor.SECONDARY;
              child = Center(
                child: Text('${index+1}', style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              );
            } else if (index < stepIndex) {
              color = CustomColor.SECONDARY;
              child = Icon(
                Icons.check,
                color: CustomColor.MAIN,
                size: 15.0,
              );
            } else {
              color = CustomColor.STEP_PROGRESS;
            }

            if (index <= stepIndex) {
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(25.0, 25.0),
                    painter: BezierPainter(
                      color: color,
                      drawStart: index > 0,
                      drawEnd: index < stepIndex,
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

  fnInitAnimation({required TickerProvider vsync}) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: vsync,
    );
    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInOut,
    ));
    notifyListeners();
  }

  Future fnOnBackTransition({required BuildContext context}) async {
    if (stepIndex == 0) {
      await Get.offNamedUntil(StartScreen.tag, (route) => false);
    } else if (stepIndex >= 1) {
      animationController!.forward();
      animationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController!.reverse();
        }
      });
      await Future.delayed(Duration(milliseconds: 550)).then((value) {
        stepIndex--;
      });
    }
    notifyListeners();
  }

  Future fnOnForwardTransition({required BuildContext context}) async {
    if (stepIndex == 0) {
      if (fKeyPersonal.currentState!.validate()) {
        animationController!.forward();
        animationController!.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController!.reverse();
          }
        });
        await Future.delayed(Duration(milliseconds: 550)).then((value) async {
          stepIndex++;
        });
      }
    } else if (stepIndex == 1) {
      if (fKeyAddress.currentState!.validate()) {
        animationController!.forward();
        animationController!.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController!.reverse();
          }
        });
        await Future.delayed(Duration(milliseconds: 550)).then((value) {
          stepIndex++;
        });
      }
    } else if (stepIndex == 2) {
      if (fKeyPassword.currentState!.validate()) {
        await _fnRegister(context: context);
      }
    }
    notifyListeners();
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

  fnToggleVisibility(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isHidePassword = !isHidePassword;
    notifyListeners();
  }

  fnToggleVisibility2(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isHidePassword2 = !isHidePassword2;
    notifyListeners();
  }

  Future fnOnSelectDate(DateRangePickerSelectionChangedArgs args, BuildContext context) async {
    this.dobController.text = DateFormat('yyyy-MM-dd').format(args.value);
    isAgeValid = await _service.validateAge(dob: dobController.text);
    if (isAgeValid == false) {
      CustomWidget.showSnackBar(context: context, content: Text('not valid'));
    }
    notifyListeners();
  }

  Future _fnRegister({required BuildContext context}) async {
    _view!.onProgressStart();

    final response = await _service.register(
      fullname: nameController.text,
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

    if (response!.status != null) {
      if (response.status == true) {
        _view!.onProgressFinish();
        await Get.offAllNamed(LoginScreen.tag, arguments: LoginScreen(isRegister: true,));
      } else {
        _view!.onProgressFinish();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.message.toString()}')));
      }
    } else {
      _view!.onProgressFinish();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something wrong')));
    }
    _view!.onProgressFinish();
  }

  Future signInGoogle(BuildContext context) async => await _service.signInWithGoogle();

}