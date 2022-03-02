import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/screen/product/product_by_category_screen.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/profile/profile_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/screen/widget/sliver_title.dart';
import 'package:flutter/material.dart';
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

class _HomeScreenState extends State<HomeScreen> {

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
          child: Text(AppLocalizations.instance.text('TXT_TITLE_BANNER'), style: TextStyle(
            fontSize: 18,
            color: CustomColor.BROWN_TXT,
            fontWeight: FontWeight.bold,
          ),),
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
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  child: CustomWidget.networkImg(context, i.image),
                                  borderRadius: BorderRadius.circular(20),
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
                            width: provider.currBanner == index ? 12.0 : 8.0,
                            height: provider.currBanner == index ? 12.0 : 8.0,
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
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(AppLocalizations.instance.text('TXT_TITLE_SELECT_CATEGORY'), style: TextStyle(
              fontSize: 18,
              color: CustomColor.BROWN_TXT,
              fontWeight: FontWeight.bold,
            ),),
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
                          onTap: () => Get.toNamed(ProductByCategoryScreen.tag, arguments: ProductByCategoryScreen(
                            category: _data.name!,
                          )),
                          child: Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 50 : 0),
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
                                SizedBox(height: 5,),
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
    );

    Widget _popularContent = Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.instance.text('TXT_TITLE_POPUlAR_PICKED'), style: TextStyle(
                  fontSize: 18,
                  color: CustomColor.BROWN_TXT,
                  fontWeight: FontWeight.bold,
                ),),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(MdiIcons.filterVariant, color: CustomColor.BROWN_TXT,),
                  label: Text('Latest', style: TextStyle(
                    color: CustomColor.BROWN_TXT,
                    fontSize: 16,
                  ),),
                ),
              ],
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
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
                            Flexible(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset('assets/images/wine_bottle.png'),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text('Casa Vinicola Triaca', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColor.BROWN_TXT,
                            ),),
                            SizedBox(height: 5,),
                            Text('IDR 400.000', style: TextStyle(
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
            SizedBox(height: 20,),
            _categoryContent,
            _popularContent,
          ],
        ),
      ),
    );

    Widget _mainContent = CustomScrollView(
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
            GestureDetector(
              onTap: () async => await Get.toNamed(ProfileScreen.tag)!
                  .then((_) async => await _provider.fnFetchUserInfo()),
              child: Consumer<HomeProvider>(
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  margin: EdgeInsets.only(right: 15, left: 5),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                    image: new DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("assets/images/ic_profile.png"),
                    ),
                  ),
                ),
                builder: (context, provider, skeleton) {
                  switch (provider.userModel.user) {
                    case null:
                      return skeleton!;
                    default:
                      switch (provider.userModel.user!.avatar) {
                        case null:
                          return skeleton!;
                        default:
                          return Padding(
                            padding: const EdgeInsets.only(right: 15, left: 5),
                            child: CustomWidget.roundedAvatarImg(url: provider.userModel.user!.avatar!, size: 30),
                          );
                      }
                  }
                },
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
