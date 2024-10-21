import 'package:flutter/material.dart';

class AddFriendButton extends StatelessWidget {
  const AddFriendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          // Add friend logic here
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Friend by Phone Number'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
