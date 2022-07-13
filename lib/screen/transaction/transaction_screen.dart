import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/transaction/transaction_provider.dart';
import 'package:eight_barrels/screen/checkout/upload_payment_screen.dart';
import 'package:eight_barrels/screen/transaction/track_order_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionScreen extends StatefulWidget {
  static String tag = '/transaction-screen';
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> 
    with SingleTickerProviderStateMixin, LoadingView {
  bool _isLoad = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<TransactionProvider>(context, listen: false).fnGetView(this);
      Provider.of<TransactionProvider>(context, listen: false).fnInitStatusOrder();
      Provider.of<TransactionProvider>(context, listen: false).fnFetchTransactionList();
      Provider.of<TransactionProvider>(context, listen: false).fnOnReceiveNotification();
      _scaffoldKey = new GlobalKey<ScaffoldState>();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<TransactionProvider>(context, listen: false);
    // final _baseProvider = Provider.of<BaseHomeProvider>(context, listen: false);

    _showDatePickerDialog(String flag) {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 300,
              padding: EdgeInsets.all(10),
              child: SfDateRangePicker(
                initialDisplayDate: DateTime.now(),
                onSelectionChanged: (value) async => await _provider.fnOnSelectCustomDate(value, flag),
              ),
            ),
          );
        },
      );
    }

    _showFilterSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value : Provider.of<TransactionProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.date_range, color: CustomColor.MAIN,),
                            SizedBox(width: 10,),
                            Text(AppLocalizations.instance.text('TXT_SORT_BY_DATE'), style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close, color: CustomColor.GREY_TXT,),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Consumer<TransactionProvider>(
                      builder: (context, provider, _) {
                        return Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: provider.dateFilter.length,
                            separatorBuilder: (context, index) {
                              return Divider(color: CustomColor.GREY_TXT,);
                            },
                            itemBuilder: (context, index) {
                              var _data = provider.dateFilter[index];
                              return RadioListTile(
                                title: Text(_data.title, style: TextStyle(
                                  fontSize: 16,
                                ),),
                                subtitle: _data.subTitle != ''
                                    ? Text(_data.subTitle)
                                    : null,
                                value: index,
                                groupValue: provider.selectedDateFilter,
                                dense: true,
                                activeColor: CustomColor.MAIN,
                                onChanged: (value) => provider.fnOnSelectDateFilter(index),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10,),
                    Consumer<TransactionProvider>(
                      child: SizedBox(),
                      builder: (context, provider, skeleton) {
                        switch (provider.isCustomDate) {
                          case true:
                            return Card(
                              color: CustomColor.GREY_LIGHT_BG,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(AppLocalizations.instance.text('TXT_FROM_DATE'), style: TextStyle(
                                            color: CustomColor.GREY_TXT,
                                          ),),
                                          SizedBox(height: 5,),
                                          GestureDetector(
                                            onTap: () => _showDatePickerDialog('from'),
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _provider.fromDateController,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: DateFormat('dd MMM yyyy').format(DateTime.now()),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                                isDense: true,
                                                filled: true,
                                                fillColor: CustomColor.GREY_BG,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(AppLocalizations.instance.text('TXT_TO_DATE'), style: TextStyle(
                                            color: CustomColor.GREY_TXT,
                                          ),),
                                          SizedBox(height: 5,),
                                          GestureDetector(
                                            onTap: () => _showDatePickerDialog('to'),
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _provider.toDateController,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: DateFormat('dd MMM yyyy').format(DateTime.now()),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                                isDense: true,
                                                filled: true,
                                                fillColor: CustomColor.GREY_BG,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          default:
                            return skeleton!;
                        }
                      },
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Consumer<TransactionProvider>(
                  child: SizedBox(),
                  builder: (context, provider, skeleton) {
                    switch (provider.isFiltered) {
                      case true:
                        return SafeArea(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            child: CustomWidget.roundBtn(
                              label: 'Submit Filter',
                              btnColor: CustomColor.MAIN,
                              lblColor: Colors.white,
                              function: () async => await provider.fnOnSubmitFilter(_scaffoldKey!.currentContext!),
                            ),
                          ),
                        );
                      default:
                        return skeleton!;
                    }
                  }
              ),
            ),
          ),
        ),
      );
    }

    Widget _tabBar = Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        return TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: true,
          indicatorColor: CustomColor.MAIN,
          indicatorWeight: 2,
          labelColor: CustomColor.BROWN_TXT,
          unselectedLabelColor: CustomColor.BROWN_LIGHT_TXT,
          tabs: List<Tab>.generate(provider.tabLabel.length, (index) {
            var _data = provider.tabLabel[index];
            return Tab(
              child: Row(
                children: [
                  Icon(_data.icon, size: 20,),
                  SizedBox(width: 10,),
                  Text(_data.label),
                ],
              ),
            );
          }),
          onTap: (value) => _provider.fnOnTabSelected(provider.tabLabel[value].id),
        );
      },
    );

    Widget _transactionListContent = Flexible(
      child: Consumer<TransactionProvider>(
          child: CustomWidget.showShimmerListView(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.transactionList.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.transactionList.result?.data?.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                          image: 'assets/images/ic_empty_2.png',
                          size: 150,
                          title: AppLocalizations.instance.text('TXT_NO_TRANSACTION_INFO'),
                        );
                      default:
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: provider.fnOnNotification,
                            child: ListView(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: provider.transactionList.result?.data?.length,
                                  itemBuilder: (context, index) {
                                    var _data = provider.transactionList.result?.data?[index];
                                    return InkWell(
                                      onTap: () => Get.toNamed(TransactionDetailScreen.tag, arguments: TransactionDetailScreen(
                                        orderId: _data?.codeTransaction,
                                        regionId: _data?.idRegion,
                                      )),
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(FontAwesomeIcons.bagShopping, color: CustomColor.MAIN),
                                                      SizedBox(width: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(AppLocalizations.instance.text('TXT_ORDER_DATE'), style: TextStyle(
                                                            color: CustomColor.GREY_TXT,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),),
                                                          Text(DateFormat('dd MMMM yyyy').format(DateTime.parse(_data?.orderedAt ?? DateTime.now().toString())), style: TextStyle(
                                                            color: CustomColor.GREY_TXT,
                                                            fontSize: 12,
                                                          ),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Text(provider.fnGetStatus(_data?.idStatusPayment ?? 0), style: TextStyle(
                                                    color: provider.fnGetStatus(_data?.idStatusPayment ?? 0) == AppLocalizations.instance.text('TXT_LBL_CANCELED')
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),),
                                                ],
                                              ),
                                              Divider(height: 30, thickness: 1,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    child: ClipRRect(
                                                      child: CustomWidget.networkImg(context, _data?.productImage,),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, top: 5,),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(_data?.product ?? '-', style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          Text('${_data?.qtyProduct} item(s)', style: TextStyle(
                                                            color: CustomColor.GREY_TXT,
                                                          ),),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(AppLocalizations.instance.text('TXT_TOTAL_PAY'), style: TextStyle(
                                                        color: CustomColor.GREY_TXT,
                                                      ),),
                                                      SizedBox(height: 2,),
                                                      Text(FormatterHelper.moneyFormatter(_data?.totalPay), style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),),
                                                    ],
                                                  ),
                                                  if (_data?.idStatusPayment == 1) /// Waiting for payment
                                                    if (_data?.paymentMethod == 'transfer_manual') /// Transfer Manual
                                                      Container(
                                                        height: 30,
                                                        child: CustomWidget.roundIconBtn(
                                                          icon: MdiIcons.shieldCheck,
                                                          label: AppLocalizations.instance.text('TXT_UPLOAD_PAYMENT'),
                                                          lblColor: Colors.white,
                                                          btnColor: Colors.green,
                                                          fontSize: 12,
                                                          radius: 5,
                                                          isBold: true,
                                                          function: () => Get.toNamed(UploadPaymentScreen.tag, arguments: UploadPaymentScreen(
                                                            orderId: _data?.codeTransaction,
                                                            orderDate: DateFormat('dd MMMM yyyy').format(DateTime.parse(_data?.orderedAt ?? DateTime.now().toString())),
                                                            totalPay: FormatterHelper.moneyFormatter(_data?.totalPay),
                                                          )),
                                                        ),
                                                      )
                                                    else if (_data?.paymentMethod == 'gopay') /// Gopay
                                                      Container(
                                                        height: 30,
                                                        child: CustomWidget.roundIconBtn(
                                                          icon: MdiIcons.shieldCheck,
                                                          label: AppLocalizations.instance.text('TXT_FINISH_PAYMENT'),
                                                          lblColor: Colors.white,
                                                          btnColor: Colors.green,
                                                          fontSize: 12,
                                                          radius: 5,
                                                          isBold: true,
                                                          function: () async {
                                                            final _url = provider.transactionList.result?.data?[0].deepLink ?? '';
                                                            if (await canLaunch(_url)) {
                                                              launch(_url);
                                                            } else {
                                                              await CustomWidget.showSnackBar(context: _scaffoldKey!.currentContext!, content: Text('Cannot launch $_url'));
                                                            }
                                                          }
                                                          // function: () async => await provider.fnFinishPayment(_scaffoldKey!.currentContext!),
                                                        ),
                                                      )
                                                    else
                                                      Container(
                                                        height: 30,
                                                        child: CustomWidget.roundBtn(
                                                          label: AppLocalizations.instance.text('TXT_TRACK_ORDER'),
                                                          lblColor: Colors.white,
                                                          btnColor: Colors.green,
                                                          fontSize: 12,
                                                          radius: 5,
                                                          isBold: true,
                                                          function: () => Get.toNamed(TrackOrderScreen.tag, arguments: TrackOrderScreen(
                                                            orderId: _data?.codeTransaction,
                                                            regionId: _data?.idRegion,
                                                          )),
                                                        ),
                                                      )
                                                  else if (_data?.idStatusPayment == 6) /// Complete
                                                    Container(
                                                      width: 100,
                                                      height: 30,
                                                      child: CustomWidget.roundBtn(
                                                        label: AppLocalizations.instance.text('TXT_BUY_AGAIN'),
                                                        lblColor: Colors.white,
                                                        btnColor: CustomColor.MAIN,
                                                        fontSize: 12,
                                                        radius: 5,
                                                        isBold: true,
                                                        function: () {},
                                                        // function: () async => await provider.fnStoreCart(context, index)
                                                        //     .then((_) async => await _baseProvider.fnGetCartCount()),
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      height: 30,
                                                      child: CustomWidget.roundBtn(
                                                        label: AppLocalizations.instance.text('TXT_TRACK_ORDER'),
                                                        lblColor: Colors.white,
                                                        btnColor: Colors.green,
                                                        fontSize: 12,
                                                        radius: 5,
                                                        isBold: true,
                                                        function: () => Get.toNamed(TrackOrderScreen.tag, arguments: TrackOrderScreen(
                                                          orderId: _data?.codeTransaction,
                                                          regionId: _data?.idRegion,
                                                        )),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  height: provider.isPaginateLoad ? 50 : 0,
                                  child: Center(
                                    child: provider.isPaginateLoad
                                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(CustomColor.MAIN),)
                                        : SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                    }
                }
            }
          }
      ),
    );

    Widget _mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.instance.text('TXT_HEADER_TRANSACTION'), style: TextStyle(
                color: CustomColor.BROWN_TXT,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              CustomWidget.textIconBtn(
                icon: MdiIcons.sort,
                label: 'Sort',
                lblColor: CustomColor.BROWN_LIGHT_TXT,
                icColor: CustomColor.BROWN_TXT,
                icSize: 22,
                fontSize: 16,
                function: () {
                  _provider.fnInitFilter();
                  _showFilterSheet();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 5,),
        _tabBar,
        _transactionListContent,
      ],
    );

    return DefaultTabController(
      length: _provider.tabLabel.length,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.BG,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20,),
              child: SizedBox(
                width: 120,
                child: Image.asset('assets/images/ic_logo_bu.png',),
              ),
            ),
          ],
        ),
        body: _mainContent,
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
