import 'package:boom_client/screens/main/confrim_ride_request.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/screens/widgets/text_form_field.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

class DriverRequestDetail extends StatefulWidget {
  String destination;
  String currentDestination;
  DriverRequestDetail(
      {super.key, required this.currentDestination, required this.destination});

  @override
  State<DriverRequestDetail> createState() => _DriverRequestDetailState();
}

class _DriverRequestDetailState extends State<DriverRequestDetail> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController passengersController = TextEditingController();

  TimeOfDay? _selectedTime;
  bool isAdded = false;
  int _currentHorizontalIntValue = 0;
  String? _selectedValue = 'Yes';
  var uuid = Uuid().v4();

  // Base values for the fare calculation
  final double baseFare = 5.0;
  final double timeRate = 0.5; // cost per minute
  final double distanceRate = 1.0; // cost per mile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ride Request',
          style: TextStyle(color: colorWhite),
        ),
        iconTheme: IconThemeData(color: colorWhite),
        backgroundColor: mainBtnColor,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("clients")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              var snap = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                    child: Text(
                      "Select Date",
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: TextFormInputField(
                      onTap: () {
                        _selectDate();
                      },
                      controller: dateController,
                      hintText: "Select Date",
                      textInputType: TextInputType.name,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                    child: Text(
                      "Select Time",
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: TextFormInputField(
                      onTap: () {
                        _selectTime();
                      },
                      controller: timeController,
                      hintText: "Select Ride Time",
                      textInputType: TextInputType.name,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                    child: Text(
                      "Number of Passengers",
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: TextFormInputField(
                      controller: passengersController,
                      hintText: "Number of Passengers",
                      textInputType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                    child: Text(
                      "Number of Pets",
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                  ),
                  NumberPicker(
                    value: _currentHorizontalIntValue,
                    minValue: 0,
                    maxValue: 10,
                    step: 1,
                    itemHeight: 100,
                    axis: Axis.horizontal,
                    onChanged: (value) =>
                        setState(() => _currentHorizontalIntValue = value),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                    child: Text(
                      "Luggage",
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<String>(
                        value: 'Yes',
                        groupValue: _selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                      ),
                      Text('Yes'),
                      Radio<String>(
                        value: 'No',
                        groupValue: _selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  Center(
                      child: isAdded
                          ? Center(
                              child: CircularProgressIndicator(
                                color: mainBtnColor,
                              ),
                            )
                          : SaveButton(
                              title: "Send Request",
                              onTap: () async {
                                if (dateController.text.isEmpty) {
                                  showMessageBar("Date is Required ", context);
                                } else if (timeController.text.isEmpty) {
                                  showMessageBar("Time is Required ", context);
                                } else {
                                  setState(() {
                                    isAdded = true;
                                  });

                                  // Calculate urgency multiplier based on current time and selected time
                                  final currentTime = DateTime.now();
                                  final selectedDate = DateFormat('yyyy-MM-dd')
                                      .parse(dateController.text);
                                  final selectedTime = TimeOfDay(
                                    hour: int.parse(
                                        timeController.text.split(":")[0]),
                                    minute: int.parse(timeController.text
                                        .split(":")[1]
                                        .split(" ")[0]),
                                  );
                                  final bookingDateTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  );
                                  final durationUntilPickup = bookingDateTime
                                      .difference(currentTime)
                                      .inMinutes;
                                  double urgencyMultiplier = 1.0;
                                  if (durationUntilPickup < 60) {
                                    urgencyMultiplier = 2.0;
                                  } else if (durationUntilPickup < 1440) {
                                    urgencyMultiplier = 1.5;
                                  }

                                  // Calculate distance (For example purposes, using a fixed value)
                                  final double distance =
                                      10.0; // Example distance value

                                  // Calculate the price based on the formula
                                  double price = baseFare +
                                      (timeRate * durationUntilPickup) +
                                      (distanceRate * distance);
                                  price += urgencyMultiplier * price;

                                  await FirebaseFirestore.instance
                                      .collection("booking")
                                      .doc(uuid)
                                      .set({
                                    "price": price.toInt(),
                                    "clientUid":
                                        FirebaseAuth.instance.currentUser!.uid,
                                    "clientName": snap['fullName'],
                                    "clientPhoto": snap['photoURL'],
                                    "clientEmail": snap['email'],
                                    "date": dateController.text,
                                    "time": timeController.text,
                                    "pets": _currentHorizontalIntValue,
                                    "lagages": _selectedValue,
                                    "status": "offers",
                                    "isAccepted": false,
                                    "uuid": uuid,
                                    "driverId": "",
                                    "driverPhoto": "",
                                    "driverEmail": "",
                                    "driverName": "",
                                    "passengers": passengersController.text,
                                    "offerPrice": 0,
                                    "currentLocation":
                                        widget.currentDestination,
                                    "destination": widget.destination,
                                  });

                                  setState(() {
                                    isAdded = false;
                                  });

                                  showMessageBar(
                                      "Ride Request Send Successfully",
                                      context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              ConfrimRideRequest()));
                                }
                              }))
                ],
              );
            }),
      ),
    );
  }

  //Functions
  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        timeController.text = pickedTime.format(context);
      });
    }
  }

  void showMessageBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
