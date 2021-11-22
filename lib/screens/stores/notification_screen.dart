import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/my_store_notification.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/services/notifications/notification_service.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:rental_apartments_finder/widgets/store_notification_item.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  NotificationService storeNotificationService = new NotificationService();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification")),
      body: Container(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("notifications")
              .doc(SignedAccount.instance.id)
              .collection('storeNotifications')
              .get(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<Widget> notificationList = [];
              List<DocumentSnapshot> documentList = querySnapshot.docs;
              documentList.forEach((element) {
                MyStoreNotification myNotification =
                    MyStoreNotification.fromQueryDocument(element);

                print(myNotification);
                notificationList.add(StoreNotificationItem(myNotification));
              });

              return ListView(
                children: notificationList,
              );
            } else {
              print("snapshot data: ${snapshot.data}");
              return CircularProgress();
            }
          },
        ),
      ),
    );
  }
}
