import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/cart/cart_total_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/checkout/delivery_provider.dart';
import 'package:eight_barrels/screen/checkout/payment_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class DeliveryScreen extends StatefulWidget {
  static String tag = '/checkout-screen';
  final CartTotalModel? cartList;
  final ProductDetailModel? product;
  const DeliveryScreen({Key? key, this.cartList, this.product}) : super(key: key);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> implements LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<DeliveryProvider>(context, listen: false).fnGetView(this);
      Provider.of<DeliveryProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<DeliveryProvider>(context, listen: false).fnFetchAddressList()
          .then((_) => Provider.of<DeliveryProvider>(context, listen: false).fnFetchSelectedAddress());
      Provider.of<DeliveryProvider>(context, listen: false).fnInitOrderSummary();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DeliveryProvider>(context, listen: false);

    _showAddressSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<DeliveryProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Consumer<DeliveryProvider>(
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
          value: Provider.of<DeliveryProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Consumer<DeliveryProvider>(
              child: CustomWidget.showShimmerListView(height: 200),
              builder: (context, provider, skeleton) {
                switch (provider.courierList.data) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.courierList.data?.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                            image: 'assets/images/ic_empty.png',
                            title: AppLocalizations.instance.text('TXT_NO_DATA'),
                            size: 180
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
                              onTap: () async => await provider.fnOnSelectCourier(_data?.title ?? '-'),
                              child: ListTile(
                                title: Text(_data?.title ?? '-'),
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

    _showCourierServiceSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<DeliveryProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.all(10),
            child: Consumer<DeliveryProvider>(
              child: CustomWidget.showShimmerListView(height: 200),
              builder: (context, provider, skeleton) {
                switch (provider.courierServiceList.data) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.courierServiceList.data?.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                            image: 'assets/images/ic_empty.png',
                            title: AppLocalizations.instance.text('TXT_NO_DATA'),
                            size: 180
                        );
                      default:
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: provider.courierServiceList.data?.length ?? 0,
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            var _data = provider.courierServiceList.data?[index];
                            return GestureDetector(
                              onTap: () async => await provider.fnOnSelectCourierService(_data!),
                              child: ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                title: Text('${_data?.etd ?? '-'} (${FormatterHelper.moneyFormatter(_data?.price ?? 0)})', style: TextStyle(
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

    Widget _deliveryContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.instance.text('TXT_DELIVERY_ADDRESS'), style: TextStyle(
                    fontSize: 16,
                  ),),
                  TextButton(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _showAddressSheet(),
                    child: Text('Change', style: TextStyle(
                      color: CustomColor.BROWN_TXT,
                    ),),
                  ),
                ],
              ),
              Divider(height: 20, thickness: 1,),
              Consumer<DeliveryProvider>(
                child: Container(
                  child: Text('no address selected'),
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
                        ],
                      );
                  }
                }
              ),
              Divider(height: 20, thickness: 1,),
              Consumer<DeliveryProvider>(
                builder: (context, provider, _) {
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Text(provider.selectedCourier ?? AppLocalizations.instance.text('TXT_CHOOSE_DELIVERY'), style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),),
                    leading: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        FontAwesomeIcons.truck,
                        color: CustomColor.BROWN_TXT,
                        size: 18,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: CustomColor.GREY_TXT,
                      size: 15,
                    ),
                    onTap: () async => await provider.fnFetchCourierList()
                        .then((_) => _showCourierSheet()),
                  );
                },
              ),
              Consumer<DeliveryProvider>(
                child: SizedBox(),
                builder: (context, provider, skeleton) {
                  switch (provider.courierServiceList.data) {
                    case null:
                      return skeleton!;
                    default:
                      var _data = provider.selectedCourierService;
                      return ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${_data?.etd ?? '-'} (${FormatterHelper.moneyFormatter(_data?.price ?? 0)})', style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),),
                        subtitle: Text(_data?.description ?? '-'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: CustomColor.GREY_TXT,
                          size: 15,
                        ),
                        onTap: () => _showCourierServiceSheet(),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );

    Widget _orderDetailContent = Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Consumer<DeliveryProvider>(
          builder: (context, provider, skeleton) {
            switch (provider.cartList) {
              case null:
                return ListTileTheme(
                  dense: true,
                  child: ExpansionTile(
                    title: Text('${AppLocalizations.instance.text('TXT_ORDER_DETAIL')} (1)', style: TextStyle(
                      fontSize: 16,
                    ),),
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    child: CustomWidget.networkImg(context, _data?.image1),
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
                                        Text('${_data?.weight.toString()} gram', style: TextStyle(
                                          color: CustomColor.GREY_TXT,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('1 x ${FormatterHelper.moneyFormatter(_data?.regularPrice ?? 0)}', style: TextStyle(
                                          color: CustomColor.GREY_TXT,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('Subtotal: ${FormatterHelper.moneyFormatter(_data?.regularPrice ?? 0)}', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.MAIN_TXT,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              default:
                return ListTileTheme(
                  dense: true,
                  child: ExpansionTile(
                    title: Text('${AppLocalizations.instance.text('TXT_ORDER_DETAIL')} (${provider.cartList?.data?.length})', style: TextStyle(
                      fontSize: 16,
                    ),),
                    initiallyExpanded: true,
                    iconColor: Colors.black,
                    textColor: Colors.black,
                    tilePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.cartList?.data?.length ?? 0,
                        separatorBuilder: (context, index) {
                          return Divider(color: CustomColor.GREY_ICON, indent: 10, endIndent: 10,);
                        },
                        itemBuilder: (context, index) {
                          var _data = provider.cartList?.data?[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    child: CustomWidget.networkImg(context, _data?.product?.image1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_data?.product?.name ?? '-', style: TextStyle(
                                          color: Colors.black,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('${_data?.product?.weight.toString()} gram', style: TextStyle(
                                          color: CustomColor.GREY_TXT,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('${_data?.qty.toString()} x ${FormatterHelper.moneyFormatter(_data?.product?.regularPrice)}', style: TextStyle(
                                          color: CustomColor.GREY_TXT,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('Subtotal: ${provider.fnGetSubtotal(_data?.product?.regularPrice ?? 0, _data?.qty ?? 0)}', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.MAIN_TXT,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
            }
          }
        ),
      ),
    );

    Widget _orderSummaryContent = Consumer<DeliveryProvider>(
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
                  Text(AppLocalizations.instance.text('TXT_ORDER_SUMMARY'), style: TextStyle(
                    fontSize: 16,
                  ),),
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
        child: Consumer<DeliveryProvider>(
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
                          fontSize: 18,
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
                        function: () {
                          if (provider.selectedCourier != null && provider.selectedCourierService != null) {
                            Get.toNamed(PaymentScreen.tag, arguments: PaymentScreen(
                              orderSummary: _data,
                            ));
                          } else {
                            CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_CHOOSE_COURIER_INFO')));
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
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.BG,
          centerTitle: true,
          title: Text.rich(TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.instance.text('TXT_DELIVERY'),
                style: TextStyle(
                  color: CustomColor.BROWN_TXT,
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Icon(Icons.arrow_forward_ios, size: 18,),
                ),
              ),
              TextSpan(
                  text: AppLocalizations.instance.text('TXT_PAYMENT'),
                  style: TextStyle(
                    color: CustomColor.GREY_TXT,
                  )
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Icon(Icons.arrow_forward_ios, size: 18,),
                ),
              ),
              TextSpan(
                text: AppLocalizations.instance.text('TXT_FINISH'),
                style: TextStyle(
                  color: CustomColor.GREY_TXT,
                ),
              ),
            ]
          )),
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
