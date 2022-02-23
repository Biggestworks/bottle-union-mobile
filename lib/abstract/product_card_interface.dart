import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:eight_barrels/service/product/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';


abstract class ProductCardInterface {
  UserPreferences _userPreferences = new UserPreferences();
  WishlistService _wishlistService = new WishlistService();
  CartService _cartService = new CartService();

  Future fnStoreWishlist(BuildContext context, int productId) async {
    var _user = await _userPreferences.getUserData();

    var _res = await _wishlistService.storeWishlist(
      uid: _user!.data!.id!,
      productId: productId,
    );

    if (_res!.status != null) {
      if (_res.status == true && _res.message == 'Save Success') {
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_WISHLIST_ADD')));
      } else if (_res.status == true && _res.message == 'Success remove wishlist') {
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_WISHLIST_DELETE_SUCCESS')));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Future fnStoreCart(BuildContext context, int productId) async {
    var _user = await _userPreferences.getUserData();

    var _res = await _cartService.storeCart(
      uid: _user!.data!.id!,
      productId: productId,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_CART_ADD_INFO')));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Widget productCard({
    required BuildContext context,
    required Data data,
    required int index,
  }) {
    return Stack(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: InkWell(
            onTap: () => Get.toNamed(
              ProductDetailScreen.tag,
              arguments: ProductDetailScreen(id: data.id,),
            ),
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
                            Icon(FontAwesomeIcons.solidStar, color: Colors.orangeAccent, size: 16,),
                            SizedBox(width: 5,),
                            Text(data.rating != null ? data.rating.toString() : '0', style: TextStyle(
                              fontSize: 12,
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColor.MAIN_TXT,
                          fontSize: 16,
                        ),),
                      ),
                      SizedBox(height: index.isEven ? 20 : 40,),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('Stock: ${data.stock ?? '0'}', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                              ),),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async => await fnStoreCart(context, data.id!),
                                    child: Icon(FontAwesomeIcons.shoppingCart, color: CustomColor.GREY_ICON, size: 18,),
                                  ),
                                  SizedBox(width: 15,),
                                  GestureDetector(
                                    onTap: () async => await fnStoreWishlist(context, data.id!),
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
        ),
        // Positioned(
        //   right: 0,
        //   child: Image.asset('assets/images/ic_new.png', ),
        // ),
      ],
    );
  }

  Widget emptyProductCard({
    required BuildContext context,
    required Data data,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: InkWell(
          onTap: () => Get.toNamed(
            ProductDetailScreen.tag,
            arguments: ProductDetailScreen(id: data.id,),
          ),
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
                        fontSize: 18,
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
                          Icon(FontAwesomeIcons.solidStar, color: Colors.orangeAccent, size: 16,),
                          SizedBox(width: 5,),
                          Text(data.rating != null ? data.rating.toString() : '0', style: TextStyle(
                            fontSize: 12,
                          ),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Flexible(
                      child: Text(FormatterHelper.moneyFormatter(data.regularPrice ?? 0), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColor.MAIN_TXT,
                        fontSize: 16,
                      ),),
                    ),
                    SizedBox(height: index.isEven ? 20 : 40,),
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
                                  child: Icon(FontAwesomeIcons.shoppingCart, color: CustomColor.GREY_ICON, size: 18,),
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
      ),
    );
  }

}