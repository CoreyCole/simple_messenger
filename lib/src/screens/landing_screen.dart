import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import 'home_screen.dart';
import 'sign_up_screen.dart';


class LandingScreen extends StatelessWidget {
  build(BuildContext context) {
    final bloc = Provider.of(context);
    return StreamBuilder(
      stream: bloc.auth.isAuthenticated,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        final authenticated = snapshot.hasData && snapshot.data;
        if (authenticated) {
          return HomeScreen();
        } else {
          return SignUpScreen();
        }
      }
    );
  }
}
