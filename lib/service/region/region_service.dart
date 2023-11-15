import 'dart:developer';

import 'package:eight_barrels/helper/url_helper.dart';

import 'package:get/get_connect/connect.dart';

import '../../model/region/branch_models.dart';
import '../../model/region/city_models.dart';
import '../../model/region/country_models.dart';

class RegionService extends GetConnect {
  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };
  Future<CountryModels> fetchCountry() async {
    Response _response = await get(
      URLHelper.countryUrl,
      headers: _headers,
    );
    return CountryModels.fromJson(_response.body);
  }

  Future<CityModels> fetchCity(id) async {
    Response _response = await get(
      "${URLHelper.cityUrl}$id",
      headers: _headers,
    );
    log("${URLHelper.cityUrl}$id");
    print(_response.body);
    return CityModels.fromJson(_response.body);
  }

  Future<BranchModels> fetchBranch(id) async {
    Response _response = await get(
      "${URLHelper.branchUrl}$id",
      headers: _headers,
    );
    print(_response.body);
    return BranchModels.fromJson(_response.body);
  }
}
