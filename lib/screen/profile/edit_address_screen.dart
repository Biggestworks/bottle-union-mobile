import 'package:flutter/material.dart';

class EditAddressScreen extends StatefulWidget {
  static String tag = '/address-screen';
  const EditAddressScreen({Key? key}) : super(key: key);

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  @override
  Widget build(BuildContext context) {

    // Widget _mainContent = Padding(
    //   padding: EdgeInsets.all(15),
    //   child: Consumer<EditAddressProviders>(
    //     builder: (context, provider, _) {
    //       return Column(
    //         children: [
    //           TextFormField(
    //             controller: _provider.addressFilterController,
    //             decoration: InputDecoration(
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //                 borderSide: BorderSide.none,
    //               ),
    //               hintText: 'Search address...',
    //               isDense: true,
    //               filled: true,
    //               prefixIcon: Icon(Icons.search),
    //               fillColor: customColor.greyBg,
    //             ),
    //             onChanged: (text) async => await provider.onChangedAddressFilter(),
    //           ),
    //           SizedBox(height: 10,),
    //           Flexible(
    //             child: Consumer<EditAddressProviders>(
    //               child: Container(
    //                 child: Text('No address selected', style: TextStyle(
    //                   color: customColor.greyText,
    //                 ),),
    //               ),
    //               builder: (context, provider, skeleton) {
    //                 switch (provider.addressList) {
    //                   case (null):
    //                     return skeleton;
    //                     break;
    //                   default:
    //                     switch (provider.addressList?.length) {
    //                       case (0):
    //                         return skeleton;
    //                         break;
    //                       default:
    //                         return ListView.builder(
    //                           physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    //                           itemCount: provider.addressList?.length,
    //                           itemBuilder: (context, index) {
    //                             var data = provider.addressList[index];
    //                             return Card(
    //                               elevation: 4,
    //                               shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadiusDirectional.circular(10),
    //                               ),
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(10),
    //                                 child: Column(
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children: [
    //                                     if (data.main == true) Container(
    //                                       decoration: BoxDecoration(
    //                                         color: Colors.blue,
    //                                         borderRadius: BorderRadius.all(Radius.circular(5)),
    //                                       ),
    //                                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    //                                       child: Text('Main', style: TextStyle(
    //                                         fontSize: 14,
    //                                         fontWeight: FontWeight.bold,
    //                                         color: Colors.white,
    //                                       ),),
    //                                     ),
    //                                     SizedBox(height: 4,),
    //                                     Text(provider.name ?? '', style: TextStyle(
    //                                       fontSize: 18,
    //                                     ),),
    //                                     SizedBox(height: 4,),
    //                                     Text(provider.phone ?? '', style: TextStyle(
    //                                       fontSize: 16,
    //                                     ),),
    //                                     SizedBox(height: 4,),
    //                                     Text(data.address, style: TextStyle(
    //                                       fontSize: 16,
    //                                       color: customColor.greyText,
    //                                     ),),
    //                                     SizedBox(height: 10,),
    //                                     Row(
    //                                       children: [
    //                                         Expanded(
    //                                           child: OutlinedButton(
    //                                             style: OutlinedButton.styleFrom(
    //                                               primary: Colors.white,
    //                                               side: BorderSide(
    //                                                 color: customColor.greyText,
    //                                               ),
    //                                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                                               shape: RoundedRectangleBorder(
    //                                                 borderRadius: BorderRadius.all(Radius.circular(10)
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                             onPressed: () {
    //                                               provider.showChangeAddressMap(
    //                                                   context: scaffoldKey.currentContext,
    //                                                   index: index
    //                                               );
    //                                             },
    //                                             child: Text('Change Address', style: TextStyle(
    //                                               color: customColor.greyText,
    //                                               fontWeight: FontWeight.bold,
    //                                             ),),
    //                                           ),
    //                                         ),
    //                                         SizedBox(width: 10,),
    //                                         OutlinedButton(
    //                                           style: OutlinedButton.styleFrom(
    //                                             primary: Colors.white,
    //                                             side: BorderSide(
    //                                               color: customColor.greyText,
    //                                             ),
    //                                             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                                             shape: RoundedRectangleBorder(
    //                                               borderRadius: BorderRadius.all(Radius.circular(10)
    //                                               ),
    //                                             ),
    //                                           ),
    //                                           onPressed: () {
    //                                             ReusableWidget.showSheet2(
    //                                               context: context,
    //                                               scroll: true,
    //                                               child: ChangeNotifierProvider.value(
    //                                                 value : Provider.of<EditAddressProviders>(context, listen: false),
    //                                                 child: Container(
    //                                                   height: data.main ? 180 : 250,
    //                                                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //                                                   child: Column(
    //                                                     crossAxisAlignment: CrossAxisAlignment.start,
    //                                                     children: [
    //                                                       Row(
    //                                                         children: [
    //                                                           IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
    //                                                             Get.back();
    //                                                           }, iconSize: 30,),
    //                                                           Text('Other options', style: TextStyle(
    //                                                             color: Colors.black,
    //                                                             fontSize: 18,
    //                                                             fontWeight: FontWeight.bold,
    //                                                           ),),
    //                                                         ],
    //                                                       ),
    //                                                       SizedBox(height: 10,),
    //                                                       if (data?.main == false) Column(
    //                                                         crossAxisAlignment: CrossAxisAlignment.start,
    //                                                         children: [
    //                                                           TextButton(
    //                                                             onPressed: () {
    //                                                               Get.back();
    //                                                               provider.updateAddressMain(context: scaffoldKey.currentContext, id: data?.id?.toString());
    //                                                             },
    //                                                             child: Text("Choose as main address", style: TextStyle(
    //                                                               color: Colors.black,
    //                                                               fontSize: 16,
    //                                                               fontWeight: FontWeight.bold,
    //                                                             ),),
    //                                                           ),
    //                                                           Divider(height: 10, indent: 5, endIndent: 5, color: Colors.black,),
    //                                                         ],
    //                                                       ),
    //                                                       TextButton(
    //                                                         onPressed: () {
    //                                                           Get.back();
    //                                                           provider.deleteAddress(scaffoldKey.currentContext, data?.id);
    //                                                         },
    //                                                         child: Text("Delete address", style: TextStyle(
    //                                                           color: customColor.redButtonColor,
    //                                                           fontSize: 16,
    //                                                           fontWeight: FontWeight.bold,
    //                                                         ),),
    //                                                       ),
    //                                                     ],
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             );
    //                                           },
    //                                           child: Icon(Icons.more_horiz, color: customColor.greyText,),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             );
    //                           },
    //                         );
    //                         break;
    //                     }
    //                     break;
    //                 }
    //               },
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    // );

    return Scaffold();
  }
}
