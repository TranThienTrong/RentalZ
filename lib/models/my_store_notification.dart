import 'package:cloud_firestore/cloud_firestore.dart';

class MyStoreNotification {
  String usernameNotify;
  String userNotifyID;
  String? productID;
  String? productOwnerID;
  String type;
  DateTime notifyTime;

  MyStoreNotification(
      {required this.usernameNotify,
      required this.userNotifyID,
      this.productID,
      this.productOwnerID,
      required this.type,
      required this.notifyTime});

  factory MyStoreNotification.fromQueryDocument(
      DocumentSnapshot documentSnapshot) {
    return MyStoreNotification(
        usernameNotify: documentSnapshot['usernameNotify'],
        userNotifyID: documentSnapshot['userNotifyID'],
        productID: documentSnapshot['productID'],
        productOwnerID: documentSnapshot['productOwnerID'],
        type: documentSnapshot['type'],
        notifyTime: documentSnapshot['notifyTime'].toDate());
  }

  @override
  String toString() {
    return " userNofity: ${usernameNotify} ${userNotifyID} productID: ${productID} productOwner: ${productOwnerID} type: ${type}";
  }
}
