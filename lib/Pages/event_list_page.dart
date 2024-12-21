import 'package:flutter/material.dart';
import 'package:hedieaty_app/Pages/add_event_page.dart';
import '../Data/firebase/services/event_firestore_service.dart';
import '../Data/local_database/services/event_service.dart';
import 'gift_list_page.dart';


class EventListPage extends StatefulWidget {
  final String userId; // Add userId parameter

  const EventListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}


class _EventListPageState extends State<EventListPage> {
  final EventService _eventService = EventService();
  final EventFirestoreService _firestoreService = EventFirestoreService();
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final events = await _eventService.getEventsByUserId(widget.userId); // Use widget.userId
    setState(() {
      _events = events;
    });
  }

  void _addOrEditEvent({Map<String, dynamic>? eventData}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditEventPage(
          eventData: eventData,
          userId: widget.userId, // Pass userId
        ),
      ),
    );

    if (result != null) {
      if (eventData == null) {
        await _eventService.insertEvent(result);
      } else {
        await _eventService.updateEvent(eventData['ID'], result);
      }
      _fetchEvents();
    }
  }

  void _deleteEvent(int eventId) async {
    await _eventService.deleteEvent(eventId);
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
      body: _events.isEmpty
          ? const Center(child: Text("No events available."))
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return ListTile(
            title: Text(event['NAME']),
            subtitle: Text('Date: ${event['DATE']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiftListPage(
                    eventId: event['ID'],
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
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () => _publishEvent(event),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
