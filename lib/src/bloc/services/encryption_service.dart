import 'package:crypto/crypto.dart';
import 'package:rxdart/rxdart.dart';


class EncryptionService {
  final BehaviorSubject<String> publicKey;

  EncryptionService() :
    publicKey = BehaviorSubject<String>.seeded(null);

  /// returns encrpyted output
  String encrypt(String input) {
    try {
      return input;
    } catch (err, stack) {
      print('[EncryptionService][encrypt] ERROR $err\n$stack');
      throw err;
    }
  }
}
