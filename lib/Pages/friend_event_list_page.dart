// friend_event_list_page.dart
import 'package:flutter/material.dart';
import 'gift_list_page.dart';

class FriendEventListPage extends StatelessWidget {
  final String friendName;

  const FriendEventListPage({super.key, required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$friendName's Events"),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with actual number of events for the friend
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Event $index for $friendName'),
            subtitle: Text(
                'Status: ${index % 3 == 0 ? "Past" : index % 2 == 0 ? "Upcoming" : "Current"}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GiftListPage(eventName: 'Event $index for $friendName'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
