import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/screens/widgets/text_form_field.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverFilter extends StatefulWidget {
  const DriverFilter({super.key});

  @override
  State<DriverFilter> createState() => _DriverFilterState();
}

class _DriverFilterState extends State<DriverFilter> {
  String? petsValue = 'Yes';
  String? AcValue = 'Yes';
  String? l = 'Yes';
  double _currentRating = 3.0; // Initial rating
  TextEditingController passengersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Filters',
          style: TextStyle(color: colorWhite),
        ),
        iconTheme: IconThemeData(color: colorWhite),
        backgroundColor: mainBtnColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 16),
            child: Text(
              "AC Available",
              style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.bold, color: colorBlack),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<String>(
                value: 'Yes',
                groupValue: AcValue,
                onChanged: (String? value) {
                  setState(() {
                    AcValue = value;
                  });
                },
              ),
              Text('Yes'),
              Radio<String>(
                value: 'No',
                groupValue: AcValue,
                onChanged: (String? value) {
                  setState(() {
                    AcValue = value;
                  });
                },
              ),
              Text('No'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 16),
            child: Text(
              "Pets Facility",
              style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.bold, color: colorBlack),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<String>(
                value: 'Yes',
                groupValue: petsValue,
                onChanged: (String? value) {
                  setState(() {
                    petsValue = value;
                  });
                },
              ),
              Text('Yes'),
              Radio<String>(
                value: 'No',
                groupValue: petsValue,
                onChanged: (String? value) {
                  setState(() {
                    petsValue = value;
                  });
                },
              ),
              Text('No'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 16),
            child: Text(
              "Select Driver Rating",
              style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.bold, color: colorBlack),
            ),
          ),
          Slider(
            value: _currentRating,
            min: 1.0,
            max: 5.0,
            divisions: 4, // 4 divisions for 5 stars
            label: _currentRating.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                _currentRating = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Rating: $_currentRating",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 16),
            child: Text(
              "Luggage Available",
              style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.bold, color: colorBlack),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<String>(
                value: 'Yes',
                groupValue: l,
                onChanged: (String? value) {
                  setState(() {
                    l = value;
                  });
                },
              ),
              Text('Yes'),
              Radio<String>(
                value: 'No',
                groupValue: l,
                onChanged: (String? value) {
                  setState(() {
                    l = value;
                  });
                },
              ),
              Text('No'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 16),
            child: Text(
              "Number of Passengers",
              style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.bold, color: colorBlack),
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
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SaveButton(
                  title: "Filter Result",
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
