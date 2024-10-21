import 'package:flutter/material.dart';
import 'CustomWidgets/friend_list_item.dart';
import 'CustomWidgets/add_friend_button.dart';
import 'CustomWidgets/create_event_button.dart';
import 'CustomWidgets/search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friends & Events',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
