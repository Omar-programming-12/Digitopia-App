import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/meal_entity.dart';

class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.location,
    required super.latitude,
    required super.longitude,
    super.imageUrl,
    required super.privacy,
    required super.userName,
    required super.timestamp,
    required super.available,
  });

  factory MealModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MealModel(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 1,
      location: data['location_text'] ?? data['location'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      imageUrl: data['image_url'] ?? data['imageUrl'],
      privacy: data['privacy'] ?? 'public',
      userName: data['userName'] ?? 'مستخدم',
      timestamp: _parseTimestamp(data['timestamp']),
      available: data['available'] ?? true,
    );
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      location: json['location_text'] ?? json['location'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? json['imageUrl'],
      privacy: json['privacy'] ?? 'public',
      userName: json['userName'] ?? 'مستخدم',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      available: json['available'] ?? true,
    );
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

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'privacy': privacy,
      'userName': userName,
      'timestamp': FieldValue.serverTimestamp(),
      'available': available,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime.now();
    }
    return DateTime.now();
  }

  MealEntity toEntity() {
    return MealEntity(
      id: id,
      name: name,
      quantity: quantity,
      location: location,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      privacy: privacy,
      userName: userName,
      timestamp: timestamp,
      available: available,
    );
  }
}