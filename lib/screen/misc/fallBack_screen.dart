import 'package:flutter/material.dart';

class FallBackScreen extends StatelessWidget {
  const FallBackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  child: Image.asset('assets/images/ic_logo_bu.png'),
                ),
                SizedBox(height: 20,),
                Text('Jailbreak or Developer Mode is detected. Please turn it off!', textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
