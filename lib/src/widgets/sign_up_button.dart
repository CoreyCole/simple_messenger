import 'package:flutter/material.dart';

import '../bloc/provider.dart';


class SignUpButton extends StatefulWidget {
  _SignUpButtonState createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return RaisedButton(
      child: Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.white
        )
      ),
      color: Theme.of(context).primaryColor,
      onPressed: () async {
        try {
          final handle = bloc.auth.signUpUsername.value;
          final displayName = bloc.auth.signUpDisplayName.value;
          final publicKey = bloc.crypto.publicKey.value;
          await bloc.auth.signUp(handle, publicKey, displayName);
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        } catch (err, stack) {
          bloc.globals.error.sink.add(err.toString());
          print('[SignUpButton] ERROR $err\n$stack');
        }
      },
    );
  }
}
