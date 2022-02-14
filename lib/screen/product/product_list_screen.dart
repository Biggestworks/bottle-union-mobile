import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/product/product_list_provider.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';


class ProductListScreen extends StatefulWidget {
  static String tag = '/product-list-screen';

  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<ProductListProvider>(context, listen: false).fnGetView(this);
      Provider.of<ProductListProvider>(context, listen: false).fnFetchProductList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductListProvider>(context, listen: false);

    _showFilterSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value : Provider.of<ProductListProvider>(context, listen: false),
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(20),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_LBL_FILTER'), style: TextStyle(
                            fontSize: 20,
                          ),),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _provider.onResetFilter();
                            },
                            child: Text('Reset Filter', style: TextStyle(
                              color: CustomColor.MAIN,
                              fontSize: 16,
                            ),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        child: Card(
                          color: CustomColor.GREY_LIGHT_BG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AppLocalizations.instance.text('TXT_LBL_BRAND'), style: TextStyle(
                                  fontSize: 20,
                                ),),
                                SizedBox(height: 10,),
                                Flexible(
                                  child: Consumer<ProductListProvider>(
                                    child: Container(),
                                    builder: (context, provider, skeleton) {
                                      switch (provider.brandList.data) {
                                        case null:
                                          return skeleton!;
                                        default:
                                          return GridView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              childAspectRatio: 2,
                                            ),
                                            itemCount: provider.brandList.data!.length,
                                            itemBuilder: (context, index) {
                                              var _data = provider.brandList.data![index];
                                              return FilterChip(
                                                label: Text(_data.name!),
                                                labelStyle: TextStyle(color: Colors.white),
                                                backgroundColor: CustomColor.GREY_ICON,
                                                selectedColor: CustomColor.MAIN,
                                                selected: provider.selectedBrandIndex == index && provider.isBrandSelected,
                                                checkmarkColor: Colors.white,
                                                onSelected: (_) {
                                                  provider.fnOnSelectBrand(index);
                                                },
                                              );
                                            },
                                          );
                                      }
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        child: Card(
                          color: CustomColor.GREY_LIGHT_BG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AppLocalizations.instance.text('TXT_LBL_CATEGORY'), style: TextStyle(
                                  fontSize: 20,
                                ),),
                                SizedBox(height: 10,),
                                Flexible(
                                  child: Consumer<ProductListProvider>(
                                    child: Container(),
                                    builder: (context, provider, skeleton) {
                                      switch (provider.categoryList.data) {
                                        case null:
                                          return skeleton!;
                                        default:
                                          return GridView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              childAspectRatio: 2,
                                            ),
                                            itemCount: provider.categoryList.data!.length,
                                            itemBuilder: (context, index) {
                                              var _data = provider.categoryList.data![index];
                                              return FilterChip(
                                                label: Text(_data.name!),
                                                labelStyle: TextStyle(color: Colors.white),
                                                backgroundColor: CustomColor.GREY_ICON,
                                                selectedColor: CustomColor.MAIN,
                                                selected: provider.selectedCategoryIndex == index && provider.isCategorySelected,
                                                checkmarkColor: Colors.white,
                                                onSelected: (_) {
                                                  provider.fnOnSelectCategory(index);
                                                },
                                              );
                                            },
                                          );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 10,),
                      // Text(AppLocalizations.instance.text('TXT_LBL_COUNTRY'), style: TextStyle(
                      //   fontSize: 20,
                      // ),),
                      SizedBox(height: 10,),
                      Flexible(
                        child: Card(
                          color: CustomColor.GREY_LIGHT_BG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AppLocalizations.instance.text('TXT_LBL_YEAR'), style: TextStyle(
                                  fontSize: 20,
                                ),),
                                SizedBox(
                                  height: 150,
                                  child: SfDateRangePicker(
                                    view: DateRangePickerView.decade,
                                    selectionMode: DateRangePickerSelectionMode.single,
                                    enableMultiView: false,
                                    allowViewNavigation: false,
                                    onSelectionChanged: (value) {
                                      _provider.fnOnSelectYear(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        child: Card(
                          color: CustomColor.GREY_LIGHT_BG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AppLocalizations.instance.text('TXT_LBL_PRICE'), style: TextStyle(
                                  fontSize: 20,
                                ),),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _provider.minPriceController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          MoneyInputFormatter(
                                            thousandSeparator: ThousandSeparator.Period,
                                            useSymbolPadding: false,
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.instance.text('TXT_LBL_MIN_PRICE'),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          isDense: true,
                                          filled: true,
                                          fillColor: CustomColor.GREY_BG,
                                          prefixIcon: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Rp'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _provider.maxPriceController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          MoneyInputFormatter(
                                            thousandSeparator: ThousandSeparator.Period,
                                            useSymbolPadding: false,
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.instance.text('TXT_LBL_MAX_PRICE'),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          isDense: true,
                                          filled: true,
                                          fillColor: CustomColor.GREY_BG,
                                          prefixIcon: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Rp'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Consumer<ProductListProvider>(
                  child: SizedBox(),
                  builder: (context, provider, skeleton) {
                    switch (provider.isFiltered) {
                      case true:
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: CustomWidget.roundBtn(
                            label: 'Submit Filter',
                            btnColor: CustomColor.MAIN,
                            lblColor: Colors.white,
                            function: () async {
                              Navigator.pop(context);
                              await _provider.fnOnSubmitFilter();
                            },
                          ),
                        );
                      default:
                        return skeleton!;
                    }
                  }
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _productListContent = Flexible(
      child: Consumer<ProductListProvider>(
          child: CustomWidget.showShimmerGridList(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.productList.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.productList.result!.data!.length) {
                      case 0:
                        return Center(child: Text('empty'),);
                      default:
                        return NotificationListener<ScrollNotification>(
                          onNotification: provider.fnOnNotification,
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: [
                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2.0,
                                  childAspectRatio: 0.62,
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.productList.result!.data!.length,
                                itemBuilder: (context, index) {
                                  var _data = provider.productList.result!.data![index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadiusDirectional.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(
                                          productList: _data,
                                        )),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: _data.image1!,
                                                width: MediaQuery.of(context).size.width,
                                                alignment: Alignment.center,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Center(
                                                    child: CircularProgressIndicator()),
                                                errorWidget: (context, url, error) =>
                                                    Center(child: Icon(Icons.error, size: 80,),),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(_data.name!, style: TextStyle(
                                                          color: CustomColor.BROWN_LIGHT_TXT,
                                                          fontSize: 16,
                                                        ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          children: [
                                                            Icon(FontAwesomeIcons.solidStar, color: Colors.orangeAccent, size: 18,),
                                                            SizedBox(width: 5,),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 2),
                                                              child: Text(_data.rating.toString()),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Flexible(
                                                          child: Text(FormatterHelper.moneyFormatter(_data.regularPrice), style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: CustomColor.MAIN_TXT,
                                                            fontSize: 18,
                                                          ),),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('Stock: ${_data.stock}', style: TextStyle(
                                                          color: CustomColor.GREY_TXT,
                                                        ),),
                                                        Flexible(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Icon(FontAwesomeIcons.shoppingCart, color: CustomColor.GREY_ICON, size: 18,),
                                                              SizedBox(width: 15,),
                                                              Icon(FontAwesomeIcons.heart, color: CustomColor.GREY_ICON, size: 18,),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                height: provider.isPaginateLoad ? 50 : 0,
                                child: Center(
                                  child: provider.isPaginateLoad
                                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(CustomColor.MAIN),)
                                      : SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        );
                    }
                }
            }
          }
      ),
    );

    Widget _mainContent = Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.instance.text('TXT_HEADER_CELLAR'), style: TextStyle(
                color: CustomColor.BROWN_TXT,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
              TextButton.icon(
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  await Future.delayed(Duration.zero).then((_) async {
                    await _provider.fnFetchBrandList();
                    await _provider.fnFetchCategoryList();
                  }).then((_) => _showFilterSheet());
                },
                icon: Icon(MdiIcons.filterVariant, color: CustomColor.BROWN_TXT,),
                label: Text('Sort/Filter', style: TextStyle(
                  color: CustomColor.BROWN_LIGHT_TXT,
                ),),
              ),
            ],
          ),
          SizedBox(height: 5,),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              hintText: 'Search product...',
              isDense: true,
              filled: true,
              suffixIcon: Icon(Icons.search, size: 24,),
              fillColor: CustomColor.GREY_BG,
            ),
            onChanged: (value) async => await _provider.fnOnSearchProduct(value),
          ),
          _productListContent,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,),
            child: SizedBox(
              width: 140,
              child: Image.asset('assets/images/ic_logo_bu.png',),
            ),
          ),
        ],
      ),
      body: _mainContent,
    );
  }

  // @override
  // void onPaginationLoadFinish() {
  //   if (mounted) {
  //     _isPaginateLoad = false;
  //     setState(() {});
  //   }
  // }
  //
  // @override
  // void onPaginationLoadStart() {
  //   if (mounted) {
  //     _isPaginateLoad = true;
  //     setState(() {});
  //   }
  // }

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
