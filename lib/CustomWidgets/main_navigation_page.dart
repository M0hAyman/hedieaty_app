import 'package:flutter/material.dart';
import 'package:hedieaty_app/event_list_page.dart';
import 'package:hedieaty_app/gift_list_page.dart';
import 'package:hedieaty_app/home_page.dart';
import 'package:hedieaty_app/pledged_gifts_page.dart';
import 'package:hedieaty_app/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() {
    return _MainNavigationState();
  }
}

class _MainNavigationState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    EventListPage(),
    GiftListPage(),
    ProfilePage(),
    PledgedGiftsPage(),
  ];

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
            icon: Icon(Icons.card_giftcard),
            label: 'Gifts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pledged Gifts',
          ),
        ],
        unselectedItemColor: Colors.black, // Color for unselected icons
        selectedItemColor: Colors.black, // Color for selected icon
      ),
    );
  }
}
