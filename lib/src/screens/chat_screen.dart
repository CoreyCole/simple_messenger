import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import '../widgets/chat_messages.dart';


class ChatScreen extends StatelessWidget {
  build(BuildContext context) {
    final bloc = Provider.of(context);

    // TODO: remove
    bloc.messenger.currentChatId.sink.add('test-chatId');
    bloc.auth.userId.sink.add('test-userId');
    bloc.auth.username.sink.add('test-username');

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
