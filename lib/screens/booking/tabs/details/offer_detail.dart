import 'package:boom_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OffersDetail extends StatefulWidget {
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
  final counterPrice;
  OffersDetail(
      {super.key,
      required this.clientUid,
      required this.cureentlocation,
      required this.destination,
      required this.name,
      required this.time,
      required this.date,
      required this.photo,
      required this.email,
      required this.counterPrice,
      required this.price,
      required this.status,
      required this.uuid});

  @override
  State<OffersDetail> createState() => _OffersDetailState();
}

class _OffersDetailState extends State<OffersDetail> {
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
                  widget.name,
                  style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorBlack),
                ),
                subtitle: Text(
                  widget.email,
                  style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: colorBlack),
                ),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.photo,
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
        ],
      ),
    );
  }
}
