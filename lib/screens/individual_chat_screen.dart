import 'package:flutter/material.dart';
import 'package:digitopia_app/widgets/custom_bottom_nav.dart';

class IndividualChatScreen extends StatefulWidget {
  final String userName;
  final ImageProvider userAvatar;

  const IndividualChatScreen({
    super.key,
    required this.userName,
    required this.userAvatar,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'أهلاً كيف حالك اليوم؟ هل وجدة الكيسة مناحة بعد؟',
      'time': 'ص 10:00',
      'isMe': false,
    },
    {
      'text': 'آمنة بدنا لا نخير شكراً لسؤالك. نعم الكيسة متاحة',
      'time': 'ص 10:02',
      'isMe': true,
    },
    {
      'text': 'كم عدد الوجبات المتوفرة؟ وكم تكلف كل شخص؟',
      'time': 'ص 10:05',
      'isMe': false,
    },
    {
      'text': 'لدينا 3 وجبات. كل واحدة تكلف 5 ₹ أشخاص',
      'time': 'ص 10:07',
      'isMe': true,
    },
    {
      'text': 'رائع! هل يمكنني استلامها بعد الساعة 5 مساءً؟',
      'time': 'ص 10:10',
      'isMe': false,
    },
    {
      'text': 'نعم هذا مناسب. هل تحتاج إلى المساعدة في إيجاد المكان؟',
      'time': 'ص 10:12',
      'isMe': true,
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
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.userAvatar,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  message['text'],
                  message['time'],
                  message['isMe'],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'اكتب رسالة...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildMessageBubble(String text, String time, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isMe
                  ? const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    )
                  : null,
              color: isMe ? null : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}