import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/product/product_detail_provider.dart';
import 'package:eight_barrels/screen/checkout/delivery_screen.dart';
import 'package:eight_barrels/screen/discussion/discussion_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductDetailScreen extends StatefulWidget {
  static String tag = '/product-detail-screen';
  final int? id;

  const ProductDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with LoadingView {
  bool _isLoad = false;
  
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<ProductDetailProvider>(context, listen: false).fnGetView(this);
      Provider.of<ProductDetailProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<ProductDetailProvider>(context, listen: false).fnFetchProduct()
          .then((_) {
        Provider.of<ProductDetailProvider>(context, listen: false).fnCheckWishlist();
        Provider.of<ProductDetailProvider>(context, listen: false).fnFetchDiscussionList(context);
      });
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductDetailProvider>(context, listen: false);
    final _baseProvider = Provider.of<BaseHomeProvider>(context, listen: false);

    Widget _imageContainer(String? url) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            child: CustomWidget.networkImg(context, url, fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    Widget _discussionContent = Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ProductDetailProvider>(
            builder: (context, provider, _) {
              return Text('Product Discussion (${provider.discussionList.data?.length})', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),);
            },
          ),
          SizedBox(height: 20,),
          Consumer<ProductDetailProvider>(
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
                          return Column(
                            children: [
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.discussionList.data?.length.clamp(0, 4) ?? 0,
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
                              ),
                              SizedBox(height: 10,),
                              TextButton(
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () => Get.toNamed(DiscussionScreen.tag, arguments: DiscussionScreen(
                                  product: provider.product.data,
                                )),
                                child: Text('See all discussion', style: TextStyle(
                                  color: CustomColor.MAIN,
                                ),),
                              ),
                            ],
                          );
                      }
                  }
              }
            }
          ),
        ],
      ),
    );

    Widget _descriptionContent = Consumer<ProductDetailProvider>(
      child: CustomWidget.showShimmerProductDetail(),
      builder: (context, provider, skeleton) {
        switch (_isLoad) {
          case true:
            return skeleton!;
          default:
            switch (provider.product.data) {
              case null:
                return skeleton!;
              default:
                var _data = _provider.product.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 300.0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                        ),
                        items: [
                          _imageContainer(_data.image1),
                          _imageContainer(_data.image2),
                          _imageContainer(_data.image3),
                          _imageContainer(_data.image4),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_data.name ?? '-', style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                              SizedBox(height: 4,),
                              Text(_data.categories?.name ?? '-', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                                fontSize: 16,
                              ),),
                              SizedBox(height: 4,),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: double.parse(_data.rating ?? '0.0'),
                                    ignoreGestures: true,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding: EdgeInsets.zero,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    itemSize: 16,
                                    onRatingUpdate: (rating) {},
                                  ),
                                  SizedBox(width: 2,),
                                  Text('(${_data.rating ?? '0.0'})', style: TextStyle(
                                    color: CustomColor.GREY_TXT,
                                  ),),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(FormatterHelper.moneyFormatter(_data.regularPrice ?? 0), style: TextStyle(
                                    color: CustomColor.MAIN,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),),
                                  _data.stock != 0
                                      ? Text('In stock ${_data.stock ?? '0'} item(s)', style: TextStyle(
                                    color: CustomColor.GREY_TXT,
                                  ),)
                                      : Text('Sold Out', style: TextStyle(
                                    color: CustomColor.MAIN_TXT,
                                    fontSize: 16,
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Brand', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                              ),),
                              SizedBox(height: 5,),
                              Text(_data.brand?.name ?? '-', style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),),
                              SizedBox(height: 10,),
                              Text('Year', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                              ),),
                              SizedBox(height: 5,),
                              Text(_data.year ?? '-', style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),),
                              SizedBox(height: 10,),
                              Text('Manufacture Country', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                              ),),
                              SizedBox(height: 5,),
                              Text(_data.manufactureCountry ?? '-', style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),),
                              SizedBox(height: 10,),
                              Text('Description', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                              ),),
                              SizedBox(height: 5,),
                              ReadMoreText(provider.fnConvertHtmlString(_data.description ?? '-'),
                                trimLines: 3,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                lessStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.pink,
                                ),
                                moreStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.pink,
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 50,
                        ),
                        _discussionContent
                      ],
                    ),
                  ],
                );
            }
        }
      },
    );

    Widget _mainContent = SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              // color: CustomColor.MAIN,
              image: DecorationImage(
                image: AssetImage('assets/images/bg_marron.png',),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0)
              ),
            ),
          ),
          _descriptionContent,
        ],
      ),
    );

    Widget _bottomMenuContent = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: CustomColor.GREY_ICON),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<ProductDetailProvider>(
                builder: (context, provider, _) {
                  return IconButton(
                    onPressed: () async => await provider.fnStoreWishlist(provider.scaffoldKey.currentContext!),
                    icon: Icon(provider.isWishlist
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart, color: CustomColor.MAIN,),
                    visualDensity: VisualDensity.compact,
                  );
                }
            ),
            SizedBox(width: 5,),
            Expanded(
              child: CustomWidget.roundOutlinedBtn(
                label: AppLocalizations.instance.text('TXT_CART_ADD'),
                lblColor: CustomColor.MAIN,
                btnColor: CustomColor.MAIN,
                function: () async {
                  await _provider.fnStoreCart(_provider.scaffoldKey.currentContext!)
                      .then((_) async => await _baseProvider.fnGetCartCount());
                  setState(() {});
                },
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: CustomWidget.roundBtn(
                label: AppLocalizations.instance.text('TXT_LBL_BUY_NOW'),
                btnColor: CustomColor.MAIN,
                lblColor: Colors.white,
                function: () => Get.toNamed(DeliveryScreen.tag, arguments: DeliveryScreen(
                  product: _provider.product,
                  isCart: false,
                )),
              ),
            ),
          ],
        ),
      ),
    );

    Widget _bottomMenuDisabledContent = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: CustomColor.GREY_ICON),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<ProductDetailProvider>(
                builder: (context, provider, _) {
                  return IconButton(
                    onPressed: () async => await provider.fnStoreWishlist(provider.scaffoldKey.currentContext!),
                    icon: Icon(provider.isWishlist
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart, color: CustomColor.MAIN,),
                    visualDensity: VisualDensity.compact,
                  );
                }
            ),
            SizedBox(width: 10,),
            Expanded(
              child: CustomWidget.roundBtn(
                label: AppLocalizations.instance.text('TXT_SOLD_OUT'),
                btnColor: CustomColor.GREY_TXT,
                lblColor: Colors.white,
                function: () {},
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        flexibleSpace: Image.asset('assets/images/bg_marron.png', fit: BoxFit.cover,),
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'),),
        actions: [
          IconButton(
            onPressed: () async {
              await FlutterShare.share(
                  title: 'Bottle Union',
                  text: 'Bottle Union Product',
                  linkUrl: 'https://bottleunion.com/product_id=51',
              );
            },
            icon: Icon(Icons.share),
            padding: EdgeInsets.only(right: 10,),
          ),
        ],
      ),
      body: _mainContent,
      bottomNavigationBar: Consumer<ProductDetailProvider>(
        builder: (context, provider, _) {
          switch (provider.product.data?.stock) {
            case 0:
              return _bottomMenuDisabledContent;
            default:
              return _bottomMenuContent;
          }
        }
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
