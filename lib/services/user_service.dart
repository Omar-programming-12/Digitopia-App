import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // إنشاء مستخدم جديد في Firestore
  static Future<bool> createUser(String name, String email) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final userModel = UserModel(
        id: user.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
        isOnline: true,
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore());

      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // الحصول على معلومات المستخدم
  static Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // تحديث حالة المستخدم (متصل/غير متصل)
  static Future<void> updateUserStatus(bool isOnline) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': isOnline,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  // الحصول على المستخدم الحالي
  static Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await getUser(user.uid);
  }
}