import 'package:boom_client/maps/geolocation_service.dart';
import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class GoogleMapSignInActivity extends StatefulWidget {
  const GoogleMapSignInActivity({
    super.key,
  });

  @override
  State<GoogleMapSignInActivity> createState() =>
      _GoogleMapSignInActivityState();
}

class _GoogleMapSignInActivityState extends State<GoogleMapSignInActivity> {
  TextEditingController _locationController = TextEditingController();
  String googleApikey = "AIzaSyBWZFXbVQj9EPhSBeFGneVgrODOgU_hHTg";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  bool _isLoading = false;
  bool loading = false;
  List latlong = [];
  String location = 'Please move map to A specific location.';
  var uuid = Uuid().v4();
  @override
  void initState() {
    getLatLong();
    _locationController.text = "Select Activity Location From Map";
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LatLng startLocation = _isLoading
        ? const LatLng(25.276987, 55.296249)
        : LatLng(latlong[0], latlong[1]);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 243, 246),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 6,
        title: const Text(
          "Set Location",
          style: TextStyle(
              fontFamily: "ProximaNova",
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Color(0xff160F29)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SizedBox(
              height: 800,
              child: Stack(
                children: [
                  GoogleMap(
                    //Map widget from google_maps_flutter package
                    zoomGesturesEnabled: true, //enable Zoom in, out on map
                    initialCameraPosition: CameraPosition(
                      //innital position in map
                      target: startLocation, //initial position
                      zoom: 14.0, //initial zoom level
                    ),
                    mapType: MapType.normal, //map type
                    onMapCreated: (controller) {
                      //method called when map is created
                      setState(() {
                        mapController = controller;
                      });
                    },
                    onCameraMove: (CameraPosition cameraPositiona) {
                      cameraPosition = cameraPositiona; //when map is dragging
                    },
                    onCameraIdle: () async {
                      List<Placemark> addresses =
                          await placemarkFromCoordinates(
                              cameraPosition!.target.latitude,
                              cameraPosition!.target.longitude);

                      var first = addresses.first;
                      print("${first.name} : ${first..administrativeArea}");

                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              cameraPosition!.target.latitude,
                              cameraPosition!.target.longitude);
                      Placemark place = placemarks[0];
                      location =
                          '${place.street},${place.subLocality},${place.locality},${place.thoroughfare},';

                      setState(() {
                        //get place name from lat and lang
                        // print(address);
                        _locationController.text = location;
                      });
                    },
                  ),
                  Center(
                    //picker image on google map
                    child: Icon(
                      Icons.location_pin,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 60, left: 20, right: 20),
                      height: 174,
                      width: 343,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 0.1), //(x,y)
                              blurRadius: 0.5,
                            ),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: const Text(
                              "Location",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xff736F7F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xffE5E5EA),
                                  )),
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, right: 10),
                              child: TextField(
                                onTap: () async {
                                  var place = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleApikey,
                                      mode: Mode.overlay,
                                      types: [],
                                      strictbounds: false,
                                      // components: [
                                      //   Component(Component.country, 'ae')
                                      // ],
                                      //google_map_webservice package
                                      onError: (err) {
                                        print(err);
                                      });

                                  if (place != null) {
                                    setState(() {
                                      location = place.description.toString();
                                      _locationController.text = location;
                                    });
                                    final plist = GoogleMapsPlaces(
                                      apiKey: googleApikey,
                                      apiHeaders:
                                          await GoogleApiHeaders().getHeaders(),
                                      //from google_api_headers package
                                    );
                                    String placeid = place.placeId ?? "0";
                                    final detail = await plist
                                        .getDetailsByPlaceId(placeid);
                                    final geometry = detail.result.geometry!;
                                    final lat = geometry.location.lat;
                                    final lang = geometry.location.lng;
                                    var newlatlang = LatLng(lat, lang);
                                    mapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: newlatlang, zoom: 17)));
                                  }
                                },
                                controller: _locationController,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                            color: Color(0xffE5E5EA))),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E5EA),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E5EA),
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.pin_drop_rounded,
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                    hintText:
                                        "52 Rue Des Fleurs 33500 Libourne"),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              )),

                          // Note
                          // There is a Problem in longitude and latitude it using default user location values not
                          //the values we selected by the navigate the map cursoor
                          Container(
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            child: Center(
                              child: loading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : SaveButton(
                                      onTap: () async {
                                        if (_locationController.text.isEmpty) {
                                          showMessageBar(
                                              "Pick the location from map",
                                              context);
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });
                                          FirebaseFirestore.instance
                                              .collection("clients")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "location": _locationController.text
                                          });
                                        }

                                        setState(() {
                                          loading = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    HomePage()));
                                      },
                                      title: 'Set Location',
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // if (_locationController.text.isEmpty) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("All Fields are required")));
  //   } else {

  //   }

  void getLatLong() async {
    setState(() {
      _isLoading = true;
    });
    latlong = await getLocation().getLatLong();
    setState(() {
      latlong;
      _isLoading = false;
    });
  }
}
