import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/store/order.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';

enum NotificationTypes {
  RENT,
  COMMENT,
  MESSAGE,
}

class PushNotificationService {
  static const String SERVER_KEY =
      'AAAAjTbwew4:APA91bHHlUCt1q6K8mDwGvg4KksREaWfU6bjalL63243faXMxV7JE2Igc1Z0sPEAfTRz00cM-aLqHKhGq977v9A2lcbRgwxi72cG9vooXgeOjrO3ZDr7BYgxfOWUWhY3VFrUgZuGwYpm';

  static const String SENDER_ID = '606512118542';
  static const String API_URL = 'https://fcm.googleapis.com/fcm/send';

  static const Map<String, String> HEADER = {
    'Authorization': 'key=$SERVER_KEY',
    'content-type': 'application/json',
  };

  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notifications: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(SignedAccount.instance.id)
        .update({'androidNotificationToken': token!});
    print('Token $token');
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message");
  }

  Future sendNotification(
      {required String toUserId,
      required String notifyTitle,
      required String notifyBody,
      Map<String, dynamic>? data}) async {
    Uri apiUrl = Uri.parse(API_URL);
    late http.Response response;

    String? userToken;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(toUserId)
        .get()
        .then((document) {
      userToken = document['androidNotificationToken'];
    });

    try {
      if (userToken != null) {
        var body = jsonEncode(
          {
            "senderId": SENDER_ID,
            "category": "",
            "collapseKey": "",
            "data": {},
            "from": "",
            "messageId": "",
            "messageType": "",
            "sentTime": "",
            "to": userToken,
            "notification": {
              "body": notifyTitle,
              "title": notifyBody,
            }
          },
        );

        response = await http.post(
          apiUrl,
          headers: HEADER,
          body: body,
        );
      }
    } catch (error) {
      print('Error occurred : ${error.toString()}');
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('send notification success');
    } else {
      print('send notification error');
    }
  }

  sendPushNotificationForCorrectUser(
      {required NotificationTypes notifyType,
      required String notifyTitle,
      Order? newOrder,
      required String notifyBody}) async {
    if (notifyType == NotificationTypes.RENT) {
      Set<String> differentLessorsId = new Set<String>();

      newOrder!.productsInRentListList.forEach(
        (product) {
          differentLessorsId.add(product.product.ownerId);
        },
      );

      Map<String, List<PropertyInRentList>> productsOfEachLessor =
          Map<String, List<PropertyInRentList>>();

      for (String lessorId in differentLessorsId) {
        List<PropertyInRentList> thisLessorProducts = newOrder
            .productsInRentListList
            .where((productsInRentList) =>
                productsInRentList.product.ownerId == lessorId)
            .toList();
        productsOfEachLessor.putIfAbsent(lessorId, () => thisLessorProducts);
      }

      productsOfEachLessor.forEach(
        (String lessorId,
            List<PropertyInRentList> productsInRentListList) async {
          productsInRentListList.forEach(
            (productsInRentList) {
              print("product in RentList: " +
                  productsInRentList.product.toString());

              sendNotification(
                  toUserId: lessorId,
                  notifyTitle:
                      'New rent request for ${productsInRentList.product.name}',
                  notifyBody:
                      '${productsInRentList.product.name} had been requested for renting ');
            },
          );
        },
      );
    }
  }
}
