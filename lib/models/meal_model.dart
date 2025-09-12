import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String name;
  final int quantity;
  final String location;
  final String? imageUrl;
  final Timestamp timestamp;
  final bool available;
  bool get expired => timestamp.toDate().isBefore(DateTime.now());

  Meal({
    required this.id,
    required this.name,
    required this.quantity,
    required this.location,
    this.imageUrl,
    required this.timestamp,
    this.available = true,
  });

  factory Meal.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      name: d['name'] ?? '',
      quantity: (d['quantity'] ?? 1) as int,
      location: d['location'] ?? '',
      imageUrl: d['imageUrl'],
      timestamp: d['timestamp'] ?? Timestamp.now(),
      available: d['available'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'location': location,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'available': available,
    };
  }
}
