import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SwitchListTile(
              title: Text("Enable Notifications"),
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
            ),
            const SizedBox(height: 20),
            const Text("Your Events",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // TODO: List user’s events
            const SizedBox(height: 20),
            const Text("Your Gifts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // TODO: List user’s gifts
          ],
        ),
      ),
    );
  }
}
