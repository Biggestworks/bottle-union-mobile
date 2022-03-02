import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/profile/profile_input_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileInputScreen extends StatefulWidget {
  static String tag = '/profile-input-screen';
  final String? flag;
  final String? data;

  const ProfileInputScreen({Key? key, this.flag, this.data}) : super(key: key);

  @override
  _ProfileInputScreenState createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> with TextValidation {

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ProfileInputProvider>(context, listen: false).fnGetArguments(context);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProfileInputProvider>(context, listen: false);

    Widget _mainContent = Consumer<ProfileInputProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (provider.flag == AppLocalizations.instance.text('TXT_LBL_EMAIL'))
                Card(
                  elevation: 0,
                  color: CustomColor.SECONDARY,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.infoCircle, color: CustomColor.BROWN_TXT,),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Text(AppLocalizations.instance.text('TXT_VERIFY_EMAIL_INFO'), style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ), textAlign: TextAlign.left,),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text(provider.flag ?? '-', style: TextStyle(
                    fontSize: 16,
                    color: CustomColor.GREY_TXT,
                  ),),
                ],
              ),
              SizedBox(height: 5,),
              provider.fnGetTextFormField(),
            ],
          ),
        );
      }
    );

    Widget _submitBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: CustomWidget.roundBtn(
          label: AppLocalizations.instance.text('TXT_SAVE'),
          btnColor: CustomColor.MAIN,
          lblColor: Colors.white,
          isBold: true,
          fontSize: 16,
          function: () async => await _provider.fnUpdateProfile(context),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.BG,
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Consumer<ProfileInputProvider>(
          builder: (context, provider, _) {
            return Text('Change ${provider.flag}');
          }
        ),
      ),
      body: _mainContent,
      bottomNavigationBar: _submitBtn,
    );
  }
}
