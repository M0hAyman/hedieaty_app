import 'package:cloud_firestore/cloud_firestore.dart';

class Gift {
  final String id;
  final String eventId;
  final String name;
  final String description;
  final String category;
  final double price;
  final String status; // available, pledged, purchased
  final String? pledgedBy; // User ID of who pledged or purchased
  final Timestamp createdAt;

  Gift({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    this.pledgedBy,
    required this.createdAt,
  });

  // Factory to create Gift object from Firestore DocumentSnapshot
  factory Gift.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Gift(
      id: doc.id,
      eventId: data['eventId'],
      name: data['name'],
      description: data['description'],
      category: data['category'],
      price: (data['price'] as num).toDouble(),
      status: data['status'],
      pledgedBy: data['pledgedBy'],
      createdAt: data['createdAt'],
    );
  }

  // Convert Gift object to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'pledgedBy': pledgedBy,
      'createdAt': createdAt,
    };
  }
}
