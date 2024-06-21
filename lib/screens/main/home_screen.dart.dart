import 'dart:async';
import 'package:boom_client/maps/map_functions.dart';
import 'package:boom_client/maps/map_service.dart';
import 'package:boom_client/screens/main/ride_request.dart';
import 'package:boom_client/screens/widgets/my_drawer.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/utils/key_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String googleApikey = googleMapKey;
  GoogleMapController? mapController;
  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(51.1657, 10.4515), zoom: 14);
  bool _isLoading = false;
  List<double> latlong = [];
  String location = 'Please move map to a specific location.';
  final TextEditingController _locationController = TextEditingController();
  BitmapDescriptor? customMarkerIcon;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await MapFunctions().getUserCurrentLocation().then((value) async {
      print("value.latitude:${value.latitude}");
      markers.add(Marker(
          markerId: MarkerId("2"),
          position: LatLng(value.latitude, value.longitude)));
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14);

      await loadCustomMarkerIcon();
      await getLatLong();
      if (mapController != null) {
        mapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
            .then((value) {
          print('animated');
        });
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // searchController.dispose();
    super.dispose();
  }

  Future<void> getLatLong() async {
    setState(() {
      _isLoading = true;
    });
    latlong = await getLocation().getLatLong();
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    LatLng startLocation = _isLoading || latlong.isEmpty
        ? const LatLng(51.1657, 10.4515)
        : LatLng(latlong[0], latlong[1]);
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.white,
        onPressed: () async {
          Position position = await MapFunctions().getUserCurrentLocation();
          mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14),
          ));
        },
        child: Icon(Icons.location_pin),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 600,
            child: GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: cameraPosition, //initial position
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
                print("${first.name} : ${first.administrativeArea}");

                List<Placemark> placemarks = await placemarkFromCoordinates(
                    cameraPosition.target.latitude,
                    cameraPosition.target.longitude);
                Placemark place = placemarks[0];
                location =
                    '${place.street}, ${place.subLocality}, ${place.locality}, ${place.thoroughfare}';

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
                  title: "Search Ride",
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
      ),
    );
  }
}
