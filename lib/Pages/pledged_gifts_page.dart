import 'package:flutter/material.dart';

class PledgedGiftsPage extends StatelessWidget {
  const PledgedGiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pledged Gifts"),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with actual number of pledged gifts
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Pledged Gift $index'),
            subtitle:
                Text('Friend: Friend $index\nDue: 2024-12-31'), // Example date
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement pledge edit functionality
              },
            ),
          );
        },
      ),
    );
  }
}
