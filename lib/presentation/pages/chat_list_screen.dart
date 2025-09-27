import 'package:digitopia_app/presentation/pages/individual_chat_screen.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatListScreenContent();
  }
}

class ChatListScreenContent extends StatelessWidget {
  const ChatListScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFF8B84f4), Color(0xFF5a45f4)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('المحادثات', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    const Spacer(),
                    const Icon(Icons.notifications_outlined, color: Colors.white, size: 25),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage('https://via.placeholder.com/32'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text('بحث عن محادثة...', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChatItem(
                  'جود أحمد',
                  'مرحبا كيف حالك اليوم؟',
                  '2 د',
                  'https://via.placeholder.com/40',
                  hasUnread: true,
                ),
                _buildChatItem(
                  'نور محمد',
                  'شكرا لك على الوجبة الرائعة',
                  '5 د',
                  'https://via.placeholder.com/40',
                ),
                _buildChatItem(
                  'سارة الخضير',
                  'هل يمكنني طلب نفس الوجبة؟',
                  '15 د',
                  'https://via.placeholder.com/40',
                  hasUnread: true,
                ),
                _buildChatItem(
                  'فريد الأحمري',
                  'متى ستكون الوجبة جاهزة؟',
                  '30 د',
                  'https://via.placeholder.com/40',
                ),
                _buildChatItem(
                  'أحمد العريفي',
                  'الطعام كان لذيذ جداً، شكراً لك',
                  '1 س',
                  'https://via.placeholder.com/40',
                ),
                _buildChatItem(
                  'نور الهزاني',
                  'هل تتوفر وجبات نباتية؟',
                  '2 س',
                  'https://via.placeholder.com/40',
                ),
                _buildChatItem(
                  'محمد الشمري',
                  'أريد أن أشارك وجبة معك',
                  '3 س',
                  'https://via.placeholder.com/40',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(String name, String message, String time, String avatar, {bool hasUnread = false}) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => IndividualChatScreen(
              userName: name,
              userAvatar: avatar,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (hasUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.more_vert,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
     ) );
  }
  }
