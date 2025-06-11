import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // لاستخدام SocketException
import 'package:intl/intl.dart';

class ChatScreenai extends StatefulWidget {
  const ChatScreenai({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenai> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String _apiKey = 'AIzaSyDE-TO8Q-KS89FDmM2M3y1z1Bql08tdOBY';
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _sendMessage(String message) async {
    final timestamp = DateFormat('hh:mm a').format(DateTime.now());
    setState(() {
      _messages
          .add({'sender': 'user', 'text': message, 'timestamp': timestamp});
      _textController.clear();
      _isTyping = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text':
                  'You are a helpful assistant. Respond in Arabic. ' + message
            }
          ]
        }
      ]
    });

    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: 10));

      setState(() {
        _isTyping = false;
      });

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final geminiResponse =
            decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _messages.add({
            'sender': 'gemini',
            'text': geminiResponse,
            'timestamp': DateFormat('hh:mm a').format(DateTime.now())
          });
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'error',
            'text': 'Error: ${response.statusCode} - ${response.body}',
            'timestamp': timestamp
          });
        });
      }
    } on SocketException {
      setState(() {
        _isTyping = false;
        _messages.add({
          'sender': 'error',
          'text': 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.',
          'timestamp': timestamp
        });
      });
    } on TimeoutException {
      setState(() {
        _isTyping = false;
        _messages.add({
          'sender': 'error',
          'text': 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.',
          'timestamp': timestamp
        });
      });
    } catch (error) {
      setState(() {
        _isTyping = false;
        _messages.add(
            {'sender': 'error', 'text': 'خطأ: $error', 'timestamp': timestamp});
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAAAAAA),
        actions: [
          Text(
            'دردشة مع الذكاء الإصطناعي',
            style: TextStyle(
              color: Color(0xFF0B5022),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
          SizedBox(width: 20),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0B5022)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // صورة الخلفية
          Positioned.fill(
            child: Image.asset(
              width: 400,
              height: 400,
              'img/greenlogo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Color(0xFFAAAAAA), // الخلفية الاحتياطية
                child: Center(
                  child: Text(
                    'فشل تحميل صورة الخلفية',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                  ),
                ),
              ),
            ),
          ),
          // طبقة شفافية لتحسين رؤية العناصر
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // شفافية سوداء بنسبة 50%
            ),
          ),
          // محتوى الصفحة
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(8.0),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == _messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF0B5022),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Gemini يكتب...',
                                style: TextStyle(
                                  color: Color(0xFF0B5022),
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "IBMPlexSansArabic",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final message = _messages[index];
                    final isUser = message['sender'] == 'user';
                    final isError = message['sender'] == 'error';

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Color(0xFF0B5022)
                              : isError
                                  ? Colors.red.withOpacity(0.2)
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['text']!,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontFamily: "IBMPlexSansArabic",
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              message['timestamp']!,
                              style: TextStyle(
                                color: isUser ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                                fontFamily: "IBMPlexSansArabic",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                color: Color(0xFFAAAAAA),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك...',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontFamily: "IBMPlexSansArabic",
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _sendMessage(value.trim());
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.send, color: Color(0xFF0B5022)),
                      onPressed: () {
                        if (_textController.text.trim().isNotEmpty) {
                          _sendMessage(_textController.text.trim());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
