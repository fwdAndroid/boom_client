import 'dart:typed_data';

import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/screens/widgets/text_form_field.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:boom_client/utils/imageutils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController customerFullNameContoller = TextEditingController();
  TextEditingController customerPhoneNumberController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Fetch data from Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Update the controllers with the fetched data
    setState(() {
      customerFullNameContoller.text = data['fullName'];
      customerPhoneNumberController.text = data['contactNumber'];
      customerAddressController.text = data['location'].toString();
      imageUrl = data['photoURL'];
    });
  }

  Future<void> selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      _image = ui;
    });
  }

  Future<String> uploadImageToStorage(Uint8List image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
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
            "Edit Profile",
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
                  onTap: () => selectImage(),
                  child: _image != null
                      ? CircleAvatar(
                          radius: 59, backgroundImage: MemoryImage(_image!))
                      : imageUrl != null
                          ? CircleAvatar(
                              radius: 59,
                              backgroundImage: NetworkImage(imageUrl!))
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/Choose Image.png"),
                            ),
                ),
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
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: mainBtnColor,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SaveButton(
                            title: "Confirm",
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              String? downloadUrl;
                              if (_image != null) {
                                downloadUrl =
                                    await uploadImageToStorage(_image!);
                              } else {
                                downloadUrl = imageUrl;
                              }

                              await FirebaseFirestore.instance
                                  .collection("clients")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "fullName":
                                    customerFullNameContoller.text.trim(),
                                "contactNumber":
                                    customerPhoneNumberController.text.trim(),
                                "location":
                                    customerAddressController.text.trim(),
                                "photoURL": downloadUrl
                              });
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => HomePage()));
                            }),
                      ),
              ),
            ],
          ),
        ));
  }
}
