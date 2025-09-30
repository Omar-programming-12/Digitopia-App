# نظام الشات المحدث - Digitopia App

## التحديثات المضافة

### 1. نماذج البيانات الجديدة
- **UserModel**: لحفظ معلومات المستخدمين مع ID فريد
- **MessageModel**: لحفظ الرسائل بين المستخدمين

### 2. الخدمات الجديدة
- **UserService**: إدارة المستخدمين في Firestore
- **ChatService**: إرسال واستقبال الرسائل

### 3. التحديثات على الملفات الموجودة

#### AuthService
- تم تحديث `signUp()` لحفظ معلومات المستخدم في Firestore
- تم تحديث `signIn()` و `signOut()` لتحديث حالة الاتصال

#### Meal Model
- تمت إضافة `userId` لربط الوجبة بالمستخدم الذي رفعها

#### ChatScreen
- تم تحويلها لتعمل مع Firebase Firestore
- تعرض الرسائل الحقيقية بين المستخدمين
- إرسال واستقبال الرسائل في الوقت الفعلي

#### MealDetailsScreen
- تم تحديثها لتمرير `chefId` للشات
- ربط زر "طلب الآن" بنظام الشات

#### ChatListScreen
- تم إعادة كتابتها لتعمل مع البيانات الحقيقية
- عرض قائمة المحادثات من Firebase

## كيفية الاستخدام

### 1. تسجيل مستخدم جديد
```dart
// سيتم حفظ المستخدم تلقائياً في Firestore مع ID فريد
final success = await AuthService.signUp(email, password, name);
```

### 2. بدء محادثة جديدة
```dart
// من شاشة تفاصيل الوجبة
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChatScreen(
      userId: chefId, // معرف صاحب الوجبة
      mealId: mealId, // معرف الوجبة (اختياري)
    ),
  ),
);
```

### 3. إرسال رسالة
```dart
await ChatService.sendMessage(
  receiverId: userId,
  message: messageText,
  mealId: mealId, // اختياري
);
```

### 4. استقبال الرسائل
```dart
// في ChatScreen
StreamBuilder<List<MessageModel>>(
  stream: ChatService.getMessages(otherUserId),
  builder: (context, snapshot) {
    // عرض الرسائل
  },
);
```

## بنية Firebase

### مجموعة Users
```
users/
  {userId}/
    - name: string
    - email: string
    - profileImage: string (optional)
    - createdAt: timestamp
    - isOnline: boolean
    - lastSeen: timestamp
```

### مجموعة Messages
```
messages/
  {messageId}/
    - senderId: string
    - receiverId: string
    - message: string
    - timestamp: timestamp
    - isRead: boolean
    - mealId: string (optional)
```

### مجموعة Meals (محدثة)
```
meals/
  {mealId}/
    - name: string
    - userId: string (جديد)
    - userName: string
    - quantity: number
    - location: string
    - imageUrl: string
    - timestamp: timestamp
    - available: boolean
```

## الميزات المضافة

1. **نظام شات حقيقي**: رسائل فورية بين المستخدمين
2. **ربط الوجبات بالمستخدمين**: كل وجبة مرتبطة بمعرف المستخدم
3. **حالة الاتصال**: عرض المستخدمين المتصلين
4. **قائمة المحادثات**: عرض جميع المحادثات النشطة
5. **ربط الرسائل بالوجبات**: إمكانية ربط المحادثة بوجبة معينة

## ملاحظات مهمة

1. تأكد من إعداد Firebase Firestore في المشروع
2. تأكد من إعداد قواعد الأمان في Firestore
3. يمكن تحسين النظام بإضافة مجموعة منفصلة للمحادثات
4. يمكن إضافة إشعارات push للرسائل الجديدة

## قواعد Firestore المقترحة

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Messages collection
    match /messages/{messageId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.senderId || 
         request.auth.uid == resource.data.receiverId);
    }
    
    // Meals collection
    match /meals/{mealId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```