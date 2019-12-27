import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import '../widgets/home_chat_tile.dart';


class HomeScreen extends StatelessWidget {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Messenger'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/new_chat');
        }
      ),
      body: StreamBuilder(
        stream: bloc.messenger.chats,
        builder: (context, snapshot) {
          final List<DocumentSnapshot> chats = snapshot.hasData ? snapshot.data : [];
          final List<Widget> chatTiles = chats.map((chat) => HomeChatTile(chat: chat)).toList();
          return ListView(
            children: chatTiles,
          );
        }
      )
    );
  }
}
