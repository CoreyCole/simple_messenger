import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class SignUpDisplayName extends StatefulWidget {
  _SignUpDisplayNameState createState() => _SignUpDisplayNameState();
}

class _SignUpDisplayNameState extends State<SignUpDisplayName> {
  final textController = TextEditingController();

  build(BuildContext context) {
    final bloc = Provider.of(context);
    textController.addListener(() {
      bloc.auth.signUpDisplayNameInput.sink.add(textController.text);
    });
    return TextField(
      controller: textController,
      decoration: InputDecoration(hintText: 'Display Name'),
    );
  }
}
