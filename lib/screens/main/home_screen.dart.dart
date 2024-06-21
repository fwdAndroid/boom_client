import 'dart:async';
import 'dart:typed_data';

import 'package:boom_client/maps/map_service.dart';
import 'package:boom_client/screens/main/ride_request.dart';
import 'package:boom_client/screens/profile/edit_profile.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/widgets/customer_logout_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String googleApikey = "AIzaSyBWZFXbVQj9EPhSBeFGneVgrODOgU_hHTg";
  GoogleMapController? mapController;
  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(51.1657, 10.4515));
  bool _isLoading = false;
  List latlong = [];
  String location = 'Please move map to A specific location.';
  final TextEditingController _locationController = TextEditingController();
  BitmapDescriptor? customMarkerIcon;
  final Completer<GoogleMapController> _completer = Completer();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await getUserCurrentLocation().then((value) async {
      print("value.latitude:${value.latitude}");
      markers.add(Marker(
          markerId: MarkerId("2"),
          position: LatLng(value.latitude, value.longitude)));
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14);

      await loadCustomMarkerIcon();
      await getLatLong();
      mapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
          .then((value) {
        print('animated');
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    //  searchController.dispose();
    super.dispose();
  }

  getLatLong() async {
    setState(() {
      _isLoading = true;
    });
    latlong = await getLocation().getLatLong();
    setState(() {
      latlong;
      _isLoading = false;
    });
  }

  Future<void> loadCustomMarkerIcon() async {
    String markerIconPath = 'assets/ic_Pin.png';
    final ByteData byteData = await rootBundle.load(markerIconPath);
    final Uint8List byteList = byteData.buffer.asUint8List();

    setState(() {
      customMarkerIcon = BitmapDescriptor.fromBytes(byteList);
    });
  }

  List<Marker> markers = [];

  void shareInviteLink(BuildContext context) {
    // Replace 'YOUR_INVITE_LINK' with your actual invite link
    final String inviteLink = 'https://yourapp.com/invite?ref=friend123';

    Share.share(
      'Join our app using my invite link: $inviteLink',
      subject: 'Join us on the app!',
    );
  }

  @override
  Widget build(BuildContext context) {
    LatLng startLocation = _isLoading
        ? const LatLng(51.1657, 10.4515)
        : LatLng(latlong[0], latlong[1]);
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: 300,
                height: 270,
                color: Color(0xffA52A2A),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("clients")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return Center(child: Text('No data available'));
                          }
                          var snap = snapshot.data;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(snap['photoURL']),
                                ),
                                Text(
                                  snap['fullName'],
                                  style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              ListTile(
                title: Text("Home"),
                leading: Icon(
                  Icons.home,
                  color: Color(0xffC1C0C9),
                ),
              ),
              ListTile(
                title: Text("Wallet"),
                leading: Icon(
                  Icons.wallet,
                  color: Color(0xffC1C0C9),
                ),
              ),
              ListTile(
                title: Text("History"),
                leading: Icon(
                  Icons.history,
                  color: Color(0xffC1C0C9),
                ),
              ),
              ListTile(
                title: Text("Notifications"),
                leading: Icon(
                  Icons.notifications,
                  color: Color(0xffC1C0C9),
                ),
              ),
              ListTile(
                onTap: () {
                  shareInviteLink(context);
                },
                title: Text("Invite Friends"),
                leading: Icon(
                  Icons.child_friendly_sharp,
                  color: Color(0xffC1C0C9),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => EditProfile()));
                },
                title: Text("Setting"),
                leading: Icon(
                  Icons.settings,
                  color: Color(0xffC1C0C9),
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return CustomerLogoutWidget();
                    },
                  );
                },
                title: Text("Logout"),
                leading: Icon(
                  Icons.logout,
                  color: Color(0xffC1C0C9),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: Colors.white,
          onPressed: () {},
          child: Icon(Icons.location_pin),
        ),
        body: Stack(
          children: [
            SizedBox(
              height: 600,
              child: GoogleMap(
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: startLocation, //initial position
                  zoom: 14.0, //initial zoom level
                ),
                markers: Set<Marker>.of(markers),
                mapType: MapType.normal, //map type
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
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude);

                  var first = addresses.first;
                  print("${first.name} : ${first..administrativeArea}");

                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude);
                  Placemark place = placemarks[0];
                  location =
                      '${place.street},${place.subLocality},${place.locality},${place.thoroughfare},';

                  setState(() {
                    _locationController.text = location;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SaveButton(
                    title: "Apply",
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => RideRequest(
                                    currentLocation: _locationController.text,
                                  )));
                    }),
              ),
            ),
          ],
        ));
  }

  Future<Position> getUserCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    await Geolocator.requestPermission().then((value) async {
      print(
          'getUserCurrentLocation:$value:${await Geolocator.getCurrentPosition()}');
    }).onError((error, stackTrace) {
      print("error" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
}
