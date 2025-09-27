import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitopia_app/presentation/pages/notifictions_screen.dart';
import 'package:digitopia_app/presentation/pages/share_meal_screen.dart';
import 'package:digitopia_app/presentation/widgets/food_card.dart';
import 'package:digitopia_app/presentation/widgets/search_text_field.dart';
import 'package:digitopia_app/services/search_system_service.dart';
import 'package:digitopia_app/utils/app_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const HomeScreenContent();
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();



  static Widget _buildCategoryButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotifictionsScreen()),
                        );
                      },
                      icon:
                          const Icon(Icons.notifications, color: Colors.white, size: 24),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text('3',
                            style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('مرحباً سارة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text('الرياض - الدخل',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ),

          SearchTextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value.trim();
              });
            },
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: SearchSystemService.getMealsService(''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()));
                        }
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 60),
                            child: Center(child: Text('لا يوجد وجبات مطابقة')),
                          );
                        }

                        final filteredMeals = SearchSystemService.filterMeals(snapshot.data!.docs, searchQuery);
                        
                        if (filteredMeals.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 60),
                            child: Center(child: Text('لا يوجد وجبات مطابقة')),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true, 
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredMeals.length,
                          itemBuilder: (context, index) {
                            final data = filteredMeals[index].data() as Map<String, dynamic>;
                          
                            return FoodCard(
                              title: data['name'] ?? '',
                              description: data['description'] ?? '',
                              chef: data['userName'] ?? data['chef'] ?? '',
                              time: AppUtils.getTimeAgo(data['timestamp']),
                              rating: 5.0,
                              price: data['price'] ?? 'مجاني',
                              status: 'متاح الآن',
                              statusColor: Colors.green,
                              imageUrl: data['imageUrl'],
                              docId: filteredMeals[index].id,
                            );
                          });
                      },
                    ),
                  ),

                if (searchQuery.isEmpty) ...[
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                        Text('تغيير الموقع', style: TextStyle(color: Colors.blue, fontSize: 14)),
                        Spacer(),
                        Text('ضمن 5 كم',
                            style:
                                TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map, color: Colors.blue, size: 32),
                                SizedBox(height: 8),
                                Text('الخريطة', style: TextStyle(color: Colors.blue, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: Colors.white, size: 32),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ShareMealScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('شارك وجبة',
                                      style: TextStyle(color: Colors.white, fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // categories
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('التصنيفات',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HomeScreenContent._buildCategoryButton('مشروبات', false),
                        HomeScreenContent._buildCategoryButton('حلويات', false),
                        HomeScreenContent._buildCategoryButton('وجبات رئيسية', false),
                        HomeScreenContent._buildCategoryButton('الكل', true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('meals')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                            height: 200, child: Center(child: CircularProgressIndicator()));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('لا توجد وجبات متاحة حالياً',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center),
                        );
                      }

                      final meals = snapshot.data!.docs;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meals.length} وجبة',
                                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                const Text('وجبات متاحة قريبة منك',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...meals.map((doc) {
                            final meal = doc.data() as Map<String, dynamic>;
                            return FoodCard(
                              title: meal['name'] ?? 'وجبة',
                              description:
                                  'تكفي ${meal['quantity'] ?? ''} أشخاص • ${meal['location'] ?? ''}',
                              chef: meal['userName'] ?? 'مستخدم',
                              time: AppUtils.getTimeAgo(meal['timestamp']),
                              rating: 5.0,
                              price: meal['privacy'] == 'عام' ? 'مجاني' : 'مدفوع',
                              status: 'متاح الآن',
                              statusColor: Colors.green,
                              imageUrl: meal['imageUrl'],
                              docId: doc.id,
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 80),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

