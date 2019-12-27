import 'package:flutter/material.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'bloc.dart';
export 'bloc.dart';

class Provider extends InheritedWidget {
  Bloc bloc;

  Provider({
    Key key,
    Widget child,
  }) : 
    bloc = Bloc(),
    super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static Bloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>()).bloc;
  }
}
