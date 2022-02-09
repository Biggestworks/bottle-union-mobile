import 'package:flutter/material.dart';

class CustomWidget {
  static Widget roundBtn({
    String label = 'title',
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    bool isBold = false,
    required void function(),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: btnColor,
      ),
      onPressed: () => function(),
      child: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: 16,
      ),),
    );
  }

  static Widget roundOutlinedBtn({
    String label = 'title',
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    bool isBold = false,
    required void function(),
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        side: BorderSide(
          color: btnColor,
        ),
      ),
      onPressed: () => function(),
      child: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: 16,
      ),),
    );
  }

  static showSheet(
      {required BuildContext context, required Widget child, bool scroll = false}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: scroll,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0)),
        ),
        builder: (BuildContext bc) {
          return child;
        });
  }

  static Widget roundIconBtn({
    String label = 'title',
    required IconData icon,
    Color btnColor = Colors.white,
    Color lblColor = Colors.black,
    Color icColor = Colors.white,
    bool isBold = false,
    required void function(),
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: btnColor,
      ),
      onPressed: () => function(),
      icon: Icon(icon, color: icColor,),
      label: Text(label, style: TextStyle(
        color: lblColor,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: 16,
      ),),
    );
  }

  static Widget circleIconBtn({
    required IconData icon,
    Color btnColor = Colors.white,
    Color icColor = Colors.white,
    bool isBold = false,
    required void function(),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: btnColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => function(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: icColor, size: 20,),
      ),
    );
  }

  static showSnackBar({
    required BuildContext context,
    required Widget content,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content,));
  }

}