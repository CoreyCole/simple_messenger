import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final Firestore _firestore;

  FirebaseService()
    : _firestore = Firestore.instance;

  /// If `userId` or `chatId` does not exist, an error will be thrown.
  Future<DocumentReference> createMessage(String fromUserId, String chatId, String message) async {
    try {
      final chatDocSnapshot = await getChat(chatId);
      final userDocSnapshot = await getUser(fromUserId);
      if (chatDocSnapshot == null)
        throw 'chatId $chatId does not exist!';
      if (userDocSnapshot == null)
        throw 'userId $fromUserId does not exist!';
      final doc = {
        'timestamp': FieldValue.serverTimestamp(),
        'fromId': fromUserId,
        'message': message,
      };
      final DocumentReference docRef = await _firestore
        .collection('chats')
        .document(chatId)
        .collection('messages')
        .add(doc);
      return docRef;
    } catch (err, stack) {
      print('[FirebaseService][createMessage] ERROR $err\n$stack');
      throw err;
    }
  }

  Stream<QuerySnapshot> messages(String chatId, int limit) {
    try {
      return _firestore
        .collection('chats')
        .document(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
    } catch (err, stack) {
      print('[FirebaseService][messages] ERROR $err\n$stack');
      throw err;
    }
  }

  Future<DocumentReference> createUser(String userId, String username, String publicKey, String displayName) async {
    try {
      final userDocSnapshot = await getUser(userId);
      if (userDocSnapshot != null)
        throw 'userId $userId already exists!';
      final doc = {
        'createdAt': FieldValue.serverTimestamp(),
        'username': username,
        'publicKey': publicKey,
        'displayName': displayName,
      };
      final docRef = _firestore
        .collection('users')
        .document(userId);
      await docRef.setData(doc);
      return docRef;
    } catch (err, stack) {
      print('[FirebaseService][createUser] ERROR $err\n$stack');
      throw err;
    }
  }

  /// Returns snapshot for `userId`
  /// If no document exists, the read will return null.
  Future<DocumentSnapshot> getUser(String userId) async {
    try {
      final doc = await _firestore
        .collection('users')
        .document(userId)
        .get();
      return doc;
    } catch (err, stack) {
      print('[FirebaseService][getUser] ERROR $err\n$stack');
      throw err;
    }
  }

  Future<List<DocumentSnapshot>> searchUsers(String usernameQuery) async {
    try {
      final query = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: usernameQuery)
        .getDocuments();
      return query.documents;
    } catch (err, stack) {
      print('[FirebaseService][searchUsers] ERROR $err\n$stack');
      throw err;
    }
  }

  /// If `userId` does not exist, an error will be thrown.
  Future<DocumentReference> updateUserDisplayName(String userId, String displayName) async {
    try {
      final userDocSnapshot = getUser(userId);
      if (userDocSnapshot == null)
        throw 'userId $userId does not exist!';
      final userDoc = await _firestore
        .collection('users')
        .document(userId);
      userDoc.setData({ 'displayName': displayName }, merge: true);
      return userDoc;
    } catch (err, stack) {
      print('[FirebaseService][updateUserDisplayName] ERROR $err\n$stack');
      throw err;
    }
  }

  Future<bool> usernameExists(String username) async {
    try {
      final query = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
      return query.documents.length != 0;
    } catch (err, stack) {
      print('[FirebaseService][usernameExists] ERROR $err\n$stack');
      throw err;
    }
  }

  /// If no chat is found for `userIds`, the read will return null.
  Future<DocumentSnapshot> chatExists(String userId, List<String> userIds) async {
    try {
      final List<DocumentSnapshot> userChats = await getChats(userId);
      userChats.forEach((chat) {
        final chatUserIds = (chat.data['users'] as List<dynamic>)
          .map((user) => user['userId'])
          .toSet();
        final checkingUserIds = userIds.toSet();
        if (chatUserIds.length == checkingUserIds.length && chatUserIds.containsAll(checkingUserIds)) {
          return chat;
        }
      });
      return null;
    } catch (err, stack) {
      print('[FirebaseService][getChatsByUserIds] ERROR $err\n$stack');
      throw err;
    }
  }

  /// If a chat already exists for `userIds`, a reference will be returned.
  Future<DocumentReference> createChat(String userId, List<String> userIds, String name) async {
    try {
      final exists = await chatExists(userId, userIds);
      if (exists != null) {
        return _firestore.collection('chats').document(exists.documentID);
      }
      final users = userIds.map((userId) {
        return {
          'createdAt': FieldValue.serverTimestamp(),
          'userId': userId
        };
      }).toList();
      final doc = {
        'createdAt': FieldValue.serverTimestamp(),
        'name': name,
        'users': users,
      };
      final docRef = await _firestore
        .collection('chats')
        .add(doc);
      return docRef;
    } catch (err, stack) {
      print('[FirebaseService][createChat] ERROR $err\n$stack');
      throw err;
    }
  }

  /// If `chatId` does not exist, the read will return null.
  Future<DocumentSnapshot> getChat(String chatId) async {
    try {
      final chatDocSnapshot = await _firestore
        .collection('chats')
        .document(chatId)
        .get();
      return chatDocSnapshot;
    } catch (err, stack) {
      print('[FirebaseService][getChat] ERROR $err\n$stack');
      throw err;
    }
  }

  /// Returns snapshots for all chats for `userId`
  Future<List<DocumentSnapshot>> getChats(String userId) async {
    try {
      final chatsQuery = await _firestore
        .collection('chats')
        .where('users.userId', isEqualTo: userId)
        .getDocuments();
      return chatsQuery.documents;
    } catch (err, stack) {
      print('[FirebaseService][getChats] ERROR $err\n$stack');
      throw err;
    }
  }

  /// Returns reference to the chat.
  /// If `userId` or `chatId` does not exist, an error will be thrown.
  Future<DocumentReference> joinChat(userId, chatId) async {
    try {
      final chatDocSnapshot = await getChat(chatId);
      final userDocSnapshot = await getUser(userId);
      if (chatDocSnapshot == null)
        throw 'chatId $chatId does not exist!';
      if (userDocSnapshot == null)
        throw 'userId $userId does not exist!';
      final chatRef = _firestore
        .collection('chats')
        .document(chatId);
      
      await chatRef
        .collection('users')
        .add({
          'createdAt': FieldValue.serverTimestamp(),
          'userId': userId
        });
      return chatRef;
    } catch (err, stack) {
      print('[FirebaseService][joinChat] ERROR $err\n$stack');
      throw err;
    }
  }

  /// Returns reference to the chat.
  /// If `userId` or `chatId` does not exist, an error will be thrown.
  Future<DocumentReference> leaveChat(String userId, String chatId) async {
    try {
      final chatDocSnapshot = await getChat(chatId);
      final userDocSnapshot = await getUser(userId);
      if (chatDocSnapshot == null)
        throw 'chatId $chatId does not exist!';
      if (userDocSnapshot == null)
        throw 'userId $userId does not exist!';
      final chatRef = _firestore
        .collection('chats')
        .document(chatId);
      final chatUsers = await chatRef
        .collection('users')
        .where('userId', isEqualTo: userId)
        .getDocuments();

      // should only be 1, but loop just in case of duplicates
      chatUsers.documents.forEach((user) {
        _firestore
          .collection('chats')
          .document(chatId)
          .collection('users')
          .document(user.documentID)
          .delete();
      });
      return chatRef;
    } catch (err, stack) {
      print('[FirebaseService][leaveChat] ERROR $err\n$stack');
      throw err;
    }
  }

  /// If `chatId` does not exist, an error will be thrown.
  Future<DocumentReference> updateChatName(String chatId, String name) async {
    try {
      final chatDoc = _firestore.collection('chats').document(chatId).get();
      if (chatDoc == null)
        throw 'chatId $chatId does not exist!';
      final chatRef = _firestore
          .collection('chats')
          .document(chatId);
      await chatRef.setData({ 'name': name }, merge: true);
      return chatRef;
    } catch (err, stack) {
      print('[FirebaseService][updateChatName] ERROR $err\n$stack');
      throw err;
    }
  }
}
