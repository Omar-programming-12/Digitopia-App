import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // إرسال رسالة
  static Future<bool> sendMessage({
    required String receiverId,
    required String message,
    String? mealId,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final messageModel = MessageModel(
        id: '',
        senderId: currentUser.uid,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now(),
        mealId: mealId,
      );

      await _firestore
          .collection('messages')
          .add(messageModel.toFirestore());

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  // الحصول على الرسائل بين مستخدمين
  static Stream<List<MessageModel>> getMessages(String otherUserId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [currentUser.uid, otherUserId])
        .where('receiverId', whereIn: [currentUser.uid, otherUserId])
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .where((message) =>
              (message.senderId == currentUser.uid && message.receiverId == otherUserId) ||
              (message.senderId == otherUserId && message.receiverId == currentUser.uid))
          .toList();
    });
  }

  // تحديد الرسائل كمقروءة
  static Future<void> markMessagesAsRead(String otherUserId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final unreadMessages = await _firestore
          .collection('messages')
          .where('senderId', isEqualTo: otherUserId)
          .where('receiverId', isEqualTo: currentUser.uid)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // الحصول على آخر رسالة بين مستخدمين
  static Future<MessageModel?> getLastMessage(String otherUserId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final query = await _firestore
          .collection('messages')
          .where('senderId', whereIn: [currentUser.uid, otherUserId])
          .where('receiverId', whereIn: [currentUser.uid, otherUserId])
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final message = MessageModel.fromFirestore(query.docs.first);
        if ((message.senderId == currentUser.uid && message.receiverId == otherUserId) ||
            (message.senderId == otherUserId && message.receiverId == currentUser.uid)) {
          return message;
        }
      }
      return null;
    } catch (e) {
      print('Error getting last message: $e');
      return null;
    }
  }
}