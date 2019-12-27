import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import 'new_chat_autocomplete_tile.dart';


class NewChatAutocomplete extends StatefulWidget {
  _NewChatAutocompleteState createState() => _NewChatAutocompleteState();
}

class _NewChatAutocompleteState extends State<NewChatAutocomplete> {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return StreamBuilder(
      stream: bloc.messenger.usernameQueryResult,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        final List<DocumentSnapshot> suggestions = snapshot.hasData ? snapshot.data : [];
        final List<Widget> suggestionTiles = suggestions
          .map((suggestion) => NewChatAutocompleteTile(user: suggestion))
          .toList();
        return ListView(
          children: suggestionTiles
        );
      }
    );
  }
}
