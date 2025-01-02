import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controller/message.dart';
import '../dbConnection/dbConnection.dart';

class AIChatPage extends StatelessWidget {
  const AIChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Tour',
                  style: TextStyle(
                      color: Color(0xff0b036c),
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                ),
                TextSpan(
                  text: 'Ease',
                  style: TextStyle(
                      color: Color(0xffe80000),
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                )
              ],
            )
        ),
      ),
      body: Column(
        children: [
          _buildChatHeader(context), // First widget
          const Expanded(child: ChatScreen()), // Second widget takes up remaining space
        ],
      ),
    );
  }
// Chat Header with Avatar, Active Status, and Close Button
  Widget _buildChatHeader(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.android, color: Colors.blue),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI CHAT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Active now',
                          style: TextStyle(
                            color: Colors.green.shade300,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        )
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userInput = TextEditingController();
  final List<Message> _messages = [];
  bool isLoading = false;

  Future<void> sendMessage() async {
    final message = _userInput.text;
    _userInput.clear();
    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });
    if (message.isEmpty) return;

    setState(() {
      isLoading = true;
      _messages.add(Message(isUser: false, message: "...", date: DateTime.now(), isLoading: true));
    });

    // Replace with your OpenAI API Key
    const openAIKey = openAPIkey;
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIKey',
      },
      body: jsonEncode({
        "model": "gpt-4o",
        //"model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ]
      }),
    );

    setState(() {
      isLoading = false;
      _messages.removeWhere((msg) => msg.isLoading);
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final reply = responseData['choices'][0]['message']['content'];
      setState(() {
        _messages.add(Message(isUser: false, message: reply ?? "", date: DateTime.now()));
      });
    } else {
      setState(() {
        _messages.add(Message(isUser: false, message: "Failed to get response from OpenAI", date: DateTime.now()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Messages(
                isUser: message.isUser,
                message: message.message,
                date: message.date,
                isLoading: message.isLoading,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 15,
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: _userInput,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text('Enter Your Message'),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                padding: const EdgeInsets.all(12),
                iconSize: 30,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(const CircleBorder()),
                ),
                onPressed: isLoading ? null : sendMessage,
                icon: isLoading
                    ? Container(width: 24, height: 24, child: const CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send),
              )
            ],
          ),
        )
      ],
    );
  }
}

