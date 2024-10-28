import 'package:flutter/material.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Implement sorting functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add event screen
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of events
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Event $index'),
            subtitle: Text(
                'Status: ${index % 3 == 0 ? "Past" : index % 2 == 0 ? "Upcoming" : "Current"}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement edit functionality
              },
            ),
            onTap: () {
              // TODO: Navigate to event details
            },
          );
        },
      ),
    );
  }
}
