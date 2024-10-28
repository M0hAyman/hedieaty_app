import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });
  void _logout(BuildContext context) {
    // Clear user session or token (if any)
    // For example, using SharedPreferences:
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    // Navigate to the login page and clear navigation history
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: userName),
              readOnly: true,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: userEmail),
              readOnly: true,
            ),
            SwitchListTile(
              title: const Text("Enable Notifications"),
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
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _logout(context),
                child: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
