import 'package:boom_client/screens/auth/auth_login.dart';
import 'package:boom_client/screens/chat/chat_page.dart';
import 'package:boom_client/screens/dashboard/account_info.dart';
import 'package:boom_client/screens/dashboard/notifcation_screen.dart';
import 'package:boom_client/screens/main/ride_setting.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: GoogleFonts.inter(color: mainBtnColor, fontSize: 18),
                  ),
                  Icon(
                    Icons.search,
                    color: mainBtnColor,
                  )
                ],
              ),
            ),
            StreamBuilder<Object>(
                stream: FirebaseFirestore.instance
                    .collection("clients")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No data available'));
                  }
                  var snap = snapshot.data;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snap['photoURL']),
                    ),
                    title: Text(
                      snap['fullName'],
                      style:
                          GoogleFonts.inter(color: mainBtnColor, fontSize: 15),
                    ),
                    subtitle: Text(
                      "Trust your feelings , be a good human beings",
                      style: GoogleFonts.inter(
                          color: secondaryTextColor, fontSize: 12),
                    ),
                  );
                }),
            Divider(
              color: dividerColor,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => AccountInfo()));
              },
              leading: Icon(
                Icons.person,
                color: dividerColor,
              ),
              title: Text(
                "Account",
                style:
                    GoogleFonts.inter(color: secondaryTextColor, fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secondaryTextColor,
              ),
            ),
            Divider(
              color: dividerColor,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => NotificationScreen()));
              },
              leading: Icon(
                Icons.notifications,
                color: dividerColor,
              ),
              title: Text(
                "Notifications",
                style:
                    GoogleFonts.inter(color: secondaryTextColor, fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secondaryTextColor,
              ),
            ),
            Divider(
              color: dividerColor,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => ChatPage()));
              },
              leading: Icon(
                Icons.chat_bubble,
                color: dividerColor,
              ),
              title: Text(
                "Chat",
                style:
                    GoogleFonts.inter(color: secondaryTextColor, fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secondaryTextColor,
              ),
            ),
            Divider(color: dividerColor),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => LocationInfo()));
              },
              leading: Icon(
                Icons.location_pin,
                color: dividerColor,
              ),
              title: Text(
                "Locations",
                style:
                    GoogleFonts.inter(color: secondaryTextColor, fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secondaryTextColor,
              ),
            ),
            Divider(
              color: dividerColor,
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip,
                color: dividerColor,
              ),
              title: Text(
                "Help & Support",
                style:
                    GoogleFonts.inter(color: secondaryTextColor, fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secondaryTextColor,
              ),
            ),
            Divider(
              color: dividerColor,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => AuthLogin()));
              },
              leading: Icon(
                Icons.logout,
                color: dividerColor,
              ),
              title: Text(
                "Logout",
                style:
                    GoogleFonts.inter(color: secondaryTextColor, fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
