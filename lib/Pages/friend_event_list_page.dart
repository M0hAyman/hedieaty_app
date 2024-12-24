import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:hedieaty_app/Data/firebase/services/event_firestore_service.dart';
import 'friend_gift_list_page.dart';


class FriendEventListPage extends StatelessWidget {
  final String currentUserId;
  final String friendName;
  final String friendId;

  const FriendEventListPage({
    required this.currentUserId,
    required this.friendName,
    required this.friendId,
    Key? key,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchFriendEvents(String friendId) async {
    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('events');

    try {
      final querySnapshot = await eventsCollection.get();
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...?doc.data() as Map<String, dynamic>?, // Ensure it's non-null
        };
      }).toList();
    } catch (e) {
      print('Error fetching friend events: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$friendName\'s Events')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFriendEvents(friendId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading events.'));
          }

          final events = snapshot.data ?? [];
          if (events.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event['NAME'] ?? 'Unnamed Event'),
                subtitle: Text('Date: ${event['DATE']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendGiftListPage(
                        currentUserId: currentUserId,
                        friendId: friendId,
                        eventId: event['EVENT_FIREBASE_ID'],
                        eventName: event['NAME'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
