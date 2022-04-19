import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/transaction/track_order_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class TrackOrderScreen extends StatefulWidget {
  static String tag = '/track-order-screen';
  final String? orderId;

  const TrackOrderScreen({Key? key, this.orderId}) : super(key: key);

  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> with LoadingView {
  bool _isLoad = false;
  
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<TrackOrderProvider>(context, listen: false).fnGetView(this);
      Provider.of<TrackOrderProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<TrackOrderProvider>(context, listen: false).fnGetTrackOrder();
    },);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    Widget _mainContent = Consumer<TrackOrderProvider>(
      child: CustomWidget.emptyScreen(
        image: 'assets/images/ic_empty.png',
        title: AppLocalizations.instance.text('TXT_NO_DATA'),
        size: 180
      ),
      builder: (context, provider, skeleton) {
        switch (provider.trackOrder.data) {
          case null:
            return skeleton!;
          default:
            return SingleChildScrollView(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: CustomColor.GREY_TXT,
                  fontSize: 14,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FixedTimeline.tileBuilder(
                    theme: TimelineThemeData(
                      nodePosition: 0,
                      color: CustomColor.GREY_BG,
                      indicatorTheme: IndicatorThemeData(
                        position: 0,
                        size: 20.0,
                      ),
                      connectorTheme: ConnectorThemeData(
                        thickness: 2.5,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      connectionDirection: ConnectionDirection.before,
                      itemCount: provider.trackOrder.data?.length ?? 0,
                      contentsBuilder: (context, index) {
                        var _data = provider.trackOrder.data?[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${_data?.createdAt != null
                                      ? DateFormat('dd MMM yyyy').format(DateTime.parse(_data?.createdAt ?? ''))
                                      : '-'}', style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: index == 0
                                        ? CustomColor.MAIN
                                        : CustomColor.GREY_TXT,
                                  ),),
                                  Text('${_data?.createdAt != null
                                      ? DateFormat('h:mm a').format(DateTime.parse(_data?.createdAt ?? ''))
                                      : '-'}'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.circle, color: CustomColor.GREY_TXT, size: 10,),
                                        SizedBox(width: 5,),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: 'Status: '),
                                              TextSpan(
                                                text: '${provider.fnGetStatus(_data?.statusCode ?? '')}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Text('[${_data?.description ?? '-'}]'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      indicatorBuilder: (_, index) {
                        var _data = provider.trackOrder.data?[index];
                        return (index + 1) == 1 ? DotIndicator(
                            color: CustomColor.MAIN,
                            child: _data?.statusCode == '6'
                                ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.0,
                            )
                                : Container()
                        ) : OutlinedDotIndicator(
                          borderWidth: 2.5,
                        );
                      },
                      connectorBuilder: (_, index, __) => SolidLineConnector(
                        color: index == 1
                            ? CustomColor.MAIN
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            );
        }
      }
    );
    
    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.MAIN,
          centerTitle: true,
          title: Text('Order Status'),
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
