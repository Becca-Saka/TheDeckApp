import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/foundation.dart';
import 'package:thedeck/models/match_details/match_details.dart';
import 'package:thedeck/models/message_details/message_details.dart';
import 'package:thedeck/models/user_details/user_details.dart';

class ChatService {
  final messagecollection = FirebaseFirestore.instance.collection("Messages");
  final firestoreInstance = FirebaseFirestore.instance;
  final usercollection = FirebaseFirestore.instance.collection("Users");
  final deckcollection = FirebaseFirestore.instance.collection("Decks");

  Future<String> saveChatImage(String path, String id) async {
    storage.Reference storageReference = storage.FirebaseStorage.instance
        .ref()
        .child('Decks')
        .child(id)
        .child('Chats')
        .child('${Timestamp.now().microsecondsSinceEpoch}');

    final storage.UploadTask uploadTask = storageReference.putFile(File(path));
    final storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Future<void> updateReadMessage(String uid, String user) async {
    await deckcollection.doc(uid).update(
      {
        '${user}Unread': [],
        'isRead': true,
        'unReadCount': 0,
      },
    );
  }

  Future<MatchDetails> sendMessage(String message, MatchDetails chatDetails,
      UserDetails userToMessage, String uid,
      {bool hasImage = false, String? imagePath}) async {
    final docs = deckcollection.doc(chatDetails.uid);

    final chatDoc = docs.collection('Chats').doc();

    final messageDetail = Message(
        uid: chatDoc.id,
        senderId: uid,
        message: message,
        isImage: hasImage,
        time: FieldValue.serverTimestamp());
    if (hasImage) {
      messageDetail.imageUrl = await saveChatImage(imagePath!, chatDoc.id);
    }
    final otherUser = chatDetails.users.firstWhere((element) => element != uid);
    final chatDetailsJson = {
      'messageId': uid,
      'recentmessage': message,
      'recentMessageTime': FieldValue.serverTimestamp(),
      '${otherUser}Unread': FieldValue.arrayUnion([
        chatDoc.id,
      ]),
    };

    await chatDoc
        .set(messageDetail.toJson())
        .whenComplete(() async => await docs.update(chatDetailsJson))
        .whenComplete(() async {
      if (userToMessage.recieveMessageNotification == true &&
          userToMessage.fcmToken != null) {
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('sendNewMessageAlert');
        callable.call({
          'path': userToMessage.fcmToken,
          'name': userToMessage.name,
        }).then((value) => debugPrint('value: ${value.data}'));
      }
      return;
    });

    return chatDetails;
  }

  Stream<List<Message>> getMessage(String uid) {
    return deckcollection
        .doc(uid)
        .collection('Chats')
        .orderBy(
          'time',
        )
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromJson(e.data())).toList())
        .asBroadcastStream();
  }
}
