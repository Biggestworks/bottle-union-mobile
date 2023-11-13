import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/model/branch_models/branch_models.dart';
import 'package:eight_barrels/model/city_models/city_models.dart';
import 'package:eight_barrels/model/country/country_models.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ChooseCountryPage extends StatefulWidget {
  const ChooseCountryPage({Key? key});

  @override
  State<ChooseCountryPage> createState() => _ChooseCountryPageState();
}

class _ChooseCountryPageState extends State<ChooseCountryPage> {
  CountryModels? selectedCountry;
  CityModels? selectedCity;
  BranchModels? selectedBranch;
  bool isSaveSelection = false;
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
              children: CountryModels.listCountry().map((e) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCountry = e;
                      selectedCity = null;
                      selectedBranch = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          if (selectedCountry != null)
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
                    children: CityModels.fetchListCity()
                        .where((element) =>
                            element.country_id == selectedCountry!.id)
                        .map((e) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCity = e;
                            selectedBranch = null;
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
          if (selectedCity != null)
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
                    children: BranchModels.fetchBranch()
                        .where((element) => element.city_id == selectedCity!.id)
                        .map((e) {
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
                              selectedCountry!.id,
                              selectedCity!.id,
                              selectedBranch!.id);
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
}
