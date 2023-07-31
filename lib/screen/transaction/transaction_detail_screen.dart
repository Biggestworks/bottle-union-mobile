import 'dart:developer';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/helper/launch_url_helper.dart';
import 'package:eight_barrels/provider/transaction/transaction_detail_provider.dart';
import 'package:eight_barrels/screen/checkout/upload_payment_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/transaction/invoice_webview_screen.dart';
import 'package:eight_barrels/screen/transaction/track_order_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDetailScreen extends StatefulWidget {
  static String tag = '/transaction-detail-screen';
  final String? orderId;
  final int? regionId;

  const TransactionDetailScreen({Key? key, this.orderId, this.regionId})
      : super(key: key);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen>
    with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<TransactionDetailProvider>(context, listen: false)
            .fnGetView(this);
        Provider.of<TransactionDetailProvider>(context, listen: false)
            .fnGetArguments(context);
        Provider.of<TransactionDetailProvider>(context, listen: false)
            .fnGetTransactionDetail();
        Provider.of<TransactionDetailProvider>(context, listen: false)
            .fnGetLocale();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider =
        Provider.of<TransactionDetailProvider>(context, listen: false);

    _showRatingSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        isRounded: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<TransactionDetailProvider>(context, listen: false),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  centerTitle: false,
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  title: Text(
                    AppLocalizations.instance.text('TXT_REVIEW'),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: RatingBar.builder(
                          initialRating: _provider.starRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 10),
                          glow: true,
                          itemBuilder: (context, _) => Icon(
                            FontAwesomeIcons.solidStar,
                            color: CustomColor.MAIN,
                          ),
                          onRatingUpdate: _provider.fnOnChangeRating,
                        ),
                      ),
                      Consumer<TransactionDetailProvider>(
                          builder: (context, provider, _) {
                        return provider.fnGetRatingInfo(context);
                      }),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.instance.text('TXT_REVIEW_PHOTO'),
                            style: TextStyle(
                              color: CustomColor.GREY_TXT,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: CustomColor.GREY_BG, width: 2)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  AppLocalizations.instance
                                      .text('TXT_ADD_PHOTO'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.instance
                                .text('TXT_REVIEW_COMMENT'),
                            style: TextStyle(
                              color: CustomColor.GREY_TXT,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _provider.commentController,
                            autofocus: false,
                            maxLines: 6,
                            maxLength: 200,
                            cursorColor: CustomColor.MAIN,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: AppLocalizations.instance
                                  .text("TXT_REVIEW_COMMENT_INFO"),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: CustomColor.GREY_BG, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: CustomColor.GREY_BG, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: CustomColor.GREY_BG, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomWidget.roundBtn(
                      label: AppLocalizations.instance.text('TXT_SAVE_REVIEW'),
                      btnColor: CustomColor.MAIN,
                      lblColor: Colors.white,
                      isBold: true,
                      radius: 10,
                      fontSize: 16,
                      function: () async {
                        Get.back();
                        await _provider.fnStoreReview(
                            _provider.scaffoldKey.currentContext!);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    _showSelectProductSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        isRounded: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<TransactionDetailProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                centerTitle: false,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                title: Text(
                  'Select product to review...',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              body: Container(
                height: 110,
                child: Consumer<TransactionDetailProvider>(
                  child: Container(),
                  builder: (context, provider, skeleton) {
                    switch (provider.transactionDetail.result?.data) {
                      case null:
                        return skeleton!;
                      default:
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              provider.transactionDetail.result?.data?.length,
                          itemBuilder: (context, index) {
                            var _data =
                                provider.transactionDetail.result?.data?[index];
                            return InkWell(
                              onTap: () => provider
                                  .fnOnSelectProduct(_data?.idProduct ?? 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: provider.selectedProductId ==
                                          _data?.idProduct
                                      ? BorderSide(
                                          color: CustomColor.MAIN, width: 2.0)
                                      : BorderSide.none,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        child: ClipRRect(
                                          child: CustomWidget.networkImg(
                                            context,
                                            _data?.product?.image1,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _data?.product?.name ?? '-',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${_data?.qty} x ${FormatterHelper.moneyFormatter(_data?.product?.salePrice ?? 0)}',
                                              style: TextStyle(
                                                color: CustomColor.GREY_TXT,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Total: ${provider.fnGetSubtotal(_data?.product?.salePrice ?? 0, _data?.qty ?? 0)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
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
                        );
                    }
                  },
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomWidget.roundBtn(
                    label: AppLocalizations.instance.text('TXT_CONTINUE'),
                    btnColor: CustomColor.MAIN,
                    lblColor: Colors.white,
                    isBold: true,
                    radius: 10,
                    fontSize: 16,
                    function: () async {
                      Get.back();
                      await Future.delayed(Duration(milliseconds: 500))
                          .whenComplete(() => _showRatingSheet());
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _orderInfoContent = Consumer<TransactionDetailProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          var _data = provider.transactionDetail.result;
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                if (_data?.data?[0].idStatusOrder == 1)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    color: CustomColor.MAIN,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.instance
                                .text('TXT_FINISH_PAYMENT_INFO'),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: _data?.expiredAt != null
                                ? DateFormat('dd MMMM yyyy, HH:mm a',
                                        provider.locale)
                                    .format(
                                        DateTime.parse(_data?.expiredAt ?? ''))
                                : '-',
                            style: TextStyle(
                              color: Colors.amberAccent,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.instance
                              .text('TXT_INVOICE_NUMBER')),
                          GestureDetector(
                            onTap: () => Get.toNamed(InvoiceWebviewScreen.tag,
                                arguments: InvoiceWebviewScreen(
                                  url:
                                      '${dotenv.get('INVOICE_URL')}/${_data?.codeTransaction ?? '-'}',
                                )),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.file_download,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _data?.codeTransaction ?? '-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_data?.paymentType == 'Transfer Manual')
                        Column(
                          children: [
                            Divider(
                              height: 20,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.instance
                                    .text('TXT_BANK_ACCOUNT')),
                                Text(
                                  _data?.manualBank?.bankName ?? '-',
                                  style: TextStyle(
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
                                Text(AppLocalizations.instance
                                    .text('TXT_BANK_RECEIVER_NAME')),
                                Text(
                                  _data?.manualBank?.receiverName ?? '-',
                                  style: TextStyle(
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
                                Text(AppLocalizations.instance
                                    .text('TXT_BANK_NUMBER')),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: _data?.manualBank?.bankAccount ??
                                            '-'));
                                    Get.snackbar(
                                      _data?.manualBank?.bankAccount ?? '-',
                                      'Copy to clipboard',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  },
                                  child: Text(
                                    _data?.manualBank?.bankAccount ?? '-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (_data?.vaNumber != null)
                        Column(
                          children: [
                            Divider(
                              height: 20,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.instance
                                    .text('TXT_VA_NUMBER')),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Clipboard.setData(
                                              ClipboardData(
                                                  text: _data?.vaNumber ?? '-'))
                                          .then((_) => CustomWidget.showSnackBar(
                                              context: context,
                                              content: Text(
                                                  'VA number is successfully copied to clipboard'))),
                                      icon: Icon(
                                        Icons.copy,
                                        size: 20,
                                      ),
                                      constraints: BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _data?.vaNumber ?? '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                          Text('Status'),
                          Flexible(
                            child: Text(
                              provider.fnGetStatus(
                                  _data?.data?[0].idStatusOrder ?? 0),
                              style: TextStyle(
                                color: _data?.data?[0].idStatusOrder == 6

                                    /// Complete
                                    ? Colors.green
                                    : _data?.data?[0].idStatusOrder == 7

                                        /// Cancel
                                        ? Colors.red
                                        : Colors.orange,
                              ),
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
                          Text(
                              AppLocalizations.instance.text('TXT_ORDER_DATE')),
                          Flexible(
                              child: Text(DateFormat(
                                      'dd MMMM yyyy, HH:mm a', provider.locale)
                                  .format(DateTime.parse(_data?.createdAt ??
                                      DateTime.now().toString())))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });

    Widget _orderDetailContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 140,
            child: Consumer<TransactionDetailProvider>(
              child: Container(),
              builder: (context, provider, skeleton) {
                switch (provider.transactionDetail.result?.data) {
                  case null:
                    return skeleton!;
                  default:
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              MdiIcons.store,
                              size: 23,
                              color: CustomColor.MAIN,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              provider.transactionDetail.result?.region ?? '-',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                provider.transactionDetail.result?.data?.length,
                            itemBuilder: (context, index) {
                              var _data = provider
                                  .transactionDetail.result?.data?[index];
                              return InkWell(
                                onTap: () =>
                                    Get.toNamed(ProductDetailScreen.tag,
                                        arguments: ProductDetailScreen(
                                          productId: _data?.idProduct,
                                        )),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          child: ClipRRect(
                                            child: CustomWidget.networkImg(
                                              context,
                                              _data?.product?.image1,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _data?.product?.name ?? '-',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${_data?.qty} x ${FormatterHelper.moneyFormatter(_data?.price ?? 0)}',
                                                style: TextStyle(
                                                  color: CustomColor.GREY_TXT,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Total: ${provider.fnGetSubtotal(_data?.price ?? 0, _data?.qty ?? 0)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
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
                        ),
                      ],
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
          var _data = provider.transactionDetail.result;
          if (_data != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.instance.text('TXT_SHIPMENT_INFORMATION'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                              child: Text(AppLocalizations.instance
                                  .text('TXT_COURIER')),
                            ),
                            Flexible(
                              child: Text(
                                  '${_data?.courierName ?? '-'} '
                                  '${_data?.courierEtd ?? '-'} '
                                  '(${FormatterHelper.moneyFormatter(_data?.courierCost ?? 0)})',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 130,
                              child: Text(AppLocalizations.instance
                                  .text('TXT_DELIVERY_ADDRESS')),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _data?.data?[0].shipment?.receiver ?? '-',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(_data?.data?[0].shipment?.phone ?? '-'),
                                  SizedBox(height: 4),
                                  Text(
                                      _data?.data?[0].shipment?.address ?? '-'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_data!.gosend != null && _data.gosend!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gosend Information",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                                    child: Text("Type "),
                                  ),
                                  Flexible(
                                    child: Text(
                                        _data.gosend!.first.bookingType
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 20,
                                thickness: 1,
                              ),
                              if (_data.gosend != null &&
                                  _data.gosend!.first.status != null)
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text("Status Pengiriman"),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _data.gosend!.first.status
                                                        .toString() ==
                                                    "Enroute Pickup"
                                                ? "Driver ditugaskan dan sedang dalam perjalanan ke lokasi pick-up"
                                                : _data.gosend!.first.status
                                                            .toString() ==
                                                        "Enroute Drop"
                                                    ? "Driver sedang dalam perjalanan ke lokasi tujuan"
                                                    : _data.gosend!.first.status
                                                                .toString() ==
                                                            "Completed"
                                                        ? "Barang berhasil di antarkan ke lokasi penerima"
                                                        : _data.gosend!.first
                                                                        .status
                                                                        .toString() ==
                                                                    "Cancelled" ||
                                                                _data
                                                                        .gosend!
                                                                        .first
                                                                        .status
                                                                        .toString() ==
                                                                    "Rejected"
                                                            ? "Pengiriman dibatalkan, pengirim akan menjadwalkan ulang pengiriman"
                                                            : _data
                                                                        .gosend!
                                                                        .first
                                                                        .status
                                                                        .toString() ==
                                                                    "Driver not found"
                                                                ? "Driver tidak ditemukan mohon tunggu beberapa saat..."
                                                                : _data.gosend!.first
                                                                            .status
                                                                            .toString() ==
                                                                        "Finding Driver"
                                                                    ? "Sedang mencari Driver..."
                                                                    : _data
                                                                        .gosend!
                                                                        .first
                                                                        .status
                                                                        .toString(),
                                            style: TextStyle(
                                              color:
                                                  _data.gosend!.first.status ==
                                                          "Completed"
                                                      ? Colors.green
                                                      : _data.gosend!.first
                                                                  .status ==
                                                              "Cancelled"
                                                          ? Colors.red
                                                          : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (_data.gosend != null &&
                                  _data.gosend!.first.status != null)
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text("Booking ID"),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _data.gosend!.first.orderNo
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: _data.gosend!.first
                                                        .orderNo));
                                          },
                                          icon: Icon(
                                            Icons.document_scanner,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (_data.gosend != null &&
                                  _data.gosend!.first.driverName != null)
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text("Nama"),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _data.gosend!.first.driverName
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if (_data.gosend != null &&
                                  _data.gosend!.first.driverPhone != null)
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 130,
                                        child: Text("Nomor Hp"),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _data.gosend!.first.driverPhone
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              launch(
                                                  'tel:${_data.gosend!.first.driverPhone}');
                                            },
                                            icon: Icon(
                                              Icons.phone,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              if (_data.gosend != null &&
                                  _data.gosend!.first.vehicleNumber != null)
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text("Plat Nomor"),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _data.gosend!.first.vehicleNumber
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                      ),
                    ],
                  ),
              ],
            );
          }
          return Container();
        },
      ),
    );

    Widget _paymentDetailContent = Container(
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Consumer<TransactionDetailProvider>(
        builder: (context, provider, _) {
          var _data = provider.transactionDetail.result;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.instance.text('TXT_PAYMENT_DETAIL'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                          Text(AppLocalizations.instance
                              .text('TXT_PAYMENT_METHOD')),
                          Flexible(
                            child: Text(_data?.paymentType ?? '-'),
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
                          Text(
                              '${AppLocalizations.instance.text('TXT_TOTAL_PRICE')} (${_data?.data?.length} item(s))'),
                          Flexible(
                            child: Text(provider.fnGetTotalPrice(
                                _data?.amount ?? 0, _data?.courierCost ?? 0)),
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
                          Text(AppLocalizations.instance
                              .text('TXT_DELIVERY_COST')),
                          Flexible(
                            child: Text(FormatterHelper.moneyFormatter(
                                _data?.courierCost ?? 0)),
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
                          Text(
                            AppLocalizations.instance.text('TXT_TOTAL_PAY'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              FormatterHelper.moneyFormatter(
                                  _data?.amount ?? 0),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

    Widget _mainContent = SmartRefresher(
      controller: _provider.refreshController,
      onRefresh: () {
        _provider.fnGetTransactionDetail();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _orderInfoContent,
            SizedBox(
              height: 5,
            ),
            _orderDetailContent,
            SizedBox(
              height: 5,
            ),
            _shipmentDetailContent,
            SizedBox(
              height: 5,
            ),
            _paymentDetailContent,
          ],
        ),
      ),
    );

    Widget _bottomContent = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 0.5, color: CustomColor.GREY_ICON),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<TransactionDetailProvider>(
              child: SizedBox(),
              builder: (context, provider, skeleton) {
                switch (provider.transactionDetail.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider
                        .transactionDetail.result?.data?[0].idStatusOrder) {
                      case 4:
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: CustomWidget.roundOutlinedBtn(
                            label: AppLocalizations.instance
                                .text('TXT_FINISH_ORDER'),
                            btnColor: CustomColor.MAIN,
                            lblColor: CustomColor.MAIN,
                            isBold: true,
                            radius: 8,
                            fontSize: 16,
                            function: () => CustomWidget.showConfirmationDialog(
                              context,
                              desc: AppLocalizations.instance
                                  .text('TXT_FINISH_ORDER_INFO'),
                              function: () async =>
                                  await provider.fnFinishOrder(
                                      provider.scaffoldKey.currentContext!),
                            ),
                          ),
                        );
                      case 6:
                        // return skeleton!;
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: CustomWidget.roundOutlinedBtn(
                            label: AppLocalizations.instance.text('TXT_REVIEW'),
                            btnColor: CustomColor.MAIN,
                            lblColor: CustomColor.MAIN,
                            isBold: true,
                            radius: 8,
                            fontSize: 16,
                            function: () async {
                              await Future.delayed(Duration.zero,
                                      await provider.fnInitReviewValue())
                                  .whenComplete(() {
                                if (provider.transactionDetail.result?.data
                                        ?.length ==
                                    1) {
                                  _showRatingSheet();
                                } else {
                                  _showSelectProductSheet();
                                }
                              });
                            },
                          ),
                        );
                      default:
                        return skeleton!;
                    }
                }
              },
            ),
            Consumer<TransactionDetailProvider>(
              child: SizedBox(),
              builder: (context, provider, skeleton) {
                switch (provider.transactionDetail.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider
                        .transactionDetail.result?.data?[0].idStatusOrder) {
                      case 1:
                        switch (
                            provider.transactionDetail.result?.paymentType) {
                          case 'Transfer Manual':
                            var _data = provider.transactionDetail.result;
                            return Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: CustomWidget.roundIconBtn(
                                icon: MdiIcons.shieldCheck,
                                label: AppLocalizations.instance
                                    .text('TXT_UPLOAD_PAYMENT'),
                                btnColor: Colors.green,
                                lblColor: Colors.white,
                                isBold: true,
                                radius: 8,
                                fontSize: 16,
                                function: () =>
                                    Get.toNamed(UploadPaymentScreen.tag,
                                        arguments: UploadPaymentScreen(
                                          orderId: _data?.codeTransaction,
                                          orderDate: DateFormat(
                                                  'dd MMMM yyyy, HH:mm a',
                                                  provider.locale)
                                              .format(_data?.createdAt != null
                                                  ? DateTime.parse(
                                                      _data?.createdAt ?? '')
                                                  : DateTime.now()),
                                          totalPay:
                                              FormatterHelper.moneyFormatter(
                                                  _data?.amount ?? 0),
                                        )),
                              ),
                            );
                          case 'GoPay':
                            return Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: CustomWidget.roundIconBtn(
                                  icon: MdiIcons.shieldCheck,
                                  label: AppLocalizations.instance
                                      .text('TXT_FINISH_PAYMENT'),
                                  btnColor: Colors.green,
                                  lblColor: Colors.white,
                                  isBold: true,
                                  radius: 8,
                                  fontSize: 16,
                                  function: () async {
                                    final _url = provider.transactionDetail
                                            .result?.deepLink ??
                                        '';

                                    await LaunchUrlHelper.launchUrl(
                                        context: provider
                                            .scaffoldKey.currentContext!,
                                        url: _url);
                                  }),
                            );
                          default:
                            return skeleton!;
                        }
                      default:
                        return skeleton!;
                    }
                }
              },
            ),
            if (_provider.transactionDetail.result != null)
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: CustomWidget.roundBtn(
                  label: _provider.transactionDetail.result!.gosend != null &&
                          _provider.transactionDetail.result!.gosend!.isNotEmpty
                      ? "GoSend Track"
                      : AppLocalizations.instance.text('TXT_TRACK_ORDER'),
                  btnColor: CustomColor.MAIN,
                  lblColor: Colors.white,
                  isBold: true,
                  radius: 8,
                  fontSize: 16,
                  function: () {
                    if (_provider.transactionDetail.result!.gosend != null &&
                        _provider
                            .transactionDetail.result!.gosend!.isNotEmpty) {
                      print(_provider.transactionDetail.result!.gosend!.first
                          .liveTrackingUrl
                          .toString() =="null");
                      if (_provider.transactionDetail.result!.gosend!.first
                              .liveTrackingUrl
                              .toString()
                              .trim() ==
                          "null") {
                        Get.toNamed(TrackOrderScreen.tag,
                            arguments: TrackOrderScreen(
                              orderId: _provider.orderId,
                              regionId: _provider.regionId,
                            ));
                      } else {
                        Get.toNamed(InvoiceWebviewScreen.tag,
                            arguments: InvoiceWebviewScreen(
                              url: _provider.transactionDetail.result!.gosend!
                                      .first.liveTrackingUrl ??
                                  "",
                            ));
                      }
                    } else {
                      Get.toNamed(TrackOrderScreen.tag,
                          arguments: TrackOrderScreen(
                            orderId: _provider.orderId,
                            regionId: _provider.regionId,
                          ));
                    }
                  },
                ),
              ),
          ],
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
          title: Text(
            AppLocalizations.instance.text('TXT_ORDER_DETAIL'),
            style: TextStyle(
              color: CustomColor.BROWN_TXT,
            ),
          ),
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
