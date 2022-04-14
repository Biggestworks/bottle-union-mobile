import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/product_card_interface.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/product/product_by_region_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ProductByRegionScreen extends StatefulWidget {
  static String tag = '/product-by-region-screen';
  final int? regionId;
  final String? region;

  const ProductByRegionScreen({Key? key, this.regionId, this.region}) : super(key: key);

  @override
  _ProductByRegionScreenState createState() => _ProductByRegionScreenState();
}

class _ProductByRegionScreenState extends State<ProductByRegionScreen>
    with LoadingView, ProductCardInterface, ProductLog {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ProductByRegionProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<ProductByRegionProvider>(context, listen: false).fnGetView(this);
      Provider.of<ProductByRegionProvider>(context, listen: false).fnFetchProductList();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductByRegionProvider>(context, listen: false);

    Widget _productListContent = Flexible(
      child: Consumer<ProductByRegionProvider>(
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
                        return CustomWidget.emptyScreen(
                          image: 'assets/images/ic_empty_product.png',
                          title: AppLocalizations.instance.text('TXT_NO_PRODUCT'),
                        );
                      default:
                        return NotificationListener<ScrollNotification>(
                          onNotification: provider.fnOnNotification,
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: [
                              MasonryGridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 4,
                                itemCount: provider.productList.result!.data!.length,
                                itemBuilder: (context, index) {
                                  var _data = provider.productList.result!.data![index];
                                  switch (_data.stock) {
                                    case 0:
                                      return popularEmptyProductCard(
                                        context: context,
                                        data: _data,
                                        index: index,
                                        storeLog: () async => await fnStoreLog(
                                          productId: [_data.id ?? 0],
                                          categoryId: null,
                                          notes: KeyHelper.CLICK_PRODUCT_KEY,
                                        ),
                                      );
                                    default:
                                      return Consumer<BaseHomeProvider>(
                                        builder: (context, baseProvider, _) {
                                          return popularProductCard(
                                            context: context,
                                            data: _data,
                                            index: index,
                                            storeClickLog: () async => await fnStoreLog(
                                              productId: [_data.id ?? 0],
                                              categoryId: null,
                                              notes: KeyHelper.CLICK_PRODUCT_KEY,
                                            ),
                                            storeCartLog: () async => await fnStoreLog(
                                              productId: [_data.id ?? 0],
                                              categoryId: null,
                                              notes: KeyHelper.SAVE_CART_KEY,
                                            ),
                                            storeWishlistLog: () async => await fnStoreLog(
                                              productId: [_data.id ?? 0],
                                              categoryId: null,
                                              notes: KeyHelper.SAVE_WISHLIST_KEY,
                                            ),
                                            onUpdateCart: () async => await baseProvider.fnGetCartCount(),
                                          );
                                        },
                                      );
                                  }
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
            children: [
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    hintText: AppLocalizations.instance.text('TXT_SEARCH_PRODUCT'),
                    isDense: true,
                    filled: true,
                    suffixIcon: Icon(Icons.search, size: 24,),
                    fillColor: CustomColor.GREY_BG,
                  ),
                  cursorColor: CustomColor.MAIN,
                  onChanged: (value) async => await _provider.fnOnSearchProduct(value),
                ),
              ),
              SizedBox(width: 10,),
              CustomWidget.textIconBtn(
                icon: MdiIcons.filterVariant,
                label: 'Filter',
                lblColor: CustomColor.BROWN_LIGHT_TXT,
                icColor: CustomColor.BROWN_TXT,
                icSize: 22,
                fontSize: 16,
                function: () {
                  // _provider.fnInitFilter();
                  // _showFilterSheet();
                },
              ),
            ],
          ),
          // SizedBox(height: 10,),
          // Consumer<ProductByRegionProvider>(
          //   child: SizedBox(),
          //   builder: (context, provider, skeleton) {
          //     switch (provider.filterVal.length) {
          //       case 0:
          //         return skeleton!;
          //       default:
          //         return Container(
          //           height: 50,
          //           child: ListView.builder(
          //             shrinkWrap: true,
          //             scrollDirection: Axis.horizontal,
          //             itemCount: provider.filterVal.length,
          //             itemBuilder: (context, index) {
          //               var _data = provider.filterVal[index];
          //               return Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 5),
          //                 child: Chip(
          //                   backgroundColor: CustomColor.BROWN_TXT,
          //                   label: Text(_data.value, style: TextStyle(
          //                     color: Colors.white,
          //                   ),),
          //                 ),
          //               );
          //             },
          //           ),
          //         );
          //     }
          //   },
          // ),
          _productListContent,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        centerTitle: true,
        title: Text(_provider.region ?? 'Title', style: TextStyle(
          color: CustomColor.BROWN_TXT,
        ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
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
