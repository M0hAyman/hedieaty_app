import 'package:flutter/material.dart';

import '../Data/firebase/firebase_auth_service.dart';
import '../Data/firebase/services/friend_firestore_service.dart';


class AddFriendButton extends StatelessWidget {
  const AddFriendButton({super.key});

  Future<void> _addFriend(BuildContext context) async {
    final AuthService authService = AuthService();
    final FriendFirestoreService friendService = FriendFirestoreService();

    final currentUser = authService.currentUser;

    if (currentUser == null) {
      // Show error if the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to add friends.')),
      );
      return;
    }

    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Friend by Phone'),
          content: TextField(
            controller: phoneController,
            decoration: const InputDecoration(hintText: 'Enter friend\'s phone'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final phoneNumber = phoneController.text.trim();

                try {
                  await friendService.sendFriendRequest(
                    fromUserId: currentUser.uid,
                    phoneNumber: phoneNumber,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Friend request sent successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }

                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Send Request'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addFriend(context),
      child: const Icon(Icons.person_add),
    );
  }
}
