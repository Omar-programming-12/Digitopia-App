import 'package:flutter/material.dart';
import 'package:digitopia_app/screens/individual_chat_screen.dart';
import 'package:digitopia_app/widgets/custom_bottom_nav.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  final List<Map<String, dynamic>> _chats = const [
    {
      'name': 'جود أحمد',
      'message': 'مرحبا كيف حالك اليوم؟',
      'time': '2 د',
      'avatar': 'https://via.placeholder.com/40',
      'hasUnread': true,
    },
    {
      'name': 'نور محمد',
      'message': 'شكرا لك على الوجبة الرائعة',
      'time': '5 د',
      'avatar': 'https://via.placeholder.com/40',
      'hasUnread': false,
    },
    {
      'name': 'سارة الخضير',
      'message': 'هل يمكنني طلب نفس الوجبة؟',
      'time': '15 د',
      'avatar': 'https://via.placeholder.com/40',
      'hasUnread': true,
    },
    {
      'name': 'فريد الأحمري',
      'message': 'متى ستكون الوجبة جاهزة؟',
      'time': '30 د',
      'avatar': 'https://via.placeholder.com/40',
      'hasUnread': false,
    },
  ];

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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return _buildChatItem(
                  context,
                  chat['name'],
                  chat['message'],
                  chat['time'],
                  chat['avatar'],
                  hasUnread: chat['hasUnread'],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildChatItem(BuildContext context, String name, String message, String time, String avatar, {bool hasUnread = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualChatScreen(
              userName: name,
              userAvatar: NetworkImage(avatar),
            ),
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
    );
  }
}