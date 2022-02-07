import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await UserPreferences().removeUserData();
            Get.offAndToNamed(StartScreen.tag);
          },
          child: Text('test'),
        ),
      ),
    );
  }
}
