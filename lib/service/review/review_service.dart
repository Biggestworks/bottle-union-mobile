import 'dart:io';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:eight_barrels/model/review/review_list_model.dart';
import 'package:get/get_connect.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ReviewService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<DefaultModel?> storeReview({
    required int productId,
    required int rating,
    String? comment,
    File? image1,
    File? image2,
    File? image3,
  }) async {
    DefaultModel _model = new DefaultModel();
    MultipartFile? _imageFile1;
    MultipartFile? _imageFile2;
    MultipartFile? _imageFile3;

    try {
      if (image1 != null) {
        _imageFile1 = MultipartFile(
          image1.path,
          filename: basename(image1.path),
          contentType: MediaType(
            "image",
            basename(image1.path),
          ).type,
        );
      }

      if (image2 != null) {
        _imageFile2 = MultipartFile(
          image2.path,
          filename: basename(image2.path),
          contentType: MediaType(
            "image",
            basename(image2.path),
          ).type,
        );
      }

      if (image3 != null) {
        _imageFile3 = MultipartFile(
          image3.path,
          filename: basename(image3.path),
          contentType: MediaType(
            "image",
            basename(image3.path),
          ).type,
        );
      }

      FormData _data = new FormData({
        "id_product": productId.toString(),
        "rating": rating,
        "comment": comment,
        "image_1": _imageFile1 ?? null,
        "image_2": _imageFile2 ?? null,
        "image_3": _imageFile3 ??  null,
      });

      print(_data.fields);

      Response _response = await post(
        URLHelper.storeReviewUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<ReviewListModel?> getReviewList() async {
    ReviewListModel _model = new ReviewListModel();

    try {
      Response _response = await get(
        URLHelper.reviewUrl,
        headers: await _headersAuth(),
      );
      _model = ReviewListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }
}