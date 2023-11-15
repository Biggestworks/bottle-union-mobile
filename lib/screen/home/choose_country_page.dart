import 'dart:developer';

import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';

import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/service/region/region_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../model/region/branch_models.dart';
import '../../model/region/city_models.dart';
import '../../model/region/country_models.dart';
import '../splash/splash_screen.dart';
import '../widget/custom_widget.dart';

class ChooseCountryPage extends StatefulWidget {
  static String tag = '/choose-country-page';
  const ChooseCountryPage({Key? key});

  @override
  State<ChooseCountryPage> createState() => _ChooseCountryPageState();
}

class _ChooseCountryPageState extends State<ChooseCountryPage> {
  CountryModels? listCountry;
  CountryData? selectedCountry;
  CityModels? listCity;
  CityData? selectedCity;
  BranchModels? listBranch;
  BranchData? selectedBranch;
  bool isSaveSelection = false;

  @override
  void initState() {
    new RegionService().fetchCountry().then((value) {
      setState(() {
        listCountry = value;
        checkSelectedRegion();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  Provider.of<BaseHomeProvider>(context, listen: false).selectedBranch = 0;
    return Scaffold(
      backgroundColor: CustomColor.MAIN,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Before using the apps, please choose store* :",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          if (listCountry != null)
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Choose Country",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: listCountry!.data.map((e) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCountry = e;
                            listCity = null;
                            selectedCity = null;
                            selectedBranch = null;
                            listBranch = null;
                            new RegionService().fetchCity(e.id).then((value) {
                              log(value.toString());
                              setState(() {
                                listCity = value;
                              });
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedCountry != null &&
                                    selectedCountry!.name == e.name
                                ? Colors.white.withOpacity(.5)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            e.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          if (selectedCountry != null && listCity != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Choose City",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: listCity!.data.map((e) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCity = e;
                            selectedBranch = null;
                            listBranch = null;

                            new RegionService().fetchBranch(e.id).then((value) {
                              setState(() {
                                listBranch = value;
                              });
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedCity != null &&
                                    selectedCity!.name == e.name
                                ? Colors.white.withOpacity(.5)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            e.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          if (selectedCity != null && listBranch != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Choose Branch",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: listBranch!.data.map((e) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedBranch = e;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedBranch != null &&
                                    selectedBranch!.name == e.name
                                ? Colors.white.withOpacity(.5)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            e.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          Container(
            margin: const EdgeInsets.only(left: 16, top: 30),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isSaveSelection = !isSaveSelection;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: isSaveSelection ? Colors.white : null,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        FontAwesome.check,
                        size: 15,
                        color:
                            isSaveSelection ? Colors.black : Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Save store selection",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width - 32, 50),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: selectedCountry != null &&
                      selectedCity != null &&
                      selectedBranch != null
                  ? () {
                      Provider.of<BaseHomeProvider>(context, listen: false)
                          .saveBranchSelection(
                              isSaveSelection,
                              selectedCountry!.id.toString(),
                              selectedCity!.id.toString(),
                              selectedBranch!.id.toString(),
                              selectedBranch!.name.toString());

                      CustomWidget.showSuccessDialog(
                        context,
                        desc: AppLocalizations.instance
                            .text('TXT_REGION_PREFERENCE_SUCCESS'),
                        function: () => Get.offNamedUntil(
                            SplashScreen.tag, (route) => false),
                      );
                    }
                  : null,
              child: Text(
                "Continue",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkSelectedRegion() async {
    final _storage = new FlutterSecureStorage();
    var country = await _storage.read(key: KeyHelper.SELECTED_COUNTRY_KEY);
    var city = await _storage.read(key: KeyHelper.SELECTED_CITY_KEY);
    var branch = await _storage.read(key: KeyHelper.SELECTED_BRANCH_KEY);

    if (country != null) {
      setState(() {
        selectedCountry = listCountry!.data
            .firstWhere((element) => element.id.toString() == country);
      });
    }

    if (city != null) {
      new RegionService().fetchCity(country).then((value) {
        setState(() {
          listCity = value;
          selectedCity =
              value.data.firstWhere((element) => element.id.toString() == city);
        });
      });
    }

    if (branch != null) {
      new RegionService().fetchBranch(city).then((value) {
        setState(() {
          listBranch = value;
          selectedBranch =
              value.data.firstWhere((e) => e.id.toString() == branch);
        });
      });
    }
  }
}
