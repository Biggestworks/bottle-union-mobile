import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/product/product_list_provider.dart';
import 'package:flutter/material.dart';
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
      child: Consumer<ProductListProvider>(
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
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: _data.image1!,
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Center(child: Icon(Icons.error, size: 80,),),
                                    ),
                                    // Container(
                                    //   color: Colors.red,
                                    //   width: MediaQuery.of(context).size.width,
                                    //   child: Image.network(_data.image1!),
                                    // ),
                                    SizedBox(height: 20,),
                                    Text(_data.name!, style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.BROWN_TXT,
                                    ),),
                                    SizedBox(height: 5,),
                                    Text(provider.fnMoneyFormatter(_data.regularPrice), style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.MAIN_TXT,
                                    ),),
                                  ],
                                ),
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
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 50,
        backgroundColor: CustomColor.BG,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: 120,
              child: Image.asset('assets/images/ic_logo_text.png',),
            ),
          ),
        ],
      ),
      body: _mainContent,
    );
  }
}
