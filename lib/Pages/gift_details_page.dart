// gift_details_page.dart

import 'package:flutter/material.dart';

class GiftDetailsPage extends StatelessWidget {
  final String giftName;
  final String category;
  final bool isPledged;

  const GiftDetailsPage({
    super.key,
    required this.giftName,
    required this.category,
    required this.isPledged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Gift Name'),
              controller: TextEditingController(text: giftName),
              readOnly: true,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Category'),
              controller: TextEditingController(text: category),
              readOnly: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Description'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status:"),
                Switch(
                  value: isPledged,
                  onChanged: (value) {
                    // TODO: Handle pledged toggle (if editable)
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement image upload
              },
              child: const Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}
