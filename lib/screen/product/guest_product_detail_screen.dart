import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/product/guest_product_detail_provider.dart';
import 'package:eight_barrels/provider/product/product_detail_provider.dart';
import 'package:eight_barrels/screen/checkout/delivery_buy_screen.dart';
import 'package:eight_barrels/screen/discussion/add_discussion_screen.dart';
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

class GuestProductDetailScreen extends StatefulWidget {
  static String tag = '/guest-product-detail-screen';
  final int? productId;

  const GuestProductDetailScreen({Key? key, this.productId}) : super(key: key);

  @override
  _GuestProductDetailScreenState createState() => _GuestProductDetailScreenState();
}

class _GuestProductDetailScreenState extends State<GuestProductDetailScreen> with LoadingView {
  bool _isLoad = false;
  
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<GuestProductDetailProvider>(context, listen: false).fnGetView(this);
      Provider.of<GuestProductDetailProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<GuestProductDetailProvider>(context, listen: false).fnFetchProduct();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<GuestProductDetailProvider>(context, listen: false);

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

    Widget _productHeaderContent = Consumer<GuestProductDetailProvider>(
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
                      padding: const EdgeInsets.only(top: 100),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_data.name ?? '-', style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 4,),
                                    Text(_data.categories?.name ?? '-', style: TextStyle(
                                      color: CustomColor.GREY_TXT,
                                      fontSize: 16,
                                    ),),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Flexible(
                                child: Text(FormatterHelper.moneyFormatter(_data.regularPrice ?? 0), style: TextStyle(
                                  color: CustomColor.MAIN,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),),
                              ),
                            ],
                          ),
                          SizedBox(height: 4,),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: double.parse(_data.rating ?? '0.0'),
                                ignoreGestures: true,
                                allowHalfRating: true,
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
                              SizedBox(width: 4,),
                              Text('(${_data.rating ?? '0.0'})', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 6,
                      height: 40,
                      color: CustomColor.GREY_BG,
                    ),
                  ],
                );
            }
        }
      },
    );

    Widget _productDetailContent = Consumer<GuestProductDetailProvider>(
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'), style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // color: CustomColor.MAIN_TXT,
                      ),),
                      SizedBox(height: 15,),
                      Text('Brand', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      Text(_data.brand?.name ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),),
                      Divider(
                        color: CustomColor.GREY_BG,
                        thickness: 1,
                      ),
                      // SizedBox(height: 10,),
                      Text('Year', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      Text(_data.year ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),),
                      Divider(
                        color: CustomColor.GREY_BG,
                        thickness: 1,
                      ),
                      // SizedBox(height: 10,),
                      Text('Manufacture Country', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      Text(_data.manufactureCountry ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),),
                      Divider(
                        color: CustomColor.GREY_BG,
                        thickness: 1,
                      ),
                      // SizedBox(height: 10,),
                      Text('Origin Country', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      Text(_data.originCountry ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),),
                      Divider(
                        color: CustomColor.GREY_BG,
                        thickness: 1,
                      ),
                      // SizedBox(height: 10,),
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
            height: 250,
            decoration: BoxDecoration(
              // color: CustomColor.MAIN,
              image: DecorationImage(
                image: AssetImage('assets/images/bg_marron_lg.png',),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0)
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productHeaderContent,
              _productDetailContent,
            ],
          )
        ],
      ),
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      backgroundColor: CustomColor.BG,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Image.asset('assets/images/bg_marron_lg.png', fit: BoxFit.cover,),
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'),),
        actions: [
          IconButton(
            onPressed: () async {
              // CustomWidget.showSnackBar(context: context, content: Text('Coming Soon'));
              await FlutterShare.share(
                  title: 'Bottle Union',
                  text: 'Bottle Union Product',
                  linkUrl: 'union://bottleunion.com/product_id=${_provider.productId}',
              );
            },
            icon: Icon(Icons.share),
            padding: EdgeInsets.only(right: 10,),
          ),
        ],
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
