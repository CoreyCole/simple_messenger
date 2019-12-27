import 'package:flutter/material.dart';

import '../widgets/sign_up_username.dart';
import '../widgets/sign_up_display_name.dart';
import '../widgets/sign_up_button.dart';


class SignUpScreen extends StatelessWidget {
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            SignUpUsername(),
            SignUpDisplayName(),
            SignUpButton(),
          ]
        ),
      ),
    );
  }
}
