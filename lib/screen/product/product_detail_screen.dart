import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
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
        Provider.of<ProductDetailProvider>(context, listen: false).fnFetchDiscussionList();
      });
      Provider.of<ProductDetailProvider>(context, listen: false).fnGetSelectedRegionProduct();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductDetailProvider>(context, listen: false);
    final _baseProvider = Provider.of<BaseHomeProvider>(context, listen: false);

    _showProductRegionSheet(Data? data) {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        isRounded: true,
        child: ChangeNotifierProvider.value(
          value: Provider.of<ProductDetailProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              color: CustomColor.BG,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(top: 15),
            child: Scaffold(
              backgroundColor: CustomColor.BG,
              appBar: AppBar(
                backgroundColor: CustomColor.BG,
                elevation: 0,
                centerTitle: false,
                title: Text(AppLocalizations.instance.text('TXT_PRODUCT_REGION'), style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.clear, color: CustomColor.GREY_TXT, size: 26,),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.white, CustomColor.BROWN_LIGHT_2, CustomColor.BROWN_LIGHT_2, CustomColor.BROWN_LIGHT_2, Colors.white],
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.circleInfo, color: CustomColor.BROWN_TXT,),
                          SizedBox(width: 10,),
                          Flexible(
                            child: Text(AppLocalizations.instance.text('TXT_SELECT_PRODUCT_REGION_INFO'), style: TextStyle(
                              color: CustomColor.BROWN_TXT,
                            ),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Flexible(
                      child: Consumer<ProductDetailProvider>(
                        child: Container(),
                        builder: (context, provider, skeleton) {
                          switch (data) {
                            case null:
                              return skeleton!;
                            default:
                              switch (data?.productRegion?.length) {
                                case 0:
                                  return Text(AppLocalizations.instance.text('TXT_NO_PRODUCT_REGION'));
                                default:
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 4.5,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemCount: data?.productRegion?.length,
                                    itemBuilder: (context, index) {
                                      var _productRegion = data?.productRegion?[index];
                                      switch (_productRegion?.stock) {
                                        case 0:
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: CustomColor.GREY_ICON,
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: CustomColor.GREY_BG)
                                            ),
                                            child: Center(
                                              child: Text('${_productRegion?.region?.name ?? '-'} (${AppLocalizations.instance.text('TXT_SOLD_OUT')})', style: TextStyle(
                                                color: CustomColor.GREY_TXT,
                                              ), textAlign: TextAlign.center,),
                                            ),
                                          );
                                        default:
                                          return GestureDetector(
                                            onTap: () async => await provider.fnOnSelectRegionProduct(_productRegion?.idRegion ?? 1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: provider.selectedRegionId == _productRegion?.idRegion
                                                    ? CustomColor.MAIN
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: CustomColor.GREY_BG, width: 2),
                                              ),
                                              child: Center(
                                                child: Text('${_productRegion?.region?.name ?? '-'} (${_productRegion?.stock.toString() ?? '0'} ${_productRegion?.stock == 1 ? 'stock' : 'stocks'})', style: TextStyle(
                                                  color: provider.selectedRegionId == _productRegion?.idRegion
                                                      ? Colors.white
                                                      : Colors.black,
                                                ), textAlign: TextAlign.center,),
                                              ),
                                            ),
                                          );
                                      }
                                    },
                                  );
                              }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2, color: CustomColor.GREY_BG),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<ProductDetailProvider>(
                        child: CustomWidget.showShimmer(
                          child: Container(
                            color: Colors.white,
                            height: 40,
                            width: 40,
                          ),
                        ),
                        builder: (context, provider, skeleton) {
                          switch (_isLoad) {
                            case true:
                              return skeleton!;
                            default:
                              return IconButton(
                                onPressed: () async {
                                  Get.back();
                                  if (provider.selectedRegionId != null) {
                                    await provider.fnStoreWishlist(provider.scaffoldKey.currentContext!);
                                  } else {
                                    await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_NO_PRODUCT_REGION_SELECTED')));
                                  }
                                },
                                icon: Icon(provider.isWishlist
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart, color: CustomColor.MAIN,),
                                visualDensity: VisualDensity.compact,
                              );
                          }
                        },
                      ),
                      SizedBox(width: 5,),
                      Consumer<ProductDetailProvider>(
                        child: Flexible(
                          child: CustomWidget.showShimmer(
                            child: Container(
                              color: Colors.white,
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        builder: (context, provider, skeleton) {
                          switch (_isLoad) {
                            case true:
                              return skeleton!;
                            default:
                              return Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomWidget.roundOutlinedBtn(
                                        label: AppLocalizations.instance.text('TXT_CART_ADD'),
                                        lblColor: CustomColor.MAIN,
                                        btnColor: CustomColor.MAIN,
                                        isBold: true,
                                        radius: 5,
                                        function: () async {
                                          Get.back();
                                          if (provider.selectedRegionId != null) {
                                            await _provider.fnStoreCart(_provider.scaffoldKey.currentContext!)
                                                .then((_) async => await _baseProvider.fnGetCartCount());
                                            setState(() {});
                                          } else {
                                            await CustomWidget.showSnackBar(context: context, content: Text('Please select product region'));
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: CustomWidget.roundBtn(
                                        label: AppLocalizations.instance.text('TXT_LBL_BUY_NOW'),
                                        btnColor: CustomColor.MAIN,
                                        lblColor: Colors.white,
                                        isBold: true,
                                        radius: 5,
                                        function: () async {
                                          Get.back();
                                          if (provider.selectedRegionId != null) {
                                            Get.toNamed(DeliveryBuyScreen.tag, arguments: DeliveryBuyScreen(
                                              product: _provider.product,
                                              isCart: false,
                                              selectedRegionId: provider.selectedRegionId,
                                            ));
                                          } else {
                                            await CustomWidget.showSnackBar(context: context, content: Text('Please select product region'));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _bottomMenuContent = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 2, color: CustomColor.GREY_BG),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<ProductDetailProvider>(
              child: CustomWidget.showShimmer(
                child: Container(
                  color: Colors.white,
                  height: 40,
                  width: 40,
                ),
              ),
              builder: (context, provider, skeleton) {
                switch (_isLoad) {
                  case true:
                    return skeleton!;
                  default:
                    switch (provider.product.data) {
                      case null:
                        return skeleton!;
                      default:
                        return IconButton(
                          onPressed: () async => _showProductRegionSheet(_provider.product.data),
                          icon: Icon(provider.isWishlist
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart, color: CustomColor.MAIN,),
                          visualDensity: VisualDensity.compact,
                        );
                    }
                }
              },
            ),
            SizedBox(width: 5,),
            Consumer<ProductDetailProvider>(
              child: Flexible(
                child: CustomWidget.showShimmer(
                  child: Container(
                    color: Colors.white,
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              builder: (context, provider, skeleton) {
                switch (_isLoad) {
                  case true:
                    return skeleton!;
                  default:
                    switch (provider.product.data) {
                      case null:
                        return skeleton!;
                      default:
                        return Flexible(
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomWidget.roundOutlinedBtn(
                                  label: AppLocalizations.instance.text('TXT_CART_ADD'),
                                  lblColor: CustomColor.MAIN,
                                  btnColor: CustomColor.MAIN,
                                  isBold: true,
                                  radius: 5,
                                  function: () => _showProductRegionSheet(_provider.product.data),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                child: CustomWidget.roundBtn(
                                  label: AppLocalizations.instance.text('TXT_LBL_BUY_NOW'),
                                  btnColor: CustomColor.MAIN,
                                  lblColor: Colors.white,
                                  isBold: true,
                                  radius: 5,
                                  function: () => _showProductRegionSheet(_provider.product.data),
                                ),
                              ),
                            ],
                          ),
                        );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );

    Widget _bottomMenuDisabledContent = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: CustomColor.GREY_ICON),
          ),
        ),
        child: CustomWidget.roundBtn(
          label: AppLocalizations.instance.text('TXT_SOLD_OUT'),
          btnColor: CustomColor.GREY_TXT,
          lblColor: Colors.white,
          isBold: true,
          radius: 5,
          function: () {},
        ),
      ),
    );

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

    Widget _productHeaderContent = Consumer<ProductDetailProvider>(
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

    Widget _productRegionContent = Consumer<ProductDetailProvider>(
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
                return GestureDetector(
                  onTap: () {
                    if (_data.productRegion?.length != 0)
                      _showProductRegionSheet(_data);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.instance.text('TXT_SELECT_PRODUCT_REGION'), style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                            Icon(Icons.arrow_forward_ios, size: 16,),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      if (_data.productRegion?.length == 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(AppLocalizations.instance.text('TXT_NO_PRODUCT_REGION'), style: TextStyle(
                            color: CustomColor.GREY_TXT,
                          ),),
                        )
                      else
                        Container(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _data.productRegion?.length,
                            itemBuilder: (context, index) {
                              var _productRegion = _data.productRegion?[index];
                              switch (_productRegion?.stock) {
                                case 0:
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(right: 10, left: index == 0 ? 10 : 0),
                                    decoration: BoxDecoration(
                                        color: CustomColor.GREY_ICON,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: CustomColor.GREY_BG)
                                    ),
                                    child: Center(
                                      child: Text('${_productRegion?.region?.name ?? '-'} (${AppLocalizations.instance.text('TXT_SOLD_OUT')})', style: TextStyle(
                                        color: CustomColor.GREY_TXT,
                                      ),),
                                    ),
                                  );
                                default:
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(right: 10, left: index == 0 ? 10 : 0),
                                    decoration: BoxDecoration(
                                      color: provider.selectedRegionId == _productRegion?.idRegion
                                          ? CustomColor.MAIN
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: CustomColor.GREY_BG, width: 2),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(_productRegion?.region?.name ?? '-', style: TextStyle(
                                          color: provider.selectedRegionId == _productRegion?.idRegion
                                              ? Colors.white
                                              : Colors.black,
                                        ),),
                                        SizedBox(width: 4,),
                                        Text('(${_productRegion?.stock.toString() ?? '0'} ${_productRegion?.stock == 1 ? 'stock' : 'stocks'})', style: TextStyle(
                                          color: provider.selectedRegionId == _productRegion?.idRegion
                                              ? Colors.white
                                              : Colors.black,
                                        ),),
                                      ],
                                    ),
                                  );
                              }
                            },
                          ),
                      ),
                      Divider(
                        thickness: 6,
                        height: 40,
                        color: CustomColor.GREY_BG,
                      ),
                    ],
                  ),
                );
            }
        }
      },
    );

    Widget _productDetailContent = Consumer<ProductDetailProvider>(
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
                  children: [
                    Padding(
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

    Widget _productDiscussionContent = Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ProductDetailProvider>(
            builder: (context, provider, _) {
              return Text('${AppLocalizations.instance.text('TXT_PRODUCT_DISCUSSION')} (${provider.discussionList.data?.length})', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                // color: CustomColor.MAIN_TXT,
              ),);
            },
          ),
          SizedBox(height: 15,),
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
                            return Center(
                              child: SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(AppLocalizations.instance.text('TXT_NO_DISCUSSION')),
                                    SizedBox(height: 5,),
                                    CustomWidget.roundIconBtn(
                                      icon: Icons.add,
                                      label: AppLocalizations.instance.text('TXT_ADD_DISCUSSION'),
                                      lblColor: Colors.white,
                                      btnColor: CustomColor.MAIN,
                                      radius: 8,
                                      function: () => Get.toNamed(AddDiscussionScreen.tag, arguments: AddDiscussionScreen(
                                        product: provider.product.data,
                                      ))!.then((value) async {
                                        if (value == true) {
                                          await _provider.fnFetchDiscussionList();
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ),
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
                                  onPressed: () async => await Get.toNamed(DiscussionScreen.tag, arguments: DiscussionScreen(
                                    product: provider.product.data,
                                  ))!.then((_) => provider.fnFetchDiscussionList()),
                                  child: Text(AppLocalizations.instance.text('TXT_ALL_DISCUSSION'), style: TextStyle(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productHeaderContent,
              _productRegionContent,
              _productDetailContent,
              _productDiscussionContent,
            ],
          )
        ],
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
          switch (provider.product.data?.productRegion?.length) {
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
