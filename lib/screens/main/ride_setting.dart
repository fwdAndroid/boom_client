import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/screens/widgets/text_form_field.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:flutter/material.dart';

class LocationInfo extends StatefulWidget {
  const LocationInfo({super.key});

  @override
  State<LocationInfo> createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Ride Location",
          style: TextStyle(color: colorWhite),
        ),
        iconTheme: IconThemeData(color: colorWhite),
        backgroundColor: mainBtnColor,
      ),
      body: Column(
        children: [
          TextFormInputField(
              controller: controller,
              hintText: "Add Location",
              textInputType: TextInputType.name),
          TextFormInputField(
              controller: controller2,
              hintText: "Add Date",
              textInputType: TextInputType.datetime),
          TextFormInputField(
              controller: controller1,
              hintText: "Add Time",
              textInputType: TextInputType.datetime),
          SaveButton(
              title: "Add Locations",
              onTap: () {
                showMessageBar("Locations are Added", context);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
