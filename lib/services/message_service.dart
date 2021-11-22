import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/messages/message.dart';
import 'package:uuid/uuid.dart';

class MessageService {
  CollectionReference conversationRef =
      FirebaseFirestore.instance.collection('conversations');

  Future sendMessage(String conversationID, Message message) async {
    DocumentReference conversationRef = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationID);

    Map<String, dynamic> newMessage = {};
    newMessage['message_content'] = message.lastMessageContent;
    newMessage['senderID'] = message.senderID;
    newMessage['sentTime'] = message.sentTime;

    switch (message.messageType) {
      case MessageType.Text:
        newMessage['message_type'] = 'text';
        break;
      case MessageType.Image:
        newMessage['message_type'] = 'image';
        break;
      case MessageType.Video:
        newMessage['message_type'] = 'video';
        break;
      case MessageType.GIF:
        newMessage['message_type'] = 'gif';
        break;
      case MessageType.Voice:
        newMessage['message_type'] = 'voice';
        break;
      default:
        newMessage['message_type'] = 'text';
        break;
    }
    await conversationRef.update({
      'messages': FieldValue.arrayUnion([newMessage])
    });
  }

  Future sendNewMessage(String receiverID, String? imageURL,
      String? messageContent, Function setNewConversation) async {
    String conversationID = Uuid().v4();
    var conversationRef =
        FirebaseFirestore.instance.collection('conversations').doc();

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationID)
        .set(
      {
        'conversationID': conversationRef.id,
        'members': [
          SignedAccount.instance.id,
          receiverID,
        ],
        'ownerID': SignedAccount.instance.id,
        'messages': [
          {
            'senderID': SignedAccount.instance.id,
            'message_content': imageURL == null ? messageContent : imageURL,
            'sentTime': DateTime.now(),
            'message_type': imageURL == null ? 'text' : 'image',
          }
        ],
      },
    );

    onCreateConversation(conversationID);
    setNewConversation(conversationID);
  }

  Future<String> sendImage(String userID, File imageFile) async {
    Reference storageReferences = FirebaseStorage.instance.ref();
    String imageFileID = new Uuid().v4();
    late String imageURL;
    try {
      //imageFile = await compressImage(imageFile, imageFileID);
      UploadTask uploadTask = storageReferences
          .child('images')
          .child(userID)
          .child('message')
          .child("message_$imageFileID")
          .putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      imageURL = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
    return imageURL;
  }

  Future<String?> createOrGetConversation(
      String senderID, String receiverID) async {
    CollectionReference userConversation = FirebaseFirestore.instance
        .collection('users')
        .doc(senderID)
        .collection('Conversations');

    var conversation = await userConversation.doc(receiverID).get();

    if (conversation.data() != null) {
      return conversation['conversationID'];
    } else {
      return null;
    }
  }

  void onCreateConversation(String conversationID) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationID)
        .get();

    List<String> memberIDsArray = List<String>.from(snapshot['members']);

    var messageList = snapshot['messages'];
    var lastMessage = messageList[messageList.length - 1];

    DocumentSnapshot senderDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(lastMessage['senderID'])
        .get();

    for (int i = 0; i < memberIDsArray.length; i++) {
      String currUserID = memberIDsArray[i];
      List<String> otherUserIDsArray =
          List<String>.from(memberIDsArray.where((otherID) {
        if (otherID != currUserID) {
          return true;
        } else {
          return false;
        }
      }));

      for (String otherUserID in otherUserIDsArray) {
        if (messageList.length > 2) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currUserID.toString())
              .collection("GroupConversations")
              .doc(conversationID)
              .set({
            "conversationID": conversationID,
            "photoUrl": senderDocument['photoUrl'],
            "displayName": senderDocument['displayName'],
            "senderID": lastMessage.senderID,
            "lastMessage_content": lastMessage.message_content,
            "sentTime": lastMessage.sentTime,
            "unseenCount": FieldValue.increment(1),
            "message_type": lastMessage.message_type,
          });
        } else {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currUserID.toString())
              .collection("Conversations")
              .doc(otherUserID.toString())
              .set({
            "conversationID": conversationID,
            "photoUrl": senderDocument['photoUrl'],
            "displayName": senderDocument['displayName'],
            "unseenCount": 0,
            "senderID": lastMessage['senderID'],
            "lastMessage_content": lastMessage['message_content'],
            "sentTime": lastMessage['sentTime'],
            "message_type": lastMessage['message_type'],
          });
        }
      }
    }
  }
}
