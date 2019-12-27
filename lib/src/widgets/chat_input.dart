import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import '../widgets/chat_send_button.dart';


class ChatInput extends StatefulWidget {
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final textController = TextEditingController();

  build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 8, child: _textInput()),
        Expanded(flex: 2, child: ChatSendButton()),
      ]
    );
  }

  _textInput() {
    return TextField(
      style: TextStyle(
        fontSize: 15.0
      ),
      controller: textController,
      decoration: InputDecoration.collapsed(
        hintText: 'Type your message...',
      ),
    );
  }
}
