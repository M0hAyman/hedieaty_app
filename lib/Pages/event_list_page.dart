import 'package:flutter/material.dart';
import 'package:hedieaty_app/Pages/add_event_page.dart';
import '../Data/firebase/services/event_firestore_service.dart';
import '../Data/firebase/services/gift_firestore_service.dart';
import '../Data/local_database/services/event_service.dart';
import '../Data/local_database/services/gift_service.dart';
import 'gift_list_page.dart';

class EventListPage extends StatefulWidget {
  final String userId;

  const EventListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventService _eventService = EventService();
  final EventFirestoreService _firestoreService = EventFirestoreService();
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Step 1: Attempt to fetch from local database
      final localEvents = await _eventService.getEventsByUserId(widget.userId);

      if (localEvents.isEmpty) {
        // Step 2: If local is empty, fetch from Firestore
        final firestoreEvents = await _firestoreService.getEventsByUser(widget.userId);

        // Convert Firestore documents to a format compatible with local storage
        final List<Map<String, dynamic>> events = firestoreEvents.map((doc) {
          return {
            'ID': null, // Local ID will be auto-assigned
            ...doc.data() as Map<String, dynamic>,
            'EVENT_FIREBASE_ID': doc.id, // Keep the Firebase ID
            'USER_ID': widget.userId,
          };
        }).toList();

        // Step 3: Save Firestore events to local database
        for (var event in events) {
          await _eventService.insertEvent(event);
        }

        setState(() {
          _events = events;
        });
      } else {
        // Fetch local events if available
        setState(() {
          _events = localEvents;
        });
      }
    } catch (e) {
      print('Error fetching events: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }


  void _addOrEditEvent({Map<String, dynamic>? eventData}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditEventPage(
          eventData: eventData,
          userId: widget.userId,
        ),
      ),
    );

    if (result != null) {
      if (eventData == null) {
        await _eventService.insertEvent(result);
      } else {
        print("Event Data: $eventData");
        print("Event ID: ${eventData['ID']}");
        await _eventService.updateEvent(eventData['ID'], result);

        // Update Firestore if published
        if (eventData['EVENT_FIREBASE_ID'] != null && eventData['EVENT_FIREBASE_ID'].isNotEmpty) {
          await _firestoreService.updateEvent(
            widget.userId,
            eventData['EVENT_FIREBASE_ID'],
            result,
          );
        }

      }
      _fetchEvents();
    }
  }

  void _deleteEvent(int eventId) async {
    // Find the event locally
    final event = _events.firstWhere((e) => e['ID'] == eventId, orElse: () => <String, dynamic>{}); // Empty map if not found

    if (event.isNotEmpty) {
      try {
      // Fetch all gifts associated with the event from the local database
      final giftService = GiftService();
      final firestoreService = GiftFirestoreService();
      final eventGifts = await giftService.getGiftsByEventId(eventId);

      // Delete each gift
      for (final gift in eventGifts) {
        await giftService.deleteGift(gift['ID']);
        if (gift['GIFT_FIREBASE_ID'] != null && gift['GIFT_FIREBASE_ID'].isNotEmpty) {
          await firestoreService.deleteGift(widget.userId, event['EVENT_FIREBASE_ID'], gift['GIFT_FIREBASE_ID']);
        }
      }

      // Delete from local database
      await _eventService.deleteEvent(eventId);

      // Delete from Firestore if published
      if (event['EVENT_FIREBASE_ID'] != null && event['EVENT_FIREBASE_ID'].isNotEmpty) {
        await _firestoreService.deleteEvent(widget.userId, event['EVENT_FIREBASE_ID']);
      }
      } catch (e) {
        print('Error deleting event: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete event!.')),
        );
      }
    }else {
      print('Event not found for deletion.');
    }
    _fetchEvents();
  }


  Future<void> _publishEvent(Map<String, dynamic> eventData) async {
    try {
      final firebaseId = eventData['EVENT_FIREBASE_ID'];
      if (firebaseId != null && firebaseId.isNotEmpty) {
        await _firestoreService.updateEvent(widget.userId, firebaseId, eventData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated on Firestore.')),
        );
      } else {
        final newDoc = await _firestoreService.addEvent(widget.userId, eventData);
        await _eventService.updateEvent(eventData['ID'], {
          ...eventData,
          'EVENT_FIREBASE_ID': newDoc.id,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event published to Firestore.')),
        );
        _fetchEvents();
      }
    } catch (e) {
      print('Error publishing event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to publish event.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditEvent(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : _events.isEmpty
          ? const Center(child: Text("No events available."))
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          final isPublished = event['EVENT_FIREBASE_ID'] != null && event['EVENT_FIREBASE_ID'].isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            color: isPublished ? Colors.green.shade100 : Colors.white,
            child: ListTile(
              title: Text(event['NAME']),
              subtitle: Text('Date: ${event['DATE']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftListPage(
                      eventId: event['ID'], // Use Firestore ID if available; fallback to local ID //could make some bugs
                      firebaseEventId: event['EVENT_FIREBASE_ID'],
                      userId: widget.userId,
                    ),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _addOrEditEvent(eventData: event),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteEvent(event['ID']),
                  ),
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isPublished
                          ? const Icon(Icons.check_circle, color: Colors.green, key: ValueKey('published'))
                          : const Icon(Icons.cloud_upload, color: Colors.grey, key: ValueKey('not_published')),
                    ),
                    onPressed: () async {
                      await _publishEvent(event);
                      setState(() {}); // Trigger re-build to show animation
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
