import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitopia_app/models/meal_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class MealService {
  static final CollectionReference _col = FirebaseFirestore.instance.collection('meals');

  // Stream for real-time updates
  static Stream<List<Meal>> mealsStream() {
    return _col.orderBy('timestamp', descending: true).snapshots().map(
      (snap) => snap.docs.map((doc) => Meal.fromDoc(doc)).toList(),
    );
  }

  // upload image to Firebase Storage and return download URL
  static Future<String?> uploadImage(File? file) async {
    if (file == null) return null;
    final id = const Uuid().v4();
    final ref = FirebaseStorage.instance.ref().child('meals/$id.jpg');
    final uploadTask = await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return url;
  }

  // add meal document
  static Future<void> addMeal({
    required String name,
    required int quantity,
    required String location,
    String? imageUrl,
  }) async {
    await _col.add({
      'name': name,
      'quantity': quantity,
      'location': location,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'available': true,
    });
  }

  // optional: mark meal reserved / not available
  static Future<void> setAvailability(String docId, bool available , Timestamp expired) async {
    await _col.doc(docId).update({'available': available , 'expired': expired});
  }
}
