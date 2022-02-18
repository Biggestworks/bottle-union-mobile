import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/cart/cart_list_provider.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CartListScreen extends StatefulWidget {
  static String tag = '/cart-list-screen';

  const CartListScreen({Key? key}) : super(key: key);

  @override
  _CartListScreenState createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> implements LoadingView {
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

    Widget _cartListContent = Padding(
      padding: const EdgeInsets.all(10),
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
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.cartList.result!.data!.length,
                                itemBuilder: (context, index) {
                                  var _data = provider.cartList.result!.data![index];
                                  return InkWell(
                                    onTap: () async => await Get.toNamed(
                                      ProductDetailScreen.tag,
                                      arguments: ProductDetailScreen(id: _data.idProduct,),
                                    )!.then((_) => provider.fnFetchCartList()),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: _data.isSelected == 1 ? true : false,
                                              onChanged: (value) => provider.fnSelectCart(_data.id!, value!),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              visualDensity: VisualDensity.compact,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 100,
                                              child: ClipRRect(
                                                child: CustomWidget.networkImg(context, _data.product!.image1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(_data.product!.name ?? '-', style: TextStyle(
                                                          color: Colors.black,
                                                        ),),
                                                        SizedBox(height: 5,),
                                                        Text(FormatterHelper.moneyFormatter(_data.product!.regularPrice), style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: CustomColor.MAIN_TXT,
                                                        ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async => await provider.fnDeleteCart(_provider.scaffoldKey.currentContext!, _data.id!),
                                                        icon: Icon(FontAwesomeIcons.trashAlt, size: 20, color: CustomColor.GREY_TXT,),
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
                                                                onPressed: () async => await provider.fnUpdateCartQty(_data.id!, 'decrease'),
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

    Widget _summaryContent = Consumer<CartListProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          switch (provider.cartList.result) {
            case null:
              return skeleton!;
            default:
              switch (provider.cartList.result!.data!.length) {
                case 0:
                  return skeleton!;
                default:
                  switch (provider.totalCart) {
                    case 0:
                      return skeleton!;
                    default:
                      return Card(
                        color: CustomColor.MAIN,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Total Pay', style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                  SizedBox(height: 5,),
                                  Text(provider.totalPay, style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              SizedBox(
                                width: 120,
                                height: 40,
                                child: CustomWidget.roundBtn(
                                  label: '${AppLocalizations.instance.text('TXT_LBL_BUY')} (${provider.totalCart})',
                                  isBold: true,
                                  fontSize: 16,
                                  radius: 10,
                                  function: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  }
              }
          }
        }
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      backgroundColor: CustomColor.BG,
      body: _cartListContent,
      floatingActionButton: _summaryContent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
