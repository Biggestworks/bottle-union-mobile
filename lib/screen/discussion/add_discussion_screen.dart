import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/provider/discussion/add_discussion_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDiscussionScreen extends StatefulWidget {
  static String tag = '/add-discussion-screen';
  final Data? product;

  const AddDiscussionScreen({Key? key, this.product}) : super(key: key);

  @override
  _AddDiscussionScreenState createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen>
    with TextValidation, LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<AddDiscussionProvider>(context, listen: false).fnGetView(this);
      Provider.of<AddDiscussionProvider>(context, listen: false).fnGetArguments(context);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AddDiscussionProvider>(context, listen: false);

    Widget _mainContent = Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<AddDiscussionProvider>(
              builder: (context, provider, _) {
                var _data = provider.product;
                return Row(
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      child: ClipRRect(
                        child: CustomWidget.networkImg(context, _data?.image1 ?? ''),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_data?.name ?? '-', style: TextStyle(
                          color: Colors.black,
                        ),),
                        SizedBox(height: 5,),
                        Text(FormatterHelper.moneyFormatter(_data?.regularPrice ?? 0), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColor.MAIN_TXT,
                        ),),
                        SizedBox(height: 5,),
                        Text('In stock ${_data?.stock ?? '0'} item(s)', style: TextStyle(
                          color: CustomColor.GREY_TXT,
                        ),),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _provider.questionController,
              validator: validateField,
              maxLength: 150,
              maxLines: null,
              cursorColor: CustomColor.MAIN,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.MAIN,),
                ),
                hintText: "Write your question here",
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              child: CustomWidget.roundBtn(
                label: AppLocalizations.instance.text('TXT_SEND'),
                btnColor: CustomColor.MAIN,
                lblColor: Colors.white,
                isBold: true,
                radius: 8,
                fontSize: 16,
                function: () async => await _provider.fnStoreDiscussion(_provider.scaffoldKey.currentContext!),
              ),
            ),
          ],
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        key: _provider.scaffoldKey,
        backgroundColor: CustomColor.BG,
        appBar: AppBar(
          backgroundColor: CustomColor.MAIN,
          elevation: 0,
          centerTitle: true,
          title: Text('Send Discussion'),
        ),
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
