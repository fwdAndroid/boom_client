import 'package:boom_client/screens/booking/booking_history.dart';
import 'package:boom_client/screens/chat/chat_page.dart';
import 'package:boom_client/screens/dashboard/account_page.dart';
import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    BookingHistory(),
    ChatPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(color: Color(0xffF4721E)),
        backgroundColor: mainBtnColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Color(0xffF4721E) : textformColor,
            ),
            label: 'Home',
            backgroundColor: mainBtnColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.taxi_alert,
              color: _currentIndex == 1 ? Color(0xffF4721E) : textformColor,
            ),
            label: 'Rides',
            backgroundColor: mainBtnColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_rounded,
              color: _currentIndex == 2 ? Color(0xffF4721E) : textformColor,
            ),
            label: 'Chat',
            backgroundColor: mainBtnColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3 ? Color(0xffF4721E) : textformColor,
            ),
            label: 'Account',
            backgroundColor: mainBtnColor,
          ),
        ],
      ),
    );
  }
}
