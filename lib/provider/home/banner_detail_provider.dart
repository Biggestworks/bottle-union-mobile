import 'package:eight_barrels/model/banner/banner_list_model.dart';
import 'package:eight_barrels/screen/home/banner_detail_screen.dart';
import 'package:flutter/material.dart';

class BannerDetailProvider extends ChangeNotifier {
  Data banner = new Data();

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as BannerDetailScreen;
    banner = _args.banner!;
    notifyListeners();
  }

}