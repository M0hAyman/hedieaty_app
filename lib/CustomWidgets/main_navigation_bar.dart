import 'package:flutter/material.dart';
import 'package:hedieaty_app/Pages/event_list_page.dart';
//import 'package:hedieaty_app/Pages/gift_list_page.dart';
import 'package:hedieaty_app/Pages/home_page.dart';
import 'package:hedieaty_app/Pages/pledged_gifts_page.dart';
import 'package:hedieaty_app/Pages/profile_page.dart';

class MainNavigationBar extends StatefulWidget {
  final String userName;
  final String userEmail;

  const MainNavigationBar({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<MainNavigationBar> createState() {
    return _MainNavigationState();
  }
}

class _MainNavigationState extends State<MainNavigationBar> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const EventListPage(),
      const PledgedGiftsPage(),
      ProfilePage(
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pledged Gifts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
      ),
    );
  }
}
