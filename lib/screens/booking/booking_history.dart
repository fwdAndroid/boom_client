import 'package:boom_client/screens/booking/tabs/my_offers.dart';
import 'package:boom_client/screens/booking/tabs/completed_request.dart';
import 'package:boom_client/screens/booking/tabs/driver_offers.dart';
import 'package:boom_client/screens/booking/tabs/progress.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Bookings"),
          bottom: TabBar(
            indicatorColor: mainBtnColor,
            labelColor: mainBtnColor,
            labelStyle: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: tabUnselectedColor,
            unselectedLabelStyle: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            tabs: const <Widget>[
              Tab(
                text: "Offers",
              ),
              Tab(
                text: "Request",
              ),
              Tab(
                text: "Progress",
              ),
              Tab(
                text: "Completed",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            MyOffers(),
            DriverOffers(),
            Progress(),
            CompletedRide()
          ],
        ),
      ),
    );
  }

  _showExitDialog(BuildContext context) {
    Future<bool?> _showExitDialog(BuildContext context) {
      return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }
  }
}
