import 'package:flutter/material.dart';

import 'bloc/provider.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/new_chat_screen.dart';
import 'screens/sign_up_screen.dart';


class App extends StatelessWidget {
  Widget build(context) {
    return Provider(
      child: MaterialApp(
        title: 'Simple Messenger',
        onGenerateRoute: _routes,
        debugShowCheckedModeBanner: false,
      )
    );
  }

  Route _routes(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        final bloc = Provider.of(context);
        return SafeArea(
          child: StreamBuilder(
            stream: bloc.globals.loading,
            builder: (context, snapshot) {
              final loading = !snapshot.hasData
                || (snapshot.hasData && snapshot.data);
              if (loading) {
                return LoadingScreen();
              } else {
                return _handleRoute(settings);
              }
            }
          )
        );
      }
    );
  }

  Widget _handleRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/': {
        // TODO: remove
        return ChatScreen();
        // return LandingScreen();
      }
      case '/sign_up': {
        return SignUpScreen();
      }
      case '/home': {
        return HomeScreen();
      }
      case '/new_chat': {
        return NewChatScreen();
      }
      case '/chat': {
        return ChatScreen();
      }
      default: {
        return LandingScreen();
      }
    }
  }
}
