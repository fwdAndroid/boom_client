import 'package:boom_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SaveButton extends StatelessWidget {
  String title;
  final void Function()? onTap;

  SaveButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(335, 49),
          backgroundColor: Color(0xffA52A2A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Text(
        title,
        style: GoogleFonts.manrope(
            fontSize: 14, fontWeight: FontWeight.w500, color: colorWhite),
      ),
    );
  }
}

// ignore: must_be_immutable
class OutlineButton extends StatelessWidget {
  String title;
  final void Function()? onTap;

  OutlineButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xffE94057), width: 1),
          fixedSize: Size(46, 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: "Mulish",
            fontWeight: FontWeight.w600,
            color: Color(0xffE94057)),
      ),
    );
  }
}
