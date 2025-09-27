import 'package:digitopia_app/presentation/widgets/location_picker.dart';
import 'package:digitopia_app/services/django_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ShareMealScreen extends StatefulWidget {
  const ShareMealScreen({super.key});

  @override
  State<ShareMealScreen> createState() => _ShareMealScreenState();
}

class _ShareMealScreenState extends State<ShareMealScreen> {
  int _quantity = 1;
  String _selectedPrivacy = 'عام';
  File? _selectedImage;
  final TextEditingController _mealNameController = TextEditingController();
  String _selectedLocation = 'اختر الموقع من الخريطة';
  double? _selectedLat;
  double? _selectedLng;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void uploadMeal() async {
  // الحصول على اسم المستخدم (يمكن استبدالها ببيانات حقيقية)
  const String currentUserName = 'سارة أحمد';
  if (_mealNameController.text.isEmpty || _selectedLocation == 'اختر الموقع من الخريطة') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("من فضلك املأ كل الحقول واختر الموقع")),
    );
    return;
  }

  try {
    String? imageUrl;

    if (_selectedImage != null) {
      try {
        final fileName = 'meal_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('meals')
            .upload(fileName, _selectedImage!, fileOptions: const FileOptions(contentType: 'image/jpeg'));

        imageUrl = Supabase.instance.client.storage
            .from('meals')
            .getPublicUrl(fileName);
        print('Image uploaded to Supabase: $imageUrl');
      } catch (e) {
        print('Supabase upload error: $e');
      }
    }

    await FirebaseFirestore.instance.collection('meals').add({
      'name': _mealNameController.text,
      'quantity': _quantity,
      'location': _selectedLocation,
      'latitude': _selectedLat,
      'longitude': _selectedLng,
      'privacy': _selectedPrivacy,
      'imageUrl': imageUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
      'userName': 'سارة أحمد', 
    });

    await DjangoNotificationService.sendMealNotification(
      userName: currentUserName,
      mealName: _mealNameController.text,
      location: _selectedLocation,
      imageUrl: imageUrl,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تمت إضافة الوجبة بنجاح")),
    );

    _mealNameController.clear();
    setState(() {
      _quantity = 1;
      _selectedPrivacy = 'عام';
      _selectedImage = null;
      _selectedLocation = 'اختر الموقع من الخريطة';
      _selectedLat = null;
      _selectedLng = null;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("خطأ في رفع الوجبة: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'رفع طعام',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'إضافة صورة الطعام',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'اسم الوجبة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _mealNameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'على سبيل المثال: كبسة دجاج',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF6366F1)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'الكمية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'عدد الأشخاص',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'الموقع',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationPickerScreen(),
                  ),
                );
                
                if (result != null) {
                  setState(() {
                    _selectedLocation = result['address'];
                    _selectedLat = result['lat'];
                    _selectedLng = result['lng'];
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _selectedLocation == 'اختر الموقع من الخريطة' 
                          ? Colors.grey[400] 
                          : const Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedLocation,
                        style: TextStyle(
                          color: _selectedLocation == 'اختر الموقع من الخريطة' 
                              ? Colors.grey[400] 
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'تاريخ انتهاء الصلاحية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'اختيار التاريخ والوقت',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'الآن',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم إتاحة الوجبة لمدة 3 ساعات بشكل افتراضي',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'خيارات الخصوصية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            RadioListTile<String>(
              title: const Text('عام - متاح للجميع'),
              value: 'عام',
              groupValue: _selectedPrivacy,
              onChanged: (value) {
                setState(() {
                  _selectedPrivacy = value!;
                });
              },
              activeColor: const Color(0xFF6366F1),
            ),
            RadioListTile<String>(
              title: const Text('خاص - متاح للمتابعين فقط'),
              value: 'خاص',
              groupValue: _selectedPrivacy,
              onChanged: (value) {
                setState(() {
                  _selectedPrivacy = value!;
                });
              },
              activeColor: const Color(0xFF6366F1),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: uploadMeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'رفع الوجبة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
