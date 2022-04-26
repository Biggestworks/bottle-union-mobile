import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  static String tag = '/contact-us-screen';
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Text(AppLocalizations.instance.text('TXT_LBL_CONTACT_US')),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Image.asset('assets/images/ic_logo_bu.png'),
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Icon(Icons.email, color: CustomColor.MAIN,),
                  SizedBox(width: 10,),
                  Text('the8barrels@gmail.com'),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Icon(Icons.phone, color: CustomColor.MAIN,),
                  SizedBox(width: 10,),
                  Text('+62 (21) 22558223'),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Icon(Icons.location_on, color: CustomColor.MAIN,),
                  SizedBox(width: 10,),
                  Text('Pergudangan Miami\nJl. Kayu Besar III Blok M1/3\nTegal Alur, Kalideres Jakarta Barat - 11820'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
