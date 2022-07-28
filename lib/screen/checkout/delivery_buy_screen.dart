import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/checkout/delivery_buy_provider.dart';
import 'package:eight_barrels/screen/checkout/payment_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/profile/add_address_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class DeliveryBuyScreen extends StatefulWidget {
  static String tag = '/checkout-screen';
  final ProductDetailModel? product;
  final int? selectedRegionId;
  final int? selectedProvinceId;
  final bool? isCart;
  const DeliveryBuyScreen({Key? key, this.product, this.selectedRegionId, this.selectedProvinceId, this.isCart}) : super(key: key);

  @override
  _DeliveryBuyScreenState createState() => _DeliveryBuyScreenState();
}

class _DeliveryBuyScreenState extends State<DeliveryBuyScreen>
    with SingleTickerProviderStateMixin, LoadingView {
  bool _isLoad = false;
  AnimationController? _animationController;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<DeliveryBuyProvider>(context, listen: false).fnGetView(this);
      Provider.of<DeliveryBuyProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<DeliveryBuyProvider>(context, listen: false).fnFetchAddressList()
          .then((_) => Provider.of<DeliveryBuyProvider>(context, listen: false).fnFetchSelectedAddress());
      Provider.of<DeliveryBuyProvider>(context, listen: false).fnInitOrderSummary();
    },);
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DeliveryBuyProvider>(context, listen: false);

    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_animationController!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController?.reverse();
        }
      });

    _showAddressSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<DeliveryBuyProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Consumer<DeliveryBuyProvider>(
              child: CustomWidget.showShimmerListView(height: 200),
              builder: (context, provider, skeleton) {
                switch (provider.addressList.data) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.addressList.data?.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                          image: 'assets/images/ic_no_data.png',
                          title: AppLocalizations.instance.text('TXT_NO_ADDRESS'),
                          size: 180,
                          icColor: CustomColor.GREY_TXT,
                        );
                      default:
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.addressList.data?.length,
                          itemBuilder: (context, index) {
                            var _data = provider.addressList.data?[index];
                            return GestureDetector(
                              onTap: () async => await provider.fnOnSelectAddress(context, _data!.id!),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(_data?.receiver ?? '-'),
                                          if (_data?.label != null)
                                            Text(' (${_data?.label})', style: TextStyle(
                                              color: CustomColor.MAIN,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Text(_data?.phone ?? '-'),
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                    }
                }
              },
            ),
          ),
        ),
      );
    }

    _showCourierSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<DeliveryBuyProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.all(10),
            child: Consumer<DeliveryBuyProvider>(
              child: CustomWidget.showShimmerListView(height: 100),
              builder: (context, provider, skeleton) {
                switch (provider.courierList.data) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.courierList.data?.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                          image: 'assets/images/ic_no_data.png',
                          title: AppLocalizations.instance.text('TXT_NO_DATA'),
                          size: 180,
                          icColor: CustomColor.GREY_TXT,
                        );
                      default:
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: provider.courierList.data?.length ?? 0,
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            var _data = provider.courierList.data?[index];
                            return GestureDetector(
                              onTap: () async => await provider.fnOnSelectCourier(value: _data!),
                              child: ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                title: Text('${_data?.courier ?? '-'} ${_data?.etd ?? '-'} (${FormatterHelper.moneyFormatter(_data?.price ?? 0)})', style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),),
                                subtitle: Text(_data?.description ?? '-'),
                              ),
                            );
                          },
                        );
                    }
                }
              },
            ),
          ),
        ),
      );
    }

    Widget _deliveryContent = Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: CustomColor.MAIN),
                      ),
                      child: Center(
                        child: Text('1', style: TextStyle(
                          fontSize: 15,
                          color: CustomColor.MAIN,
                        ), textAlign: TextAlign.center,),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(AppLocalizations.instance.text('TXT_SHIPMENT_INFORMATION'), style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.instance.text('TXT_DELIVERY_ADDRESS'), style: TextStyle(
                      fontSize: 15,
                    ),),
                    Consumer<DeliveryBuyProvider>(
                      child: SizedBox(),
                      builder: (context, provider, skeleton) {
                        switch (provider.addressList.data) {
                          case null:
                            return skeleton!;
                          default:
                            switch (provider.addressList.data?.length) {
                              case 0:
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () async => await Get.toNamed(AddAddressScreen.tag, arguments: AddAddressScreen())!.then((value) async {
                                    if (value == true) {
                                      await provider.fnFetchAddressList()
                                          .then((_) async => await provider.fnFetchSelectedAddress());
                                      await CustomWidget.showSnackBar(context: context, content: Text('Success add address'));
                                    }
                                  }),
                                  child: Text(AppLocalizations.instance.text('TXT_ADD_ADDRESS'), style: TextStyle(
                                    color: CustomColor.BROWN_TXT,
                                  ),),
                                );
                              default:
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () => _showAddressSheet(),
                                  child: Text('Change', style: TextStyle(
                                    color: CustomColor.BROWN_TXT,
                                  ),),
                                );
                            }
                        }
                      },
                    ),
                  ],
                ),
                Divider(height: 20, thickness: 1,),
                Consumer<DeliveryBuyProvider>(
                    child: Center(
                      child: Text('no address selected', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                    ),
                    builder: (context, provider, skeleton) {
                      switch (provider.selectedAddress) {
                        case null:
                          return skeleton!;
                        default:
                          var _data = provider.selectedAddress;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(_data?.receiver ?? '-'),
                                  if (_data?.label != null)
                                    Text(' (${_data?.label})', style: TextStyle(
                                      color: CustomColor.MAIN,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Text(_data?.phone ?? '-'),
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
                            ],
                          );
                      }
                    }
                ),
                Divider(height: 20, thickness: 1,),
              ],
            ),
          ),
          Consumer<DeliveryBuyProvider>(
            child: SizedBox(),
            builder: (context, provider, skeleton) {
              switch (provider.addressList.data) {
                case null:
                  return skeleton!;
                default:
                  switch (provider.addressList.data?.length) {
                    case 0:
                      return skeleton!;
                    default:
                      switch (provider.selectedCourier) {
                        case null:
                          return AnimatedBuilder(
                            animation: offsetAnimation,
                            builder: (context, child) {
                              return Padding(
                                padding: EdgeInsets.only(left: offsetAnimation.value + 15.0, right: 15.0 - offsetAnimation.value),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: CustomColor.GREY_BG, width: 1.5),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    title: Text(AppLocalizations.instance.text('TXT_CHOOSE_DELIVERY'), style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),),
                                    leading: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(
                                        MdiIcons.truckFast,
                                        color: CustomColor.BROWN_TXT,
                                        size: 26,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: CustomColor.GREY_TXT,
                                      size: 15,
                                    ),
                                    onTap: () async => await provider.fnFetchCourierList().then((_) async {
                                      if (provider.courierList.data != null) {
                                        _showCourierSheet();
                                      } else {
                                        await CustomWidget.showSnackBar(context: provider.scaffoldKey.currentContext!, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
                                      }
                                    }),
                                  ),
                                ),
                              );
                            },
                          );
                        default:
                          var _courier = provider.selectedCourier;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: CustomColor.GREY_BG, width: 1.5),
                              ),
                              child: ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                title: Text('${_courier?.courierData?.courier ?? '-'} ${_courier?.courierData?.etd ?? '-'} '
                                    '(${FormatterHelper.moneyFormatter(_courier?.courierData?.price ?? 0)})', style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),),
                                subtitle: Text(_courier?.courierData?.description ?? '-'),
                                leading: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(
                                    MdiIcons.truckFast,
                                    color: CustomColor.BROWN_TXT,
                                    size: 26,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: CustomColor.GREY_TXT,
                                  size: 15,
                                ),
                                onTap: () async => await provider.fnFetchCourierList().then((_) async {
                                  if (provider.courierList.data != null) {
                                    _showCourierSheet();
                                  } else {
                                    await CustomWidget.showSnackBar(context: provider.scaffoldKey.currentContext!, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
                                  }
                                }),
                              ),
                            ),
                          );
                      }
                  }
              }
            },
          ),
        ],
      ),
    );

    Widget _orderDetailContent = Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Consumer<DeliveryBuyProvider>(
            builder: (context, provider, _) {
             return ListTileTheme(
                dense: true,
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: CustomColor.MAIN),
                        ),
                        child: Center(
                          child: Text('2', style: TextStyle(
                            fontSize: 15,
                            color: CustomColor.MAIN,
                          ), textAlign: TextAlign.center,),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('${AppLocalizations.instance.text('TXT_ORDER_DETAIL')} (1)', style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                  initiallyExpanded: true,
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  tilePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  children: [
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 1,
                      separatorBuilder: (context, index) {
                        return Divider(color: CustomColor.GREY_ICON, indent: 10, endIndent: 10,);
                      },
                      itemBuilder: (context, index) {
                        var _data = provider.product?.data;
                        return InkWell(
                          onTap: () => Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(productId: _data?.id,)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        child: CustomWidget.networkImg(context, _data?.image1, fit: BoxFit.cover,),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_data?.name ?? '-', style: TextStyle(
                                              color: Colors.black,
                                            ),),
                                            SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Icon(MdiIcons.storeCheck, size: 20, color: CustomColor.MAIN,),
                                                SizedBox(width: 5,),
                                                Text('${_data?.productRegion?.firstWhere((i) => i.idRegion == provider.selectedRegionId).region?.name ?? '-'}', style: TextStyle(
                                                  color: CustomColor.GREY_TXT,
                                                ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Text('${_data?.weight.toString()} gram', style: TextStyle(
                                              color: CustomColor.GREY_TXT,
                                            ),),
                                            SizedBox(height: 5,),
                                            Text('${provider.productQty} x ${FormatterHelper.moneyFormatter(_data?.salePrice ?? 0)}', style: TextStyle(
                                              color: CustomColor.GREY_TXT,
                                            ),),
                                            SizedBox(height: 5,),
                                            Text('Subtotal: ${provider.fnGetSubtotal(_data?.salePrice ?? 0, provider.productQty)}', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: CustomColor.MAIN_TXT,
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
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
                                            onPressed: () async => await provider.fnUpdateProductQty(false),
                                            icon: Icon(Icons.remove, size: 18, color: provider.productQty != 1
                                                ? Colors.green
                                                : CustomColor.GREY_ICON,
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 2),
                                            constraints: BoxConstraints(),
                                          ),
                                        ),
                                        Text(provider.productQty.toString(), style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                        Expanded(
                                          child: IconButton(
                                            onPressed: () async => await provider.fnUpdateProductQty(true),
                                            icon: Icon(Icons.add, size: 18, color: Colors.green,),
                                            padding: EdgeInsets.symmetric(vertical: 2),
                                            constraints: BoxConstraints(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );

    Widget _orderSummaryContent = Consumer<DeliveryBuyProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          switch (provider.orderSummary.data) {
            case null:
              return skeleton!;
            default:
              var _data = provider.orderSummary.data;
              return Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: CustomColor.MAIN),
                          ),
                          child: Center(
                            child: Text('3', style: TextStyle(
                              fontSize: 15,
                              color: CustomColor.MAIN,
                            ), textAlign: TextAlign.center,),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(AppLocalizations.instance.text('TXT_ORDER_SUMMARY'), style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                    Divider(height: 20, thickness: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.instance.text('TXT_TOTAL_PRICE')),
                        Text(FormatterHelper.moneyFormatter(_data?.totalPrice ?? 0)),
                      ],
                    ),
                    if (_data?.deliveryCost != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.instance.text('TXT_DELIVERY_COST')),
                              Text(FormatterHelper.moneyFormatter(_data?.deliveryCost ?? 0)),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              );
          }
        }
    );

    Widget _mainContent = SingleChildScrollView(
      child: Column(
        children: [
          _deliveryContent,
          SizedBox(height: 5,),
          _orderDetailContent,
          SizedBox(height: 5,),
          _orderSummaryContent,
          SizedBox(height: 10,),
        ],
      ),
    );

    Widget _bottomMenuContent = Container(
      color: CustomColor.MAIN,
      padding: EdgeInsets.all(15),
      child: SafeArea(
        child: Consumer<DeliveryBuyProvider>(
            child: Container(),
            builder: (context, provider, skeleton) {
              switch (provider.orderSummary.data) {
                case null:
                  return skeleton!;
                default:
                  var _data = provider.orderSummary.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_TOTAL_PAY'), style: TextStyle(
                            color: Colors.white,
                          ),),
                          SizedBox(height: 5,),
                          Text(FormatterHelper.moneyFormatter(_data?.totalPay ?? 0), style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: CustomWidget.roundBtn(
                          label: '${AppLocalizations.instance.text('TXT_CHOOSE_PAYMENT')}',
                          isBold: true,
                          fontSize: 14,
                          btnColor: Colors.green,
                          lblColor: Colors.white,
                          radius: 8,
                          function: () async {
                            if (provider.selectedCourier != null) {
                              Get.toNamed(PaymentScreen.tag, arguments: PaymentScreen(
                                orderSummary: _data,
                                addressId: provider.selectedAddress?.id,
                                product: provider.product,
                                productQty: provider.productQty,
                                isCart: provider.isCart,
                                selectedCourierList: [provider.selectedCourier!],
                              ));
                            } else {
                              await _animationController?.forward(from: 0.0);
                              await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_CHOOSE_COURIER_INFO')));
                            }
                          },
                        ),
                      ),
                    ],
                  );
              }
            }
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        key: _provider.scaffoldKey,
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.BG,
          centerTitle: true,
          titleSpacing: 0,
          title: RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.instance.text('TXT_DELIVERY'),
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColor.BROWN_TXT,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_ios, size: 16,),
                  ),
                ),
                TextSpan(
                    text: AppLocalizations.instance.text('TXT_PAYMENT'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColor.GREY_TXT,
                    )
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_ios, size: 16,),
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.instance.text('TXT_FINISH'),
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColor.GREY_TXT,
                  ),
                ),
              ]
          ),),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: _mainContent,
        bottomNavigationBar: _bottomMenuContent,
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