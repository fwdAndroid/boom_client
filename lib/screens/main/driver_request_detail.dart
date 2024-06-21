import 'package:boom_client/screens/main/select_driver.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverRequestDetail extends StatefulWidget {
  String destination;
  String currentDestination;
  DriverRequestDetail(
      {super.key, required this.currentDestination, required this.destination});

  @override
  State<DriverRequestDetail> createState() => _DriverRequestDetailState();
}

class _DriverRequestDetailState extends State<DriverRequestDetail> {
  String googleApikey = "AIzaSyBWZFXbVQj9EPhSBeFGneVgrODOgU_hHTg";
  String location = 'Please move map to A specific location.';
  GoogleMapController? mapController;
  List<Marker> markers = [];
  bool _isLoading = false;
  List<double> latlong = []; // Ensure this list contains doubles

  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(51.1657, 10.4515));
  @override
  Widget build(BuildContext context) {
    LatLng startLocation = _isLoading || latlong.isEmpty
        ? const LatLng(51.1657, 10.4515)
        : LatLng(latlong[0], latlong[1]);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.location_pin),
      ),
      body: SafeArea(
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
                  List<Placemark> addresses = await placemarkFromCoordinates(
                      cameraPosition!.target.latitude,
                      cameraPosition!.target.longitude);

                  var first = addresses.first;
                  print("${first.name} : ${first..administrativeArea}");

                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition!.target.latitude,
                      cameraPosition!.target.longitude);
                  Placemark place = placemarks[0];
                  location =
                      '${place.street},${place.subLocality},${place.locality},${place.thoroughfare},';

                  setState(() {
                    //get place name from lat and lang
                    // print(address);
                    // destinationLocationController.text = location;
                  });
                },
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: SizedBox(
                height: 300,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    if (documents.isEmpty) {
                      return Center(
                        child: Text(
                          "No Driver Available",
                          style: TextStyle(
                              color:
                                  Colors.black), // Ensure colorBlack is defined
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;

                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectDriver(
                                        destination: widget.destination,
                                        location: widget.currentDestination,
                                        uid: data['uid'],
                                        photoURL: data['photoURL'],
                                        fullName: data['fullName'],
                                      )),
                            );
                          },
                          hoverColor: Color(0xffA52A2A),
                          selectedColor: Color(0xffA52A2A),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['photoURL']),
                          ),
                          title: Text(
                            data['fullName'],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(data['location']),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "\$56",
                                style: TextStyle(
                                  color: Color(0xffA52A2A),
                                ),
                              ),
                              Text(
                                "5 Min",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
