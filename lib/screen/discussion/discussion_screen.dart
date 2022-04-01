import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/discussion/discussion_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiscussionScreen extends StatefulWidget {
  static String tag = '/discussion-screen';
  final Data? product;

  const DiscussionScreen({Key? key, this.product}) : super(key: key);

  @override
  _DiscussionScreenState createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<DiscussionProvider>(context, listen: false).fnGetView(this);
      Provider.of<DiscussionProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<DiscussionProvider>(context, listen: false).fnFetchDiscussionList();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget _mainContent = Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<DiscussionProvider>(
            child: Container(),
            builder: (context, provider, skeleton) {
              var _data = provider.product;
              return Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      child: CustomWidget.networkImg(context, _data?.image1 ?? ''),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_data?.name ?? '-', style: TextStyle(
                        color: Colors.black,
                      ),),
                      SizedBox(height: 5,),
                      Text(FormatterHelper.moneyFormatter(_data?.regularPrice ?? 0), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColor.MAIN_TXT,
                      ),),
                    ],
                  ),
                ],
              );
            },
          ),
          Divider(height: 40, thickness: 1.5,),
          Consumer<DiscussionProvider>(
              child: CustomWidget.showShimmer(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      height: 50,
                    );
                  },
                ),
              ),
              builder: (context, provider, skeleton) {
                switch (_isLoad) {
                  case true:
                    return skeleton!;
                  default:
                    switch (provider.discussionList.data) {
                      case null:
                        return skeleton!;
                      default:
                        switch (provider.discussionList.data?.length) {
                          case 0:
                            return CustomWidget.emptyScreen(
                              image: 'assets/images/ic_empty.png',
                              size: 150,
                              title: AppLocalizations.instance.text('TXT_NO_DISCUSSION'),
                            );
                          default:
                            return ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provider.discussionList.data?.length ?? 0,
                              separatorBuilder: (context, index) {
                                return Divider(color: CustomColor.GREY_ICON, height: 30,);
                              },
                              itemBuilder: (context, index) {
                                var _data = provider.discussionList.data?[index];
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        CustomWidget.roundedAvatarImg(
                                          url: _data?.user?.avatar ?? '',
                                          size: 40,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(_data?.user?.fullname ?? '-', style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),),
                                                  Text(" . ${timeago.format(DateTime.parse(_data?.createdAt ?? DateTime.now().toString()), locale: 'en_short')} ago",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Text(_data?.comment ?? '-', style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _data?.replyDiscussions?.length,
                                      itemBuilder: (context, index) {
                                        var _reply = _data?.replyDiscussions?[index];
                                        return Row(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 1,
                                              margin: EdgeInsets.symmetric(horizontal: 20),
                                              color: Colors.grey,
                                            ),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  CustomWidget.roundedAvatarImg(
                                                    url: _reply?.user?.avatar ?? '',
                                                    size: 40,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(_reply?.user?.fullname ?? '-', style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),),
                                                            Text(" . ${timeago.format(DateTime.parse(_reply?.createdAt ?? DateTime.now().toString()), locale: 'en_short')} ago",
                                                              style: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text(_reply?.comment ?? '-', style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                        }
                    }
                }
              }
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        flexibleSpace: Image.asset('assets/images/bg_marron.png', fit: BoxFit.cover,),
        elevation: 0,
        centerTitle: true,
        title: Text('Discussion'),
      ),
      body: _mainContent,
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
