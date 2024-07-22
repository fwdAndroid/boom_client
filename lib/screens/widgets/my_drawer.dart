import 'package:boom_client/screens/booking/booking_history.dart';
import 'package:boom_client/screens/profile/edit_profile.dart';
import 'package:boom_client/screens/widgets/specialRides.dart';
import 'package:boom_client/screens/widgets/wallet_screen.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:boom_client/widgets/customer_logout_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 300,
              height: 270,
              color: Color(0xffA52A2A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("clients")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text('No data available'));
                        }
                        var snap = snapshot.data;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(snap['photoURL']),
                              ),
                              Text(
                                snap['fullName'],
                                style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w600, fontSize: 22),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
            ListTile(
              title: const Text("Home"),
              leading: Icon(
                Icons.home,
                color: iconColor,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => WalletScreen()));
              },
              title: const Text("Wallet"),
              leading: Icon(
                Icons.wallet,
                color: iconColor,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const SpecialRides()));
              },
              title: Text("Drivers"),
              leading: Icon(
                Icons.taxi_alert,
                color: iconColor,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => BookingHistory()));
              },
              title: const Text("History"),
              leading: Icon(
                Icons.history,
                color: iconColor,
              ),
            ),
            ListTile(
              title: const Text("Notifications"),
              leading: Icon(
                Icons.notifications,
                color: iconColor,
              ),
            ),
            ListTile(
              onTap: () {
                shareInviteLink(context);
              },
              title: const Text("Invite Friends"),
              leading: Icon(
                Icons.child_friendly_sharp,
                color: iconColor,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const EditProfile()));
              },
              title: Text("Setting"),
              leading: Icon(
                Icons.settings,
                color: iconColor,
              ),
            ),
            ListTile(
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return CustomerLogoutWidget();
                  },
                );
              },
              title: Text("Logout"),
              leading: Icon(
                Icons.logout,
                color: Color(0xffC1C0C9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void shareInviteLink(BuildContext context) {
    // Replace 'YOUR_INVITE_LINK' with your actual invite link
    final String inviteLink = 'https://yourapp.com/invite?ref=friend123';

    Share.share(
      'Join our app using my invite link: $inviteLink',
      subject: 'Join us on the app!',
    );
  }
}
