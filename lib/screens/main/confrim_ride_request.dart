import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfrimRideRequest extends StatefulWidget {
  const ConfrimRideRequest({super.key});

  @override
  State<ConfrimRideRequest> createState() => _ConfrimRideRequestState();
}

class _ConfrimRideRequestState extends State<ConfrimRideRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Container()),
          Image.asset("assets/final.png"),
          Text(
            "Congratulations",
            style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Offer send Successfully",
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w200, color: Colors.black),
          ),
          Flexible(child: Container()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => HomePage()));
                },
                child: Text(
                  "Close",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                )),
          )
        ],
      ),
    );
  }
}
