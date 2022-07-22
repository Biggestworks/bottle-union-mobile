import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/product/popular_product_list_model.dart' as popularProduct;
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

abstract class ProductCardInterface {

  String _fnGetDiscount(int? regularPrice, int? salePrice) {
    String _disc = '0%';
    if (salePrice != null && (salePrice < (regularPrice ?? 0))) {
      double _res = (((regularPrice ?? 0) - salePrice) / (regularPrice ?? 0)) * 100;
      _disc = '${_res.round()}%';
    }
    return _disc;
  }

  Widget productCard({
    required BuildContext context,
    required Data data,
    required int index,
    required Future storeClickLog(),
    required Future storeCartLog(),
    required Future storeWishlistLog(),
    required void onUpdateCart(),
  }) {
    return Stack(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          shadowColor: CustomColor.GREY_TXT,
          child: InkWell(
            onTap: () async {
              await storeClickLog();
              Get.toNamed(
                ProductDetailScreen.tag,
                arguments: ProductDetailScreen(productId: data.id,),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data.image1 ?? '',
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.name ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 5,),
                      Flexible(
                        child: Row(
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(data.rating ?? '0.0'),
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemPadding: EdgeInsets.zero,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemSize: 15,
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(width: 2,),
                            Text('(${data.rating ?? '0.0'})', style: TextStyle(
                              color: CustomColor.GREY_TXT,
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      if (data.salePrice != null && ((data.salePrice ?? 0) < (data.regularPrice ?? 0)))
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(FormatterHelper.moneyFormatter(data.salePrice ?? 0), style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColor.MAIN_TXT,
                              ),),
                              SizedBox(height: 5,),
                              Flexible(
                                child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                                  color: CustomColor.GREY_TXT,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 1.5,
                                  decorationColor: CustomColor.GREY_TXT,
                                ),),
                              ),
                            ],
                          ),
                        )
                      else
                        Flexible(
                          child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColor.MAIN_TXT,
                          ),),
                        ),
                      SizedBox(height: index.isEven ? 15 : 25,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (data.salePrice != null && ((data.salePrice ?? 0) < (data.regularPrice ?? 0)))
          Positioned(
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/ic_discount.png'), fit: BoxFit.fill),
              ),
              height: 40,
              width: 40,
              child: Center(
                child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(-30 / 360),
                  child: Text('${_fnGetDiscount(data.regularPrice, data.salePrice)}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget emptyProductCard({
    required BuildContext context,
    required Data data,
    required int index,
    required Future storeLog(),
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      shadowColor: CustomColor.GREY_TXT,
      child: InkWell(
        onTap: () async {
          await storeLog();
          Get.toNamed(
            ProductDetailScreen.tag,
            arguments: ProductDetailScreen(productId: data.id,),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data.image1 ?? '',
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: CustomColor.GREY_ICON,
                  ),
                  child: Center(
                    child: Text(AppLocalizations.instance.text('TXT_SOLD_OUT'), style: TextStyle(
                      fontSize: 16,
                      color: CustomColor.MAIN,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data.name ?? '-', style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 5,),
                  Flexible(
                    child: Row(
                      children: [
                        RatingBar.builder(
                          initialRating: double.parse(data.rating ?? '0.0'),
                          ignoreGestures: true,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding: EdgeInsets.zero,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemSize: 15,
                          onRatingUpdate: (rating) {},
                        ),
                        SizedBox(width: 2,),
                        Text('(${data.rating ?? '0.0'})', style: TextStyle(
                          color: CustomColor.GREY_TXT,
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Flexible(
                    child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColor.MAIN_TXT,
                    ),),
                  ),
                  SizedBox(height: index.isEven ? 15 : 35,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget popularProductCard({
    required BuildContext context,
    required popularProduct.Data data,
    required int index,
    required Future storeClickLog(),
    required Future storeCartLog(),
    required Future storeWishlistLog(),
    required void onUpdateCart(),
  }) {
    return Stack(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          shadowColor: CustomColor.GREY_TXT,
          child: InkWell(
            onTap: () async {
              await storeClickLog();
              Get.toNamed(
                ProductDetailScreen.tag,
                arguments: ProductDetailScreen(productId: data.id,),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data.image ?? '',
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.name ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 5,),
                      Flexible(
                        child: Row(
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(data.rating ?? '0.0'),
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemPadding: EdgeInsets.zero,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemSize: 15,
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(width: 2,),
                            Text('(${data.rating ?? '0.0'})', style: TextStyle(
                              color: CustomColor.GREY_TXT,
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Flexible(
                        child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColor.MAIN_TXT,
                        ),),
                      ),
                      SizedBox(height: index.isEven ? 25 : 45,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (data.flag == 'NEW PRODUCT')
          Positioned(
            right: 0,
            child: Image.asset('assets/images/ic_new.png', ),
          ),
      ],
    );
  }

  Widget popularEmptyProductCard({
    required BuildContext context,
    required popularProduct.Data data,
    required int index,
    required Future storeLog(),
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      shadowColor: CustomColor.GREY_TXT,
      child: InkWell(
        onTap: () async {
          await storeLog();
          Get.toNamed(
            ProductDetailScreen.tag,
            arguments: ProductDetailScreen(productId: data.id,),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data.image ?? '',
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: CustomColor.GREY_ICON,
                  ),
                  child: Center(
                    child: Text(AppLocalizations.instance.text('TXT_SOLD_OUT'), style: TextStyle(
                      fontSize: 16,
                      color: CustomColor.MAIN,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data.name ?? '-', style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 5,),
                  Flexible(
                    child: Row(
                      children: [
                        RatingBar.builder(
                          initialRating: double.parse(data.rating ?? '0.0'),
                          ignoreGestures: true,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding: EdgeInsets.zero,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemSize: 15,
                          onRatingUpdate: (rating) {},
                        ),
                        SizedBox(width: 2,),
                        Text('(${data.rating ?? '0.0'})', style: TextStyle(
                          color: CustomColor.GREY_TXT,
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Flexible(
                    child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColor.MAIN_TXT,
                    ),),
                  ),
                  SizedBox(height: index.isEven ? 25 : 45,),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('${AppLocalizations.instance.text('TXT_SOLD_OUT')}', style: TextStyle(
                            color: Colors.red,
                          ),),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Icon(FontAwesomeIcons.cartShopping, color: CustomColor.GREY_ICON, size: 18,),
                              ),
                              SizedBox(width: 15,),
                              GestureDetector(
                                onTap: () {},
                                child: Icon(FontAwesomeIcons.heart, color: CustomColor.GREY_ICON, size: 18,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget regionalProductCard({
    required BuildContext context,
    required popularProduct.Data data,
    required int index,
    required Future storeClickLog(),
    required Future storeCartLog(),
    required Future storeWishlistLog(),
    required void onUpdateCart(),
  }) {
    return Container(
      width: 200,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: InkWell(
          onTap: () async {
            await storeClickLog();
            Get.toNamed(
              ProductDetailScreen.tag,
              arguments: ProductDetailScreen(productId: data.id,),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: data.image ?? '',
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.name ?? '-', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 5,),
                      Flexible(
                        child: Row(
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(data.rating ?? '0.0'),
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemPadding: EdgeInsets.zero,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemSize: 15,
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(width: 2,),
                            Text('(${data.rating ?? '0.0'})', style: TextStyle(
                              color: CustomColor.GREY_TXT,
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Flexible(
                        child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColor.MAIN_TXT,
                        ),),
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
  }

  Widget regionalEmptyProductCard({
    required BuildContext context,
    required popularProduct.Data data,
    required int index,
    required Future storeLog(),
  }) {
    return Container(
      width: 200,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: InkWell(
          onTap: () async {
            await storeLog();
            Get.toNamed(
              ProductDetailScreen.tag,
              arguments: ProductDetailScreen(productId: data.id,),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: data.image ?? '',
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.no_photography, size: 50, color: CustomColor.GREY_ICON,),),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: CustomColor.GREY_ICON,
                    ),
                    child: Center(
                      child: Text(AppLocalizations.instance.text('TXT_SOLD_OUT'), style: TextStyle(
                        fontSize: 16,
                        color: CustomColor.MAIN,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(data.name ?? '-', style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                    SizedBox(height: 5,),
                    Flexible(
                      child: Row(
                        children: [
                          RatingBar.builder(
                            initialRating: double.parse(data.rating ?? '0.0'),
                            ignoreGestures: true,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.zero,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemSize: 15,
                            onRatingUpdate: (rating) {},
                          ),
                          SizedBox(width: 2,),
                          Text('(${data.rating ?? '0.0'})', style: TextStyle(
                            color: CustomColor.GREY_TXT,
                          ),),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Flexible(
                      child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColor.MAIN_TXT,
                      ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}