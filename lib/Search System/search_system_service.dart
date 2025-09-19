import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchSystemService {
  static Timer? _debounceTimer;
  
  static Stream<QuerySnapshot> getMealsService(String query) {
    final meals = FirebaseFirestore.instance.collection('meals');
    
    if (query.isEmpty) {
      return meals
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots();
    }
    
    return meals.snapshots();
  }
  
  static List<QueryDocumentSnapshot> filterMeals(List<QueryDocumentSnapshot> docs, String query) {
    if (query.isEmpty) return docs;
    
    final searchQuery = query.toLowerCase().trim();
    
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final name = (data['name'] ?? '').toString().toLowerCase();
      final description = (data['description'] ?? '').toString().toLowerCase();
      final chef = (data['chef'] ?? '').toString().toLowerCase();
      final userName = (data['userName'] ?? '').toString().toLowerCase();
      
      return name.contains(searchQuery) ||
             description.contains(searchQuery) ||
             chef.contains(searchQuery) ||
             userName.contains(searchQuery);
    }).toList();
  }
  
  static void searchWithDebounce(String query, Function(String) onSearch) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      onSearch(query);
    });
  }
  
  static Stream<QuerySnapshot> searchByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('meals')
        .where('category', isEqualTo: category)
        .where('available', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  
  static Stream<QuerySnapshot> searchByLocation(String location) {
    return FirebaseFirestore.instance
        .collection('meals')
        .where('location', isEqualTo: location)
        .where('available', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}


// StreamBuilder <QuerySnapshot> (
//   stream: getMealsService(searchQuery),
//   builder: (context , snapshot){
//     if (!snapshot.hasData) return CircularProgressIndicator();
     
//      final docs = snapshot.data!.docs;

//      return ListView.builder(
//       itemCount: docs.length
//       itemBuilder: (context , index){
//         final meal = docs[index];
//         return ListTile(
//           title: Text(meal['mealName']),
//           subtitle: Text(meal['description'] ?? ""),
//         )
//       }
//     )
//   }
// )