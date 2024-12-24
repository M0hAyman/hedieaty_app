import 'package:flutter/material.dart';
import 'package:hedieaty_app/CustomWidgets/add_friend_button.dart';
import 'package:hedieaty_app/CustomWidgets/create_event_button.dart';
import 'package:hedieaty_app/CustomWidgets/friend_list_item.dart';
import 'package:hedieaty_app/CustomWidgets/search_bar.dart';

import '../Data/firebase/firebase_auth_service.dart';
import '../Data/firebase/services/friend_firestore_service.dart';
import '../Models/friend_model.dart';
import 'friend_event_list_page.dart'; // Import the new page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FriendFirestoreService _friendService = FriendFirestoreService();
  final AuthService _authService = AuthService();

  List<Friend> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        final friends = await _friendService.getAcceptedFriends(userId);
        setState(() {
          _friends = friends;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Friends & Events'),
        actions: const [
          CreateEventButton(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/logo.png',
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 20),
          const CustomSearchBar(),
          _isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
            child: ListView(
              children: [
                const Text(
                  'Accepted Friends',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_friends.isEmpty)
                  const Center(child: Text('No friends found.'))
                else
                  ..._friends.map(
                        (friend) {
                      final friendName = friend.fromId ==
                          _authService.currentUser?.uid
                          ? friend.toName
                          : friend.fromName;
                      return FriendListItem(
                        name: friendName,
                        imagePath: 'assets/images/icon-user.png',
                        eventCount: 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendEventListPage(
                                currentUserId: _authService.currentUser!.uid,
                                friendName: friendName,
                                friendId: friend.fromId == _authService.currentUser?.uid
                                    ? friend.toId
                                    : friend.fromId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
          AddFriendButton(onFriendAdded: _fetchData), // Pass the callback here
        ],
      ),
    );
  }
}
