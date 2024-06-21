import 'package:boom_client/screens/booking/tabs/details/offer_detail.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOffers extends StatefulWidget {
  const MyOffers({super.key});

  @override
  State<MyOffers> createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("booking")
                    .where("clientUid",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .where("status", isEqualTo: "offers")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Offer  Available",
                        style: TextStyle(color: colorBlack),
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        final Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Ride Request",
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: colorBlack),
                                    ),
                                  ),
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data['clientPhoto'],
                                      ),
                                    ),
                                    title: Text(data['clientName']),
                                    subtitle: Text(data['clientEmail']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date:",
                                          style: GoogleFonts.interTight(
                                              color: colorBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          data['date'],
                                          style: GoogleFonts.interTight(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Time:",
                                          style: GoogleFonts.interTight(
                                              color: colorBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          data['time'],
                                          style: GoogleFonts.interTight(
                                              color: colorBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Destination:",
                                      style: GoogleFonts.interTight(
                                          color: colorBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data['destination'],
                                      style: GoogleFonts.interTight(
                                          color: colorBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  OffersDetail(
                                                    email: data['clientEmail'],
                                                    clientUid:
                                                        data['clientUid'],
                                                    cureentlocation:
                                                        data['currentLocation'],
                                                    destination:
                                                        data['destination'],
                                                    name: data['clientName'],
                                                    price: data['price']
                                                        .toString(),
                                                    status: data['status'],
                                                    time: data['time'],
                                                    date: data['date'],
                                                    uuid: data['uuid'],
                                                    counterPrice:
                                                        data['offerPrice'],
                                                    photo: data['clientPhoto'],
                                                  )));
                                    },
                                    child: Text(
                                      "View Ride Detail",
                                      style: TextStyle(color: mainBtnColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                })));
  }
}
