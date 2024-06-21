import 'package:boom_client/maps/google_map_signin_activity.dart';
import 'package:boom_client/screens/auth/signup_account.dart';
import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:boom_client/services/auth_methods.dart';
import 'package:boom_client/services/google_signin_method.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({super.key});

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController customerPassController = TextEditingController();
  bool isLoading = false;
  bool isGoogle = false;
  //Password
  bool showPassword = false;
  //Password Functions
  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword; // Toggle the showPassword flag
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: customerEmailController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xffADB3BC),
                ),
                filled: true,
                fillColor: Color(0xffF6F7F9),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    borderSide: BorderSide(
                      color: Color(0xffF0F3F6),
                    )),
                border: InputBorder.none,
                hintText: "Email",
                hintStyle: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  color: Color(0xffADB3BC),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: !showPassword,
              controller: customerPassController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      borderSide: BorderSide(
                        color: Color(0xffF0F3F6),
                      )),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xffF6F7F9),
                  hintText: "Password",
                  hintStyle: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    color: Color(0xffADB3BC),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0xffADB3BC),
                  ),
                  suffixIcon: IconButton(
                    onPressed: toggleShowPassword,
                    icon: showPassword
                        ? Icon(
                            Icons.visibility_off,
                            color: Color(0xffADB3BC),
                          )
                        : Icon(
                            Icons.visibility,
                            color: Color(0xffADB3BC),
                          ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SaveButton(
                title: "Sign In",
                onTap: () async {
                  if (customerEmailController.text.isEmpty ||
                      customerPassController.text.isEmpty) {
                    showMessageBar("Email and Password is Required", context);
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    String rse = await AuthMethods().loginUpUser(
                      email: customerEmailController.text.trim(),
                      pass: customerPassController.text.trim(),
                    );

                    setState(() {
                      isLoading = false;
                    });
                    if (rse == 'sucess') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => HomePage()));
                    } else {
                      showMessageBar(rse, context);
                    }
                  }
                }),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => CustomerSignUp()));
              },
              child: Text.rich(TextSpan(
                  text: 'Don’t have an account? ',
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Join Now',
                      style: GoogleFonts.workSans(
                          color: Color(0xffA52A2A),
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    )
                  ])),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          isGoogle
              ? Center(
                  child: CircularProgressIndicator(
                  color: mainBtnColor,
                ))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SocialLoginButton(
                    backgroundColor: Colors.white,
                    borderRadius: 50,
                    buttonType: SocialLoginButtonType.google,
                    onPressed: () async {
                      GoogleSignInMethod()
                          .signInWithGoogle()
                          .then((value) async {
                        setState(() {
                          isGoogle = true;
                        });
                        User? user = FirebaseAuth.instance.currentUser;

                        // Check if user data exists in Firestore
                        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                            await FirebaseFirestore.instance
                                .collection("clients")
                                .doc(user?.uid)
                                .get();

                        // If user data doesn't exist, store it
                        if (!userSnapshot.exists) {
                          // If user is not null and phone number is available, use it. Otherwise, use a default text.
                          String contactNumber =
                              user?.phoneNumber ?? "No Number Available";

                          // Set user data in Firestore
                          await FirebaseFirestore.instance
                              .collection("clients")
                              .doc(user?.uid)
                              .set({
                            "photoURL": user?.photoURL?.toString(),
                            "email": user?.email,
                            "isblocked": false,
                            "location": "No Location Selected",
                            "fullName": user?.displayName,
                            "contactNumber": contactNumber,
                            "uid": user?.uid,
                            "password": "Auto Take Password",
                            "confirmPassword": "Auto Take Password",
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      GoogleMapSignInActivity()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => HomePage()));
                        }

                        setState(() {
                          isGoogle = false;
                        });
                      });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
