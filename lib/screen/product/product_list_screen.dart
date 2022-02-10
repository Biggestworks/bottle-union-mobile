import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/product/product_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  static String tag = '/product-list-screen';

  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  @override
  Widget build(BuildContext context) {

    Widget _mainContent = Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.instance.text('TXT_HEADER_CELLAR'), style: TextStyle(
            color: CustomColor.BROWN_TXT,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 10,),
          TextFormField(
            // controller: _provider.productFilterController,
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
            // onChanged: (_) async => await _provider.onChangedProductFilter(),
          ),
          SizedBox(height: 20,),
          Consumer<ProductListProvider>(
            child: Container(),
            builder: (context, provider, skeleton) {
              switch (provider.productList.data) {
                case null:
                  return skeleton!;
                default:
                  switch (provider.productList.data!.length) {
                    case 0:
                      return Center(child: Text('empty'),);
                    default:
                      return Flexible(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              var _data = provider.productList.data![index];
                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: _data.image1!,
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Center(child: Icon(Icons.error, size: 80,),),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_data.name!, style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: CustomColor.BROWN_LIGHT_TXT,
                                              fontSize: 16,
                                            ),),
                                            SizedBox(height: 15,),
                                            Text(provider.fnMoneyFormatter(_data.regularPrice), style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: CustomColor.MAIN_TXT,
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                  }
              }
            }
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.BG,
        elevation: 0,
        centerTitle: true,
        // title:SizedBox(
        //   width: 150,
        //   child: Image.asset('assets/images/ic_logo_bu.png',),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 10),
            child: SizedBox(
              width: 150,
              child: Image.asset('assets/images/ic_logo_bu.png',),
            ),
          ),
        ],
      ),
      body: _mainContent,
    );
  }
}
