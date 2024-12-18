import 'package:flutter/material.dart';

import '../Data/firebase/firebase_auth_service.dart';
import '../Data/firebase/services/friend_firestore_service.dart';


class AddFriendButton extends StatelessWidget {
  const AddFriendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () => _showAddFriendDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Friend by Phone Number'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  // Function to show a dialog for adding a friend
  Future<void> _showAddFriendDialog(BuildContext context) async {
    final TextEditingController phoneController = TextEditingController();
    final friendService = FriendFirestoreService();
    final authService = AuthService(); // To get the current user's ID

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              hintText: 'Enter friend\'s phone number',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final phoneNumber = phoneController.text.trim();
                if (phoneNumber.isNotEmpty) {
                  try {
                    // Fetch the friend's user ID by phone number
                    final friend = await friendService.getFriendByPhoneNumber(phoneNumber);
                    if (friend != null) {
                      // Add the friend to the current user's friends list
                      final userId = authService.currentUser!.uid;
                      await friendService.addFriend(
                        userId: userId,
                        friendId: friend['uid']!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${friend['name']} has been added!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Friend not found.')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
