import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class NewChatAutocompleteTile extends StatefulWidget {
  final DocumentSnapshot user;

  NewChatAutocompleteTile({ this.user });

  _NewChatAutocompleteTileState createState() => _NewChatAutocompleteTileState();
}

class _NewChatAutocompleteTileState extends State<NewChatAutocompleteTile> {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return ListTile(
      title: widget.user.data['username'],
      subtitle: widget.user.data['displayName'],
      onTap: () async {
        try {
          final userIds = [bloc.auth.userId, widget.user.documentID];
          final chatRef = await bloc.messenger.createChat(userIds);
          bloc.messenger.openChat(chatRef.documentID);
          Navigator.of(context).pushNamed('/chat');
        } catch (err, stack) {
          bloc.globals.error.sink.add(err.toString());
          print('[NewChatAutocompleteTile] ERROR $err\n$stack');
        } 
      },
    );
  }
}
