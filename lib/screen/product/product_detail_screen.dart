import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/product/product_detail_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<ProductDetailProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<ProductDetailProvider>(context, listen: false).fnGetProduct()
          .then((value) => Provider.of<ProductDetailProvider>(context, listen: false).fnCheckWishlist());
      // Provider.of<ProductDetailProvider>(context, listen: false).fnHideOnScroll();
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            child: CustomWidget.networkImg(context, url, fit: BoxFit.fitHeight),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    Widget _discussionContent = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Product Discussion (4)', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              IconButton(
                icon: Icon(MdiIcons.chatPlus, color: Colors.green, size: 28,),
                onPressed: () {},
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          SizedBox(height: 20,),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            separatorBuilder: (context, index) {
              return Divider(color: CustomColor.GREY_ICON, height: 30,);
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/ic_profile.png'),
                          ),
                        ),
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
                                Text("User ${index+1}", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                Text(" . ${timeago.format(DateTime.now(), locale: 'en_short')} ago",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Ready kak?", style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 50,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                                image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/images/ic_launcher.png'),
                                ),
                              ),
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
                                      Text("Bottle Union Admin", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text(" . ${timeago.format(DateTime.now(), locale: 'en_short')} ago",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Ready gan, silahkan di order", style: TextStyle(
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
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    Widget _descriptionContent = Consumer<ProductDetailProvider>(
      child: CustomWidget.showShimmerProductDetail(),
      builder: (context, provider, skeleton) {
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
                      onPageChanged: (index, reason) {
                        // _provider.onBannerChanged(index);
                      },
                    ),
                    items: [
                      _imageContainer(_data.image1),
                      _imageContainer(_data.image2),
                      _imageContainer(_data.image3),
                      _imageContainer(_data.image4),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_data.name!, style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                Text(_data.categories?.name ?? '-', style: TextStyle(
                                  color: CustomColor.GREY_TXT,
                                  fontSize: 16,
                                ),),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.solidStar, color: Colors.orangeAccent, size: 18,),
                              SizedBox(width: 5,),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(_data.rating != null
                                    ? _data.rating.toString()
                                    : '0', style: TextStyle(
                                  fontSize: 18,
                                ),),
                              ),
                            ],
                          ),
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
                            fontSize: 20,
                          ),),
                          _data.stock != 0
                              ? Text('In stock ${_data.stock ?? '0'} item(s)', style: TextStyle(
                            color: CustomColor.GREY_TXT,
                            fontSize: 14,
                          ),)
                              : Text('Sold Out', style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),),
                        ],
                      ),
                      Divider(
                        color: CustomColor.MAIN,
                        thickness: 1.5,
                        height: 25,
                      ),
                      Text('Brand', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      Text(_data.brand?.name ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),),
                      SizedBox(height: 10,),
                      Text('Year', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      Text(_data.year ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),),
                      SizedBox(height: 10,),
                      Text('Manufacture Country', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      Text(_data.manufactureCountry ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),),
                      SizedBox(height: 10,),
                      Text('Description', style: TextStyle(
                        color: CustomColor.GREY_TXT,
                      ),),
                      SizedBox(height: 5,),
                      // Html(
                      //   data: _data.description ?? '',
                      //   style: {"body": Style(padding: EdgeInsets.zero, margin: EdgeInsets.zero, fontSize: FontSize.large,)},
                      // ),
                      ReadMoreText(_data.description ?? '-',
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
                          fontSize: 16,
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 50,
                      ),
                      _discussionContent
                    ],
                  ),
                ),
              ],
            );
        }
      },
    );

    Widget _mainContent = SingleChildScrollView(
      // controller: _provider.scrollController,
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
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
            SizedBox(width: 10,),
            Expanded(
              child: CustomWidget.roundBtn(
                label: 'Buy Now',
                btnColor: CustomColor.MAIN,
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
        // backgroundColor: CustomColor.MAIN,
        flexibleSpace: Image.asset('assets/images/bg_marron.png', fit: BoxFit.cover,),
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'),),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share),
            padding: EdgeInsets.only(right: 10,),
          ),
        ],
      ),
      body: _mainContent,
      bottomNavigationBar: _bottomMenuContent,
    );
  }
}
