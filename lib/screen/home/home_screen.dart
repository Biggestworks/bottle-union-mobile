import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/screen/home/banner_detail_screen.dart';
import 'package:eight_barrels/screen/product/product_by_category_screen.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/profile/profile_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/screen/widget/sliver_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ProductLog {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      PushNotificationManager().initFCM();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<HomeProvider>(context, listen: false);

    Widget _bannerContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
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
                      items: provider.bannerList.data!.map((i) {
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
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    child: CustomWidget.networkImg(context, i.image,),
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
          },
        ),
      ],
    );

    Widget _categoryContent = Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Material(
            elevation: 4,
            child: Container(
              height: 150,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                  notes: KeyHelper.CLICK_CATEGORY_KEY,
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
                                        width: 120,
                                        height: 140,
                                        child: ClipRRect(
                                          child: CustomWidget.networkImg(context, _data.image),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(_data.name!, style: TextStyle(
                                        fontSize: 16,
                                      ),),
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

    Widget _popularContent = Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(FontAwesomeIcons.star, color: CustomColor.MAIN,),
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
                switch (provider.productList.result) {
                  case null:
                    return skeleton!;
                  default:
                    switch (provider.productList.result?.data?.length) {
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
                                  itemCount: provider.productList.result!.data!.length,
                                  itemBuilder: (context, index) {
                                    var _data = provider.productList.result!.data![index];
                                    switch (_data.stock) {
                                      case 0:
                                        return provider.popularEmptyProductCard(
                                          context: context,
                                          data: _data,
                                          index: index,
                                          storeLog: () async => await fnStoreLog(
                                            productId: [_data.id ?? 0],
                                            categoryId: null,
                                            notes: KeyHelper.CLICK_PRODUCT_KEY,
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
                                                notes: KeyHelper.CLICK_PRODUCT_KEY,
                                              ),
                                              storeCartLog: () async => await fnStoreLog(
                                                productId: [_data.id ?? 0],
                                                categoryId: null,
                                                notes: KeyHelper.SAVE_CART_KEY,
                                              ),
                                              storeWishlistLog: () async => await fnStoreLog(
                                                productId: [_data.id ?? 0],
                                                categoryId: null,
                                                notes: KeyHelper.SAVE_WISHLIST_KEY,
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

    Widget _menuContent = SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          color: CustomColor.BG,
        ),
        child: Column(
          children: [
            _bannerContent,
            SizedBox(height: 60,),
            _categoryContent,
            SizedBox(height: 30,),
            _popularContent,
          ],
        ),
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
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.bell, size: 22,),
                visualDensity: VisualDensity.compact,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 5),
                child: GestureDetector(
                  onTap: () async => await Get.toNamed(ProfileScreen.tag)!
                      .then((_) async => await _provider.fnFetchUserInfo()),
                  child: CustomWidget.roundedAvatarImg(url: _provider.userModel.user?.avatar ?? '', size: 30),
                ),
              ),
            ],
            expandedHeight: 150,
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
                            Text('${AppLocalizations.instance.text('TXT_HALLO_USER')}${provider.userModel.user!.fullname!}', style: TextStyle(
                              fontSize: 12,
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
