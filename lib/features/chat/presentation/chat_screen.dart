import 'package:flutter/material.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/chat_message.dart';
import 'package:admit_ai/core/services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ChatScreen({super.key, required this.userProfile});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final AiService _aiService = AiService();

  @override
  void initState() {
    super.initState();

    _messages.add(
      ChatMessage(
        text:
            'Hi! I am your AdmitAI assistant. Ask me about your plan or exams.',
        isUser: false,
      ),
    );
  }

  Future<void> _sendMessage() async{
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });

    _scrollToBottom();

    _controller.clear();

    final response = await _aiService.sendMessage(text);

    setState(() {
      _messages.add(ChatMessage(text: response, isUser: false));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendQuickMessage(String text) {
    _controller.text = text;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.blue
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_messages.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                children: [
                  _QuickButton(
                    text: 'Build my plan',
                    onTap: () => _sendQuickMessage('build my plan'),
                  ),
                  _QuickButton(
                    text: 'What exams do I need?',
                    onTap: () => _sendQuickMessage('what exams do i need'),
                  ),
                ],
              ),
            ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask something...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _QuickButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(text), onPressed: onTap);
  }
}
