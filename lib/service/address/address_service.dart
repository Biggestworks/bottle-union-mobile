import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/address/address_list_model.dart';
import 'package:eight_barrels/model/address/ro_city_model.dart';
import 'package:eight_barrels/model/address/ro_province_model.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:get/get_connect.dart';

class AddressService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    print(_token);

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<RoProvinceModel?> getProvince() async {
    RoProvinceModel _model = new RoProvinceModel();

    try {
      Response _response = await get(
        URLHelper.roProvinceUrl,
        headers: _headers,
      );
      _model = RoProvinceModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<RoCityModel?> getCity({required String provinceId}) async {
    RoCityModel _model = new RoCityModel();

    try {
      Response _response = await get(
        URLHelper.roCityUrl(provinceId),
        headers: _headers,
      );
      _model = RoCityModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> storeAddress({
    required String address,
    required String detailNote,
    required String provinceId,
    required String province,
    required String cityId,
    required String city,
    required String postCode,
    required String label,
    required String latitude,
    required String longitude,
    required String receiver,
    required String phone,
  }) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "address": address,
      "detail_note": detailNote,
      "province_code": provinceId,
      "province_name": province,
      "city_code": cityId,
      "city_name": city,
      "post_code": postCode,
      "label": label,
      "latitude": latitude,
      "longitude": longitude,
      "receiver": receiver,
      "phone": phone,
    };

    try {
      Response _response = await post(
        URLHelper.storeAddressUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<AddressListModel?> getAddress({String? search}) async {
    AddressListModel _model = new AddressListModel();

    final Map<String, dynamic> _query = {
      "keyword": search,
    };

    try {
      Response _response = await get(
        URLHelper.addressUrl,
        query: _query,
        headers: await _headersAuth(),
      );
      _model = AddressListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> deleteAddress({required int id}) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "id": id,
    };

    try {
      Response _response = await post(
        URLHelper.deleteAddressUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> updateAddress({
    required String addressId,
    required String address,
    required String detailNote,
    required String provinceId,
    required String province,
    required String cityId,
    required String city,
    required String postCode,
    required String label,
    required String latitude,
    required String longitude,
    required String receiver,
    required String phone,
  }) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "id": addressId,
      "address": address,
      "detail_note": detailNote,
      "province_code": provinceId,
      "province_name": province,
      "city_code": cityId,
      "city_name": city,
      "post_code": postCode,
      "label": label,
      "latitude": latitude,
      "longitude": longitude,
      "receiver": receiver,
      "phone": phone,
    };

    try {
      Response _response = await post(
        URLHelper.updateAddressUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> selectAddress({required int id}) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "id_address_selected": id,
    };

    try {
      Response _response = await post(
        URLHelper.selectAddressUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }
}
