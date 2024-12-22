// gift_list_page.dart
import 'package:flutter/material.dart';
import 'package:hedieaty_app/Data/firebase/services/gift_firestore_service.dart';
import '../Data/local_database/services/gift_service.dart';
import 'AddEditGiftPage.dart';

class GiftListPage extends StatefulWidget {
  final int eventId;
  final String? firebaseEventId;
  final String userId; // Current logged-in user ID

  const GiftListPage({super.key, required this.eventId, this.firebaseEventId ,required this.userId});

  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftService _giftService = GiftService();
  final GiftFirestoreService _firestoreService = GiftFirestoreService();
  List<Map<String, dynamic>>  _gifts = [];

  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async {
    try {
      print('Fetching gifts locally...');
      // Fetch gifts from local DB first
      final localGifts = await _giftService.getGiftsByEventId(widget.eventId);

      if (localGifts.isEmpty) {
        print('Local gifts are empty. Fetching from Firestore.');
        // If local is empty, sync from Firestore
        final firestoreGifts = await _firestoreService.getGiftsByEvent(
          widget.userId,
          widget.firebaseEventId!,
        );

        // Convert Firestore documents to a format compatible with local storage
        final List<Map<String, dynamic>> gifts = firestoreGifts.map((doc) {
          return {
            'ID': null, // Local ID will be auto-assigned
            ...doc.data() as Map<String, dynamic>,
            'GIFT_FIREBASE_ID': doc.id, // Keep the Firebase ID
            'USER_ID': widget.userId,
          };
        }).toList();

        // Step 3: Save Firestore events to local database
        for (var gift in gifts) {
          await _giftService.insertGift(gift);
        }

        setState(() {
          _gifts = gifts;
        });
      } else {
        setState(() {
          _gifts = localGifts;
        });
      }
    } catch (e) {
      print("Error fetching gifts: $e");
    }
  }

  Future<void> _publishGift(Map<String, dynamic> giftData) async {
    try {
      final firebaseId = giftData['GIFT_FIREBASE_ID'];

      if (firebaseId != null && firebaseId.isNotEmpty) {
        await _firestoreService.updateGift(
          widget.userId,
          widget.firebaseEventId!,
          firebaseId,
          giftData,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gift updated on Firestore.')),
        );
      } else {
        final newDoc = await _firestoreService.addGift(
          widget.userId,
          widget.firebaseEventId!,
          giftData,
        );
        await _giftService.updateGift(giftData['ID'], {
          ...giftData,
          'GIFT_FIREBASE_ID': newDoc.id,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gift published to Firestore.')),
        );
        _fetchGifts();
      }
    } catch (e) {
      print('Error publishing gift: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to publish gift.')),
      );
    }
  }

  Future<void> _pledgeGift(int giftId) async {
    await _giftService.pledgeGift(giftId, widget.userId);
    _fetchGifts();
  }

  Future<void> _unpledgeGift(int giftId) async {
    await _giftService.unpledgeGift(giftId);
    _fetchGifts();
  }

  void _addOrEditGift({Map<String, dynamic>? giftData}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditGiftPage(
          eventId: widget.eventId,
          giftData: giftData,
          userId: widget.userId,
        ),
      ),
    );

    if (result != null) {
      final giftData = result['giftData'];
      final isNew = result['isNew'];

      if (!isNew) {
        print("Gift Data: $giftData");
        print("Gift ID: ${giftData['ID']}");
        // Ensure 'ID' exists for update
        final giftId = giftData['ID'];
        if (giftId == null) {
          throw Exception("Cannot update gift: missing ID.");
        }
        await _giftService.updateGift(giftId, giftData);
      }

      if (isNew) {
        // Insert new gift
        await _giftService.insertGift(giftData);
      } else {
        // Update existing gift
        // Ensure 'ID' exists for update
        final giftId = giftData['ID'];
        if (giftId == null) {
          throw Exception("Cannot update gift: missing ID.");
        }
        await _giftService.updateGift(giftId, giftData);
      }

      // Refresh the list
      _fetchGifts();
    }
  }




  Future<void> _deleteGift(int giftId) async {
    // Find the event locally
    final gift = _gifts.firstWhere((e) => e['ID'] == giftId, orElse: () => <String, dynamic>{}); // Empty map if not found

    if (gift.isNotEmpty) {
      // Delete from local database
      await _giftService.deleteGift(giftId);

      // Delete from Firestore if published
      if (gift['GIFT_FIREBASE_ID'] != null && gift['GIFT_FIREBASE_ID'].isNotEmpty) {
        await _firestoreService.deleteGift(widget.userId,widget.firebaseEventId, gift['GIFT_FIREBASE_ID']);
      }
    }else {
      print('Event not found for deletion.');
    }
    _fetchGifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditGift(),
          ),
        ],
      ),
      body: _gifts.isEmpty
          ? const Center(child: Text("No gifts added for this event."))
          : ListView.builder(
        itemCount: _gifts.length,
        itemBuilder: (context, index) {
          final gift = _gifts[index];
          final isOwner = gift['USER_ID'] == widget.userId;
          final isPublished =
              gift['GIFT_FIREBASE_ID'] != null && gift['GIFT_FIREBASE_ID'].isNotEmpty;

          return ListTile(
            title: Text(gift['NAME']),
            subtitle: Text('Category: ${gift['CATEGORY']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (gift['IS_PLEDGED'] == 1)
                  const Icon(Icons.check_circle, color: Colors.green),
                if (isOwner)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _addOrEditGift(giftData: gift),
                  ),
                if (isOwner)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteGift(gift['ID']),
                  ),
                if (isOwner)
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isPublished
                          ? const Icon(Icons.check_circle, color: Colors.green, key: ValueKey('published'))
                          : const Icon(Icons.cloud_upload, color: Colors.grey, key: ValueKey('not_published')),
                    ),
                    onPressed: () async {
                      await _publishGift(gift);
                      setState(() {}); // Trigger re-build to show animation
                    },
                  ),

                if (!isOwner)
                  IconButton(
                    icon: Icon(
                      gift['IS_PLEDGED'] == 1 ? Icons.cancel : Icons.star,
                      color: gift['IS_PLEDGED'] == 1
                          ? Colors.red
                          : Colors.blue,
                    ),
                    onPressed: () {
                      if (gift['IS_PLEDGED'] == 1) {
                        _unpledgeGift(gift['ID']);
                      } else {
                        _pledgeGift(gift['ID']);
                      }
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
