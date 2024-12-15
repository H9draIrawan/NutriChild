import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _currentDisplayText = "";
  Timer? _typeTimer;

  @override
  void initState() {
    super.initState();
    // Mengubah pesan selamat datang ke Bahasa Indonesia
    _messages.add(
      ChatMessage(
        text: "Halo! Terima kasih telah menghubungi. Apa yang bisa saya bantu?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    super.dispose();
  }

  void _animateText(String text) {
    if (text.isEmpty) return;
    
    final words = text.split(' ');
    var currentIndex = 0;
    _currentDisplayText = "";

    _typeTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (currentIndex < words.length) {
        setState(() {
          _currentDisplayText += "${words[currentIndex]} ";
          _messages.last = ChatMessage(
            text: _currentDisplayText.trim(),
            isUser: false,
            timestamp: DateTime.now(),
          );
        });
        currentIndex++;
      } else {
        timer.cancel();
        _isLoading = false;
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await http.post(
        Uri.parse('https://api.cohere.ai/v1/chat'),
        headers: {
          'Authorization': 'Bearer gKeFiwYfdepYLdtl9jlHDeg9UVnn6VQ5BofZp3UW',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'model': 'command-nightly',
          'preamble': '''Anda adalah asisten dokter AI yang ahli dalam kesehatan dan gizi.
          Anda harus selalu menjawab dalam Bahasa Indonesia yang mudah dipahami.
          Berikan informasi medis yang akurat dan terpercaya.
          Jika ditanya tentang penyakit serius, selalu sarankan untuk konsultasi ke dokter.
          Fokus pada memberikan informasi kesehatan dan gizi yang bermanfaat.
          Jelaskan istilah medis dengan bahasa yang sederhana.''',
          'temperature': 0.8,
          'connectors': [],
          'chat_history': _messages.take(10).map((msg) => {
            'role': msg.isUser ? 'USER' : 'CHATBOT',
            'message': msg.text,
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['text'] ?? "Maaf, terjadi kesalahan dalam memproses respons.";
        
        setState(() {
          _messages.add(
            ChatMessage(
              text: "",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        
        _animateText(botResponse);
        
      } else {
        print('Error response: ${response.body}');
        throw Exception('Gagal mendapatkan respons: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Maaf, saya sedang mengalami gangguan teknis. Mohon coba beberapa saat lagi.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.medical_services, color: Colors.blue),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dokter Pintar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Konsultasi Kesehatan & Gizi',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.medical_services, color: Colors.blue),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ketik pesan Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: (value) => _sendMessage(value),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
