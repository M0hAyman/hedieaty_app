import 'package:flutter/material.dart';
import 'package:hedieaty_app/Pages/add_event_page.dart';
import '../Data/firebase/services/event_firestore_service.dart';
import '../Data/local_database/services/event_service.dart';
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
      final events = await _eventService.getEventsByUserId(widget.userId);
      setState(() {
        _events = events;
      });
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
