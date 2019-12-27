import 'package:firebase_core/firebase_core.dart';
import 'package:localstorage/localstorage.dart';

import 'services/auth_service.dart';
import 'services/encryption_service.dart';
import 'services/firebase_service.dart';
import 'services/globals_service.dart';
import 'services/messenger_service.dart';

/// The Business logic component
class Bloc {
  final FirebaseApp firebaseApp = FirebaseApp(name: 'DEFAULT');
  LocalStorage storage;

  AuthService auth;
  EncryptionService crypto;
  FirebaseService firebase;
  GlobalsService globals;
  MessengerService messenger;

  Bloc() {
    storage = LocalStorage('storage.json');
    firebase = FirebaseService(firebaseApp: firebaseApp);
    crypto = EncryptionService();
    globals = GlobalsService();
    auth = AuthService(storage: storage, firebaseService: firebase, encryptionService: crypto);
    messenger = MessengerService(firebaseService: firebase, authService: auth, encryptionService: crypto);
  }

  dispose() {
    globals.dispose();
    messenger.dispose();
  }
}
