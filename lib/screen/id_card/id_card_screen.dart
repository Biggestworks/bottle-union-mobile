import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class IdCardScreen extends StatefulWidget {
  const IdCardScreen({Key? key}) : super(key: key);

  static String tag = '/id-card';

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {
  Future<void> selectImage() async {
    final ImagePicker _picker = ImagePicker();

    final image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      setState(() {
        file = image;
      });
    }
  }

  PickedFile? file;

  Future<void> _uploadData() async {
    try {
      setState(() {
        loading = true;
      });
      var request = new http.MultipartRequest(
          "POST", Uri.parse(URLHelper.updateIdCardUrl));

      request.headers.addAll(await _headersAuth());
      request.files.add(
        http.MultipartFile.fromBytes('image', await file!.readAsBytes(),
            filename: DateTime.now().toString() + '.jpg',
            contentType: MediaType('image', 'jpg')),
      );
      final response = await request.send();
      final data = jsonDecode(await response.stream.bytesToString());
      log(data.toString());
      log(URLHelper.updateIdCardUrl);
      if (response.statusCode == 200 && data['status']) {
        Get.offAndToNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload Failed')));
      }
    } catch (e) {
      log(e.toString());

      /// logic error here
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  bool loading = false;

  Future<Map<String, String>> _headersAuth() async {
    final _userPreferences = UserPreferences();
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        title: Text('One Step Again'),
      ),
      bottomSheet: Ink(
        color: file == null
            ? Colors.grey
            : loading
                ? Colors.grey
                : CustomColor.MAIN,
        height: 50 + MediaQuery.of(context).padding.bottom,
        width: double.infinity,
        child: InkWell(
          onTap: file == null
              ? null
              : loading
                  ? null
                  : _uploadData,
          child: Center(
              child: Text(
            'Upload Data',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '*Please upload your id card for identity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Upload ID Card',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all()),
              child: InkWell(
                onTap: selectImage,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      file != null ? 'Edit selected' : 'Select your ID Card',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Flexible(
                    child: Text(
                  'Saya menyatakan bahwa ini adalah Id Asli',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                ))
              ],
            ),
            SizedBox(
              height: 12,
            ),
            if (file != null)
              Container(
                height: 80,
                width: 80,
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  File(file!.path),
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
