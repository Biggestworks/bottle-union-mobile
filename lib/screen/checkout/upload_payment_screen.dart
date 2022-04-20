import 'package:dotted_border/dotted_border.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/checkout/upload_payment_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UploadPaymentScreen extends StatefulWidget {
  static String tag = '/upload-payment-screen';
  final String? orderId;
  final String? orderDate;
  final String? totalPay;

  const UploadPaymentScreen({Key? key, this.orderId, this.orderDate, this.totalPay}) : super(key: key);

  @override
  _UploadPaymentScreenState createState() => _UploadPaymentScreenState();
}

class _UploadPaymentScreenState extends State<UploadPaymentScreen> with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<UploadPaymentProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<UploadPaymentProvider>(context, listen: false).fnGetView(this);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UploadPaymentProvider>(context, listen: false);

    Widget _mainContent = Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              child: Consumer<UploadPaymentProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order ID'),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Clipboard.setData(ClipboardData(text: 'kxtiZEzeNy'))
                                    .then((_) => CustomWidget.showSnackBar(context: context, content: Text('Order ID successfully copied to clipboard'))),
                                icon: Icon(Icons.copy, size: 20,),
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              SizedBox(width: 10,),
                              Text(provider.orderId ?? '-', style: TextStyle(
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
                          Text('Order Date'),
                          Flexible(
                            child: Text(provider.orderDate ?? '-'),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Pay'),
                          Text(provider.totalPay ?? '-'),
                        ],
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: CustomColor.INFO,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.infoCircle, color: Colors.blue,),
                  SizedBox(width: 10,),
                  Flexible(
                    child: Text(AppLocalizations.instance.text('TXT_UPLOAD_PAYMENT_INFO'), style: TextStyle(
                      color: Colors.black,
                    ), textAlign: TextAlign.left,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Flexible(
            child: GestureDetector(
              onTap: () async => await _provider.fnUploadImage(context),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                color: CustomColor.GREY_ICON,
                strokeWidth: 3,
                dashPattern: [10, 5, 10, 5],
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10.0),
                  child: Consumer<UploadPaymentProvider>(
                    builder: (context, provider, _) {
                      switch (provider.imageFile) {
                        case null:
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.camera, size: 120, color: CustomColor.GREY_ICON,),
                              SizedBox(height: 5,),
                              Text('Choose File...', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                                fontSize: 16,
                              ),),
                            ],
                          );
                        default:
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              child: Image.file(provider.imageFile!, fit: BoxFit.cover,),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                      }
                    }
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget _submitBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: CustomWidget.roundBtn(
          label: AppLocalizations.instance.text('TXT_UPLOAD_PAYMENT'),
          btnColor: CustomColor.MAIN,
          lblColor: Colors.white,
          isBold: true,
          fontSize: 16,
          // function: () => Get.toNamed(SuccessScreen.tag, arguments: SuccessScreen(
          //   message: AppLocalizations.instance.text('TXT_UPLOAD_PAYMENT_SUCCESS'),
          //   orderId: _provider.orderId,
          // )),
          function: () async => await _provider.fnUploadPayment(_provider.scaffoldKey.currentContext!),
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        key: _provider.scaffoldKey,
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.MAIN,
          centerTitle: true,
          title: Text(AppLocalizations.instance.text('TXT_UPLOAD_PAYMENT'), style: TextStyle(
            color: Colors.white,
          ),),
        ),
        body: _mainContent,
        bottomNavigationBar: Consumer<UploadPaymentProvider>(
          child: SafeArea(child: SizedBox()),
          builder: (context, provider, skeleton) {
            switch (provider.imageFile) {
              case null:
                return skeleton!;
              default:
                return _submitBtn;
            }
          }
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
