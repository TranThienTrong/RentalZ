import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType{
  Text,
  Image,
  Video,
  GIF,
  Voice,
}

class Message {
  String? _conversationID;
  String? _displayName;
  String? _photoUrl;
  String? _senderID;
  String? _lastMessageContent;
  int? _unseenCount;
  DateTime? _sentTime;
  MessageType? messageType;

  Message({
    String? conversationID,
    String? senderID,
    String? lastMessageContent,
    int? unseenCount,
    DateTime? sentTime,
    String? displayName,
    String? photoUrl,
    MessageType? messageType,
  }) {
    this._senderID = senderID;
    this._lastMessageContent = lastMessageContent;
    this._unseenCount = unseenCount;
    this._sentTime = sentTime;
    this._displayName = displayName;
    this._photoUrl = photoUrl;
    this._conversationID = conversationID;
    this.messageType = messageType;

  }

  factory Message.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {

    late MessageType messageType;
    switch (documentSnapshot['message_type']){
      case "text":
        messageType = MessageType.Text;
        break;
      case "gif":
        messageType = MessageType.GIF;
        break;
      case "video":
        messageType = MessageType.Video;
        break;
      case "image":
        messageType = MessageType.Image;
        break;
      case "void":
        messageType = MessageType.Voice;
        break;
    }

    return Message(
        conversationID: documentSnapshot['conversationID'],
        senderID: documentSnapshot['senderID'],
        lastMessageContent: documentSnapshot['lastMessage_content'],
        unseenCount: documentSnapshot['unseenCount'],
        sentTime: documentSnapshot['sentTime'].toDate(),
        displayName: documentSnapshot['displayName'],
        photoUrl: documentSnapshot['photoUrl'],
        messageType: messageType,
    );
  }

  DateTime? get sentTime => _sentTime;

  set sentTime(DateTime? value) {
    _sentTime = value;
  }

  int? get unseenCount => _unseenCount;

  set unseenCount(int? value) {
    _unseenCount = value;
  }

  String? get lastMessageContent => _lastMessageContent;

  set lastMessageContent(String? value) {
    _lastMessageContent = value;
  }

  String? get senderID => _senderID;

  set senderID(String? value) {
    _senderID = value;
  }

  String? get photoUrl => _photoUrl;

  set photoUrl(String? value) {
    _photoUrl = value;
  }

  String? get displayName => _displayName;

  set displayName(String? value) {
    _displayName = value;
  }

  String? get conversationID => _conversationID;

  set conversationID(String? value) {
    _conversationID = value;
  }
}
