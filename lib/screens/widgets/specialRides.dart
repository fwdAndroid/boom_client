import 'package:boom_client/screens/main/driver_request_detail.dart';
import 'package:boom_client/screens/widgets/driver_filter.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialRides extends StatefulWidget {
  const SpecialRides({super.key});

  @override
  State<SpecialRides> createState() => _SpecialRidesState();
}

class _SpecialRidesState extends State<SpecialRides> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Drivers"),
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => DriverFilter()));
                },
                child: Icon(Icons.align_horizontal_center))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("cars").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No  Cars  Available",
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
                                      "Driver Details",
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: colorBlack),
                                    ),
                                  ),
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data['driverPhoto'],
                                      ),
                                    ),
                                    title: Text(data['driverName']),
                                    subtitle: Text(data['driverEmail']),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Text(
                                          data['rate'].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8, right: 8),
                                    child: Text(
                                      "Reviews",
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: colorBlack),
                                    ),
                                  ),
                                  // Display reviews using a ListView.builder
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 70, // Adjust height as needed
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: data['review']
                                              .length, // Use data['review'].length
                                          itemBuilder: (context, reviewIndex) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['review'][
                                                        reviewIndex], // Access individual review
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Car Details",
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: colorBlack),
                                    ),
                                  ),
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data['carPhoto'],
                                      ),
                                    ),
                                    title: Text(data['carName']),
                                    subtitle: Text(data['registerNumber']),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  DriverRequestDetail(
                                                    currentDestination:
                                                        "Fasilabad",
                                                    destination: "Lahore",
                                                  )));
                                    },
                                    child: Text(
                                      "Book Car",
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
