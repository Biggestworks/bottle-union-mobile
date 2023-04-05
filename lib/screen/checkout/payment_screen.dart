import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/card_number_formatter.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/checkout/delivery_courier_model.dart';
import 'package:eight_barrels/model/checkout/order_summary_model.dart'
    as summary;
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/checkout/payment_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  static String tag = '/payment-screen';
  final summary.Data? orderSummary;
  final int? addressId;
  final ProductDetailModel? product;
  final int? productQty;
  final List<DeliveryCourier>? selectedCourierList;
  final bool? isCart;

  const PaymentScreen(
      {Key? key,
      this.orderSummary,
      this.addressId,
      this.product,
      this.productQty,
      this.selectedCourierList,
      this.isCart})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with LoadingView {
  WebViewController webViewController = WebViewController();

  TextEditingController cardNumberController = TextEditingController();
  FocusNode cardNumberFocusNode = FocusNode();
  TextEditingController expiryDateController = TextEditingController();
  FocusNode expiryDateFocusNode = FocusNode();
  TextEditingController cvvController = TextEditingController();
  FocusNode cvvFocusNode = FocusNode();
  TextEditingController holderNameController = TextEditingController();
  FocusNode holderNameFocusNode = FocusNode();

  TextEditingController targetController = TextEditingController();
  FocusNode targetFocusNode = FocusNode();

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<PaymentProvider>(context, listen: false).fnGetView(this);
        Provider.of<PaymentProvider>(context, listen: false)
            .fnGetArguments(context);
        Provider.of<PaymentProvider>(context, listen: false)
            .fnFetchPaymentList();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PaymentProvider>(context, listen: false);

    showCreditCardSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Text(
                      "Tambahkan Kartu Kredit ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: KeyboardActions(
                      config: KeyboardActionsConfig(
                        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                        actions: [
                          KeyboardActionsItem(
                            focusNode: cardNumberFocusNode,
                            displayDoneButton: false,
                            displayActionBar: false,
                          ),
                        ],
                      ),
                      tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                      child: TextFormField(
                        focusNode: cardNumberFocusNode,
                        controller: cardNumberController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          validateCardNumWithLuhnAlgorithm(val.toString());
                        },
                        onChanged: (val) {
                          if (RegExp('^4[0-9]{12}(?:[0-9]{3})?\$')
                              .hasMatch(val)) {
                            print('visa');
                          } else if (RegExp(
                                  '^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14})\$')
                              .hasMatch(val)) {
                            print('visa master card');
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: '5XXXXXX',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 70,
                            child: KeyboardActions(
                              config: KeyboardActionsConfig(
                                keyboardActionsPlatform:
                                    KeyboardActionsPlatform.IOS,
                                actions: [
                                  KeyboardActionsItem(
                                    focusNode: expiryDateFocusNode,
                                    displayDoneButton: false,
                                    displayActionBar: false,
                                  ),
                                ],
                              ),
                              tapOutsideBehavior:
                                  TapOutsideBehavior.opaqueDismiss,
                              child: TextFormField(
                                focusNode: expiryDateFocusNode,
                                controller: expiryDateController,
                                onChanged: (value) {
                                  setState(() {
                                    value = value.replaceAll(RegExp(r"\D"), "");
                                    switch (value.length) {
                                      case 0:
                                        expiryDateController.text = "MM/YY";
                                        expiryDateController.selection =
                                            TextSelection.collapsed(offset: 0);
                                        break;
                                      case 1:
                                        expiryDateController.text =
                                            "${value}M/YY";
                                        expiryDateController.selection =
                                            TextSelection.collapsed(offset: 1);
                                        break;
                                      case 2:
                                        expiryDateController.text = "$value/YY";
                                        expiryDateController.selection =
                                            TextSelection.collapsed(offset: 2);
                                        break;
                                      case 3:
                                        expiryDateController.text =
                                            "${value.substring(0, 2)}/${value.substring(2)}Y";
                                        expiryDateController.selection =
                                            TextSelection.collapsed(offset: 4);
                                        break;
                                      case 4:
                                        expiryDateController.text =
                                            "${value.substring(0, 2)}/${value.substring(2, 4)}";
                                        expiryDateController.selection =
                                            TextSelection.collapsed(offset: 5);
                                        break;
                                    }
                                    if (value.length > 4) {
                                      expiryDateController.text =
                                          "${value.substring(0, 2)}/${value.substring(2, 4)}";
                                      expiryDateController.selection =
                                          TextSelection.collapsed(offset: 5);
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Expired Date',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  hintText: 'XX/XX',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 70,
                            child: KeyboardActions(
                              config: KeyboardActionsConfig(
                                keyboardActionsPlatform:
                                    KeyboardActionsPlatform.IOS,
                                actions: [
                                  KeyboardActionsItem(
                                    focusNode: cvvFocusNode,
                                    displayDoneButton: false,
                                    displayActionBar: false,
                                  ),
                                ],
                              ),
                              tapOutsideBehavior:
                                  TapOutsideBehavior.opaqueDismiss,
                              child: TextFormField(
                                focusNode: cvvFocusNode,
                                maxLength: 3,
                                controller: cvvController,
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: KeyboardActions(
                      config: KeyboardActionsConfig(
                        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                        actions: [
                          KeyboardActionsItem(
                            focusNode: cardNumberFocusNode,
                            displayDoneButton: false,
                            displayActionBar: false,
                          ),
                        ],
                      ),
                      tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                      child: TextFormField(
                        focusNode: holderNameFocusNode,
                        controller: holderNameController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Card Holder',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'John Doe',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 16, 50),
                        backgroundColor: CustomColor.MAIN,
                      ),
                      onPressed: () {
                        _provider.fnFetchXenditTokenId(context,
                            card_holder: holderNameController.text,
                            card_number: cardNumberController.text,
                            expiry_month:
                                expiryDateController.text.split("/").first,
                            expiry_year:
                                expiryDateController.text.split("/").last,
                            cvv: cvvController.text);
                      },
                      child: Text(
                        "Validate",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              // TextFormField(),
            ],
          ),
        ),
      );
    }

    showOvoPayload() {
      return CustomWidget.showSheet(
          context: context,
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Text(
                        "Masukan Nomor OVO ",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: KeyboardActions(
                        config: KeyboardActionsConfig(
                          keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                          actions: [
                            KeyboardActionsItem(
                              focusNode: targetFocusNode,
                              displayDoneButton: false,
                              displayActionBar: false,
                            ),
                          ],
                        ),
                        tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                        child: TextFormField(
                          focusNode: targetFocusNode,
                          keyboardType: TextInputType.number,
                          controller: targetController,
                          decoration: InputDecoration(
                            prefixText: '+62 ',
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: '8XXXXXXX',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 16, 50),
                          backgroundColor: CustomColor.MAIN,
                        ),
                        onPressed: () {
                          if (_provider.isCart == true) {
                            _provider.fnEwalletOrderCart(context,
                                phone: targetController.text);
                          } else {
                            _provider.fnEwalletOrderNow(context,
                                phone_number: targetController.text);
                          }

                          Navigator.pop(context);
                        },
                        child: Text(
                          "Validate",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                )
              ],
            ),
          ));
    }

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
                      // WidgetSpan(
                      //   child: Container(
                      //     width: 100,
                      //     child: Image.asset('assets/images/midtrans_logo.png'),
                      //   ),
                      // ),
                    ],
                  )),
                ),
                SizedBox(
                  height: 10,
                ),
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
                                image: 'assets/images/ic_no_data.png',
                                title: AppLocalizations.instance
                                    .text('TXT_NO_DATA'),
                                size: 180,
                                icColor: CustomColor.GREY_TXT,
                              );
                            default:
                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount:
                                    provider.paymentList.data?.length ?? 0,
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemBuilder: (context, index) {
                                  var _data = provider.paymentList.data?[index];
                                  return GestureDetector(
                                    onTap: () {
                                      if (_data?.name == "credit-card") {
                                        provider.fnOnSelectPayment(_data!);
                                        showCreditCardSheet();
                                      } else if (_data?.name == "ovo") {
                                        provider.fnOnSelectPayment(_data!);
                                        showOvoPayload();
                                      } else {
                                        provider.fnOnSelectPayment(_data!);
                                      }
                                    },
                                    child: ListTile(
                                      title: Text(_data?.description ?? '-'),
                                      leading: Container(
                                        height: 50,
                                        width: 80,
                                        child: CustomWidget.networkImg(
                                            context, _data?.image,
                                            fit: BoxFit.contain),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            child: Text(
                              '2',
                              style: TextStyle(
                                fontSize: 15,
                                color: CustomColor.MAIN,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.instance.text('TXT_ORDER_SUMMARY'),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.instance.text('TXT_TOTAL_PRICE')),
                        Flexible(
                            child: Text(FormatterHelper.moneyFormatter(
                                _data?.totalPrice ?? 0))),
                      ],
                    ),
                    if (_data?.deliveryCost != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.instance
                                  .text('TXT_DELIVERY_COST')),
                              Flexible(
                                  child: Text(FormatterHelper.moneyFormatter(
                                      _data?.deliveryCost ?? 0))),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              );
          }
        });

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
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColor.MAIN),
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColor.MAIN,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_PAYMENT_INFORMATION'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_PAYMENT_METHOD'),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => _showPaymentSheet(),
                      child: Text(
                        AppLocalizations.instance
                            .text('TXT_CHOOSE_PAYMENT_METHOD'),
                        style: TextStyle(
                          color: CustomColor.BROWN_TXT,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20,
                thickness: 1,
              ),
              Consumer<PaymentProvider>(
                child: Center(
                  child: Text(
                    'no selected payment method',
                    style: TextStyle(
                      color: CustomColor.GREY_TXT,
                    ),
                  ),
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
                        title: Text(
                          _data?.description ?? '-',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        leading: Container(
                          height: 50,
                          width: 80,
                          child: CustomWidget.networkImg(context, _data?.image,
                              fit: BoxFit.contain),
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
          SizedBox(
            height: 5,
          ),
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
                    mainAxisAlignment: _provider.webViewUrl == null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.instance.text('TXT_TOTAL_PAY'),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            FormatterHelper.moneyFormatter(
                                _data?.totalPay ?? 0),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (_provider.webViewUrl == null &&
                          _provider.selectedPayment?.name != "ovo")
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: CustomWidget.roundIconBtn(
                            icon: MdiIcons.shieldCheck,
                            label:
                                '${AppLocalizations.instance.text('TXT_PAY')}',
                            isBold: true,
                            fontSize: 14,
                            btnColor: Colors.green,
                            lblColor: Colors.white,
                            icColor: Colors.white,
                            radius: 8,
                            function: () async {
                              if (provider.isCart == true) {
                                await _provider.fnStoreOrderCart(
                                    _provider.scaffoldKey.currentContext!);
                              } else {
                                await _provider.fnStoreOrderBuyNow(
                                    _provider.scaffoldKey.currentContext!);
                              }
                            },
                          ),
                        ),
                    ],
                  );
              }
            }),
      ),
    );

    switch (_isLoad) {
      case true:
        return CustomWidget.checkoutLoadingPage(_provider.scaffoldKey);
      default:
        return Scaffold(
          key: _provider.scaffoldKey,
          backgroundColor: CustomColor.BG,
          appBar: AppBar(
            backgroundColor: CustomColor.BG,
            centerTitle: true,
            titleSpacing: 0,
            title: RichText(
                text: TextSpan(children: [
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
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
              ),
              TextSpan(
                text: AppLocalizations.instance.text('TXT_PAYMENT'),
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColor.BROWN_TXT,
                  fontWeight: FontWeight.bold,
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
              ),
              TextSpan(
                text: AppLocalizations.instance.text('TXT_FINISH'),
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColor.GREY_TXT,
                ),
              ),
            ])),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          body: _provider.webViewUrl != null
              ? InAppWebView(
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        supportZoom: false, // zoom support
                        preferredContentMode: UserPreferredContentMode
                            .MOBILE), // here you change the mode
                  ),
                  onWebViewCreated: (controller) {
                    controller.addJavaScriptHandler(
                        handlerName: 'parent',
                        callback: (cal) {
                          print(cal);
                        });
                    controller.addJavaScriptHandler(
                        handlerName: 'load',
                        callback: (cal) {
                          print(cal);
                        });
                  },
                  onLoadStart: (controller, url) {
                    print(url);
                    if (url.toString().contains('verification_redirect')) {
                      _provider.fnWebViewOtpVerified(context);
                    }
                    if (url.toString().contains('success')) {
                      _provider.fnDataPaymentVerified(context);
                    }
                  },
                  onLoadStop: (controller, url) {
                    if (url.toString().contains('verification_redirect')) {
                      _provider.fnWebViewOtpVerified(context);
                    }

                    if (url.toString().contains('success')) {
                      _provider.fnDataPaymentVerified(context);
                    }
                  },
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(_provider.webViewUrl.toString())),
                )
              : _mainContent,
          bottomNavigationBar: _bottomMenuContent,
        );
    }
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

String validateCardNumWithLuhnAlgorithm(String input) {
  if (input.isEmpty) {
    return "Field cant be empty";
  }

  if (input.trim().length < 8) {
    // No need to even proceed with the validation if it's less than 8 characters
    return 'Number is invalid';
  }

  int sum = 0;
  int length = input.length;
  for (var i = 0; i < length; i++) {
    // get digits in reverse order
    int digit = int.parse(input[length - i - 1]);

    // every 2nd number multiply with 2
    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }

  if (sum % 10 == 0) {
    return '';
  }

  return 'number is invalid';
}
