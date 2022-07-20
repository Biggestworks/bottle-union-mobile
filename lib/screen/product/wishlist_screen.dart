import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/product/wishlist_provider.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  static String tag = '/wishlist-screen';

  const WishListScreen({Key? key}) : super(key: key);

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen>
    with LoadingView, ProductLog {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<WishListProvider>(context, listen: false).fnGetView(this);
      Provider.of<WishListProvider>(context, listen: false).fnFetchWishlist();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<WishListProvider>(context, listen: false);
    final _baseProvider = Provider.of<BaseHomeProvider>(context, listen: false);

    Widget _productListContent = Flexible(
      child: Consumer<WishListProvider>(
          child: CustomWidget.showShimmerListView(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.wishlist.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.wishlist.result!.data!.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                          image: 'assets/images/ic_empty_2.png',
                          size: 180,
                          title: AppLocalizations.instance.text('TXT_NO_WISHLIST'),
                          action: SizedBox(
                            width: 150,
                            child: CustomWidget.roundBtn(
                              label: AppLocalizations.instance.text('TXT_SHOP_NOW'),
                              lblColor: Colors.white,
                              btnColor: CustomColor.MAIN,
                              function: () {
                                Get.back();
                                _baseProvider.fnOnNavBarSelected(1);
                              },
                            ),
                          ),
                        );
                      default:
                        return NotificationListener<ScrollNotification>(
                          onNotification: provider.fnOnNotification,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.wishlist.result?.data?.length,
                                itemBuilder: (context, index) {
                                  var _data = provider.wishlist.result?.data?[index];
                                  return Row(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        child: provider.isSelection
                                            ? Checkbox(
                                          value: provider.selectionList[index].status,
                                          onChanged: (value) => provider.fnOnChangedCkBox(value ?? false, index),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                          activeColor: Colors.green,
                                        )
                                            : SizedBox(),
                                      ),
                                      Flexible(
                                        child: InkWell(
                                          onTap: () async => await Get.toNamed(
                                            ProductDetailScreen.tag,
                                            arguments: ProductDetailScreen(productId: _data?.idProduct,),
                                          )!.then((_) => provider.fnFetchWishlist()),
                                          child: Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.symmetric(vertical: 5),
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      if (_data?.product?.stock == 0)
                                                        Stack(
                                                          children: [
                                                            Container(
                                                              width: 80,
                                                              height: 80,
                                                              child: ClipRRect(
                                                                child: CustomWidget.networkImg(context, _data?.product?.image1, fit: BoxFit.cover),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 80,
                                                              height: 80,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(10),),
                                                                color: CustomColor.GREY_ICON,
                                                              ),
                                                              child: Center(
                                                                child: Text(AppLocalizations.instance.text('TXT_SOLD_OUT'), style: TextStyle(
                                                                  color: CustomColor.MAIN,
                                                                  fontWeight: FontWeight.bold,
                                                                ),),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      else
                                                        Container(
                                                          width: 80,
                                                          height: 80,
                                                          child: ClipRRect(
                                                            child: CustomWidget.networkImg(context, _data?.product?.image1, fit: BoxFit.cover),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              // Text.rich(TextSpan(
                                                              //   children: [
                                                              //     TextSpan(
                                                              //       text: _data?.product?.name ?? '-',
                                                              //       style: TextStyle(
                                                              //         fontSize: 16,
                                                              //       ),
                                                              //     ),
                                                              //     WidgetSpan(child: Text(' - ')),
                                                              //     TextSpan(
                                                              //       text: _data?.region?.name ?? '-',
                                                              //       style: TextStyle(
                                                              //         fontSize: 16,
                                                              //         color: CustomColor.MAIN,
                                                              //       ),
                                                              //     ),
                                                              //   ]
                                                              // )),
                                                              Text(_data?.product?.name ?? '-', style: TextStyle(
                                                                color: Colors.black,
                                                              ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                              SizedBox(height: 5,),
                                                              Text(FormatterHelper.moneyFormatter(_data?.product?.regularPrice), style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: CustomColor.MAIN_TXT,
                                                              ),),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Icon(MdiIcons.storeCheck, size: 20, color: CustomColor.MAIN,),
                                                                  SizedBox(width: 5,),
                                                                  Text('${_data?.region?.name ?? '-'}', style: TextStyle(
                                                                    color: CustomColor.GREY_TXT,
                                                                  ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                children: [
                                                                  RatingBar.builder(
                                                                    initialRating: double.parse(_data?.product?.rating ?? '0.0'),
                                                                    ignoreGestures: true,
                                                                    direction: Axis.horizontal,
                                                                    itemCount: 5,
                                                                    itemPadding: EdgeInsets.zero,
                                                                    itemBuilder: (context, _) => Icon(
                                                                      Icons.star,
                                                                      color: Colors.amber,
                                                                    ),
                                                                    itemSize: 15,
                                                                    onRatingUpdate: (rating) {},
                                                                  ),
                                                                  SizedBox(width: 2,),
                                                                  Text('(${_data?.product?.rating ?? '0.0'})', style: TextStyle(
                                                                    color: CustomColor.GREY_TXT,
                                                                  ),),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          CustomWidget.showConfirmationDialog(
                                                            context,
                                                            desc: AppLocalizations.instance.text('TXT_REMOVE_WISHLIST_INFO'),
                                                            function: () async {
                                                              await fnStoreLog(
                                                                productId: [_data?.idProduct ?? 0],
                                                                categoryId: null,
                                                                notes: KeyHelper.REMOVE_WISHLIST_KEY,
                                                              );
                                                              await provider.fnDeleteWishlist(
                                                                provider.scaffoldKey.currentContext!,
                                                                _data?.id ?? 0,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(FontAwesomeIcons.trashAlt, size: 20,),
                                                        visualDensity: VisualDensity.compact,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      if (_data?.product?.stock == 0)
                                                        Expanded(
                                                          child: CustomWidget.roundBtn(
                                                            function: () {},
                                                            label: AppLocalizations.instance.text('TXT_SOLD_OUT'),
                                                            btnColor: CustomColor.GREY_TXT,
                                                            lblColor: Colors.white,
                                                            radius: 10,
                                                          ),
                                                        )
                                                      else
                                                        Expanded(
                                                          child: CustomWidget.roundIconBtn(
                                                            function: () async {
                                                              await fnStoreLog(
                                                                productId: [_data?.idProduct ?? 0],
                                                                categoryId: null,
                                                                notes: KeyHelper.SAVE_CART_KEY,
                                                              );
                                                              await provider.fnStoreCart(context, _data?.idProduct, _data?.idRegion)
                                                                  .then((_) async => await _baseProvider.fnGetCartCount());
                                                            },
                                                            icon: Icons.add,
                                                            label: AppLocalizations.instance.text('TXT_CART_ADD'),
                                                            btnColor: CustomColor.MAIN,
                                                            lblColor: Colors.white,
                                                            radius: 10,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<WishListProvider>(
            child: Container(),
            builder: (context, provider, skeleton) {
              switch (provider.wishlist.result) {
                case null:
                  return skeleton!;
                default:
                  switch (provider.wishlist.result!.data!.length) {
                    case 0:
                      return skeleton!;
                    default:
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${provider.wishlist.result!.total ?? '0'}'
                              '${AppLocalizations.instance.text('TXT_WISHLIST_TOTAL')}', style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                          CustomWidget.textIconBtn(
                            icon: FontAwesomeIcons.checkCircle,
                            label: provider.isSelection
                                ? AppLocalizations.instance.text('TXT_CANCEL')
                                : AppLocalizations.instance.text('TXT_SELECT'),
                            lblColor: CustomColor.BROWN_LIGHT_TXT,
                            icColor: CustomColor.BROWN_TXT,
                            fontSize: 16,
                            function: () => provider.fnToggleSelection(),
                          ),
                        ],
                      );
                  }
              }
            },
          ),
          SizedBox(height: 5,),
          _productListContent,
        ],
      ),
    );

    Widget _submitBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: MediaQuery.of(context).size.width,
        child: CustomWidget.roundBtn(
          label: AppLocalizations.instance.text('TXT_LBL_REMOVE_WISHLIST'),
          btnColor: CustomColor.MAIN,
          lblColor: Colors.white,
          isBold: true,
          fontSize: 16,
          function: () async {
            _provider.fnGetSelectionList();
            if (_provider.idList.isNotEmpty) {
              CustomWidget.showConfirmationDialog(
                context,
                desc: AppLocalizations.instance.text('TXT_REMOVE_WISHLIST_INFO'),
                function: () async {
                  await fnStoreLog(
                    productId: _provider.idList,
                    categoryId: null,
                    notes: KeyHelper.REMOVE_WISHLIST_KEY,
                  );
                  await _provider.fnDeleteMultiWishlist(_provider.scaffoldKey.currentContext!);
                },
              );
            } else {
              CustomWidget.showSnackBar(
                context: context,
                content: Text(AppLocalizations.instance.text('TXT_SELECT_ITEM_INFO')),
              );
            }
          },
        ),
      ),
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_LBL_WISHLIST'), style: TextStyle(
          color: CustomColor.BROWN_TXT,
        ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: _mainContent,
      bottomNavigationBar: Consumer<WishListProvider>(
        child: SizedBox(),
        builder: (context, provider, skeleton) {
          if (provider.isSelection && (provider.wishlist.result?.data?.length ?? 0) > 0) {
            return _submitBtn;
          } else {
            return SizedBox();
          }
        },
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
