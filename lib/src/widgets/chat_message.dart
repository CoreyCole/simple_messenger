import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class ChatMessage extends StatefulWidget {
  final DocumentSnapshot message;

  ChatMessage({ this.message });

  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  build(BuildContext context) {
    return ListTile(
      title: widget.message.data['message']
    );
  }
}
