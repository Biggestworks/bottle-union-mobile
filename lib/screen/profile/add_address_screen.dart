import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/model/address/address_list_model.dart';
import 'package:eight_barrels/provider/profile/add_address_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  static String tag = '/add-address-screen';
  final Data? address;

  const AddAddressScreen({Key? key, this.address}) : super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen>
    with TextValidation , LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<AddAddressProvider>(context, listen: false).fnGetView(this);
      Provider.of<AddAddressProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<AddAddressProvider>(context, listen: false).fnFetchProvinceList();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AddAddressProvider>(context, listen: false);

    Widget _mainContent = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _provider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.text('TXT_LBL_ADDRESS'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: () async => _provider.fnShowMapPicker(),
                child: TextFormField(
                  enabled: false,
                  controller: _provider.addressController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validateField,
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: Icon(FontAwesomeIcons.mapMarkedAlt, size: 24, color: Colors.black,),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: CustomColor.GREY_BG,
                    errorStyle: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_LBL_DETAIL_NOTE'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              TextFormField(
                controller: _provider.noteController,
                maxLines: null,
                decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: CustomColor.GREY_BG,
                    hintText: '*Optional'
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_REGISTER_PROVINCE'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: () => CustomWidget.showSheet(
                  context: context,
                  isScroll: true,
                  child: ChangeNotifierProvider.value(
                    value: Provider.of<AddAddressProvider>(context, listen: false),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Consumer<AddAddressProvider>(
                        child: Container(),
                        builder: (context, provider, skeleton) {
                          switch (provider.provinceList.rajaongkir) {
                            case null:
                              return skeleton!;
                            default:
                              switch (provider.provinceList.rajaongkir?.results) {
                                case null:
                                  return skeleton!;
                                default:
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: provider.provinceList.rajaongkir!.results!.length,
                                    itemBuilder: (context, index) {
                                      var _data = provider.provinceList.rajaongkir!.results![index];
                                      return GestureDetector(
                                        onTap: () async {
                                          Get.back();
                                          await provider.fnOnSelectProvince(
                                            name: _data.province!,
                                            id: _data.provinceId!,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                          child: Text(_data.province ?? '-', style: TextStyle(
                                            fontSize: 16,
                                          ),),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                  );
                              }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                child: TextFormField(
                  enabled: false,
                  controller: _provider.provinceController,
                  validator: validateField,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: CustomColor.GREY_BG,
                    errorStyle: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_REGISTER_CITY'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: () {
                  if (_provider.provinceController.text.isNotEmpty) {
                    CustomWidget.showSheet(
                      context: context,
                      isScroll: true,
                      child: ChangeNotifierProvider.value(
                        value: Provider.of<AddAddressProvider>(context, listen: false),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Consumer<AddAddressProvider>(
                            child: Container(),
                            builder: (context, provider, skeleton) {
                              switch (provider.cityList.rajaongkir) {
                                case null:
                                  return skeleton!;
                                default:
                                  switch (provider.cityList.rajaongkir?.results) {
                                    case null:
                                      return skeleton!;
                                    default:
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: provider.cityList.rajaongkir!.results!.length,
                                        itemBuilder: (context, index) {
                                          var _data = provider.cityList.rajaongkir!.results![index];
                                          return GestureDetector(
                                            onTap: () async {
                                              Get.back();
                                              await provider.fnOnSelectCity(
                                                name: _data.cityName!,
                                                id: _data.cityId!,
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                              child: Text(_data.cityName ?? '-', style: TextStyle(
                                                fontSize: 16,
                                              ),),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider();
                                        },
                                      );
                                  }
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_REGISTER_CITY_INFO')));
                  }
                },
                child: TextFormField(
                  enabled: false,
                  controller: _provider.cityController,
                  validator: validateField,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: CustomColor.GREY_BG,
                    errorStyle: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_POST_CODE'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              TextFormField(
                controller: _provider.posCodeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validateField,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: CustomColor.GREY_BG,
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_LBL_ADDRESS_LABEL'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              TextFormField(
                controller: _provider.labelController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: CustomColor.GREY_BG,
                  hintText: 'e.g: Home, Office, etc',
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_LBL_RECEIVER_NAME'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              TextFormField(
                controller: _provider.nameController,
                textInputAction: TextInputAction.next,
                validator: validateField,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: CustomColor.GREY_BG,
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_LBL_RECEIVER_PHONE'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              TextFormField(
                controller: _provider.phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: validatePhoneNumber,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: CustomColor.GREY_BG,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _submitBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: CustomWidget.roundBtn(
          label: AppLocalizations.instance.text('TXT_SAVE'),
          btnColor: CustomColor.MAIN,
          lblColor: Colors.white,
          isBold: true,
          fontSize: 16,
          function: () async => await _provider.fnStoreAddress(context),
        ),
      ),
    );
    
    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.MAIN,
          title: Consumer<AddAddressProvider>(
            builder: (context, provider, _) {
              return Text(provider.title);
            }
          ),
        ),
        body: _mainContent,
        bottomNavigationBar: _submitBtn,
      ),
    );
  }

  @override
  void onProgressFinish() {
    if (mounted) {
      _isLoad = false;
      setState(() {});
    }
  }

  @override
  void onProgressStart() {
    if (mounted) {
      _isLoad = true;
      setState(() {});
    }
  }

}
