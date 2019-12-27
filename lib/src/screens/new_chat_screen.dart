import 'package:flutter/material.dart';

import '../widgets/new_chat_username.dart';
import '../widgets/new_chat_button.dart';
import '../widgets/new_chat_autocomplete.dart';


class NewChatScreen extends StatelessWidget {
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat')
      ),
      body: Container(
        margin:EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 8, child: NewChatUsername()),
                Expanded(flex: 2, child: NewChatButton()),
              ]
            ),
            NewChatAutocomplete(),
          ],
        ),
      ),
    );
  }
}
