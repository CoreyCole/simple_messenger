import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget {
  build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
