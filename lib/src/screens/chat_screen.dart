import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import '../widgets/chat_messages.dart';


class ChatScreen extends StatelessWidget {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        bloc.messenger.leaveChat();
        return true;
      },
      child: Scaffold(
        appBar: _appBar(context, bloc),
        body: Column(
          children: [
            Expanded(flex: 9, child: ChatMessages()),
            Expanded(flex: 1, child: SizedBox()),
          ]
        ),
      )
    );
  }

  _appBar(BuildContext context, Bloc bloc) {
    return AppBar(
      title: StreamBuilder(
        stream: bloc.messenger.currentChatDisplayName,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return SizedBox();
          return Text(snapshot.data);
        }
      )
    );
  }
}
