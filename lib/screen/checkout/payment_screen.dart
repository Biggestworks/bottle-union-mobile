import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/checkout/courier_list_model.dart' as courier;
import 'package:eight_barrels/model/checkout/order_summary_model.dart' as summary;
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/checkout/payment_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  static String tag = '/payment-screen';
  final summary.Data? orderSummary;
  final int? addressId;
  final ProductDetailModel? product;
  final courier.Data? selectedCourier;
  final bool? isCart;

  const PaymentScreen({Key? key, this.orderSummary, this.addressId, this.product, this.selectedCourier, this.isCart}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> implements LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<PaymentProvider>(context, listen: false).fnGetView(this);
      Provider.of<PaymentProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<PaymentProvider>(context, listen: false).fnFetchPaymentList();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PaymentProvider>(context, listen: false);

    _showPaymentSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<PaymentProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text.rich(TextSpan(
                    children: [
                      TextSpan(
                        text: 'Powered By  ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      WidgetSpan(
                        child: Container(
                          width: 100,
                          child: Image.asset('assets/images/midtrans_logo.png'),
                        ),
                      ),
                    ],
                  )),
                ),
                SizedBox(height: 10,),
                Flexible(
                  child: Consumer<PaymentProvider>(
                    child: CustomWidget.showShimmerListView(height: 200),
                    builder: (context, provider, skeleton) {
                      switch (provider.paymentList.data) {
                        case null:
                          return skeleton!;
                        default:
                          switch (provider.paymentList.data?.length) {
                            case 0:
                              return CustomWidget.emptyScreen(
                                  image: 'assets/images/ic_empty.png',
                                  title: AppLocalizations.instance.text('TXT_NO_DATA'),
                                  size: 180
                              );
                            default:
                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount: provider.paymentList.data?.length ?? 0,
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemBuilder: (context, index) {
                                  var _data = provider.paymentList.data?[index];
                                  return GestureDetector(
                                    onTap: () => provider.fnOnSelectPayment(_data!),
                                    child: ListTile(
                                      title: Text(_data?.description ?? '-'),
                                      leading: Container(
                                        height: 50,
                                        width: 80,
                                        child: CustomWidget.networkImg(context, _data?.image, fit: BoxFit.contain),
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
              ],
            ),
          ),
        ),
      );
    }

    Widget _orderSummaryContent = Consumer<PaymentProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          switch (provider.orderSummary) {
            case null:
              return skeleton!;
            default:
              var _data = provider.orderSummary;
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
                        Flexible(child: Text(FormatterHelper.moneyFormatter(_data?.totalPrice ?? 0))),
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
                              Flexible(child: Text(FormatterHelper.moneyFormatter(_data?.deliveryCost ?? 0))),
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

    Widget _paymentContent = Column(
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
                  Text(AppLocalizations.instance.text('TXT_PAYMENT_METHOD'), style: TextStyle(
                    fontSize: 16,
                  ),),
                  Flexible(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => _showPaymentSheet(),
                      child: Text(AppLocalizations.instance.text('TXT_CHOOSE_PAYMENT_METHOD'), style: TextStyle(
                        color: CustomColor.BROWN_TXT,
                      ),),
                    ),
                  ),
                ],
              ),
              Divider(height: 20, thickness: 1,),
              Consumer<PaymentProvider>(
                child: Center(
                  child: Text('no selected payment method', style: TextStyle(
                    color: CustomColor.GREY_TXT,
                  ),),
                ),
                builder: (context, provider, skeleton) {
                  switch (provider.selectedPayment) {
                    case null:
                      return skeleton!;
                    default:
                      var _data = provider.selectedPayment;
                      return ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        title: Text(_data?.description ?? '-', style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),),
                        leading: Container(
                          height: 50,
                          width: 80,
                          child: CustomWidget.networkImg(context, _data?.image, fit: BoxFit.contain),
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );

    Widget _mainContent = SingleChildScrollView(
      child: Column(
        children: [
          _paymentContent,
          SizedBox(height: 5,),
          _orderSummaryContent,
        ],
      ),
    );

    Widget _bottomMenuContent = Container(
      color: CustomColor.MAIN,
      padding: EdgeInsets.all(15),
      child: SafeArea(
        child: Consumer<PaymentProvider>(
            child: Container(),
            builder: (context, provider, skeleton) {
              switch (provider.orderSummary) {
                case null:
                  return skeleton!;
                default:
                  var _data = provider.orderSummary;
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
                        width: 120,
                        height: 40,
                        child: CustomWidget.roundIconBtn(
                          icon: MdiIcons.shieldCheck,
                          label: '${AppLocalizations.instance.text('TXT_PAY')}',
                          isBold: true,
                          fontSize: 14,
                          btnColor: Colors.green,
                          lblColor: Colors.white,
                          icColor: Colors.white,
                          radius: 8,
                          function: () async => await _provider.fnStoreOrder(_provider.scaffoldKey.currentContext!),
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
                    child: Icon(Icons.arrow_forward_ios, size: 18,),
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.instance.text('TXT_PAYMENT'),
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColor.BROWN_TXT,
                  ),
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_ios, size: 18,),
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
