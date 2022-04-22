import 'package:eight_barrels/helper/color_helper.dart';
import 'package:flutter/material.dart';

class ReviewInputScreen extends StatefulWidget {
  static String tag = '/review-input-screen';
  const ReviewInputScreen({Key? key}) : super(key: key);

  @override
  _ReviewInputScreenState createState() => _ReviewInputScreenState();
}

class _ReviewInputScreenState extends State<ReviewInputScreen> {
  @override
  Widget build(BuildContext context) {

    // Widget _mainContent = Container(
    //   padding: EdgeInsets.all(10),
    //   child: Column(
    //     children: [
    //       Card(
    //         child: ,
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Text('Tulis Ulasan'),
      ),
    );
  }
}
