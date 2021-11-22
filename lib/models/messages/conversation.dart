import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class Conversation {
  final String conversationID;
  final List members;
  final List messages;
  final String ownerID;

  Conversation(
      {required this.conversationID,
      required this.members,
      required this.messages,
      required this.ownerID});

  factory Conversation.fromDocument(DocumentSnapshot documentSnapshot) {
    List _messagesList = [];

    MessageType messageType;
    _messagesList = documentSnapshot['messages'].map((message) {
      switch (message['message_type']) {
        case 'text':
          messageType = MessageType.Text;
          break;
        case 'image':
          messageType = MessageType.Image;
          break;
        case 'video':
          messageType = MessageType.Video;
          break;
        case 'voice':
          messageType = MessageType.Voice;
          break;
        case 'gif':
          messageType = MessageType.GIF;
          break;
        default:
          messageType = MessageType.Text;
          break;
      }

      return Message(
        senderID: message['senderID'],
        lastMessageContent: message['message_content'],
        sentTime: message['sentTime'].toDate(),
        messageType: messageType,
      );
    }).toList();

    return Conversation(
        conversationID: documentSnapshot['conversationID'],
        members: documentSnapshot['members'],
        messages: _messagesList,
        ownerID: documentSnapshot['ownerID']);
  }

  @override
  String toString() {
    return 'Conversation{conversationID: $conversationID, members: $members, messages: $messages, senderID: $ownerID}';
  }
}
