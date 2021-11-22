import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';

class NotificationService {
  CollectionReference notifyCollectionReference =
      FirebaseFirestore.instance.collection('notifications');

/* ____________________________________ INSERT ____________________________________ */

  insertPropertyRentedNotification(
      {required String productId,
      required String ownerId,
      required String notifyType}) async {
    await notifyCollectionReference
        .doc(ownerId)
        .collection("storeNotifications")
        .doc(productId)
        .set(
      {
        'usernameNotify': SignedAccount.instance.username,
        'userNotifyID': SignedAccount.instance.id,
        'productID': productId,
        'productOwnerID': ownerId,
        'type': notifyType,
        'notifyTime': DateTime.now(),
      },
    );
  }

/* ____________________________________ RETRIEVE ____________________________________ */

  Future<QuerySnapshot> getAllStoreNotificationForCurrentUser() async {
    QuerySnapshot querySnapshot = await notifyCollectionReference
        .doc(SignedAccount.instance.id)
        .collection('storeNotifications')
        .orderBy('notifyTime', descending: true)
        .get();
    return querySnapshot;
  }

/* ____________________________________ UPDATE ____________________________________ */

/* ____________________________________ DELETE ____________________________________ */

}
