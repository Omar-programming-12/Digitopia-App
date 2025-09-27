class MealEntity {
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
  
  const MealEntity({
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
    required this.available,
  });

  bool get isExpired => timestamp.isBefore(
    DateTime.now().subtract(const Duration(hours: 24))
  );

  bool get isAvailable => available && !isExpired;

  MealEntity copyWith({
    String? id,
    String? name,
    int? quantity,
    String? location,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? privacy,
    String? userName,
    DateTime? timestamp,
    bool? available,
  }) {
    return MealEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      privacy: privacy ?? this.privacy,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      available: available ?? this.available,
    );
  }
}