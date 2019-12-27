import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class NewChatUsername extends StatefulWidget {
  _NewChatUsernameState createState() => _NewChatUsernameState();
}

class _NewChatUsernameState extends State<NewChatUsername> {
  final textController = TextEditingController();

  build(BuildContext context) {
    final bloc = Provider.of(context);
    textController.addListener(() {
      bloc.messenger.usernameQueryInput.sink.add(textController.text);
    });
    return TextField(
      controller: textController,
      decoration: InputDecoration(hintText: '@handle'),
    );
  }
}
