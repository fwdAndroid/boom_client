import 'package:boom_client/screens/main/driver_request_detail.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';

class RideRequest extends StatefulWidget {
  String currentLocation;
  RideRequest({super.key, required this.currentLocation});

  @override
  State<RideRequest> createState() => _RideRequestState();
}

class _RideRequestState extends State<RideRequest> {
  late TextEditingController currentLocationController;
  late TextEditingController destinationLocationController;
  String googleApikey = "AIzaSyBWZFXbVQj9EPhSBeFGneVgrODOgU_hHTg";
  String location = 'Please move map to A specific location.';
  GoogleMapController? mapController;
  List<Marker> markers = [];
  bool _isLoading = false;
  List<double> latlong = []; // Ensure this list contains doubles

  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(51.1657, 10.4515));

  @override
  void initState() {
    super.initState();
    currentLocationController =
        TextEditingController(text: widget.currentLocation);
    destinationLocationController = TextEditingController();
    print(widget.currentLocation);
  }

  @override
  void dispose() {
    currentLocationController.dispose();
    destinationLocationController.dispose();
    super.dispose();
  }

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
      body: Stack(
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
                  destinationLocationController.text = location;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: currentLocationController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: "Pick Up Point",
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
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
                        destinationLocationController.text = location;
                      });
                      final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 17)));
                    }
                  },
                  controller: destinationLocationController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: "Destination",
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/ic_Pin.png",
              height: 60,
              width: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SaveButton(
                title: "Search",
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => DriverRequestDetail(
                        destination: destinationLocationController.text,
                        currentDestination: currentLocationController.text,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
