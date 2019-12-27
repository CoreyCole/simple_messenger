import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class NewChatButton extends StatefulWidget {
  _NewChatButtonState createState() => _NewChatButtonState();
}

class _NewChatButtonState extends State<NewChatButton> {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return RaisedButton(
      child: Text(
        'Start',
        style: TextStyle(
          color: Colors.white
        )
      ),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        try {
          final username = bloc.messenger.usernameQueryInput.value;
          bloc.messenger.currentChatId.sink.add(username);
          Navigator.of(context).pushNamed('/chat');
        } catch (err, stack) {
          bloc.globals.error.sink.add(err.toString());
          print('[NewChatButton] ERROR $err\n$stack');
        }
      },
    );
  }
}
