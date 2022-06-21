import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MemberLoyaltyScreen extends StatefulWidget {
  static String tag = '/member-loyalty-screen';
  const MemberLoyaltyScreen({Key? key}) : super(key: key);

  @override
  _MemberLoyaltyScreenState createState() => _MemberLoyaltyScreenState();
}

class _MemberLoyaltyScreenState extends State<MemberLoyaltyScreen> {

  @override
  Widget build(BuildContext context) {

    Widget _mainContent = Container(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                // image: DecorationImage(
                //   image: AssetImage('assets/images/bg_marron_2.png',),
                //   fit: BoxFit.cover,
                // ),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0)
                ),
              ),
            ),
            Container(
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(top: 10),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(MdiIcons.hexagonSlice6, color: Colors.orange, size: 60,),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gold Member', style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),),
                              SizedBox(height: 5,),
                              Text('1,250 pts', style: TextStyle(
                                color: CustomColor.GREY_TXT,
                                fontWeight: FontWeight.bold,
                              ),),
                              SizedBox(height: 5,),
                              LinearProgressIndicator(
                                backgroundColor: CustomColor.GREY_ICON,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                minHeight: 5,
                                value: 0.8,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        // flexibleSpace: Image.asset('assets/images/bg_marron_2.png', fit: BoxFit.cover,),
        elevation: 0,
        centerTitle: true,
        title: Text('Membership'),
      ),
      body: _mainContent,
    );
  }
}
