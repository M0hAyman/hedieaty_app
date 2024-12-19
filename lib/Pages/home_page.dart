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
  List<Friend> _pendingSentRequests = [];
  List<Friend> _pendingReceivedRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final userId = _authService.currentUser?.uid; // Get the current user's ID
      if (userId != null) {
        final friends = await _friendService.getAcceptedFriends(userId);
        final sentRequests = await _friendService.getPendingSentRequests(userId);
        print('requests show: $sentRequests');
        final receivedRequests = await _friendService.getPendingReceivedRequests(userId);
        setState(() {
          _friends = friends;
          _pendingSentRequests = sentRequests;
          _pendingReceivedRequests = receivedRequests;
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

  Future<void> _acceptRequest(Friend request) async {
    try {
      await _friendService.acceptFriendRequest(request);
      _fetchData(); // Refresh data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request accepted!')),
      );
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  Future<void> _rejectRequest(Friend request) async {
    try {
      await _friendService.rejectFriendRequest(request);
      _fetchData(); // Refresh data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request rejected.')),
      );
    } catch (e) {
      print('Error rejecting friend request: $e');
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_friends.isEmpty)
                  const Center(child: Text('No friends found.'))
                else
                  ..._friends.map(
                        (friend) => FriendListItem(
                      name: friend.name,
                      imagePath: 'assets/images/icon-user.png',
                      eventCount: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FriendEventListPage(
                              friendName: friend.name,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const Divider(),
                const Text(
                  'Pending Sent Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_pendingSentRequests.isEmpty)
                  const Center(child: Text('No pending requests sent.'))
                else
                  ..._pendingSentRequests.map(
                        (request) => ListTile(
                      title: Text(request.name),
                      subtitle: const Text('Waiting for approval...'),
                    ),
                  ),
                const Divider(),
                const Text(
                  'Pending Received Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_pendingReceivedRequests.isEmpty)
                  const Center(child: Text('No pending requests received.'))
                else
                  ..._pendingReceivedRequests.map(
                        (request) => ListTile(
                      title: Text(request.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => _acceptRequest(request),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _rejectRequest(request),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const AddFriendButton(),
        ],
      ),
    );
  }
}
