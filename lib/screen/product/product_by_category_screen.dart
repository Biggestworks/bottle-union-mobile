import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/provider/product/product_by_category_provider.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ProductByCategoryScreen extends StatefulWidget {
  static String tag = '/product-by-category-screen';
  final String? category;

  const ProductByCategoryScreen({Key? key, this.category}) : super(key: key);

  @override
  _ProductByCategoryScreenState createState() => _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> with LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ProductByCategoryProvider>(context, listen: false).fnGetArguments(context);
      Provider.of<ProductByCategoryProvider>(context, listen: false).fnGetView(this);
      Provider.of<ProductByCategoryProvider>(context, listen: false).fnFetchProductList();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductByCategoryProvider>(context, listen: false);

    Widget _productListContent = Flexible(
      child: Consumer<ProductByCategoryProvider>(
          child: CustomWidget.showShimmerGridList(),
          builder: (context, provider, skeleton) {
            switch (_isLoad) {
              case true:
                return skeleton!;
              default:
                switch (provider.productList.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.productList.result!.data!.length) {
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
                            physics: BouncingScrollPhysics(),
                            children: [
                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2.0,
                                  childAspectRatio: 0.6,
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.productList.result!.data!.length,
                                itemBuilder: (context, index) {
                                  var _data = provider.productList.result!.data![index];
                                  return CustomWidget.productCard(
                                    context: context,
                                    data: _data,
                                    function: () => Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(product: _data,)),
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
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              hintText: 'Search product...',
              isDense: true,
              filled: true,
              suffixIcon: Icon(Icons.search, size: 24,),
              fillColor: CustomColor.GREY_BG,
            ),
            onChanged: (value) async => await _provider.fnOnSearchProduct(value),
          ),
          _productListContent,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        elevation: 0,
        centerTitle: true,
        title: Text(_provider.category ?? 'Title', style: TextStyle(
          color: CustomColor.MAIN,
        ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
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
