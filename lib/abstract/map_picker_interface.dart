import 'package:eight_barrels/helper/key_helper.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:location/location.dart';

abstract class MapPickerInterface {
  Location _location = new Location();

  Future showMapPicker({required LatLng currLocation}) async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
      }

      if (_serviceEnabled && _permissionGranted != PermissionStatus.denied) {
        Get.to(() => PlacePicker(
          apiKey: KeyHelper.API_KEY,
          enableMapTypeButton: true,
          usePlaceDetailSearch: true,
          onPlacePicked: (result) => onPlacePicked(result),
          region: 'ID',
          initialPosition: currLocation,
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