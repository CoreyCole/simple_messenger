import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_service.dart';
import 'encryption_service.dart';


class AuthService {
  final FirebaseAuth _auth;

  final LocalStorage storage;
  final FirebaseService firebaseService;
  final EncryptionService encryptionService;

  final BehaviorSubject<FirebaseUser> user;

  final BehaviorSubject<String> signUpUsernameInput;
  final BehaviorSubject<String> signUpDisplayNameInput;

  AuthService({
    @required this.storage,
    @required this.firebaseService,
    @required this.encryptionService,
  }) :
      _auth = FirebaseAuth.fromApp(firebaseService.firebaseApp),
      user = BehaviorSubject<FirebaseUser>.seeded(null),
      signUpUsernameInput = BehaviorSubject<String>.seeded(''),
      signUpDisplayNameInput = BehaviorSubject<String>.seeded('') {
    _auth.currentUser().then((firebaseUser) async {
      if (firebaseUser == null) {
        print('[AuthService] anonymous sign in');
        await _auth.signInAnonymously();
      } else {
        print('[AuthService] already authenticated');
      }
    });
    _auth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
        print('[AuthService] uid = ${firebaseUser.uid}');
      }
      user.sink.add(firebaseUser);
    });
  }

  Stream<bool> get isAuthenticated => user.stream
    .map((firebaseUser) => firebaseUser != null);
  Stream<String> get userId => user.stream
    .map((firebaseUser) => firebaseUser.uid);
  Stream<DocumentSnapshot> get userDocument => userId
    .switchMap((userId) => firebaseService.getUser(userId).asStream());
  Stream<String> get username => userDocument
    .map((userDocument) => userDocument.data['username']);

  /// If `handle` already exists, an error will be thrown.
  /// If `publicKey` is null, an error will be thrown. 
  Future<void> signUp(String handle, String publicKey, String displayName) async {
    try {
      if (user.value == null)
        throw 'user not authenticated!';
      final nameTaken = await firebaseService.usernameExists(handle);
      if (nameTaken)
        throw 'username $handle already taken!';
      if (publicKey == null || publicKey == '')
        throw 'publicKey cannot be empty!';
      final newUserId = user.value.uid;
      await firebaseService.createUser(
        newUserId,
        handle,
        publicKey,
        displayName
      );
    } catch (err, stack) {
      print('[AuthService][signUp] ERROR $err\n$stack');
      throw err;
    }
  }

  dispose() {
    user.close();
    signUpUsernameInput.close();
    signUpDisplayNameInput.close();
  }
}
