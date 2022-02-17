import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/provider/product/product_detail_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  static String tag = '/product-detail-screen';
  final Data? product;

  const ProductDetailScreen({Key? key, this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<ProductDetailProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<ProductDetailProvider>(context, listen: false).fnCheckWishlist();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductDetailProvider>(context, listen: false);

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
            child: CustomWidget.networkImg(context, url),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    Widget _descriptionContent = Consumer<ProductDetailProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.product.name ?? '-', style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),),
              Text(provider.product.categories?.name ?? '-', style: TextStyle(
                color: CustomColor.GREY_TXT,
                fontSize: 16,
              ),),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(FormatterHelper.moneyFormatter(provider.product.regularPrice ?? 0), style: TextStyle(
                    color: CustomColor.MAIN,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),),
                  Text('In stock ${provider.product.stock ?? '0'} item(s)', style: TextStyle(
                    color: CustomColor.GREY_TXT,
                    fontSize: 14,
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
              Text(provider.product.brand?.name ?? '-', style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),),
              SizedBox(height: 10,),
              Text('Year', style: TextStyle(
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              Text(provider.product.year ?? '-', style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),),
              SizedBox(height: 10,),
              Text('Manufacture Country', style: TextStyle(
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              Text(provider.product.manufactureCountry ?? '-', style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),),
              SizedBox(height: 10,),
              Text('Description', style: TextStyle(
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              ReadMoreText(
                provider.product.description ?? '-',
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
            ],
          ),
        );
      },
    );

    Widget _mainContent = Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: CustomColor.MAIN,
            borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0)
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ],
          ),
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ProductDetailProvider>(
                  builder: (context, provider, _) {
                    return CarouselSlider(
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
                        _imageContainer(provider.product.image1),
                        _imageContainer(provider.product.image2),
                        _imageContainer(provider.product.image3),
                        _imageContainer(provider.product.image4),
                      ],
                    );
                  },
                ),
                _descriptionContent,
              ],
            ),
          ),
        ),
      ],
    );

    Widget _bottomMenuContent = Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
              label: 'Add to Cart',
              lblColor: CustomColor.MAIN,
              btnColor: CustomColor.MAIN,
              function: () {},
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
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_PRODUCT_DETAIL'),),
      ),
      body: _mainContent,
      bottomNavigationBar: _bottomMenuContent,
    );
  }
}
