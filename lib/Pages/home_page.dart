import 'package:flutter/material.dart';
import 'package:hedieaty_app/CustomWidgets/add_friend_button.dart';
import 'package:hedieaty_app/CustomWidgets/create_event_button.dart';
import 'package:hedieaty_app/CustomWidgets/friend_list_item.dart';
import 'package:hedieaty_app/CustomWidgets/search_bar.dart';
import 'friend_event_list_page.dart'; // Import the new page

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
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/logo.png',
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 20),
          const CustomSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return FriendListItem(
                  name: 'Friend $index',
                  imagePath: 'assets/images/icon-user.png',
                  eventCount: index % 2 == 0 ? 2 : 0,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FriendEventListPage(friendName: 'Friend $index'),
                      ),
                    );
                  },
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
