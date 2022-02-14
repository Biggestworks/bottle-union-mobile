import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  static String tag = '/product-detail-screen';
  final Data? productList;

  const ProductDetailScreen({Key? key, this.productList}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as ProductDetailScreen;

    Widget _descriptionContent = Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_args.productList!.name!, style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontSize: 24,
          ),),
          Text(_args.productList!.categories!.name!, style: TextStyle(
            color: CustomColor.BROWN_LIGHT_TXT,
          ),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(FormatterHelper.moneyFormatter(_args.productList!.regularPrice!), style: TextStyle(
                color: CustomColor.MAIN_TXT,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),),
              Text('Stock ${_args.productList!.stock!} Item(s)', style: TextStyle(
                color: CustomColor.BROWN_LIGHT_TXT,
                fontSize: 16,
              ),),
            ],
          ),
          Divider(
            color: CustomColor.MAIN,
            thickness: 2,
            height: 20,
          ),
          Text('Brand', style: TextStyle(
            color: CustomColor.BROWN_LIGHT_TXT,
          ),),
          Text(_args.productList!.brand!.name!, style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          SizedBox(height: 10,),
          Text('Year', style: TextStyle(
            color: CustomColor.BROWN_LIGHT_TXT,
          ),),
          Text(_args.productList!.year!, style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          SizedBox(height: 10,),
          Text('Manufacture Country', style: TextStyle(
            color: CustomColor.BROWN_LIGHT_TXT,
          ),),
          Text(_args.productList!.manufactureCountry!, style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          SizedBox(height: 10,),
          Text('Description', style: TextStyle(
            color: CustomColor.BROWN_LIGHT_TXT,
          ),),
          Text(_args.productList!.description!, style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        ],
      ),
    );

    Widget _mainContent = SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      child: Image.network(_args.productList!.image1!, fit: BoxFit.fill,),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      child: Image.network(_args.productList!.image2!, fit: BoxFit.fill,),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      child: Image.network(_args.productList!.image3!, fit: BoxFit.fill,),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      child: Image.network(_args.productList!.image4!, fit: BoxFit.fill,),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            _descriptionContent,
          ],
        ),
      ),
    );

    Widget _bottomMenuContent = Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(FontAwesomeIcons.solidHeart, color: CustomColor.GREY_TXT,),
          //   visualDensity: VisualDensity.compact,
          // ),
          // SizedBox(width: 10,),
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
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: _mainContent,
      bottomNavigationBar: _bottomMenuContent,
    );
  }
}
