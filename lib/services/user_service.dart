import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';

class FirebaseUserService {
  CollectionReference userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  /* ____________________________________ RETRIEVE ____________________________________ */

  Future<QuerySnapshot> getAllUser() async {
    QuerySnapshot querySnapshot = await userCollectionRef.get();
    return querySnapshot;
  }

  Future<DocumentSnapshot> getUserById(String userId) async {
    DocumentSnapshot<Object?> documentSnapshot =
        await userCollectionRef.doc(userId).get();
    return documentSnapshot;
  }

  Stream getUserByDisplayName(String displayName) {
    return FirebaseFirestore.instance
        .collection('users')
        .where("displayName", isGreaterThanOrEqualTo: displayName)
        .where("displayName", isLessThan: displayName + 'z')
        .where('displayName', isNotEqualTo: SignedAccount.instance.displayName)
        .snapshots();
  }

  Future<void> getAdmin() async {
    QuerySnapshot querySnapshot = await userCollectionRef
        .orderBy('postCount', descending: false)
        .where('isAdmin', isEqualTo: false)
        .get();

    querySnapshot.docs.forEach((document) => print(document.data()));
  }

  Future<bool> checkUser(String userId) async {
    DocumentSnapshot<Object?> documentSnapshot =
        await userCollectionRef.doc(userId).get();
    if (documentSnapshot.exists) {
      return true;
    }
    return false;
  }

  Stream getUserStreamByDisplayName(String displayName) {
    return FirebaseFirestore.instance
        .collection('users')
        .where("displayName", isGreaterThanOrEqualTo: displayName)
        .where("displayName", isLessThan: displayName + 'z')
        .where('displayName', isNotEqualTo: SignedAccount.instance.displayName)
        .snapshots();
  }

  Future<String> getImageOfUser(String userID) async {
    QuerySnapshot querySnapshot =
        await userCollectionRef.where('id', isEqualTo: userID).get();

    return querySnapshot.docs.first['photoUrl'];
  }

  /* ____________________________________ INSERT ____________________________________ */

  Future<void> insertUser() {
    return userCollectionRef
        .add({'isAdmin': false, 'username': 'alex', 'postCount': 0})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> insertUserWithId(String userId, String username, bool isAdmin) {
    return userCollectionRef
        .doc(userId)
        .set({'isAdmin': isAdmin, 'username': username, 'postCount': 0})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  /* ____________________________________ UPDATE ____________________________________ */

  Future<void> updateUser(String userId, String newUsername) {
    return userCollectionRef
        .doc(userId)
        .update({'username': newUsername})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  /* ____________________________________ DELETE ____________________________________ */

  Future<void> deleteUser(String userId) {
    return userCollectionRef
        .doc(userId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
