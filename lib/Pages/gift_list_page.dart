// gift_list_page.dart
import 'package:flutter/material.dart';
import 'gift_details_page.dart';

class GiftListPage extends StatelessWidget {
  final String eventName;

  const GiftListPage({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Gifts for $eventName", style: const TextStyle(fontSize: 15)),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual number of gifts for the event
        itemBuilder: (context, index) {
          String giftName = 'Gift $index';
          String category = index % 2 == 0 ? "Electronics" : "Books";
          bool isPledged = index % 2 == 0;

          return ListTile(
            title: Text(giftName),
            subtitle: Text('Category: $category'),
            trailing: Icon(
              Icons.circle,
              color: isPledged ? Colors.green : Colors.grey,
            ),
            onTap: () {
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
