import 'dart:typed_data';

import 'package:boom_client/maps/map_screen.dart';
import 'package:boom_client/screens/auth/auth_login.dart';
import 'package:boom_client/screens/dashboard/main_dashboard.dart';
import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/screens/widgets/text_form_field.dart';
import 'package:boom_client/services/auth_methods.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:boom_client/utils/imageutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CustomerSignUp extends StatefulWidget {
  const CustomerSignUp({super.key});

  @override
  State<CustomerSignUp> createState() => SignUpAccount();
}

class SignUpAccount extends State<CustomerSignUp> {
  TextEditingController providerEmailController = TextEditingController();
  TextEditingController providerFullNameContoller = TextEditingController();
  TextEditingController providerPassController = TextEditingController();
  TextEditingController providerConfrimPassController = TextEditingController();
  TextEditingController providerContactController = TextEditingController();
  TextEditingController providerLocation = TextEditingController();

  //Password Check
  bool passwordVisible = false;
  bool passwordVisibleConfrim = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    passwordVisibleConfrim = true;
  }

  String? selectedLocation; // New variable to hold the selected description
  void setSelectedDescription(String description) {
    setState(() {
      selectedLocation = description;
      providerLocation.text =
          description; // Optionally set the text field value
    });
  }

  //loader
  bool isLoading = false;

  //Image
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => selectImage(),
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 59, backgroundImage: MemoryImage(_image!))
                        : CircleAvatar(
                            radius: 59,
                            backgroundImage: AssetImage('assets/person.png'),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 70,
                        child: IconButton(
                            onPressed: () => selectImage(),
                            icon: Icon(
                              Icons.add_a_photo,
                              color: colorBlack,
                            )))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Hello User",
                  style: GoogleFonts.workSans(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Create your account for \n better Experience",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.workSans(
                      color: textformColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormInputField(
                    controller: providerFullNameContoller,
                    hintText: "Full Name",
                    IconSuffix: Icons.person,
                    textInputType: TextInputType.text),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: TextFormInputField(
                    controller: providerContactController,
                    hintText: "Contact Number",
                    IconSuffix: Icons.contact_page,
                    textInputType: TextInputType.number),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: TextFormInputField(
                    controller: providerEmailController,
                    hintText: "Email Address",
                    IconSuffix: Icons.email,
                    textInputType: TextInputType.emailAddress),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: TextFormField(
                    obscureText: passwordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      fillColor: Color(0xffF6F7F9),
                      filled: true,
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 16),
                      hintText: "New Password",
                    ),
                    controller: providerPassController,
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, top: 8, bottom: 8),
                  child: TextFormField(
                    obscureText: passwordVisibleConfrim,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisibleConfrim
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisibleConfrim = !passwordVisibleConfrim;
                            },
                          );
                        },
                      ),
                      fillColor: Color(0xffF6F7F9),
                      filled: true,
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 16),
                      hintText: "Confirm Password",
                    ),
                    controller: providerConfrimPassController,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: TextFormInputField(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => MapScreenActivity(
                                  onAddDescription: setSelectedDescription)));
                    },
                    controller: providerLocation,
                    hintText: "Location",
                    IconSuffix: Icons.location_pin,
                    textInputType: TextInputType.text),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: mainBtnColor,
                        ),
                      )
                    : SaveButton(
                        title: "SIGNUP",
                        onTap: () async {
                          if (_image == null) {
                            showMessageBar("Photo is Required", context);
                          } else if (providerEmailController.text.isEmpty) {
                            showMessageBar("Email is Required", context);
                          } else if (providerLocation.text.isEmpty) {
                            showMessageBar("Location is Required", context);
                          } else if (providerContactController.text.isEmpty) {
                            showMessageBar(
                                "Contact Number is Required ", context);
                          } else if (providerPassController.text.isEmpty) {
                            showMessageBar(
                                "Password is Required is Required", context);
                          } else if (providerConfrimPassController
                              .text.isEmpty) {
                            showMessageBar(
                                "Confrim Password is Required", context);
                          } else if (providerPassController.text !=
                              providerConfrimPassController.text) {
                            showMessageBar("Passwords do not match", context);
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            String res = await AuthMethods().signUpUser(
                                isblocked: false,
                                email: providerEmailController.text.trim(),
                                pass: providerPassController.text.trim(),
                                confrimPass:
                                    providerConfrimPassController.text.trim(),
                                username: providerFullNameContoller.text.trim(),
                                contact: providerContactController.text.trim(),
                                providerLocation: providerLocation.text.trim(),
                                file: _image!);
                            setState(() {
                              isLoading = false;
                            });
                            if (res != 'sucess') {
                              showMessageBar(res, context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => MainDashboard()));
                            }
                          }
                        }),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => AuthLogin()));
                },
                child: Text.rich(TextSpan(
                    text: 'Already have an account? ',
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Sign In',
                        style: GoogleFonts.workSans(
                            color: mainBtnColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Fucctions
  /// Select Image From Gallery
  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      _image = ui;
    });
  }
}
