import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressDetail extends StatefulWidget {
  final uuid;
  final clientUid;
  final status;
  final price;
  final destination;
  final cureentlocation;
  final name;
  final time;
  final date;
  final photo;
  final email;
  final driverId;
  final driverEmail;
  final driverPhoto;
  final driverName;
  final counterPrice;
  ProgressDetail(
      {super.key,
      required this.clientUid,
      required this.cureentlocation,
      required this.destination,
      required this.name,
      required this.time,
      required this.date,
      required this.photo,
      required this.driverEmail,
      required this.driverId,
      required this.driverName,
      required this.driverPhoto,
      required this.email,
      required this.counterPrice,
      required this.price,
      required this.status,
      required this.uuid});

  @override
  State<ProgressDetail> createState() => _ProgressDetailState();
}

class _ProgressDetailState extends State<ProgressDetail> {
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/aa.png",
              fit: BoxFit.cover,
              height: 150,
              width: MediaQuery.of(context).size.width),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(
                  widget.driverName,
                  style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorBlack),
                ),
                subtitle: Text(
                  widget.driverEmail,
                  style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: colorBlack),
                ),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.driverPhoto,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
            child: Text(
              "Destination:",
              style: GoogleFonts.manrope(
                  fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.destination,
              style: GoogleFonts.nunitoSans(
                  fontSize: 14, fontWeight: FontWeight.w500, color: colorBlack),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
            child: Text(
              "Date and Time:",
              style: GoogleFonts.manrope(
                  fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.date,
                  style: GoogleFonts.nunitoSans(
                      color: colorBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.time,
                  style: GoogleFonts.nunitoSans(
                      color: colorBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Offer Price",
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                    Text(
                      widget.price,
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isLoad
              ? Center(
                  child: CircularProgressIndicator(
                    color: mainBtnColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SaveButton(
                        title: "Completed",
                        onTap: () async {
                          setState(() {
                            isLoad = true;
                          });
                          FirebaseFirestore.instance
                              .collection("booking")
                              .doc(widget.uuid)
                              .update({"status": "completed"});

                          setState(() {
                            isLoad = false;
                          });

                          showMessageBar("Job is Done", context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => HomePage()));
                        }),
                  ),
                )
        ],
      ),
    );
  }
}
