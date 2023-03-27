import 'package:badges/badges.dart' as BadgeWidget;
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/home/notification_provider.dart';
import 'package:eight_barrels/screen/transaction/transaction_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  static String tag = '/notification-screen';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<NotificationProvider>(context, listen: false).fnGetView(this);
      Provider.of<NotificationProvider>(context, listen: false)
          .fnGetNotification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<NotificationProvider>(context, listen: false);

    Widget _tabBar = Container(
      child: Consumer<NotificationProvider>(builder: (context, provider, _) {
        return TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: CustomColor.MAIN,
          indicatorWeight: 2,
          labelColor: CustomColor.BROWN_TXT,
          unselectedLabelColor: CustomColor.BROWN_LIGHT_TXT,
          tabs: [
            Tab(
              child: BadgeWidget.Badge(
                badgeContent: Text(
                  provider.infoCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                // badgeColor: CustomColor.BROWN_TXT,
                // padding: EdgeInsets.all(6),
                position: BadgeWidget.BadgePosition.topEnd(top: -15, end: -18),
                child: Text('Info'),
              ),
            ),
            Tab(
              child: BadgeWidget.Badge(
                badgeContent: Text(
                  provider.promoCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                // badgeColor: CustomColor.BROWN_TXT,
                // padding: EdgeInsets.all(6),
                position: BadgeWidget.BadgePosition.topEnd(top: -15, end: -18),
                child: Text('Promo'),
              ),
            ),
          ],
          onTap: (value) => _provider.fnOnTabSelected(value),
        );
      }),
    );

    Widget _mainContent = Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          _tabBar,
          Flexible(
            child: Consumer<NotificationProvider>(
                child: CustomWidget.showShimmerListView(),
                builder: (context, provider, skeleton) {
                  switch (_isLoad) {
                    case true:
                      return skeleton!;
                    default:
                      switch (provider.notificationList.length) {
                        case 0:
                          return CustomWidget.emptyScreen(
                            image: 'assets/images/ic_no_data.png',
                            title:
                                AppLocalizations.instance.text('TXT_NO_DATA'),
                            size: 150,
                            icColor: CustomColor.GREY_TXT,
                          );
                        default:
                          return ListView.separated(
                            itemCount: provider.notificationList.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 5,
                              );
                            },
                            itemBuilder: (context, index) {
                              var _data = provider.notificationList[index];
                              return Container(
                                color: CustomColor.BROWN_LIGHT_3,
                                child: InkWell(
                                  onTap: () async {
                                    if (_data.type == 'info') {
                                      await provider
                                          .fnOnReadNotification(_data.id ?? 0);
                                      await Get.toNamed(
                                              TransactionDetailScreen.tag,
                                              arguments:
                                                  TransactionDetailScreen(
                                                orderId: _data.codeTransaction,
                                                regionId: _data.regionId,
                                              ))!
                                          .then((_) async => await provider
                                              .fnGetNotification());
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.bagShopping,
                                          color: CustomColor.MAIN,
                                        ),
                                        Flexible(
                                          child: ListTile(
                                            visualDensity:
                                                VisualDensity.compact,
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      _data.type ?? '-',
                                                      style: TextStyle(
                                                        color: CustomColor
                                                            .GREY_TXT,
                                                      ),
                                                    ),
                                                    _data.isNew == 1
                                                        ? Icon(
                                                            Icons.circle,
                                                            color: CustomColor
                                                                .MAIN,
                                                            size: 10,
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  _data.title ?? '-',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _data.body ?? '-',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${timeago.format(_data.createdAt != null ? DateTime.parse(_data.createdAt!) : DateTime.now(), locale: 'en_short')} ago",
                                                      style: TextStyle(
                                                        color: CustomColor
                                                            .GREY_TXT,
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
                                  ),
                                ),
                              );
                            },
                          );
                      }
                  }
                }),
          ),
        ],
      ),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.BG,
          centerTitle: true,
          title: Text(
            AppLocalizations.instance.text('TXT_NOTIFICATION'),
            style: TextStyle(
              color: CustomColor.BROWN_TXT,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
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
