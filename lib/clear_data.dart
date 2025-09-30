import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> clearAllMeals() async {
  final collection = FirebaseFirestore.instance.collection('meals');
  final snapshots = await collection.get();
  
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }
  
  print('تم حذف ${snapshots.docs.length} وجبة');
}