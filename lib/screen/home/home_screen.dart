import 'package:cached_network_image/cached_network_image.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/provider/home/home_provider.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/profile/profile_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/screen/widget/sliver_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

    Widget bannerContent = Column(
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
        CarouselSlider(
          options: CarouselOptions(
            height: 180.0,
            autoPlay: true,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              // _provider.onBannerChanged(index);
            },
          ),
          items: _provider.bannerList.map((i) {
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
                      child: Image.asset(i, fit: BoxFit.fill,),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );

    Widget categoryContent = Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 50 : 0),
                  child: Column(
                    children: [
                      Flexible(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          child: ClipRRect(
                            child: Image.asset('assets/images/wine.jpg', fit: BoxFit.contain,),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('Wine ${index+1}', style: TextStyle(
                        fontSize: 16,
                      ),)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    Widget popularContent = Container(
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

    Widget menuContent = SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
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
            bannerContent,
            SizedBox(height: 20,),
            categoryContent,
            SizedBox(height: 20,),
            popularContent,
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomWidget.roundBtn(
                label: 'Sign Out (tentative button)',
                btnColor: CustomColor.MAIN,
                lblColor: Colors.white,
                function: () async {
                  SharedPreferences _prefs = await SharedPreferences.getInstance();
                  _prefs.setString(KeyHelper.KEY_LOCALE, 'en');
                  AppLocalizations.instance.load(Locale('en'));
                  await UserPreferences().removeUserData();
                  Get.offAndToNamed(StartScreen.tag);
                },
              ),
            ),
          ],
        ),
      ),
    );

    Widget mainContent = CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: [
        SliverAppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.shoppingCart, size: 20,),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.bell, size: 20,),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(ProfileScreen.tag),
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
                  switch (provider.userModel.data) {
                    case null:
                      return skeleton!;
                    default:
                      switch (provider.userModel.data!.avatar) {
                        case null:
                          return skeleton!;
                        default:
                          return Padding(
                            padding: const EdgeInsets.only(right: 15, left: 5),
                            child: CachedNetworkImage(
                              imageUrl: provider.userModel.data!.avatar!,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      )),
                                );
                              },
                            ),
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
              switch (provider.userModel.data) {
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
                          Text('${AppLocalizations.instance.text('TXT_HALLO_USER')}${provider.userModel.data!.fullname!}', style: TextStyle(
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
        menuContent,
      ],
    );

    return Scaffold(
      backgroundColor: CustomColor.MAIN,
      body: mainContent,
    );
  }
}
