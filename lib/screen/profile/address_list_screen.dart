import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/model/address/address_list_model.dart';
import 'package:eight_barrels/provider/profile/address_list_provider.dart';
import 'package:eight_barrels/screen/profile/add_address_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatefulWidget {
  static String tag = '/address-list-screen';
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> implements LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<AddressListProvider>(context, listen: false).fnGetView(this);
      Provider.of<AddressListProvider>(context, listen: false).fnFetchAddressList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AddressListProvider>(context, listen: false);

    _showOptionSheet(Data? data) {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value : Provider.of<AddressListProvider>(context, listen: false),
          child: Container(
            height: 250,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                      iconSize: 30,
                    ),
                    Text('Other options', style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                ),
                SizedBox(height: 10,),
                if (data?.isChoosed == 0) Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        await _provider.fnSelectAddress(_provider.scaffoldKey.currentContext!, data!.id!);
                      },
                      child: Text("Choose as main address", style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Divider(height: 10, indent: 5, endIndent: 5, color: Colors.black,),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    Get.back();
                    await _provider.fnDeleteAddress(_provider.scaffoldKey.currentContext!, data!.id!);
                  },
                  child: Text("Delete address", style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _mainContent = Padding(
      padding: EdgeInsets.all(15),
      child: Consumer<AddressListProvider>(
        child: CustomWidget.showShimmerListView(height: 200),
        builder: (context, provider, skeleton) {
          switch (provider.addressList.data) {
            case null:
              return skeleton!;
            default:
              switch (provider.addressList.data?.length) {
                case 0:
                  return CustomWidget.emptyScreen(
                    image: 'assets/images/ic_empty.png',
                    title: AppLocalizations.instance.text('TXT_NO_ADDRESS'),
                    size: 180
                  );
                default:
                  return Column(
                    children: [
                      TextFormField(
                        controller: _provider.searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Search address...',
                          isDense: true,
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          fillColor: CustomColor.GREY_BG,
                        ),
                        // onChanged: (text) async => await provider.onChangedAddressFilter(),
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.addressList.data?.length,
                          itemBuilder: (context, index) {
                            var _data = provider.addressList.data?[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_data?.isChoosed == 1) Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Text('Main', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),),
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text(_data?.user?.fullname ?? '-'),
                                        if (_data?.label != null)
                                          Text(' (${_data?.label})', style: TextStyle(
                                            color: CustomColor.MAIN,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Text(_data?.user?.phone ?? '-'),
                                    SizedBox(height: 5,),
                                    Text(_data?.address ?? '-', style: TextStyle(
                                      color: CustomColor.GREY_TXT,
                                    ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 5,),
                                    Text(_data?.cityName ?? '-', style: TextStyle(
                                      color: CustomColor.GREY_TXT,
                                    ),),
                                    SizedBox(height: 5,),
                                    Text(_data?.provinceName ?? '-', style: TextStyle(
                                      color: CustomColor.GREY_TXT,
                                    ),),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              primary: Colors.white,
                                              side: BorderSide(
                                                color: CustomColor.GREY_TXT,
                                              ),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10),),
                                              ),
                                            ),
                                            onPressed: () async => await Get.toNamed(AddAddressScreen.tag, arguments: AddAddressScreen(
                                              address: _data,
                                            ))!.then((value) async {
                                              if (value == true) {
                                                await _provider.fnFetchAddressList();
                                                await CustomWidget.showSnackBar(context: context, content: Text('Success'));
                                              }
                                            }),
                                            child: Text('Edit Address', style: TextStyle(
                                              color: CustomColor.GREY_TXT,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            primary: Colors.white,
                                            side: BorderSide(
                                              color: CustomColor.GREY_TXT,
                                            ),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)
                                              ),
                                            ),
                                          ),
                                          onPressed: () => _showOptionSheet(_data),
                                          child: Icon(Icons.more_horiz, color: CustomColor.GREY_TXT,),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                  break;
              }
              break;
          }
        },
      ),
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_LBL_MY_ADDRESS')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async => await Get.toNamed(AddAddressScreen.tag, arguments: AddAddressScreen())!.then((value) async {
                if (value == true) {
                  await _provider.fnFetchAddressList();
                  await CustomWidget.showSnackBar(context: context, content: Text('Success'));
                }
              }),
              icon: Icon(Icons.add, size: 28,),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: _mainContent,
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
