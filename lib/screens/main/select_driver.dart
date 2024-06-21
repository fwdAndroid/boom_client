import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class SelectDriver extends StatefulWidget {
  final String fullName;
  final String photoURL;
  final String uid;
  final String destination;
  final String location;

  const SelectDriver({
    super.key,
    required this.fullName,
    required this.photoURL,
    required this.destination,
    required this.location,
    required this.uid,
  });

  @override
  State<SelectDriver> createState() => _SelectDriverState();
}

class _SelectDriverState extends State<SelectDriver> {
  String googleApikey = "YOUR_GOOGLE_API_KEY";
  String location = 'Please move map to A specific location.';
  GoogleMapController? mapController;
  List<Marker> markers = [];
  bool _isLoading = false;
  List<double> latlong = []; // Ensure this list contains doubles

  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(51.1657, 10.4515));
  TextEditingController priceController = TextEditingController();
  var uuid = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    LatLng startLocation = _isLoading || latlong.isEmpty
        ? const LatLng(51.1657, 10.4515)
        : LatLng(latlong[0], latlong[1]);
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("clients").snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var snap = snapshot.data!.docs.first.data();

            return SafeArea(
              child: Stack(
                children: [
                  SizedBox(
                    height: 600,
                    child: GoogleMap(
                      zoomGesturesEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: startLocation,
                        zoom: 14.0, // initial zoom level
                      ),
                      markers: Set<Marker>.of(markers),
                      mapType: MapType.normal,
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                        });
                      },
                      onCameraMove: (CameraPosition cameraPositiona) {
                        cameraPosition = cameraPositiona;
                      },
                      onCameraIdle: () async {
                        List<Placemark> addresses =
                            await placemarkFromCoordinates(
                                cameraPosition.target.latitude,
                                cameraPosition.target.longitude);

                        var first = addresses.first;
                        print("${first.name} : ${first.administrativeArea}");

                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                cameraPosition.target.latitude,
                                cameraPosition.target.longitude);
                        Placemark place = placemarks[0];
                        location =
                            '${place.street},${place.subLocality},${place.locality},${place.thoroughfare},';

                        setState(() {
                          // Update location
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: SizedBox(
                      height: 200,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(""),
                                  Text(
                                    "Edit Price",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Icon(
                                    Icons.close,
                                    color: colorBlack,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: priceController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.rate_review,
                                    color: Color(0xffA52A2A),
                                  ),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: "Edit Price",
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            SaveButton(
                              title: "Send",
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection("book")
                                    .doc(uuid)
                                    .set({
                                  "price": int.parse(priceController.text),
                                  "uuid": uuid,
                                  "driverName": widget.fullName,
                                  "driverPhoto": widget.photoURL,
                                  "currentLocation": widget.location,
                                  "destination": widget.destination,
                                  "driverUid": widget.uid,
                                  "uid": FirebaseAuth.instance.currentUser!.uid,
                                  "name": snap['fullName'],
                                  "photo": snap['photoURL']
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => HomePage()));
                                showMessageBar("Rider Request Send", context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
