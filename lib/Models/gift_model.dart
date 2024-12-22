import 'package:cloud_firestore/cloud_firestore.dart';

class Gift {
  final String id;
  final String fireBaseId;
  final String eventId;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? pledgedBy; // User ID of who pledged or purchased
  final bool isPledged; // Boolean to check if gift is pledged

  Gift({
    required this.id,
    required this.fireBaseId,
    required this.eventId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.pledgedBy,
    required this.isPledged,
  });

  // Factory to create Gift object from Firestore DocumentSnapshot
  factory Gift.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Gift(
      id: doc.id,
      fireBaseId: data['fireBaseId'],
      eventId: data['eventId'],
      name: data['name'],
      description: data['description'],
      category: data['category'],
      price: (data['price'] as num).toDouble(),
      pledgedBy: data['pledgedBy'],
      isPledged: data['isPledged'],
    );
  }

  // Convert Gift object to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'fireBaseId': fireBaseId,
      'eventId': eventId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'pledgedBy': pledgedBy,
      'isPledged': isPledged,
    };
  }
}
