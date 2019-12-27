import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class SignUpUsername extends StatefulWidget {
  _SignUpUsernameState createState() => _SignUpUsernameState();
}

class _SignUpUsernameState extends State<SignUpUsername> {
  final textController = TextEditingController();

  build(BuildContext context) {
    final bloc = Provider.of(context);
    textController.addListener(() {
      bloc.auth.signUpUsernameInput.sink.add(textController.text);
    });
    return TextField(
      controller: textController,
      decoration: InputDecoration(hintText: '@handle'),
    );
  }
}
