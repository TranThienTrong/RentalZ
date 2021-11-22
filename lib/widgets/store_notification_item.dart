import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/my_store_notification.dart';
import 'package:rental_apartments_finder/services/user_service.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoreNotificationItem extends StatelessWidget {
  MyStoreNotification notification;

  FirebaseUserService firebaseUserService = new FirebaseUserService();
  FirebasePropertyService firebasePropertyService =
      new FirebasePropertyService();

  Future<String>? userAvatar;
  Future<String>? imageURL;

  StoreNotificationItem(this.notification) {
    imageURL =
        firebasePropertyService.getImageOfProperty(notification.productID!);
    userAvatar = firebaseUserService.getImageOfUser(notification.userNotifyID);
  }

  String? activity;

  String getActivity() {
    if (notification.type == 'property_rented')
      return "had sent renting request for #${notification.productID} property";
    else
      return "";
  }

  Widget previewPropertyImage(String imageURL) {
    if (notification.type == 'property_rented') {
      return GestureDetector(
        onTap: () {},
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(imageURL)),
              ),
            ),
          ),
        ),
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([imageURL!, userAvatar!]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Container(
                color: Colors.white,
                child: GestureDetector(
                  onTap: () => {},
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data![1]),
                    ),
                    title: GestureDetector(
                      onTap: () {},
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        text: TextSpan(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: notification.usernameNotify,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " ${getActivity()} ",
                              ),
                            ]),
                      ),
                    ),
                    subtitle: Text(timeago.format(notification.notifyTime)),
                    trailing: previewPropertyImage(snapshot.data![0]),
                  ),
                ),
              ),
            );
          } else {
            return LinearProgress();
          }
        });
  }
}
