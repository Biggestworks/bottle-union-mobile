import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/banner/banner_list_model.dart';
import 'package:get/get_connect.dart';

class BannerService extends GetConnect {
  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<BannerListModel?> getBannerList() async {
    BannerListModel _model = new BannerListModel();

    try {
      Response _response = await get(
        URLHelper.BANNER_URL,
        headers: _headers,
      );
      _model = BannerListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}