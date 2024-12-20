// gift_list_page.dart
import 'package:flutter/material.dart';
import '../Data/local_database/services/gift_service.dart';
import 'AddEditGiftPage.dart';

class GiftListPage extends StatefulWidget {
  final int eventId;
  final String userId; // Current logged-in user ID

  const GiftListPage({super.key, required this.eventId, required this.userId});

  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftService _giftService = GiftService();
  List<Map<String, dynamic>> _gifts = [];

  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async {
    final gifts = await _giftService.getGiftsByEventId(widget.eventId);
    setState(() {
      _gifts = gifts;
    });
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
        await _giftService.updateGift(giftData['ID'], giftData);
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
    await _giftService.deleteGift(giftId);
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
