import 'dart:math';

import 'package:eight_barrels/helper/app-localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:location/location.dart';
import 'package:timelines/timelines.dart';

class RegisterProvider extends ChangeNotifier {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  String gender = 'man';
  int stepIndex = 0;
  
  AnimationController? animationController;
  Animation<Offset>? offsetAnimation;

  LatLng? currLocation;
  LatLng? selectedLocation;
  

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

  Future fnGetCurrLocation() async {
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
      await location.getLocation().then((value) {
        currLocation = LatLng(value.latitude!, value.longitude!);
      });
    } on Exception {
      currLocation = null;
    }
  }

  Widget fnShowMapPicker() {
    return Container(
      height: 300,
      child: PlacePicker(
        apiKey: KeyHelper.API_KEY,
        enableMapTypeButton: false,
        usePlaceDetailSearch: false,
        onPlacePicked: (result) {
          print(result);
        },
        region: 'ID',
        initialPosition: currLocation!,
        useCurrentLocation: true,
        enableMyLocationButton: true,
        resizeToAvoidBottomInset: true,
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
      await location.getLocation().then((value) {
        currLocation = LatLng(value.latitude!, value.longitude!);
      });
    } on Exception {
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
          },
          region: 'ID',
          initialPosition: currLocation!,
          useCurrentLocation: true,
          enableMyLocationButton: true,
        ),
      ),
    );

  }

  initAnimation({required TickerProvider vsync}) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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

  Future backTransition({required BuildContext context}) async {
    if (stepIndex == 0) {
      await Navigator.pushNamedAndRemoveUntil(
          context, StartScreen.tag, (Route<dynamic> route) => false);
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

  Future forwardTransition({required BuildContext context}) async {
    if (stepIndex == 0) {
      await fnGetCurrLocation();

      animationController!.forward();
      animationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController!.reverse();
        }
      });
      await Future.delayed(Duration(milliseconds: 600)).then((value) async {
        stepIndex++;
      });
    } else if (stepIndex == 1) {
      animationController!.forward();
      animationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController!.reverse();
        }
      });
      await Future.delayed(Duration(milliseconds: 550)).then((value) {
        stepIndex++;
      });
    } else if (stepIndex == 2) {
    }
    notifyListeners();
  }
}

class BezierPainter extends CustomPainter {
  const BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}