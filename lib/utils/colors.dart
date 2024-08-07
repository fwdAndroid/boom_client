import 'package:flutter/material.dart';

final colorWhite = Colors.white;
final textformColor = Color(0xffF0F3F6);
final colorBlack = Colors.black;
final mainBtnColor = Color(0xffA52A2A);
final iconColor = Color(0xffC1C0C9);
final tabUnselectedColor = Color(0xffADB3BC);

/// SnakBar Code
showMessageBar(String contexts, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(contexts),
    duration: Duration(seconds: 3),
  ));
}

final secondaryTextColor = Color(0xff4F5E7B);
final dividerColor = Color(0xffEBEBEB);
final borderColor = Color(0xffEBEBEB);
