import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/transaction/transaction_detail_provider.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class TransactionDetailScreen extends StatefulWidget {
  static String tag = '/transaction-detail-screen';
  final String? orderId;

  const TransactionDetailScreen({Key? key, this.orderId}) : super(key: key);

  @override
  _TransactionDetailScreenState createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<TransactionDetailProvider>(context, listen: false).fnGetView(this);
      Provider.of<TransactionDetailProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<TransactionDetailProvider>(context, listen: false).fnGetTransactionDetail();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<TransactionDetailProvider>(context, listen: false);

    Widget _orderInfoContent = Container(
      color: Colors.white,
      child: Consumer<TransactionDetailProvider>(
          child: Container(),
          builder: (context, provider, skeleton) {
            var _data = provider.transactionDetail.data;
            return Container(
              color: Colors.white,
              child: Padding(
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
                              onPressed: () => Clipboard.setData(ClipboardData(text: _data?.codeTransaction ?? '-'))
                                  .then((_) => CustomWidget.showSnackBar(context: context, content: Text('Order ID successfully copied to clipboard'))),
                              icon: Icon(Icons.copy, size: 20,),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            SizedBox(width: 10,),
                            Text(_data?.codeTransaction ?? '-', style: TextStyle(
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
                        Flexible(
                          child: Text(_data?.statusOrder ?? '-', style: TextStyle(
                            color: Colors.orange,
                          ),),
                        ),
                      ],
                    ),
                    Divider(height: 20, thickness: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Date'),
                        Flexible(child: Text(DateFormat('dd MMMM yyyy, HH:mm a').format(DateTime.parse(_data?.orderedAt ?? DateTime.now().toString())))),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );

    Widget _orderDetailContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'), style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 10,),
          Container(
            height: 120,
            child: Consumer<TransactionDetailProvider>(
              child: Container(),
              builder: (context, provider, skeleton) {
                switch (provider.transactionDetail.data?.product) {
                  case null:
                    return skeleton!;
                  default:
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.transactionDetail.data?.product?.length,
                      itemBuilder: (context, index) {
                        var _data = provider.transactionDetail.data?.order?[index];
                        return InkWell(
                          onTap: () => Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(id: _data?.idProduct,)),
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
                                      child: CustomWidget.networkImg(context, _data?.product?.image1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_data?.product?.name ?? '-', style: TextStyle(
                                          color: Colors.black,
                                        ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        SizedBox(height: 5,),
                                        Text('${_data?.qty} x ${FormatterHelper.moneyFormatter(_data?.product?.regularPrice ?? 0)}', style: TextStyle(
                                          color: CustomColor.GREY_TXT,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('Total: ${provider.fnGetSubtotal(_data?.price ?? 0, _data?.qty ?? 0)}', style: TextStyle(
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
                    );
                }
              },
            ),
          ),
        ],
      ),
    );

    Widget _shipmentDetailContent = Container(
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Consumer<TransactionDetailProvider>(
        builder: (context, provider, _) {
          var _data = provider.transactionDetail.data;
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
                            child: Text('${_data?.order?[0].payment?.courierName ?? '-'} '
                                '${_data?.order?[0].payment?.courierEtd ?? '-'} '
                                '(${FormatterHelper.moneyFormatter(_data?.order?[0].payment?.courierCost ?? 0)})', style: TextStyle(
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
                                Text(_data?.shipmentInformation?.shipment?.receiver ?? '-', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                SizedBox(height: 4),
                                Text(_data?.shipmentInformation?.shipment?.phone ?? '-'),
                                SizedBox(height: 4),
                                Text(_data?.shipmentInformation?.shipment?.address ?? '-'),
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
      child: Consumer<TransactionDetailProvider>(
        builder: (context, provider, _) {
          var _data = provider.transactionDetail.data;
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
                            child: Text(_data?.detailPayments?.paymentMethod ?? '-'),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${AppLocalizations.instance.text('TXT_TOTAL_PRICE')} (${_data?.countProduct} item(s))'),
                          Flexible(
                            child: Text(FormatterHelper.moneyFormatter(_data?.detailPayments?.totalPrice ?? 0)),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_DELIVERY_COST')),
                          Flexible(
                            child: Text(FormatterHelper.moneyFormatter(_data?.detailPayments?.courierCost ?? 0)),
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
                            child: Text(FormatterHelper.moneyFormatter(_data?.totalPay ?? 0), style: TextStyle(
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
          _orderInfoContent,
          SizedBox(height: 5,),
          _orderDetailContent,
          SizedBox(height: 5,),
          _shipmentDetailContent,
          SizedBox(height: 5,),
          _paymentDetailContent,
        ],
      ),
    );

    Widget _bottomContent = SafeArea(
      child: Consumer<TransactionDetailProvider>(
        child: SizedBox(),
        builder: (context, provider, skeleton) {
          switch (provider.transactionDetail.data) {
            case null:
              return skeleton!;
            default:
              switch (provider.transactionDetail.data?.statusOrder) {
                case null:
                  return Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(width: 0.5, color: CustomColor.GREY_ICON),
                      ),
                    ),
                    child: CustomWidget.roundIconBtn(
                      icon: MdiIcons.shieldCheck,
                      label: AppLocalizations.instance.text('TXT_FINISH_PAYMENT'),
                      btnColor: Colors.green,
                      lblColor: Colors.white,
                      isBold: true,
                      radius: 8,
                      fontSize: 16,
                      function: () async => await provider.fnFinishPayment(_provider.scaffoldKey.currentContext!),
                    ),
                  );
                default:
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    width: MediaQuery.of(context).size.width,
                    child: CustomWidget.roundBtn(
                      label: AppLocalizations.instance.text('TXT_TRACK_ORDER'),
                      btnColor: Colors.green,
                      lblColor: Colors.white,
                      isBold: true,
                      radius: 8,
                      fontSize: 16,
                      function: () {},
                    ),
                  );
              }
          }
        },
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
          title: Text(AppLocalizations.instance.text('TXT_ORDER_DETAIL'), style: TextStyle(
            color: CustomColor.BROWN_TXT,
          ),),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: _mainContent,
        bottomNavigationBar: _bottomContent,
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
