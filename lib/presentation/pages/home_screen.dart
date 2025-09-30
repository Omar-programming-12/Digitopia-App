import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitopia_app/presentation/pages/main_navigation.dart';
import 'package:digitopia_app/presentation/widgets/food_card.dart';
import 'package:digitopia_app/presentation/widgets/search_text_field.dart';
import 'package:digitopia_app/services/search_system_service.dart';
import 'package:digitopia_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser;
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
                const Spacer(),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        user?.displayName ?? 'اسم المستخدم',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  
                  ],
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white24,
                  child: Text(
                    user?.displayName?.isNotEmpty == true 
                        ? user!.displayName![0].toUpperCase() 
                        : 'U',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
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
                              mealOwnerId: data['userId'],
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
                      
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainNavigation(initialIndex: 1),
                                ),
                              );
                            },
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
                                  Icon(Icons.restaurant_menu, color: Colors.blue, size: 32),
                                  SizedBox(height: 8),
                                  Text('وجباتي', style: TextStyle(color: Colors.blue, fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainNavigation(initialIndex: 2),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.white, size: 32),
                                  SizedBox(height: 8),
                                  Text('شارك وجبة',
                                      style: TextStyle(color: Colors.white, fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                              mealOwnerId: meal['userId'],
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

