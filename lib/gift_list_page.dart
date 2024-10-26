// gift_list_page.dart

import 'package:flutter/material.dart';
import 'gift_details_page.dart';

class GiftListPage extends StatelessWidget {
  const GiftListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add gift screen
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of gifts
        itemBuilder: (context, index) {
          String giftName = 'Gift $index';
          String category = index % 2 == 0 ? "Electronics" : "Books";
          bool isPledged =
              index % 2 == 0; // Example condition for pledged status

          return ListTile(
            title: Text(giftName),
            subtitle: Text('Category: $category'),
            trailing: Icon(
              Icons.circle,
              color: isPledged
                  ? Colors.green
                  : Colors.grey, // Pledged status color indicator
            ),
            onTap: () {
              // Navigate to GiftDetailsPage and pass data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiftDetailsPage(
                    giftName: giftName,
                    category: category,
                    isPledged: isPledged,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
