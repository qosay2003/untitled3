import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName; // اسم المستخدم
  final String userImage; // مسار صورة المستخدم
  const ChatScreen(
      {super.key, required this.userName, required this.userImage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    // رسائل افتراضية للاختبار
    {'text': 'مرحبًا، كيف الحال؟', 'isMe': false, 'time': '01:30 AM'},
    {'text': 'تمام، وأنت؟', 'isMe': true, 'time': '01:32 AM'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // دالة لإرسال رسالة جديدة
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isMe': true,
          'time': _getCurrentTime(),
        });
        _messageController.clear();
      });
    }
  }

  // دالة للحصول على الوقت الحالي
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAAAAAA),
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                widget.userName,
                style: TextStyle(
                  color: Color(0xFF0B5022),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.userImage),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFAAAAAA),
      body: SafeArea(
        child: Stack(
          children: [
            // شعار التطبيق في الخلفية
            Center(
              child: Image.asset(
                'img/greenlogo.png',
                width: 400,
                height: 800,
                fit: BoxFit.contain,
                opacity: AlwaysStoppedAnimation(0.6),
              ),
            ),
            // قائمة الرسائل وحقل الإدخال
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true, // الرسائل الجديدة تظهر في الأسفل
                    padding: EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[
                          _messages.length - 1 - index]; // عكس الترتيب
                      return _buildMessageBubble(
                        message['text'],
                        message['isMe'],
                        message['time'],
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText: 'اكتب رسالتك...',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Color(0xFF0B5022),
                        ),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // دالة لبناء فقاعة الرسالة
  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? Color(0xFF0B5022) : Colors.grey[300],
          borderRadius: BorderRadius.circular(16).copyWith(
            topRight: isMe ? Radius.zero : Radius.circular(16),
            topLeft: isMe ? Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
