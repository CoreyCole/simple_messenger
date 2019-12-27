import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'firebase_service.dart';
import 'auth_service.dart';
import 'encryption_service.dart';


class MessengerService {
  final FirebaseService firebaseService;
  final AuthService authService;
  final EncryptionService encryptionService;

  final BehaviorSubject<String> currentChatId;
  final BehaviorSubject<int> messageLimit;

  final BehaviorSubject<String> usernameQueryInput;
  final BehaviorSubject<String> messageInput;

  MessengerService({
    @required this.firebaseService,
    @required this.authService,
    @required this.encryptionService
  }) :
    currentChatId = BehaviorSubject<String>.seeded(null),
    messageLimit = BehaviorSubject<int>.seeded(20),
    usernameQueryInput = BehaviorSubject<String>.seeded(''),
    messageInput = BehaviorSubject<String>.seeded('');

  Stream<List<DocumentSnapshot>> get chats => authService.userId
    .switchMap((userId) {
      if (userId == null) return Future.value([]).asStream();
      return firebaseService.getChats(userId).asStream()
        .map((chats) {
          return chats.map((chat) {
            chat.data['displayName'] = chatDisplayName(chat);
            return chat;
          }).toList();
        });
    });
  Stream<DocumentSnapshot> get currentChat => currentChatId
    .switchMap((chatId) {
      if (chatId == null) return Future.value(null).asStream();
      return firebaseService.getChat(chatId).asStream();
    });
  Stream<String> chatDisplayName(DocumentSnapshot chat) {
    if (chat == null) return Future.value('').asStream();
    if (chat.data['name'] != null && chat.data['name'] != '') return chat['name'];
    return authService.userId.switchMap((myUserId) {
      final chatUsers = (chat.data['users'] as List<dynamic>)
        .where((user) => user['userId'] != myUserId)
        .toSet();
      return firebaseService.getUser(chatUsers.first['userId']).asStream()
        .map((user) {
          final firstUsername = user.data['username'];
          if (chatUsers.length == 1) {
            // 1-on-1 chat
            return '@$firstUsername';
          } else {
            // group chat
            final otherUserCount = chatUsers.length - 1;
            return '@$firstUsername +$otherUserCount';
          }
        });
    });
  }
  Stream<String> get currentChatDisplayName => currentChat
    .switchMap((chat) => chatDisplayName(chat));
  Stream<List<DocumentSnapshot>> get messages => currentChatId
    .switchMap((chatId) {
      if (chatId == null) return Future.value([]).asStream();
      return messageLimit.switchMap((limit) => firebaseService
        .messages(chatId, limit)
        .map((query) => query.documents)
      );
    });
  Stream<List<DocumentSnapshot>> get usernameQueryResult => usernameQueryInput
    .switchMap((query) {
      if (query.length < 2) return Future.value([]).asStream();
      return firebaseService.searchUsers(query).asStream();
    });

  /// If a chat already exists between the `userIds`, a reference to it will be returned.
  Future<DocumentReference> createChat(List<String> userIds, { String name = '' }) async {
    try {
      final user = authService.user.value;
      if (user == null)
        throw 'user not authenticated!';
      final userId = user.uid;
      final chatDoc = await firebaseService.createChat(userId, userIds, name);
      return chatDoc;
    } catch (err, stack) {
      print('[MessengerService][createChat] ERROR = $err\n$stack');
      throw err;
    }
  }

  Future<DocumentReference> createMessage(String message) {
    final user = authService.user.value;
    if (user == null)
      throw 'user not authenticated!';
    final encryptedMessage = encryptionService.encrypt(message);
    final chatId = currentChatId.value;
    final userId = user.uid;
    firebaseService.createMessage(userId, chatId, encryptedMessage);
  }

  void openChat(String chatId) async {
    messageLimit.sink.add(20);
    currentChatId.sink.add(chatId);
  }

  void leaveChat() {
    currentChatId.sink.add(null);
    messageLimit.sink.add(20);
  }

  void dispose() {
    leaveChat();
    currentChatId.close();
  }
}
