import 'package:boom_client/maps/geolocation_service.dart';
import 'package:boom_client/maps/map_functions.dart';
import 'package:boom_client/screens/main/driver_request_detail.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/utils/key_const.dart';
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
  List<TextEditingController> additionalControllers = [];
  String googleApikey = googleMapKey;
  String location = 'Please move map to A specific location.';
  GoogleMapController? mapController;
  List<Marker> markers = [];
  bool _isLoading = false;
  List<double> latlong = []; // Ensure this list contains doubles

  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(51.1657, 10.4515));

  BitmapDescriptor? customMarkerIcon;

  @override
  void initState() {
    super.initState();
    init();
    currentLocationController =
        TextEditingController(text: widget.currentLocation);
    destinationLocationController = TextEditingController();
  }

  @override
  void dispose() {
    currentLocationController.dispose();
    destinationLocationController.dispose();
    for (var controller in additionalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addNewDestinationField() {
    setState(() {
      additionalControllers.add(TextEditingController());
    });
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
        onPressed: () async {
          var currentLocation = await MapFunctions().getUserCurrentLocation();
          var newlatlang =
              LatLng(currentLocation.latitude, currentLocation.longitude);
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: newlatlang, zoom: 17),
            ),
          );
          setState(() {
            markers.clear();
            markers.add(Marker(
              markerId: MarkerId("currentLocation"),
              position: newlatlang,
            ));
          });
        },
        child: Icon(Icons.location_pin),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: 700,
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
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude);

                  var first = addresses.first;
                  print("${first.name} : ${first.administrativeArea}");

                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude);
                  Placemark place = placemarks[0];
                  location =
                      '${place.street},${place.subLocality},${place.locality},${place.thoroughfare},';

                  setState(() {
                    destinationLocationController.text = location;
                    markers.clear();
                    markers.add(Marker(
                      markerId: MarkerId("currentLocation"),
                      position: cameraPosition.target,
                    ));
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
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
                                apiHeaders:
                                    await GoogleApiHeaders().getHeaders(),
                                //from google_api_headers package
                              );
                              String placeid = place.placeId ?? "0";
                              final detail =
                                  await plist.getDetailsByPlaceId(placeid);
                              final geometry = detail.result.geometry!;
                              final lat = geometry.location.lat;
                              final lang = geometry.location.lng;
                              var newlatlang = LatLng(lat, lang);
                              mapController?.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: newlatlang, zoom: 17)));
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
                        for (var controller in additionalControllers)
                          Column(
                            children: [
                              SizedBox(height: 8),
                              TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                  ),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: "Additional Destination",
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: addNewDestinationField,
                        child: Container(
                          margin: EdgeInsets.only(top: 45),
                          child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Icon(Icons.add)),
                        ),
                      ),
                    ),
                  ),
                ],
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
      ),
    );
  }

// Functions
  init() async {
    await MapFunctions().getUserCurrentLocation().then((value) async {
      print("value.latitude:${value.latitude}");
      markers.add(Marker(
          markerId: MarkerId("2"),
          position: LatLng(value.latitude, value.longitude)));
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14);

      await getLatLong();
      mapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
          .then((value) {});
      setState(() {});
    });
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
}
