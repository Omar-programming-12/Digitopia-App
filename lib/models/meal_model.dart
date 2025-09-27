import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String name;
  final int quantity;
  final String location;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final String privacy;
  final String userName;
  final DateTime timestamp;
  final bool available;
  
  bool get expired => timestamp.isBefore(DateTime.now().subtract(const Duration(hours: 24)));

  Meal({
    required this.id,
    required this.name,
    required this.quantity,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.privacy,
    required this.userName,
    required this.timestamp,
    this.available = true,
  });

  static Meal fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 1,
      location: data['location'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'],
      privacy: data['privacy'] ?? 'public',
      userName: data['userName'] ?? 'مستخدم',
      timestamp: _parseTimestamp(data['timestamp']),
      available: data['available'] ?? true,
    );
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      location: json['location_text'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'],
      privacy: json['privacy'] ?? 'public',
      userName: json['userName'] ?? 'مستخدم',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      available: json['available'] ?? true,
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'location_text': location,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'privacy': privacy,
      'userName': userName,
      'timestamp': timestamp.toIso8601String(),
      'available': available,
    };
  }
}