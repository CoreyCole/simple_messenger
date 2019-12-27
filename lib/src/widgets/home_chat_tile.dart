import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class HomeChatTile extends StatefulWidget {
  final DocumentSnapshot chat;
  
  HomeChatTile({ this.chat });

  _HomeChatTileState createState() => _HomeChatTileState();
}

class _HomeChatTileState extends State<HomeChatTile> {
  final textController = TextEditingController();

  build(BuildContext context) {
    final bloc = Provider.of(context);
    return ListTile(
      title: widget.chat.data['displayName'],
      onTap: () {
        bloc.messenger.openChat(widget.chat.documentID);
        Navigator.of(context).pushNamed('/chat');
      },
    );
  }
}
