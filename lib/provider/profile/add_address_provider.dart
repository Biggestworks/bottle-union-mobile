import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/map_picker_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/address/address_list_model.dart';
import 'package:eight_barrels/model/address/ro_city_model.dart';
import 'package:eight_barrels/model/address/ro_province_model.dart';
import 'package:eight_barrels/screen/profile/add_address_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/address/address_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class AddAddressProvider extends ChangeNotifier with MapPickerInterface {
  AddressService _service = new AddressService();
  TextEditingController addressController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  TextEditingController provinceController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController posCodeController = new TextEditingController();
  TextEditingController labelController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  LoadingView? _view;

  LatLng? _currLocation;

  RoProvinceModel provinceList = new RoProvinceModel();
  RoCityModel cityList = new RoCityModel();

  String? selectedProvinceId;
  String? selectedCityId;

  Data? _addr;

  String title = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    _view!.onProgressStart();
    final _args = ModalRoute.of(context)!.settings.arguments as AddAddressScreen;
    _addr = _args.address ?? null;
    if (_addr != null) {
      title = AppLocalizations.instance.text('TXT_UPDATE_ADDRESS');
      addressController.text = _addr?.address ?? '';
      noteController.text = _addr?.detailNote ?? '';
      selectedProvinceId = _addr?.provinceCode.toString();
      provinceController.text = _addr?.provinceName ?? '';
      selectedCityId = _addr?.cityCode.toString();
      cityController.text = _addr?.cityName ?? '';
      posCodeController.text = _addr?.postCode ?? '';
      labelController.text = _addr?.label ?? '';
      _currLocation = LatLng(double.parse(_addr?.latitude ?? '0'), double.parse(_addr?.longitude ?? '0'));
      nameController.text = _addr?.receiver ?? '';
      phoneController.text = _addr?.phone ?? '';
    } else {
      title = AppLocalizations.instance.text('TXT_ADD_ADDRESS');
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnShowMapPicker(BuildContext context) async {
    double _lat = 0;
    double _lng = 0;

    if (_addr != null) {
      if (_currLocation != null) {
        await super.showMapPicker(context: context, currLocation: LatLng(_currLocation!.latitude, _currLocation!.longitude));
      } else {
        _lat = double.parse(_addr?.latitude ?? '0');
        _lng = double.parse(_addr?.longitude ?? '0');
        await super.showMapPicker(context: context, currLocation: LatLng(_lat, _lng));
      }
    } else {
      await super.showMapPicker(context: context);
    }
  }

  Future fnFetchProvinceList() async {
    _view!.onProgressStart();
    provinceList = (await _service.getProvince())!;
    if (selectedProvinceId != null) {
      cityList = (await _service.getCity(provinceId: selectedProvinceId ?? ''))!;
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSelectProvince({required String name, required String id}) async {
    provinceController.text = name;
    selectedProvinceId = id;
    cityList = (await _service.getCity(provinceId: selectedProvinceId ?? ''))!;
    notifyListeners();
  }

  fnOnSelectCity({required String name, required String id}) {
    cityController.text = name;
    selectedCityId = id;
    notifyListeners();
  }

  Future fnStoreAddress(BuildContext context) async {
    var _res;

    if (formKey.currentState!.validate()) {
      if (_addr != null) {
        _res = await _service.updateAddress(
          addressId: _addr!.id.toString(),
          address: addressController.text,
          detailNote: noteController.text,
          provinceId: selectedProvinceId ?? '',
          province: provinceController.text,
          cityId: selectedCityId ?? '',
          city: cityController.text,
          postCode: posCodeController.text,
          label: labelController.text,
          latitude: _currLocation!.latitude.toString(),
          longitude: _currLocation!.latitude.toString(),
          receiver: nameController.text,
          phone: phoneController.text,
        );
      } else {
        _res = await _service.storeAddress(
          address: addressController.text,
          detailNote: noteController.text,
          provinceId: selectedProvinceId ?? '',
          province: provinceController.text,
          cityId: selectedCityId ?? '',
          city: cityController.text,
          postCode: posCodeController.text,
          label: labelController.text,
          latitude: _currLocation!.latitude.toString(),
          longitude: _currLocation!.latitude.toString(),
          receiver: nameController.text,
          phone: phoneController.text,
        );
      }

      if (_res!.status != null) {
        if (_res.status == true) {
          Get.back(result: true);
        } else {
          await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
        }
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      }
    }
    notifyListeners();
  }

  @override
  Future onPlacePicked(PickResult result) async {
    Get.back();
    addressController.text = result.formattedAddress!;
    _currLocation = LatLng(result.geometry!.location.lat, result.geometry!.location.lng);
    List<Placemark> _address = await placemarkFromCoordinates(_currLocation!.latitude, _currLocation!.longitude);
    posCodeController.text = _address[0].postalCode ?? '';
    notifyListeners();
  }

}