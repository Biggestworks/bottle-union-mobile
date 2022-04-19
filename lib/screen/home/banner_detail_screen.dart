import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/model/banner/banner_list_model.dart';
import 'package:eight_barrels/provider/home/banner_detail_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BannerDetailScreen extends StatefulWidget {
  static String tag = '/banner-detail-screen';
  final Data? banner;
  const BannerDetailScreen({Key? key, this.banner}) : super(key: key);

  @override
  _BannerDetailScreenState createState() => _BannerDetailScreenState();
}

class _BannerDetailScreenState extends State<BannerDetailScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<BannerDetailProvider>(context, listen: false).fnGetArguments(context);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<BannerDetailProvider>(context, listen: false);

    Widget _mainContent = SafeArea(
      child: Consumer<BannerDetailProvider>(
        child: Container(),
        builder: (context, provider, skeleton) {
          switch (provider.banner) {
            case null:
              return skeleton!;
            default:
              return CustomScrollView(
                slivers: <Widget>[
                  SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      expandedHeight: 250.0,
                      floating: true,
                      pinned: false,
                      snap: true,
                      elevation: 10,
                      backgroundColor: Colors.transparent,
                      leading: SizedBox(),
                      flexibleSpace: FlexibleSpaceBar(
                        background: CustomWidget.networkImg(context, provider.banner!.image,),
                        collapseMode: CollapseMode.parallax,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('EEEE, dd MMMM yyyy')
                              .format(DateTime.parse(provider.banner!.createdAt ?? '')),
                            style: TextStyle(
                              fontSize: 12,
                              color: CustomColor.MAIN,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(provider.banner!.title ?? '-', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),),
                          Html(
                            data: provider.banner!.description ?? '-',
                            style: {"body": Style(padding: EdgeInsets.zero, margin: EdgeInsets.zero)},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );


    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
      ),
      body: _mainContent,
    );
  }
}