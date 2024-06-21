import 'package:boom_client/maps/map_functions.dart';
import 'package:boom_client/screens/main/confrim_ride_request.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/screens/widgets/text_form_field.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
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
  TextEditingController priceController = TextEditingController();

  TimeOfDay? _selectedTime;
  bool isAdded = false;
  int _currentHorizontalIntValue = 10;
  String? _selectedValue = 'Yes';
  var uuid = Uuid().v4();

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
                      "Offer Price",
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorBlack),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: TextFormInputField(
                      controller: priceController,
                      hintText: "Price Title",
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
                    maxValue: 100,
                    step: 10,
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
                                if (priceController.text.isEmpty) {
                                  showMessageBar("Price is Required", context);
                                } else if (dateController.text.isEmpty) {
                                  showMessageBar("Date is Required ", context);
                                } else if (timeController.text.isEmpty) {
                                  showMessageBar("Time is Required ", context);
                                } else {
                                  setState(() {
                                    isAdded = true;
                                  });

                                  FirebaseFirestore.instance
                                      .collection("booking")
                                      .doc(uuid)
                                      .set({
                                    "price": int.parse(priceController.text),
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
                                    "offerPrice": 0,
                                    "currentLocation":
                                        widget.currentDestination,
                                    "destination": widget.destination,
                                  });
                                  setState(() {
                                    isAdded = false;
                                  });
                                  // Handle the result accordingly

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
      // Update the text field with the selected date
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
}

//  Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SelectDriver(
//                                         destination: widget.destination,
//                                         location: widget.currentDestination,
//                                         uid: data['uid'],
//                                         photoURL: data['photoURL'],
//                                         fullName: data['fullName'],
//                                       )),
//                             );
