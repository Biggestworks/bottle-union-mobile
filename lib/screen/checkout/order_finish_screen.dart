import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/helper/launch_url_helper.dart';
import 'package:eight_barrels/model/checkout/order_cart_model.dart';
import 'package:eight_barrels/model/checkout/order_now_model.dart';
import 'package:eight_barrels/provider/checkout/order_finish_provider.dart';
import 'package:eight_barrels/screen/checkout/upload_payment_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/transaction/invoice_webview_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class OrderFinishScreen extends StatefulWidget {
  static String tag = '/order-finish-screen';
  final OrderNowModel? orderNow;
  final OrderCartModel? orderCart;

  const OrderFinishScreen({Key? key, this.orderNow, this.orderCart}) : super(key: key);

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

    Widget _paymentInfoContent = Consumer<OrderFinishProvider>(
      child: Container(),
      builder: (context, provider, skeleton) {
        switch (provider.orderCart) {
          case null:
            var _data = provider.orderNow?.data?[0];
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.solidCircleCheck, color: Colors.green, size: 60,),
                        SizedBox(width: 10,),
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
                          text: _data?.expiredAt != null
                              ? DateFormat('dd MMMM yyyy, HH:mm a').format(DateTime.parse(_data?.expiredAt ?? ''))
                              : '-',
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
                            Text(AppLocalizations.instance.text('TXT_INVOICE_NUMBER')),
                            GestureDetector(
                              onTap: () => Get.toNamed(InvoiceWebviewScreen.tag, arguments: InvoiceWebviewScreen(
                                url: '${dotenv.get('INVOICE_URL')}/${_data?.order?[0].codeTransaction ?? '-'}',
                              )),
                              child: Row(
                                children: [
                                  Icon(Icons.file_download, size: 20, color: Colors.blue,),
                                  SizedBox(width: 5,),
                                  Text(_data?.order?[0].codeTransaction ?? '-', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_data?.vaNumber != null)
                          Column(
                            children: [
                              Divider(height: 20, thickness: 1,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.instance.text('TXT_VA_NUMBER')),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => Clipboard.setData(ClipboardData(text: _data?.vaNumber ?? '-'))
                                            .then((_) => CustomWidget.showSnackBar(context: context, content: Text('VA number successfully copied to clipboard'))),
                                        icon: Icon(Icons.copy, size: 20,),
                                        constraints: BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(_data?.vaNumber ?? '-', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),
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
                              color: Colors.deepOrange,
                            ),),
                          ],
                        ),
                        Divider(height: 20, thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.instance.text('TXT_ORDER_DATE')),
                            Text(DateFormat('dd MMMM yyyy, HH:mm a').format(_data?.transactionTime != null ? DateTime.parse(_data?.transactionTime ?? '') : DateTime.now())),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          default:
            var _data = provider.orderCart?.result?[0];
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.solidCircleCheck, color: Colors.green, size: 60,),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.instance.text('TXT_ORDER_FINISH_INFO'), style: TextStyle(
                                fontSize: 16,
                              ),),
                              SizedBox(height: 4,),
                              Text('${AppLocalizations.instance.text('TXT_ORDER_ID_INFO')} ${_data?.codeTransaction} ${AppLocalizations.instance.text('TXT_ORDER_ID_INFO_2')}', style: TextStyle(
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
                          text: _data?.expiredAt != null
                              ? DateFormat('dd MMMM yyyy, HH:mm a').format(DateTime.parse(_data?.expiredAt ?? ''))
                              : '-',
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
                            Text(AppLocalizations.instance.text('TXT_INVOICE_NUMBER')),
                            GestureDetector(
                              onTap: () => Get.toNamed(InvoiceWebviewScreen.tag, arguments: InvoiceWebviewScreen(
                                url: '${dotenv.get('INVOICE_URL')}/${_data?.codeTransaction ?? '-'}',
                              )),
                              child: Row(
                                children: [
                                  Icon(Icons.file_download, size: 20, color: Colors.blue,),
                                  SizedBox(width: 5,),
                                  Text(_data?.codeTransaction ?? '-', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_data?.vaNumber != null)
                          Column(
                            children: [
                              Divider(height: 20, thickness: 1,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.instance.text('TXT_VA_NUMBER')),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => Clipboard.setData(ClipboardData(text: _data?.vaNumber ?? '-'))
                                            .then((_) => CustomWidget.showSnackBar(context: context, content: Text('VA number is successfully copied to clipboard'))),
                                        icon: Icon(Icons.copy, size: 20,),
                                        constraints: BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(_data?.vaNumber ?? '-', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),
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
                              color: Colors.deepOrange,
                            ),),
                          ],
                        ),
                        Divider(height: 20, thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.instance.text('TXT_ORDER_DATE')),
                            Text(DateFormat('dd MMMM yyyy, HH:mm a').format(_data?.createdAt != null ? DateTime.parse(_data?.createdAt ?? '') : DateTime.now())),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
        }
      }
    );

    Widget _orderDetailContent = Consumer<OrderFinishProvider>(
      child: Container(),
      builder: (context, provider, skeleton) {
        switch (provider.orderCart) {
          case null:
            var _data = provider.orderNow?.data?[0];
            return Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15.0),
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _data?.order?.length,
                      itemBuilder: (context, index) {
                        var _product = _data?.order?[index].product;
                        return InkWell(
                          onTap: () => Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(productId: _product?.id,)),
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
                                        Text('${_data?.order?[index].qty ?? 0} x ${FormatterHelper.moneyFormatter(_product?.salePrice ?? 0)}', style: TextStyle(
                                          color: CustomColor.GREY_TXT,
                                        ),),
                                        SizedBox(height: 5,),
                                        Text('Total: ${provider.fnGetSubtotal(_data?.order?[index].product?.salePrice ?? 0, _data?.order?[index].qty ?? 0)}', style: TextStyle(
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
              ),
            );
          default:
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: provider.orderCart?.result?.length,
              itemBuilder: (context, index) {
                var _data = provider.orderCart?.result?[index];
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${AppLocalizations.instance.text('TXT_ORDER')} #${index+1}', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(MdiIcons.store, size: 23, color: CustomColor.MAIN,),
                          SizedBox(width: 5,),
                          Text(_data?.region ?? '-', style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _data?.data?.length,
                          itemBuilder: (context, index) {
                            var _product = _data?.data?[index].product;
                            return InkWell(
                              onTap: () => Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(productId: _product?.id,)),
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
                                            Text('${_data?.data?[index].qty ?? 0} x ${FormatterHelper.moneyFormatter(_product?.salePrice ?? 0)}', style: TextStyle(
                                              color: CustomColor.GREY_TXT,
                                            ),),
                                            SizedBox(height: 5,),
                                            Text('Total: ${provider.fnGetSubtotal(_data?.data?[index].product?.salePrice ?? 0, _data?.data?[index].qty ?? 0)}', style: TextStyle(
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
                      Divider(
                        color: CustomColor.GREY_BG,
                        thickness: 1.5,
                        height: 30,
                      ),
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
                                  SizedBox(
                                    width: 130,
                                    child: Text(AppLocalizations.instance.text('TXT_COURIER')),
                                  ),
                                  Flexible(
                                    child: Text('${_data?.data?[0].courierName ?? '-'} '
                                        '${_data?.data?[0].courierEtd ?? '-'} '
                                        '(${FormatterHelper.moneyFormatter(_data?.data?[0].courierCost ?? 0)})', style: TextStyle(
                                      color: Colors.black,
                                    )),
                                  ),
                                ],
                              ),
                              Divider(height: 20, thickness: 1,),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text(AppLocalizations.instance.text('TXT_DELIVERY_ADDRESS')),
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_data?.data?[0].shipment?.receiver ?? '-', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        SizedBox(height: 4),
                                        Text(_data?.data?[0].shipment?.phone ?? '-'),
                                        SizedBox(height: 4),
                                        Text(_data?.data?[0].shipment?.address ?? '-'),
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
                );
              }
            );
        }
      },
    );

    Widget _shipmentDetailContent = Consumer<OrderFinishProvider>(
      child: SizedBox(),
      builder: (context, provider, skeleton) {
        switch (provider.orderCart) {
          case null:
            var _data = provider.orderNow?.data?[0];
            return Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.white,
              child: Column(
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
                                    Text(_data?.shipment?.receiver ?? '-', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    SizedBox(height: 4),
                                    Text(_data?.shipment?.phone ?? '-'),
                                    SizedBox(height: 4),
                                    Text(_data?.shipment?.address ?? '-'),
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
            );
          default:
            return skeleton!;
        }
      },
    );

    Widget _paymentDetailContent = Consumer<OrderFinishProvider>(
      builder: (context, provider, _) {
        switch (provider.orderCart) {
          case null:
            var _data = provider.orderNow?.data?[0];
            return Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.white,
              child: Column(
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
                              SizedBox(
                                width: 150,
                                child: Text(AppLocalizations.instance.text('TXT_PAYMENT_METHOD')),
                              ),
                              Flexible(
                                child: Text(_data?.paymentType ?? '-'),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text('${AppLocalizations.instance.text('TXT_TOTAL_PRICE')} (${_data?.order?.length} item(s))'),
                              ),
                              Flexible(
                                child: Text(provider.fnGetTotalPrice(_data?.amount ?? 0, _data?.courierCost ?? 0)),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(AppLocalizations.instance.text('TXT_DELIVERY_COST')),
                              ),
                              Flexible(
                                child: Text(FormatterHelper.moneyFormatter(_data?.courierCost ?? 0)),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(AppLocalizations.instance.text('TXT_TOTAL_PAY'), style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
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
              ),
            );
          default:
            var _data = provider.orderCart?.result?[0];
            return Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.white,
              child: Column(
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
                              SizedBox(
                                width: 150,
                                child: Text(AppLocalizations.instance.text('TXT_PAYMENT_METHOD')),
                              ),
                              Flexible(
                                child: Text(_data?.paymentType ?? '-',
                                  textAlign: TextAlign.right,),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text('${AppLocalizations.instance.text('TXT_TOTAL_PRICE')} (${provider.fnGetTotalItem()} item(s))'),
                              ),
                              Flexible(
                                child: Text(provider.fnGetTotalPrice(_data?.amount ?? 0, _data?.data?[0].courierCost ?? 0),
                                  textAlign: TextAlign.right,),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(AppLocalizations.instance.text('TXT_DELIVERY_COST')),
                              ),
                              Flexible(
                                child: Text(provider.fnGetTotalCourierCost(),
                                  textAlign: TextAlign.right,),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(AppLocalizations.instance.text('TXT_TOTAL_PAY'), style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              Flexible(
                                child: Text(FormatterHelper.moneyFormatter(_data?.amount ?? 0), style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ), textAlign: TextAlign.right,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
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
        ],
      ),
    );

    Widget _bottomGroupBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 0.5, color: CustomColor.GREY_ICON),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<OrderFinishProvider>(
              child: SizedBox(),
              builder: (context, provider, skeleton) {
                switch (provider.orderCart) {
                  case null:
                    switch (provider.orderNow?.data?[0].paymentMethod) {
                      case 'transfer_manual':
                        var _data = provider.orderNow?.data?[0];
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
                            function: () => Get.toNamed(UploadPaymentScreen.tag, arguments: UploadPaymentScreen(
                              orderId: _data?.order?[0].codeTransaction,
                              orderDate: DateFormat('dd MMMM yyyy, HH:mm a').format(_data?.transactionTime != null
                                  ? DateTime.parse(_data?.transactionTime ?? '')
                                  : DateTime.now()),
                              totalPay: FormatterHelper.moneyFormatter(_data?.amount ?? 0),
                            )),
                          ),
                        );
                      default:
                        switch (provider.orderNow?.data?[0].vaNumber) {
                          case null:
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
                                function: () async {
                                  final _url = provider.orderNow?.deepLink ?? '';
                                  await LaunchUrlHelper.launchUrl(context: provider.scaffoldKey.currentContext!, url: _url);
                                },
                              ),
                            );
                          default:
                            return skeleton!;
                        }
                    }
                  default:
                    switch (provider.orderCart?.result?[0].paymentType) {
                      case 'Transfer Manual':
                        var _data = provider.orderCart?.result?[0];
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
                            function: () => Get.toNamed(UploadPaymentScreen.tag, arguments: UploadPaymentScreen(
                              orderId: _data?.codeTransaction,
                              orderDate: DateFormat('dd MMMM yyyy, HH:mm a').format(_data?.createdAt != null
                                  ? DateTime.parse(_data?.createdAt ?? '')
                                  : DateTime.now()),
                              totalPay: FormatterHelper.moneyFormatter(_data?.amount ?? 0),
                            )),
                          ),
                        );
                      default:
                        switch (provider.orderCart?.result?[0].vaNumber) {
                          case null:
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
                                function: () async {
                                  final _url = provider.orderCart?.deeplink ?? '';
                                  await LaunchUrlHelper.launchUrl(context: provider.scaffoldKey.currentContext!, url: _url);
                                },
                              ),
                            );
                          default:
                            return skeleton!;
                        }
                    }
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
                function: () async => await Get.offNamedUntil(BaseHomeScreen.tag, (route) => false, arguments: BaseHomeScreen(pageIndex: 3)),
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
          await Get.offNamedUntil(BaseHomeScreen.tag, (route) => route.isFirst, arguments: BaseHomeScreen(pageIndex: 3));
          return false;
        },
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
                      fontWeight: FontWeight.bold,
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
