import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitopia_app/constants/app_constants.dart';
import 'package:digitopia_app/presentation/pages/meal_details_screen.dart';
import 'package:digitopia_app/presentation/widgets/optimized_image.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.title,
    required this.description,
    required this.chef,
    required this.time,
    required this.rating,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.imageUrl,
    required this.docId,
    this.chefImageUrl,
    this.location,
    this.quantity,
  });

  final String title;
  final String description;
  final String chef;
  final String time;
  final double? rating;
  final String price;
  final String status;
  final Color? statusColor;
  final String? imageUrl;
  final String docId;
  final String? chefImageUrl;
  final String? location;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsScreen(
              mealId: docId,
              title: title,
              description: description,
              chef: chef,
              time: time,
              rating: rating ?? 5.0,
              price: price,
              status: status,
              statusColor: statusColor ?? Colors.green,
              imageUrl: imageUrl,
              location: location ?? 'غير محدد',
              quantity: quantity ?? 1,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              OptimizedImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusMedium)),
                errorWidget: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.fastfood,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 60,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await FirebaseFirestore.instance.collection('meals').doc(docId).delete();
                    } catch (e) {
                      debugPrint('Error deleting meal: $e');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        Text(' $rating', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text(chef, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey[300],
                          child: OptimizedImage(
                            imageUrl: chefImageUrl,
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(10),
                            errorWidget: const Icon(
                              Icons.person,
                              size: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
