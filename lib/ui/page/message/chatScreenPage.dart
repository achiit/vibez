import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(ChatScreen());
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sejal '),
        ),
        body: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                        child: Text(
                          "Welcome to the chat!\n\n"
                          "Rules:\n"
                          "- Be respectful and considerate.\n"
                          "- No spamming or flooding the chat.\n"
                          "- Avoid sharing personal information.\n"
                          "- Follow community guidelines.\n"
                          "- To know the commands you can use for chatbot use '/help'"
                          "\nEnjoy your conversation!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _messages[index];
                      },
                    ),
            ),
            Divider(height: 1),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  )),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.link,
                      color: Colors.blue,
                    ),
                    onPressed: _getImageFromGallery,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _uploadImage(pickedFile.path);
    }
  }

  void _uploadImage(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://ao-server-production.up.railway.app/upload'));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);

        setState(() {
          _messages.add(ChatMessage(
            text: responseData['image'],
            isUserMessage: false,
          ));
        });
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _sendMessage() async {
    String message = _messageController.text.trim();
    _messageController.clear();

    if (message.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUserMessage: true,
      ));
    });

    if (message.toLowerCase() == '/help') {
      _sendAllApiRequest();
    } else if (message.toLowerCase() == '/gpt') {
      _sendGptApiRequest();
    } else if (message.toLowerCase() == '/news') {
      _sendNewsApiRequest();
    } else if (message.toLowerCase() == '/price') {
      _sendPriceApiRequest();
    }
  }

  void _sendAllApiRequest() async {
    try {
      var response = await http
          .get(Uri.parse('https://ao-server-production.up.railway.app/all'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          for (var item in responseBody) {
            _messages.add(ChatMessage(
              text: '${item["endpoint"]}: ${item["description"]}',
              isUserMessage: false,
            ));
          }
        });
      } else {
        print('Failed to load response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending API request: $e');
    }
  }

  void _sendPriceApiRequest() async {
    try {
      var response = await http
          .post(Uri.parse('https://ao-server-production.up.railway.app/price'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          for (var item in responseBody) {
            _messages.add(ChatMessage(
              text: '${item["name"]}: \$${item["price"].toStringAsFixed(2)}',
              isUserMessage: false,
            ));
          }
        });
      } else {
        print('Failed to load response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending API request: $e');
    }
  }

  void _sendReceiveApiRequest() async {
    try {
      var response = await http.post(
          Uri.parse('https://ao-server-production.up.railway.app/receive'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          for (var item in responseBody) {
            _messages.add(ChatMessage(
              text: '${item["name"]}: \$${item["price"].toStringAsFixed(2)}',
              isUserMessage: false,
            ));
          }
        });
      } else {
        print('Failed to load response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending API request: $e');
    }
  }

  void _sendGptApiRequest() async {
    try {
      var response = await http
          .get(Uri.parse('https://ao-server-production.up.railway.app/gpt'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body) as String;

        setState(() {
          _messages.add(ChatMessage(
            text: responseBody,
            isUserMessage: false,
          ));
        });
      } else {
        print('Failed to load response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending API request: $e');
    }
  }

  void _sendNewsApiRequest() async {
    try {
      var response = await http
          .post(Uri.parse('https://ao-server-production.up.railway.app/news'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          int articlesToShow = min(5, responseBody.length);
          for (var i = 0; i < articlesToShow; i++) {
            _messages.add(ChatMessage(
              text: responseBody[i],
              isUserMessage: false,
            ));
          }
        });
      } else {
        print('Failed to load response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending API request: $e');
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const ChatMessage({
    required this.text,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isUserMessage ? Colors.blue : Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
