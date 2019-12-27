import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import 'chat_message.dart';


class ChatMessages extends StatefulWidget {
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return StreamBuilder(
      stream: bloc.messenger.messages,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (!snapshot.hasData) return SizedBox();
        final List<Widget> messages = snapshot.data.map((message) {
          return ChatMessage(message: message);
        }).toList();
        return ListView(
          children: messages,
        );
      }
    );
  }
}
