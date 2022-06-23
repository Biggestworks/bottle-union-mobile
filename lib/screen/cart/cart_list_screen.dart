import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/provider/cart/cart_list_provider.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/screen/checkout/delivery_cart_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class CartListScreen extends StatefulWidget {
  static String tag = '/cart-list-screen';

  const CartListScreen({Key? key}) : super(key: key);

  @override
  _CartListScreenState createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen>
    with LoadingView, ProductLog {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<CartListProvider>(context, listen: false).fnGetView(this);
      Provider.of<CartListProvider>(context, listen: false).fnFetchCartList();
      Provider.of<CartListProvider>(context, listen: false).fnGetTotalPay();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartListProvider>(context, listen: false);
    final _baseProvider = Provider.of<BaseHomeProvider>(context, listen: false);

    Widget _cartListContent = Flexible(
      child: Consumer<CartListProvider>(
          child: CustomWidget.showShimmerListView(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.cartList.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.cartList.result!.data!.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                          image: 'assets/images/ic_empty_2.png',
                          size: 200,
                          title: AppLocalizations.instance.text('TXT_NO_CART'),
                          action: SizedBox(
                            width: 150,
                            child: CustomWidget.roundBtn(
                              label: AppLocalizations.instance.text('TXT_SHOP_NOW'),
                              lblColor: Colors.white,
                              btnColor: CustomColor.MAIN,
                              function: () => _baseProvider.fnOnNavBarSelected(1),
                            ),
                          ),
                        );
                      default:
                        return NotificationListener<ScrollNotification>(
                          onNotification: provider.fnOnNotification,
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.cartList.result!.data!.length,
                                itemBuilder: (context, index) {
                                  var _data = provider.cartList.result!.data![index];
                                  return InkWell(
                                    onTap: () async => await Get.toNamed(
                                      ProductDetailScreen.tag,
                                      arguments: ProductDetailScreen(productId: _data.idProduct,),
                                    )!.then((_) => provider.fnFetchCartList()),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                              value: _data.isSelected == 1 ? true : false,
                                              onChanged: (value) => provider.fnSelectCart(_data.id!, value!),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              visualDensity: VisualDensity.compact,
                                              activeColor: CustomColor.MAIN,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        child: ClipRRect(
                                                          child: CustomWidget.networkImg(context, _data.product?.image1),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(_data.product?.name ?? '-', style: TextStyle(
                                                              color: Colors.black,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            Text(FormatterHelper.moneyFormatter(_data.product?.regularPrice), style: TextStyle(
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
                                                                Text('${_data.region?.name ?? '-'}', style: TextStyle(
                                                                  color: CustomColor.GREY_TXT,
                                                                ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          CustomWidget.showCartConfirmationDialog(
                                                            context,
                                                            desc: AppLocalizations.instance.text('TXT_DELETE_CART_INFO'),
                                                            fnDeleteCart: () async {
                                                              Get.back();
                                                              await fnStoreLog(
                                                                productId: [_data.id ?? 0],
                                                                categoryId: null,
                                                                notes: KeyHelper.REMOVE_CART_KEY,
                                                              );
                                                              await provider.fnDeleteCart(_provider.scaffoldKey.currentContext!, _data.id!)
                                                                  .then((_) async => await _baseProvider.fnGetCartCount());
                                                            },
                                                            fnStoreWishlist: () async {
                                                              Get.back();
                                                              await fnStoreLog(
                                                                productId: [_data.id ?? 0],
                                                                categoryId: null,
                                                                notes: KeyHelper.SAVE_WISHLIST_KEY,
                                                              );
                                                              await provider.fnDeleteCart(_provider.scaffoldKey.currentContext!, _data.id ?? 0)
                                                                  .then((_) async {
                                                                await provider.fnStoreWishlist(_provider.scaffoldKey.currentContext!, _data.idProduct ?? 0, _data.idRegion ?? 0);
                                                                await _baseProvider.fnGetCartCount();
                                                              });
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(FontAwesomeIcons.trashCan, size: 20, color: CustomColor.GREY_TXT,),
                                                        visualDensity: VisualDensity.compact,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(
                                                            color: CustomColor.GREY_ICON,
                                                          ),
                                                        ),
                                                        width: 100,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Expanded(
                                                              child: IconButton(
                                                                onPressed: () async => await provider.fnUpdateCartQty(_data.id!, 'decrease')
                                                                    .then((_) async {if (_data.qty == 1) await _baseProvider.fnGetCartCount();}),
                                                                icon: Icon(Icons.remove, size: 18, color: _data.qty != 1
                                                                    ? Colors.green
                                                                    : CustomColor.GREY_ICON,
                                                                ),
                                                                padding: EdgeInsets.symmetric(vertical: 2),
                                                                constraints: BoxConstraints(),
                                                              ),
                                                            ),
                                                            Text(_data.qty.toString(), style: TextStyle(
                                                              fontSize: 12,
                                                            ),),
                                                            Expanded(
                                                              child: IconButton(
                                                                onPressed: () async => await provider.fnUpdateCartQty(_data.id!, 'increase'),
                                                                icon: Icon(Icons.add, size: 18, color: Colors.green,),
                                                                padding: EdgeInsets.symmetric(vertical: 2),
                                                                constraints: BoxConstraints(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
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
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.instance.text('TXT_HEADER_ORDER'), style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 5,),
          Consumer<CartListProvider>(
            builder: (context, provider, _) {
              return Text(sprintf(AppLocalizations.instance.text('TXT_CART_INFO'), ['${provider.cartList.result?.data?.length} item(s)']), style: TextStyle(
                color: CustomColor.GREY_TXT,
              ),);
            },
          ),
          SizedBox(height: 10,),
          _cartListContent,
        ],
      ),
    );

    Widget _bottomMenuContent = Consumer<CartListProvider>(
        child: SizedBox(),
        builder: (context, provider, skeleton) {
          switch (provider.cartList.result) {
            case null:
              return skeleton!;
            default:
              switch (provider.cartList.result?.data?.length) {
                case 0:
                  return skeleton!;
                default:
                  return Card(
                    color: CustomColor.MAIN,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocalizations.instance.text('TXT_TOTAL_PRICE'), style: TextStyle(
                                color: Colors.white,
                              ),),
                              SizedBox(height: 5,),
                              Text(FormatterHelper.moneyFormatter(provider.totalPay), style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: CustomWidget.roundIconBtn(
                              icon: MdiIcons.cartArrowUp,
                              label: '${AppLocalizations.instance.text('TXT_LBL_BUY')} (${provider.totalCart})',
                              isBold: true,
                              fontSize: 14,
                              btnColor: provider.totalCart != 0
                                  ? Colors.green
                                  : CustomColor.GREY_ICON,
                              lblColor: Colors.white,
                              radius: 5,
                              function: () {
                                if (provider.totalCart != 0)
                                  Get.toNamed(DeliveryCartScreen.tag, arguments: DeliveryCartScreen(
                                    cartList: _provider.cartTotalList,
                                    isCart: true,
                                  ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
              }
          }
        }
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,),
            child: SizedBox(
              width: 120,
              child: Image.asset('assets/images/ic_logo_bu.png',),
            ),
          ),
        ],
      ),
      body: _mainContent,
      bottomNavigationBar: _bottomMenuContent,
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
