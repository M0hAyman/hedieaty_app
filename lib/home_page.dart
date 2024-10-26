import 'package:flutter/material.dart';

import 'CustomWidgets/friend_list_item.dart';
import 'CustomWidgets/add_friend_button.dart';
import 'CustomWidgets/create_event_button.dart';
import 'CustomWidgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          const SizedBox(height: 20), // Spacing before the logo
          Image.asset(
            'assets/images/logo.png', // Path to your logo
            height: 100, // Adjust size as needed
            width: 100,
          ),
          const SizedBox(height: 20), // Spacing after the logo
          const CustomSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with the actual number of friends
              itemBuilder: (context, index) {
                return FriendListItem(
                  name: 'Friend $index',
                  profileImageUrl: 'https://via.placeholder.com/150',
                  eventCount: index % 2 == 0 ? 2 : 0, // Example event logic
                );
              },
            ),
          ),
          const AddFriendButton(),
        ],
      ),
    );
  }
}
