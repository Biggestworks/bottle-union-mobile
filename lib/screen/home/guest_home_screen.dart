import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/provider/home/guest_home_provider.dart';
import 'package:eight_barrels/screen/home/banner_detail_screen.dart';
import 'package:eight_barrels/screen/home/notification_screen.dart';
import 'package:eight_barrels/screen/product/product_by_category_screen.dart';
import 'package:eight_barrels/screen/profile/profile_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/screen/widget/sliver_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class GuestHomeScreen extends StatefulWidget {
  static String tag = '/guest-home-screen';

  const GuestHomeScreen({Key? key}) : super(key: key);

  @override
  _GuestHomeScreenState createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen>
    with LoadingView, TextValidation, SingleTickerProviderStateMixin {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<GuestHomeProvider>(context, listen: false).fnGetView(this);
      Provider.of<GuestHomeProvider>(context, listen: false).fnFetchBannerList();
      Provider.of<GuestHomeProvider>(context, listen: false).fnFetchCategoryList();
      Provider.of<GuestHomeProvider>(context, listen: false).fnFetchProductList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<GuestHomeProvider>(context, listen: false);

    _showFilterSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        child: ChangeNotifierProvider.value(
          value : Provider.of<GuestHomeProvider>(context, listen: false),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _provider.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.instance.text('TXT_LBL_FILTER'), style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),),
                              TextButton(
                                onPressed: () async {
                                  Get.back();
                                  await _provider.fnOnResetFilter();
                                },
                                child: Text('Reset Filter', style: TextStyle(
                                  color: CustomColor.MAIN,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Flexible(
                          child: Card(
                            color: CustomColor.GREY_LIGHT_BG,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations.instance.text('TXT_LBL_BRAND'), style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  SizedBox(height: 10,),
                                  Flexible(
                                    child: Consumer<GuestHomeProvider>(
                                        child: Container(),
                                        builder: (context, provider, skeleton) {
                                          switch (provider.brandList.data) {
                                            case null:
                                              return skeleton!;
                                            default:
                                              return GridView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  childAspectRatio: 2,
                                                ),
                                                itemCount: provider.brandList.data!.length,
                                                itemBuilder: (context, index) {
                                                  var _data = provider.brandList.data![index];
                                                  return FilterChip(
                                                    label: Text(_data.name!),
                                                    labelStyle: TextStyle(color: Colors.white),
                                                    backgroundColor: CustomColor.GREY_ICON,
                                                    selectedColor: CustomColor.MAIN,
                                                    selected: provider.selectedBrandIndex == index && provider.isBrandSelected,
                                                    checkmarkColor: Colors.white,
                                                    onSelected: (_) => provider.fnOnSelectBrand(index),
                                                  );
                                                },
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
                        SizedBox(height: 10,),
                        Flexible(
                          child: Card(
                            color: CustomColor.GREY_LIGHT_BG,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations.instance.text('TXT_LBL_CATEGORY'), style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  SizedBox(height: 10,),
                                  Flexible(
                                    child: Consumer<GuestHomeProvider>(
                                      child: Container(),
                                      builder: (context, provider, skeleton) {
                                        switch (provider.categoryList.data) {
                                          case null:
                                            return skeleton!;
                                          default:
                                            return GridView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                childAspectRatio: 2,
                                              ),
                                              itemCount: provider.categoryList.data!.length,
                                              itemBuilder: (context, index) {
                                                var _data = provider.categoryList.data![index];
                                                return FilterChip(
                                                  label: Text(_data.name!),
                                                  labelStyle: TextStyle(color: Colors.white),
                                                  backgroundColor: CustomColor.GREY_ICON,
                                                  selectedColor: CustomColor.MAIN,
                                                  selected: provider.selectedCategoryIndex == index && provider.isCategorySelected,
                                                  checkmarkColor: Colors.white,
                                                  onSelected: (_) => provider.fnOnSelectCategory(index),
                                                );
                                              },
                                            );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Flexible(
                          child: Card(
                            color: CustomColor.GREY_LIGHT_BG,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations.instance.text('TXT_LBL_YEAR'), style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    controller: _provider.yearController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    maxLength: 4,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: validateYear,
                                    decoration: InputDecoration(
                                      counter: Offstage(),
                                      hintText: AppLocalizations.instance.text('TXT_LBL_YEAR'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      isDense: true,
                                      filled: true,
                                      fillColor: CustomColor.GREY_BG,
                                    ),
                                    onChanged: (_) => _provider.fnOnFiltered(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Flexible(
                          child: Card(
                            color: CustomColor.GREY_LIGHT_BG,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations.instance.text('TXT_LBL_PRICE'), style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _provider.minPriceController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            MoneyInputFormatter(
                                              thousandSeparator: ThousandSeparator.Period,
                                              useSymbolPadding: false,
                                              mantissaLength: 0,
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.instance.text('TXT_LBL_MIN_PRICE'),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            isDense: true,
                                            filled: true,
                                            fillColor: CustomColor.GREY_BG,
                                            prefixIcon: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Rp'),
                                              ],
                                            ),
                                          ),
                                          onChanged: (_) => _provider.fnOnFiltered(),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _provider.maxPriceController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            MoneyInputFormatter(
                                              thousandSeparator: ThousandSeparator.Period,
                                              useSymbolPadding: false,
                                              mantissaLength: 0,
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.instance.text('TXT_LBL_MAX_PRICE'),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            isDense: true,
                                            filled: true,
                                            fillColor: CustomColor.GREY_BG,
                                            prefixIcon: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Rp'),
                                              ],
                                            ),
                                          ),
                                          onChanged: (_) => _provider.fnOnFiltered(),
                                        ),
                                      ),
                                    ],
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
              bottomNavigationBar: Consumer<GuestHomeProvider>(
                  child: SizedBox(),
                  builder: (context, provider, skeleton) {
                    switch (provider.isFiltered) {
                      case true:
                        return SafeArea(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            child: CustomWidget.roundBtn(
                              label: 'Submit Filter',
                              btnColor: CustomColor.MAIN,
                              lblColor: Colors.white,
                              function: () async => await provider.fnOnSubmitFilter(),
                            ),
                          ),
                        );
                      default:
                        return skeleton!;
                    }
                  }
              ),
            ),
          ),
        ),
      );
    }

    Widget _bannerContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
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
        Consumer<GuestHomeProvider>(
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
                            height: 180,
                            autoPlay: true,
                            enlargeCenterPage: false,
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              _provider.fnOnBannerChanged(index);
                            },
                          ),
                          items: provider.bannerList.data?.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  width: MediaQuery.of(context).size.width,
                                  child: GestureDetector(
                                    onTap: () => Get.toNamed(BannerDetailScreen.tag, arguments: BannerDetailScreen(
                                      banner: i,
                                    )),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        child: CustomWidget.networkImg(context, i.banner?[0].image, fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 5,),
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
                child: Consumer<GuestHomeProvider>(
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

    Widget _productListContent = Container(
      color: CustomColor.BG,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.instance.text('TXT_HEADER_CATALOG'), style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
                CustomWidget.textIconBtn(
                  icon: MdiIcons.filterVariant,
                  label: 'Sort/Filter',
                  lblColor: CustomColor.BROWN_LIGHT_TXT,
                  icColor: CustomColor.BROWN_TXT,
                  icSize: 22,
                  fontSize: 16,
                  function: () async => await _provider.fnInitFilter()
                      .whenComplete(() => _showFilterSheet()),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    hintText: AppLocalizations.instance.text('TXT_SEARCH_PRODUCT'),
                    isDense: true,
                    filled: true,
                    suffixIcon: Icon(Icons.search, size: 24,),
                    fillColor: CustomColor.GREY_BG,
                  ),
                  cursorColor: CustomColor.MAIN,
                  onChanged: (value) async => await _provider.fnOnSearchProduct(value),
                ),
                SizedBox(height: 10,),
                Consumer<GuestHomeProvider>(
                  child: SizedBox(),
                  builder: (context, provider, skeleton) {
                    switch (provider.filterVal.length) {
                      case 0:
                        return skeleton!;
                      default:
                        return Container(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.filterVal.length,
                            itemBuilder: (context, index) {
                              var _data = provider.filterVal[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Chip(
                                  backgroundColor: CustomColor.BROWN_TXT,
                                  label: Text(_data.value, style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ),
                              );
                            },
                          ),
                        );
                    }
                  },
                ),
                SizedBox(height: 10,),
                Consumer<GuestHomeProvider>(
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
                                  return MediaQuery.removePadding(
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
                                          itemCount: provider.productList.result?.data?.length,
                                          itemBuilder: (context, index) {
                                            var _data = provider.productList.result?.data?[index];
                                            switch (_data?.stock) {
                                              case 0:
                                                return provider.emptyProductCard(
                                                  context: context,
                                                  data: _data!,
                                                  index: index,
                                                  storeLog: () async {},
                                                );
                                              default:
                                                return Consumer<BaseHomeProvider>(
                                                  builder: (context, baseProvider, _) {
                                                    return provider.productCard(
                                                      context: context,
                                                      data: _data!,
                                                      index: index,
                                                      storeClickLog: () async {},
                                                      storeCartLog: () async {},
                                                      storeWishlistLog: () async {},
                                                      onUpdateCart: () async {},
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
                                  );
                              }
                          }
                      }
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget _menuContent = SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
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
            _productListContent,
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
                onPressed: () => Get.toNamed(NotificationScreen.tag),
                icon: Icon(FontAwesomeIcons.bell, size: 20,),
                visualDensity: VisualDensity.compact,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 5),
                child: GestureDetector(
                  onTap: () async => await Get.toNamed(ProfileScreen.tag, arguments: ProfileScreen(isGuest: true,))!
                      .then((_) async => await _provider.onRefresh()),
                  child: CustomWidget.roundedAvatarImg(url: '', size: 25, fit: BoxFit.contain),
                ),
              ),
            ],
            expandedHeight: 80,
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: CustomColor.MAIN,
            title: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(top: 10),
              centerTitle: false,
              title: SliverTitle(
                child: Text('${AppLocalizations.instance.text('TXT_HALLO_USER')}Guest', style: TextStyle(
                  fontSize: 12,
                ),),
                secondChild: SizedBox(),
              ),
              collapseMode: CollapseMode.parallax,
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
