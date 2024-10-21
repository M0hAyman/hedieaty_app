import 'package:flutter/material.dart';

class FriendListItem extends StatelessWidget {
  final String name;
  final String profileImageUrl;
  final int eventCount;

  const FriendListItem({
    super.key,
    required this.name,
    required this.profileImageUrl,
    required this.eventCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
              radius: 25,
            ),
            if (eventCount >
                0) // Only show the badge if there are upcoming events
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green, // Green color for the badge
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      '$eventCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(name),
        onTap: () {
          // Navigate to the friend's gift list
        },
      ),
    );
  }
}



/**
 * 
 * OLD CODE
class FriendListItem extends StatelessWidget {
  final String name;
  final String profileImageUrl;
  final int eventCount;

  const FriendListItem({
    super.key,
    required this.name,
    required this.profileImageUrl,
    required this.eventCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        title: Text(name),
        subtitle: Text(eventCount > 0
            ? 'Upcoming Events: $eventCount'
            : 'No Upcoming Events'),
        onTap: () {
          // Navigate to the friend's gift list
        },
      ),
    );
  }
}

 */