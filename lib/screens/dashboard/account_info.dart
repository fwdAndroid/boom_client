import 'package:boom_client/screens/profile/edit_profile.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/screens/widgets/text_form_field.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  TextEditingController customerFullNameContoller = TextEditingController();
  TextEditingController customerPhoneNumberController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController email = TextEditingController();
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Fetch data from Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('clients')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Update the controllers with the fetched data
    setState(() {
      customerFullNameContoller.text = data['fullName'];
      customerPhoneNumberController.text = data['contactNumber'];
      customerAddressController.text = data['location'].toString();
      imageUrl = data['photoURL'];
      email.text = data['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text(
            "Account Info",
            style: GoogleFonts.workSans(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: mainBtnColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    child: CircleAvatar(
                        radius: 59, backgroundImage: NetworkImage(imageUrl!))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormInputField(
                    controller: customerFullNameContoller,
                    hintText: "Full Name",
                    IconSuffix: Icons.person,
                    textInputType: TextInputType.text),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: TextFormInputField(
                    controller: email,
                    hintText: "Email",
                    IconSuffix: Icons.email,
                    textInputType: TextInputType.text),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: TextFormInputField(
                    controller: customerPhoneNumberController,
                    hintText: "Contact Number",
                    IconSuffix: Icons.contact_page,
                    textInputType: TextInputType.number),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: TextFormInputField(
                  controller: customerAddressController,
                  hintText: "Location",
                  textInputType: TextInputType.text,
                  IconSuffix: Icons.location_pin,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SaveButton(
                      title: "Edit Profile",
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EditProfile()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
