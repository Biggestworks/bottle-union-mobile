import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart' as key;
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/screen/home/banner_detail_screen.dart';
import 'package:eight_barrels/screen/home/notification_screen.dart';
import 'package:eight_barrels/screen/product/product_by_category_screen.dart';
import 'package:eight_barrels/screen/product/product_by_region_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/profile/profile_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/screen/widget/sliver_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ProductLog, SingleTickerProviderStateMixin {
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _initialURILinkHandled = false;

  StreamSubscription? _linkSubs;
  // TabController? _tabController;

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      print('Invoked _initURIHandler');
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
      }
    }
  }

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _linkSubs = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        setState(() {
          if (uri?.queryParameters['product_id'] != null) {
            Get.toNamed(ProductDetailScreen.tag, arguments: ProductDetailScreen(id: int.parse(uri?.queryParameters['product_id'] ?? '')));
          }
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      // NetworkConnectionHelper().initConnectivity(subscription: _subscription, context: context);
      Provider.of<HomeProvider>(context, listen: false).fnFetchUserInfo().then((_) {
        Provider.of<HomeProvider>(context, listen: false).fnFetchRegionProductList();
        Provider.of<HomeProvider>(context, listen: false).fnFetchBannerList();
      });
      Provider.of<HomeProvider>(context, listen: false).fnFetchCategoryList();
      Provider.of<HomeProvider>(context, listen: false).fnFetchPopularProductList();
      Provider.of<HomeProvider>(context, listen: false).fnSaveFcmToken();
      Provider.of<HomeProvider>(context, listen: false).fnFetchAddressList();
      PushNotificationManager().initFCM();
      _initURIHandler();
      _incomingLinkHandler();
      // _tabController = new TabController(length: 4, vsync: this);
    });
    super.initState();
  }

  @override
  void dispose() {
    _linkSubs?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<HomeProvider>(context, listen: false);

    Widget _memberCardContent = Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: CustomColor.BG,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: CustomColor.BROWN_LIGHT_3,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(MdiIcons.starCircle, color: Colors.orange, size: 32,),
                        SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status', style: TextStyle(
                              color: CustomColor.BROWN_TXT,
                              // fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),),
                            SizedBox(height: 4,),
                            Text('Gold Member', style: TextStyle(
                              color: CustomColor.MAIN_TXT,
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Bottle Points', style: TextStyle(
                          color: CustomColor.BROWN_TXT,
                          // fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),),
                        SizedBox(height: 4,),
                        Text('1,250 pts', style: TextStyle(
                          color: CustomColor.MAIN_TXT,
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: CustomColor.GREY_ICON,
                  thickness: 1,
                ),
                Flexible(
                  child: Card(
                    color: CustomColor.BG,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(AppLocalizations.instance.text('TXT_DELIVERY_TO'), style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: CustomColor.BROWN_TXT,
                              ),),
                              SizedBox(width: 4,),
                              Icon(Icons.keyboard_arrow_down, size: 16,)
                            ],
                          ),
                          SizedBox(height: 2,),
                          Flexible(
                            child: Consumer<HomeProvider>(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.instance.text('TXT_NO_ADDRESS_INFO'), style: TextStyle(
                                      color: CustomColor.GREY_TXT,
                                      fontSize: 12,
                                    ),),
                                    Flexible(
                                      child: Text(AppLocalizations.instance.text('TXT_ADD_NOW'), style: TextStyle(
                                        color: CustomColor.BROWN_TXT,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),),
                                    ),
                                  ],
                                ),
                                builder: (context, provider, skeleton) {
                                  switch (provider.selectedAddress) {
                                    case null:
                                      return skeleton!;
                                    default:
                                      var _data = provider.selectedAddress;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_data?.receiver ?? '-', style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                          SizedBox(height: 2,),
                                          Flexible(
                                            child: Text(_data?.address ?? '-', style: TextStyle(
                                              color: CustomColor.GREY_TXT,
                                              fontSize: 12,
                                            ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          ),
                                        ],
                                      );
                                  }
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget _bannerContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.text('TXT_TITLE_BANNER'), style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 5,),
              Text(AppLocalizations.instance.text('TXT_SUB_TITLE_BANNER'), style: TextStyle(
                color: CustomColor.GREY_TXT,
              ),),
            ],
          ),
        ),
        Consumer<HomeProvider>(
          child: CustomWidget.showShimmer(
            child: Container(
              height: 200,
              color: Colors.white,
            ),
          ),
          builder: (context, provider, skeleton) {
            switch (provider.bannerList.data) {
              case null:
                return skeleton!;
              default:
                switch (provider.bannerList.data?.length) {
                  case 0:
                    return Container(
                      height: 100,
                      child: Center(
                        child: Text(AppLocalizations.instance.text('TXT_NO_BANNER_INFO'), style: TextStyle(
                          color: CustomColor.GREY_TXT,
                        ),),
                      ),
                    );
                  default:
                    return Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            enlargeCenterPage: false,
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              _provider.onBannerChanged(index);
                            },
                          ),
                          items: provider.bannerList.data?.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: MediaQuery.of(context).size.width,
                                  child: GestureDetector(
                                    onTap: () => Get.toNamed(BannerDetailScreen.tag, arguments: BannerDetailScreen(
                                      banner: i,
                                    )),
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        child: CustomWidget.networkImg(context, i.banner?[0].image,),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: provider.bannerList.data!.map((i) {
                              int index = provider.bannerList.data!.indexOf(i);
                              return Container(
                                width: provider.currBanner == index ? 10.0 : 6.0,
                                height: provider.currBanner == index ? 10.0 : 6.0,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: provider.currBanner == index
                                      ? CustomColor.MAIN
                                      : CustomColor.GREY_TXT,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                }
            }
          },
        ),
      ],
    );

    Widget _categoryContent = Container(
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: Stack(
        children: [
          Material(
            elevation: 4,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_brown.png',),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.instance.text('TXT_TITLE_SELECT_CATEGORY'), style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 5,),
                    Text(AppLocalizations.instance.text('TXT_SUB_TITLE_SELECT_CATEGORY'), style: TextStyle(
                      color: Colors.white,
                    ),),
                  ],
                ),
              ),
              Flexible(
                child: Consumer<HomeProvider>(
                    child: Container(),
                    builder: (context, provider, skeleton) {
                      switch (provider.categoryList.data) {
                        case null:
                          return skeleton!;
                        default:
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: provider.categoryList.data!.length,
                            itemBuilder: (context, index) {
                              var _data = provider.categoryList.data![index];
                              return InkWell(
                                onTap: () async {
                                  await fnStoreLog(
                                    productId: null,
                                    categoryId: _data.id,
                                    notes: key.KeyHelper.CLICK_CATEGORY_KEY,
                                  );
                                  Get.toNamed(ProductByCategoryScreen.tag, arguments: ProductByCategoryScreen(
                                    category: _data.name ?? '',
                                  ));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: index == 0 ? 50 : 0, right: 10),
                                  child: Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        elevation: 0,
                                        child: Container(
                                          width: 100,
                                          height: 120,
                                          child: ClipRRect(
                                            child: CustomWidget.networkImg(context, _data.image),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(_data.name ?? '-'),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                      }
                    }
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget _regionalProductContent = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.instance.text('TXT_TITLE_RECOMMENDED_REGION'), style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
              Flexible(
                child: GestureDetector(
                  onTap: () => Get.toNamed(ProductByRegionScreen.tag, arguments: ProductByRegionScreen(
                    regionId: _provider.userRegionId,
                    region: _provider.userRegion,
                  )),
                  child: Text(AppLocalizations.instance.text('TXT_SEE_ALL'), style: TextStyle(
                    color: CustomColor.MAIN,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Material(
          elevation: 4,
          child: Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [CustomColor.MAIN, CustomColor.MAIN, CustomColor.MAIN_TXT],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Consumer<HomeProvider>(
                  child: Container(),
                  builder: (context, provider, skeleton) {
                    switch (provider.regionProductList.result) {
                      case null:
                        return skeleton!;
                      default:
                        switch (provider.regionProductList.result?.data?.length) {
                          case 0:
                            return Center(
                              child: Text(AppLocalizations.instance.text('TXT_NO_PRODUCT'), style: TextStyle(
                                color: Colors.white,
                              ),),
                            );
                          default:
                            return CustomScrollView(
                              scrollDirection: Axis.horizontal,
                              slivers: [
                                SliverAppBar(
                                  expandedHeight: 100,
                                  floating: false,
                                  pinned: false,
                                  snap: false,
                                  backgroundColor: CustomColor.MAIN,
                                  flexibleSpace: Center(
                                    child: Text(provider.userRegion ?? '-', style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: provider.regionProductList.result?.data?.length,
                                    itemBuilder: (context, index) {
                                      var _data = provider.regionProductList.result?.data?[index];
                                      switch (_data!.stock) {
                                        case 0:
                                          return Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: provider.regionalEmptyProductCard(
                                              context: context,
                                              data: _data,
                                              index: index,
                                              storeLog: () async => await fnStoreLog(
                                                productId: [_data.id ?? 0],
                                                categoryId: null,
                                                notes: key.KeyHelper.CLICK_PRODUCT_KEY,
                                              ),
                                            ),
                                          );
                                        default:
                                          return Consumer<BaseHomeProvider>(
                                              builder: (context, baseProvider, _) {
                                                return Padding(
                                                  padding: EdgeInsets.only(right: 10),
                                                  child: provider.regionalProductCard(
                                                    context: context,
                                                    data: _data,
                                                    index: index,
                                                    storeClickLog: () async => await fnStoreLog(
                                                      productId: [_data.id ?? 0],
                                                      categoryId: null,
                                                      notes: key.KeyHelper.CLICK_PRODUCT_KEY,
                                                    ),
                                                    storeCartLog: () async => await fnStoreLog(
                                                      productId: [_data.id ?? 0],
                                                      categoryId: null,
                                                      notes: key.KeyHelper.SAVE_CART_KEY,
                                                    ),
                                                    storeWishlistLog: () async => await fnStoreLog(
                                                      productId: [_data.id ?? 0],
                                                      categoryId: null,
                                                      notes: key.KeyHelper.SAVE_WISHLIST_KEY,
                                                    ),
                                                    onUpdateCart: () async => await baseProvider.fnGetCartCount(),
                                                  ),
                                                );
                                              }
                                          );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                        }
                    }
                  }
              ),
            ),
          ),
        ),
      ],
    );

    Widget _popularProductContent = Container(
      padding: EdgeInsets.only(top: 20),
      color: CustomColor.BG,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(FontAwesomeIcons.star, color: CustomColor.MAIN, size: 22,),
                    SizedBox(width: 10,),
                    Text(AppLocalizations.instance.text('TXT_TITLE_POPUlAR_PICKED'), style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                ),
                SizedBox(height: 5,),
                Text(AppLocalizations.instance.text('TXT_SUB_TITLE_POPUlAR_PICKED'), style: TextStyle(
                  color: CustomColor.GREY_TXT,
                ),),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Flexible(
            child: Consumer<HomeProvider>(
                child: CustomWidget.showShimmerGridList(),
                builder: (context, provider, skeleton) {
                  switch (provider.popularProductList.result) {
                    case null:
                      return skeleton!;
                    default:
                      switch (provider.popularProductList.result?.data?.length) {
                        case 0:
                          return CustomWidget.emptyScreen(
                            image: 'assets/images/ic_empty_product.png',
                            title: AppLocalizations.instance.text('TXT_NO_PRODUCT'),
                          );
                        default:
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  MasonryGridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 4,
                                    itemCount: provider.popularProductList.result?.data?.length,
                                    itemBuilder: (context, index) {
                                      var _data = provider.popularProductList.result?.data?[index];
                                      switch (_data!.stock) {
                                        case 0:
                                          return provider.popularEmptyProductCard(
                                            context: context,
                                            data: _data,
                                            index: index,
                                            storeLog: () async => await fnStoreLog(
                                              productId: [_data.id ?? 0],
                                              categoryId: null,
                                              notes: key.KeyHelper.CLICK_PRODUCT_KEY,
                                            ),
                                          );
                                        default:
                                          return Consumer<BaseHomeProvider>(
                                            builder: (context, baseProvider, _) {
                                              return provider.popularProductCard(
                                                context: context,
                                                data: _data,
                                                index: index,
                                                storeClickLog: () async => await fnStoreLog(
                                                  productId: [_data.id ?? 0],
                                                  categoryId: null,
                                                  notes: key.KeyHelper.CLICK_PRODUCT_KEY,
                                                ),
                                                storeCartLog: () async => await fnStoreLog(
                                                  productId: [_data.id ?? 0],
                                                  categoryId: null,
                                                  notes: key.KeyHelper.SAVE_CART_KEY,
                                                ),
                                                storeWishlistLog: () async => await fnStoreLog(
                                                  productId: [_data.id ?? 0],
                                                  categoryId: null,
                                                  notes: key.KeyHelper.SAVE_WISHLIST_KEY,
                                                ),
                                                onUpdateCart: () async => await baseProvider.fnGetCartCount(),
                                              );
                                            },
                                          );
                                      }
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
                            ),
                          );
                      }
                  }
                }
            ),
          ),
        ],
      ),
    );

    // Widget _productTabs = SliverAppBar(
    //   floating: false,
    //   pinned: true,
    //   snap: false,
    //   collapsedHeight: 60,
    //   backgroundColor: CustomColor.BG,
    //   flexibleSpace: TabBar(
    //     controller: _tabController,
    //     labelColor: Colors.black,
    //     isScrollable: true,
    //     tabs: [
    //       Tab(
    //         text: 'Paling Populer',
    //       ),
    //       Tab(
    //         text: 'Paling Populer',
    //       ),
    //       Tab(
    //         text: 'Paling Populer',
    //       ),
    //       Tab(
    //         text: 'Paling Populer',
    //       ),
    //     ],
    //   ),
    // );

    Widget _menuContent = SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.only(top: 90, bottom: 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: CustomColor.BG,
            ),
            child: Column(
              children: [
                _bannerContent,
                SizedBox(height: 40,),
                _categoryContent,
                SizedBox(height: 20,),
                _regionalProductContent,
                SizedBox(height: 20,),
                _popularProductContent,
              ],
            ),
          ),
          _memberCardContent,
        ],
      ),
    );

    Widget _mainContent = NotificationListener<ScrollNotification>(
      onNotification: _provider.fnOnNotification,
      child: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () => Get.toNamed(WishListScreen.tag),
                icon: Icon(FontAwesomeIcons.heart, size: 22,),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: () => Get.toNamed(NotificationScreen.tag),
                icon: Icon(FontAwesomeIcons.bell, size: 22,),
                visualDensity: VisualDensity.compact,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 5),
                child: GestureDetector(
                  onTap: () async => await Get.toNamed(ProfileScreen.tag)!
                      .then((_) async => await _provider.onRefresh()),
                  child: CustomWidget.roundedAvatarImg(url: _provider.userModel.user?.avatar ?? '', size: 30),
                ),
              ),
            ],
            expandedHeight: 80,
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: CustomColor.MAIN,
            title: Consumer<HomeProvider>(
              child: Container(),
              builder: (context, provider, skeleton) {
                switch (provider.userModel.user) {
                  case null:
                    return skeleton!;
                  default:
                    return FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(top: 15),
                      centerTitle: false,
                      title: SliverTitle(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${AppLocalizations.instance.text('TXT_HALLO_USER')}${provider.userModel.user?.fullname ?? '-'}', style: TextStyle(
                              fontSize: 10,
                            ),),
                            Text('Gold Member', style: TextStyle(
                              fontSize: 10,
                              color: Colors.amber,
                            ),),
                          ],
                        ),
                        secondChild: SizedBox(),
                      ),
                      collapseMode: CollapseMode.parallax,
                    );
                }
              },
            ),
          ),
          _menuContent,
          // _productTabs,
          // _popularProductContent,
        ],
      ),
    );

    return RefreshIndicator(
      onRefresh: () async => await _provider.onRefresh(),
      child: Scaffold(
        backgroundColor: CustomColor.MAIN,
        body: _mainContent,
      ),
    );
  }
}
