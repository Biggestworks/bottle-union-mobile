import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/product/wishlist_provider.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  static String tag = '/wishlist-screen';

  const WishListScreen({Key? key}) : super(key: key);

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<WishListProvider>(context, listen: false).fnGetView(this);
      Provider.of<WishListProvider>(context, listen: false).fnFetchWishlist();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<WishListProvider>(context, listen: false);

    Widget _productListContent = Flexible(
      child: Consumer<WishListProvider>(
          child: CustomWidget.showShimmerListView(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.wishlist.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.wishlist.result!.data!.length) {
                      case 0:
                        return CustomWidget.emptyScreen(
                          image: 'assets/images/ic_empty_product.png',
                          title: AppLocalizations.instance.text('TXT_NO_PRODUCT'),
                        );
                      default:
                        return NotificationListener<ScrollNotification>(
                          onNotification: provider.fnOnNotification,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.wishlist.result!.data!.length,
                                itemBuilder: (context, index) {
                                  var _data = provider.wishlist.result!.data![index];
                                  return Row(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        child: provider.isSelection
                                            ? Checkbox(
                                          value: provider.selectionList[index].status,
                                          onChanged: (value) => provider.fnOnChangedCkBox(value, index),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        )
                                            : SizedBox(),
                                      ),
                                      Flexible(
                                        child: InkWell(
                                          onTap: () async => await Get.toNamed(
                                            ProductDetailScreen.tag,
                                            arguments: ProductDetailScreen(id: _data.idProduct,),
                                          )!.then((_) => provider.fnFetchWishlist()),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 120,
                                                        height: 120,
                                                        child: ClipRRect(
                                                          child: CustomWidget.networkImg(context, _data.product!.image1),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(_data.product!.name ?? '-', style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 16,
                                                              ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                              SizedBox(height: 5,),
                                                              Text(FormatterHelper.moneyFormatter(_data.product!.regularPrice), style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: CustomColor.MAIN_TXT,
                                                                fontSize: 16,
                                                              ),),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                children: [
                                                                  Icon(FontAwesomeIcons.solidStar, color: Colors.orangeAccent, size: 16,),
                                                                  SizedBox(width: 5,),
                                                                  Text(_data.product!.rating.toString(), style: TextStyle(
                                                                    fontSize: 12,
                                                                  ),),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async => await provider.fnDeleteWishlist(
                                                          provider.scaffoldKey.currentContext!,
                                                          _data.id!,
                                                        ),
                                                        icon: Icon(FontAwesomeIcons.trashAlt, size: 20,),
                                                        visualDensity: VisualDensity.compact,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Expanded(
                                                        child: CustomWidget.roundIconBtn(
                                                          function: () async => await provider.fnStoreCart(context, _data.idProduct!),
                                                          icon: Icons.add,
                                                          label: AppLocalizations.instance.text('TXT_CART_ADD'),
                                                          btnColor: CustomColor.MAIN,
                                                          lblColor: Colors.white,
                                                          radius: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Container(
                                height: provider.isPaginateLoad ? 50 : 0,
                                child: Center(
                                  child: provider.isPaginateLoad
                                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(CustomColor.MAIN),)
                                      : SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        );
                    }
                }
            }
          }
      ),
    );

    Widget _mainContent = Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Consumer<WishListProvider>(
            child: Container(),
            builder: (context, provider, skeleton) {
              switch (provider.wishlist.result) {
                case null:
                  return skeleton!;
                default:
                  switch (provider.wishlist.result!.data!.length) {
                    case 0:
                      return skeleton!;
                    default:
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${provider.wishlist.result!.total ?? '0'}'
                              '${AppLocalizations.instance.text('TXT_WISHLIST_TOTAL')}', style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                          CustomWidget.textIconBtn(
                            icon: FontAwesomeIcons.checkCircle,
                            label: provider.isSelection
                                ? AppLocalizations.instance.text('TXT_CANCEL')
                                : AppLocalizations.instance.text('TXT_SELECT'),
                            lblColor: CustomColor.BROWN_LIGHT_TXT,
                            icColor: CustomColor.BROWN_TXT,
                            fontSize: 16,
                            function: () => provider.fnToggleSelection(),
                          ),
                        ],
                      );
                  }
              }
            },
          ),
          SizedBox(height: 5,),
          _productListContent,
        ],
      ),
    );

    Widget _submitBtn = Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      width: MediaQuery.of(context).size.width,
      child: CustomWidget.roundBtn(
        label: AppLocalizations.instance.text('TXT_LBL_REMOVE_WISHLIST'),
        btnColor: CustomColor.MAIN,
        lblColor: Colors.white,
        isBold: true,
        fontSize: 16,
        function: () async => await _provider.fnDeleteMultiWishlist(_provider.scaffoldKey.currentContext!),
      ),
    );

    return Scaffold(
      key: _provider.scaffoldKey,
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_LBL_WISHLIST'), style: TextStyle(
          color: CustomColor.MAIN,
        ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: _mainContent,
      bottomNavigationBar: Consumer<WishListProvider>(
        child: SizedBox(),
        builder: (context, provider, skeleton) {
          switch (provider.isSelection) {
            case true:
              return _submitBtn;
            default:
              return SizedBox();
          }
        },
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
