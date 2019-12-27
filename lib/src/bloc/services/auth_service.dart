import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_service.dart';
import 'encryption_service.dart';


class AuthService {
  // final FirebaseAuth _auth;

  final LocalStorage storage;
  final FirebaseService firebaseService;
  final EncryptionService encryptionService;

  final BehaviorSubject<String> username;
  final BehaviorSubject<String> userId;

  final BehaviorSubject<String> signUpUsername;
  final BehaviorSubject<String> signUpDisplayName;

  AuthService({
    @required this.storage,
    @required this.firebaseService,
    @required this.encryptionService,
  }) :
      // _auth = FirebaseAuth(),
      username = BehaviorSubject<String>.seeded(null),
      userId = BehaviorSubject<String>.seeded(null),
      signUpUsername = BehaviorSubject<String>.seeded(''),
      signUpDisplayName = BehaviorSubject<String>.seeded('') {
    storage.ready.then((_) async {
      await storage.clear();
      final storedUsername = storage.getItem('username');
      print('[AuthService] username = $storedUsername');
      username.sink.add(storedUsername);
    });
  }

  Stream<bool> get isAuthenticated => username.stream
    .map((usernameData) => usernameData != null);

  /// If `handle` already exists, an error will be thrown.
  /// If `publicKey` is null, an error will be thrown. 
  Future<void> signUp(String handle, String publicKey, String displayName) async {
    try {
      final nameTaken = await firebaseService.usernameExists(handle);
      if (nameTaken)
        throw 'username $handle already taken!';
      if (publicKey == null || publicKey == '')
        throw 'publicKey cannot be empty!';
      // final user = _auth.anonymousSignIn();
      // final userId = user.id;
      final newUserId = 'test-user-id';
      await firebaseService.createUser(
        newUserId,
        handle,
        publicKey,
        displayName
      );
      await storage.setItem('username', handle);
      await storage.setItem('userId', newUserId);
      await storage.setItem('publicKey', publicKey);
      username.sink.add(handle);
      userId.sink.add(newUserId);
    } catch (err, stack) {
      print('[AuthService][signUp] ERROR $err\n$stack');
      throw err;
    }
  }

  dispose() {
    username.close();
    userId.close();
  }
}
