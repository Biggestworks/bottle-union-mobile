import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/banner/banner_list_model.dart';
import 'package:get/get_connect.dart';

class BannerService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<BannerListModel?> getBannerList({String? regionId}) async {
    BannerListModel _model = new BannerListModel();

    final Map<String, dynamic> _query = {
      "id_region": regionId ?? '1',
    };

    try {
      Response _response = await get(
        URLHelper.bannerUrl,
        query: _query,
        headers: await _headersAuth(),
      );
      _model = BannerListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}