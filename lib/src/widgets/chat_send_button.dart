import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import 'chat_message.dart';


class ChatSendButton extends StatefulWidget {
  _ChatSendButtonState createState() => _ChatSendButtonState();
}

class _ChatSendButtonState extends State<ChatSendButton> {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return StreamBuilder(
      stream: bloc.messenger.messageInput,
      builder: (context, AsyncSnapshot<String> snapshot) {
        final disabled = !snapshot.hasData || snapshot.data == '';
        return IconButton(
          icon: new Icon(Icons.send),
          onPressed: disabled ? null : () {
            try {
              final message = bloc.messenger.messageInput.value;
              bloc.messenger.createMessage(message);
            } catch (err, stack) {
              bloc.globals.error.sink.add(err.toString());
              print('[ChatSendButton] ERROR $err\n$stack');
            }
          }
        );
      }
    );
  }
}
