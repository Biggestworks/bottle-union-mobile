import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

abstract class MapPickerInterface {
  Future showMapPicker(
      {required BuildContext context, LatLng? currLocation}) async {
    try {
      bool _serviceEnabled;
      LocationPermission _permission;

      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        await CustomWidget.showSnackBar(
            context: context, content: Text('Location services are disabled.'));
      }

      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
        if (_permission == LocationPermission.denied) {
          await CustomWidget.showSnackBar(
              context: context,
              content: Text('Location permissions are denied.'));
        } else if (_permission == LocationPermission.deniedForever) {
          await CustomWidget.showSnackBar(
              context: context,
              content: Text(
                  'Location permissions are permanently denied, Bottle Union cannot request permissions.'));
        }
      } else if (_permission == LocationPermission.deniedForever) {
        await CustomWidget.showSnackBar(
            context: context,
            content: Text(
                'Location permissions are permanently denied, Bottle Union cannot request permissions.'));
      }

      if (currLocation == null) {
        await Geolocator.getCurrentPosition().then((value) {
          currLocation = LatLng(value.latitude, value.longitude);
        });
      }

      if (currLocation != null) {
        Get.to(() => PlacePicker(
              apiKey: dotenv.get('MAP_API_KEY', fallback: 'API_URL not found'),
              enableMapTypeButton: true,
              usePlaceDetailSearch: true,
              onPlacePicked: (result) => onPlacePicked(result),
              region: 'ID',
              initialPosition: currLocation!,
              useCurrentLocation: false,
              enableMyLocationButton: true,
              selectInitialPosition: true,
            ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future onPlacePicked(PickResult result);
}
