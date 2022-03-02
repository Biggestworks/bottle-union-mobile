import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/cart/cart_list_model.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeliveryScreen extends StatefulWidget {
  static String tag = '/delivery-screen';
  final List<Data>? cartList;
  const DeliveryScreen({Key? key, this.cartList}) : super(key: key);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as DeliveryScreen;

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
                    onPressed: () {},
                    child: Text('Change', style: TextStyle(
                      color: CustomColor.BROWN_TXT,
                    ),),
                  ),
                ],
              ),
              Divider(height: 20, thickness: 1,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text('Home', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
              ),
              SizedBox(height: 5,),
              Text('Enda Phramoedya'),
              SizedBox(height: 5,),
              Text('081212024801'),
              SizedBox(height: 5,),
              Text('Kav. DKI Blok E1/14, Pondok Kelapa, Duren Sawit, Jakarta TImur', style: TextStyle(
                color: CustomColor.GREY_TXT,
              ),),
            ],
          ),
        ),
        SizedBox(height: 5,),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15,),
          child: ListTile(
            dense: true,
            title: Text(AppLocalizations.instance.text('TXT_CHOOSE_DELIVERY'), style: TextStyle(
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
            onTap: () {},
          ),
        ),
      ],
    );

    Widget _orderDetailContent = Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListTileTheme(
          dense: true,
          child: ExpansionTile(
            title: Text('${AppLocalizations.instance.text('TXT_ORDER_DETAIL')} (3)', style: TextStyle(
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
                itemCount: _args.cartList!.where((i) => i.isSelected == 1).length,
                separatorBuilder: (context, index) {
                  return Divider(color: CustomColor.GREY_ICON, indent: 10, endIndent: 10,);
                },
                itemBuilder: (context, index) {
                  var _data = _args.cartList!.where((i) => i.isSelected == 1).toList()[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            child: CustomWidget.networkImg(context, _data.product!.image1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_data.product!.name ?? '-', style: TextStyle(
                                  color: Colors.black,
                                ),),
                                SizedBox(height: 5,),
                                Text('${_data.product!.weight.toString()} gram', style: TextStyle(
                                  color: CustomColor.GREY_TXT,
                                ),),
                                SizedBox(height: 5,),
                                Text('${_data.qty.toString()} x ${FormatterHelper.moneyFormatter(_data.product!.regularPrice)}', style: TextStyle(
                                  color: CustomColor.GREY_TXT,
                                ),),
                                SizedBox(height: 5,),
                                Text('Subtotal: ${FormatterHelper.moneyFormatter(_data.product!.regularPrice)}', style: TextStyle(
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
        ),
      ),
    );

    Widget _orderSummaryContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
                  Text('Rp 495.765'),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.instance.text('TXT_DELIVERY_COST')),
                  Text('Rp 69.000'),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    Widget _mainContent = SingleChildScrollView(
      child: Column(
        children: [
          _deliveryContent,
          SizedBox(height: 10,),
          _orderDetailContent,
          SizedBox(height: 10,),
          _orderSummaryContent,
          SizedBox(height: 20,),
        ],
      ),
    );

    Widget _bottomMenuContent = Container(
      color: CustomColor.MAIN,
      padding: EdgeInsets.all(15),
      child: SafeArea(
        child: Row(
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
                Text('Rp 512.765', style: TextStyle(
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
                function: () {},
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
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
              )
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
          ]
        )),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: _mainContent,
      bottomNavigationBar: _bottomMenuContent,
    );
  }
}
