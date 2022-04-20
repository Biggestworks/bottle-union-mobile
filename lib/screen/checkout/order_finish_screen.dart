import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/checkout/order_model.dart';
import 'package:eight_barrels/provider/checkout/order_finish_provider.dart';
import 'package:eight_barrels/screen/checkout/upload_payment_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class OrderFinishScreen extends StatefulWidget {
  static String tag = '/order-finish-screen';
  final OrderModel? order;

  const OrderFinishScreen({Key? key, this.order}) : super(key: key);

  @override
  _OrderFinishScreenState createState() => _OrderFinishScreenState();
}

class _OrderFinishScreenState extends State<OrderFinishScreen> with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<OrderFinishProvider>(context, listen: false).fnGetView(this);
      Provider.of<OrderFinishProvider>(context, listen: false).fnGetArguments(context);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<OrderFinishProvider>(context, listen: false);

    Widget _paymentInfoContent = Container(
      color: Colors.white,
      child: Consumer<OrderFinishProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          var _data = provider.order?.data?[0];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.solidCheckCircle, color: Colors.green, size: 60,),
                    SizedBox(width: 20,),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_ORDER_FINISH_INFO'), style: TextStyle(
                            fontSize: 16,
                          ),),
                          SizedBox(height: 4,),
                          Text('${AppLocalizations.instance.text('TXT_ORDER_ID_INFO')} ${_data?.idOrder} ${AppLocalizations.instance.text('TXT_ORDER_ID_INFO_2')}', style: TextStyle(
                            fontSize: 14,
                            color: CustomColor.GREY_TXT,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                color: CustomColor.MAIN,
                child: Text.rich(TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.instance.text('TXT_FINISH_PAYMENT_INFO'),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: DateFormat('dd MMMM yyyy, HH:mm a').format(_data?.transactionTime != null ? DateTime.parse(_data?.transactionTime ?? '').add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1))),
                      style: TextStyle(
                        color: Colors.amberAccent,
                      ),
                    ),
                  ],
                ), textAlign: TextAlign.center,),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID'),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Clipboard.setData(ClipboardData(text: _data?.order?[0].codeTransaction ?? '-'))
                                  .then((_) => CustomWidget.showSnackBar(context: context, content: Text('Order ID successfully copied to clipboard'))),
                              icon: Icon(Icons.copy, size: 20,),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            SizedBox(width: 10,),
                            Text(_data?.order?[0].codeTransaction ?? '-', style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 20, thickness: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status'),
                        Text(_data?.statusPayment ?? '-', style: TextStyle(
                          color: Colors.orange,
                        ),),
                      ],
                    ),
                    Divider(height: 20, thickness: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Date'),
                        Text(DateFormat('dd MMMM yyyy, HH:mm a').format(_data?.transactionTime != null ? DateTime.parse(_data?.transactionTime ?? '') : DateTime.now())),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );

    Widget _orderDetailContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Consumer<OrderFinishProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          switch (provider.order) {
            case null:
              return skeleton!;
            default:
              var _data = provider.order?.data?[0];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'), style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 10,),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _data?.order?.length,
                      itemBuilder: (context, index) {
                        var _product = _data?.order?[index].product;
                        return InkWell(
                          onTap: () => Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(id: _data?.id,)),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      child: CustomWidget.networkImg(context, _product?.image1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_product?.name ?? '-', style: TextStyle(
                                          color: Colors.black,
                                        ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        SizedBox(height: 5,),
                                        Text('${_data?.order?[index].qty ?? 0} x ${FormatterHelper.moneyFormatter(_product?.regularPrice ?? 0)}', style: TextStyle(
                                          color: CustomColor.GREY_TXT,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('Total: ${FormatterHelper.moneyFormatter(_data?.amount)}', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),),
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
                  ),
                ],
              );
          }
        },
      ),
    );

    Widget _shipmentDetailContent = Container(
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Consumer<OrderFinishProvider>(
        builder: (context, provider, _) {
          var _data = provider.order?.data?[0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.text('TXT_SHIPMENT_INFORMATION'), style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 10,),
              Card(
                color: CustomColor.GREY_LIGHT_BG,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 130,
                            child: Text(AppLocalizations.instance.text('TXT_COURIER')),
                          ),
                          Flexible(
                            child: Text('${_data?.courierName ?? '-'} ${_data?.courierEtd ?? '-'} (${FormatterHelper.moneyFormatter(_data?.courierCost ?? 0)})', style: TextStyle(
                              color: Colors.black,
                            )),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1,),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130,
                            child: Text(AppLocalizations.instance.text('TXT_DELIVERY_ADDRESS')),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_data?.order?[0].shipment?.receiver ?? '-', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                SizedBox(height: 4),
                                Text(_data?.order?[0].shipment?.phone ?? '-'),
                                SizedBox(height: 4),
                                Text(_data?.order?[0].shipment?.address ?? '-'),
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
          );
        },
      ),
    );

    Widget _paymentDetailContent = Container(
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Consumer<OrderFinishProvider>(
        builder: (context, provider, _) {
          var _data = provider.order?.data?[0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.text('TXT_PAYMENT_DETAIL'), style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 10,),
              Card(
                color: CustomColor.GREY_LIGHT_BG,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_PAYMENT_METHOD')),
                          Flexible(
                            child: Text(_data?.paymentType ?? '-'),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${AppLocalizations.instance.text('TXT_TOTAL_PRICE')} (3 items)'),
                          Flexible(
                            child: Text(provider.fnGetTotalPrice(_data?.amount ?? 0, _data?.courierCost ?? 0)),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_DELIVERY_COST')),
                          Flexible(
                            child: Text(FormatterHelper.moneyFormatter(_data?.courierCost ?? 0)),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_TOTAL_PAY'), style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                          Flexible(
                            child: Text(FormatterHelper.moneyFormatter(_data?.amount ?? 0), style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    Widget _mainContent = SingleChildScrollView(
      child: Column(
        children: [
          _paymentInfoContent,
          SizedBox(height: 5,),
          _orderDetailContent,
          SizedBox(height: 5,),
          _shipmentDetailContent,
          SizedBox(height: 5,),
          _paymentDetailContent,
          SizedBox(height: 10,),
        ],
      ),
    );

    Widget _bottomGroupBtn = SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<OrderFinishProvider>(
              builder: (context, provider, _) {
                switch (provider.order?.data?[0].paymentMethod) {
                  case 'transfer_manual':
                    var _data = provider.order?.data?[0];
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: CustomWidget.roundIconBtn(
                        icon: MdiIcons.shieldCheck,
                        label: AppLocalizations.instance.text('TXT_UPLOAD_PAYMENT'),
                        btnColor: Colors.green,
                        lblColor: Colors.white,
                        isBold: true,
                        radius: 8,
                        fontSize: 16,
                        function: () => Get.offAndToNamed(UploadPaymentScreen.tag, arguments: UploadPaymentScreen(
                          orderId: _data?.order?[0].codeTransaction,
                          orderDate: DateFormat('dd MMMM yyyy, HH:mm a').format(_data?.transactionTime != null ? DateTime.parse(_data?.transactionTime ?? '') : DateTime.now()),
                          totalPay: FormatterHelper.moneyFormatter(_data?.amount ?? 0),
                        )),
                      ),
                    );
                  default:
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: CustomWidget.roundIconBtn(
                        icon: MdiIcons.shieldCheck,
                        label: AppLocalizations.instance.text('TXT_FINISH_PAYMENT'),
                        btnColor: Colors.green,
                        lblColor: Colors.white,
                        isBold: true,
                        radius: 8,
                        fontSize: 16,
                        function: () async => await _provider.fnFinishPayment(_provider.scaffoldKey.currentContext!),
                      ),
                    );
                }
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: CustomWidget.roundBtn(
                label: AppLocalizations.instance.text('TXT_BACK'),
                btnColor: CustomColor.MAIN,
                lblColor: Colors.white,
                isBold: true,
                radius: 8,
                fontSize: 16,
                function: () => Get.offNamedUntil(BaseHomeScreen.tag, (route) => false, arguments: BaseHomeScreen(pageIndex: 3)),
              ),
            ),
          ],
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: WillPopScope(
        onWillPop: () async {
          Get.offNamedUntil(BaseHomeScreen.tag, (route) => false, arguments: BaseHomeScreen(pageIndex: 3));
          return false;
        },
        child: Scaffold(
          key: _provider.scaffoldKey,
          backgroundColor: CustomColor.BG,
          appBar: AppBar(
            backgroundColor: CustomColor.BG,
            centerTitle: true,
            title: RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.instance.text('TXT_DELIVERY'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColor.GREY_TXT,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black,),
                    ),
                  ),
                  TextSpan(
                    text: AppLocalizations.instance.text('TXT_PAYMENT'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColor.GREY_TXT,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black,),
                    ),
                  ),
                  TextSpan(
                    text: AppLocalizations.instance.text('TXT_FINISH'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColor.BROWN_TXT,
                    ),
                  ),
                ]
            )),
          ),
          body: _mainContent,
          bottomNavigationBar: _bottomGroupBtn,
        ),
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
