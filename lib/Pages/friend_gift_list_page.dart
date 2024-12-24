import 'package:flutter/material.dart';
import 'package:hedieaty_app/Data/firebase/services/gift_firestore_service.dart';

import '../Data/local_database/services/gift_service.dart';

class FriendGiftListPage extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  final String eventId;
  final String eventName;

  const FriendGiftListPage({
    super.key,
    required this.currentUserId,
    required this.friendId,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<FriendGiftListPage> createState() => _FriendGiftListPageState();
}

class _FriendGiftListPageState extends State<FriendGiftListPage> {
  final GiftFirestoreService _giftFirestoreService = GiftFirestoreService();
  final GiftService _giftLocalService = GiftService();
  List<Map<String, dynamic>> _gifts = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendGifts();
  }

  Future<void> _fetchFriendGifts() async {
    try {
      final gifts = await _giftFirestoreService.getGiftsByEvent(widget.friendId, widget.eventId);
      setState(() {
        _gifts = gifts.map((doc) {
          // Fix: Ensure each document's data is safely merged with its ID
          final data = doc.data() as Map<String, dynamic>? ?? {};
          return {
            'GIFT_FIREBASE_ID': doc.id,
            ...data,
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching friend's gifts: $e");
    }
  }

  Future<void> _pledgeGift(String giftId) async {
    try {
      await _giftFirestoreService.pledgeGift(widget.currentUserId,widget.friendId, widget.eventId, giftId);

      // Update the local database
      await _giftLocalService.pledgeGift(giftId,widget.currentUserId);

      // Directly update the local _gifts list
      setState(() {
        final gift = _gifts.firstWhere((g) => g['GIFT_FIREBASE_ID'] == giftId);
        gift['IS_PLEDGED'] = 1; // Update the local gift data
      });

      _fetchFriendGifts(); // Refresh the list after pledging
    } catch (e) {
      print("Error pledging gift: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.eventName} Gifts"),
      ),
      body: _gifts.isEmpty
          ? const Center(child: Text("No gifts added for this event."))
          : ListView.builder(
        itemCount: _gifts.length,
        itemBuilder: (context, index) {
          final gift = _gifts[index];
          return ListTile(
            title: Text(gift['NAME'] ?? 'Unnamed Gift'),
            subtitle: Text('Category: ${gift['CATEGORY'] ?? 'Unknown'}'),
            trailing: IconButton(
              icon: Icon(
                gift['IS_PLEDGED'] == 1 ? Icons.cancel : Icons.star,
                color: gift['IS_PLEDGED'] == 1 ? Colors.red : Colors.blue,
              ),
              onPressed: () {
                if (gift['IS_PLEDGED'] == 1) {
                  // Unpledge functionality (if needed)
                } else {
                  _pledgeGift(gift['GIFT_FIREBASE_ID']);

                }
              },
            ),
          );
        },
      ),
    );
  }
}
