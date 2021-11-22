import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';

class MyUser {
  String? _id;
  String? _username;
  String? _email;
  String? _photoUrl;
  String? _displayName;
  String? _bio;
  DateTime? _timeJoined;
  bool? _isOnline;

  MyUser({
    required String? id,
    required String? username,
    required String? email,
    required String? photoUrl,
    required String? displayName,
    required String? bio,
    required DateTime? timeJoined,
    required bool? isOnline,
  }) {
    this._id = id;
    this._username = username;
    this._email = email;
    this._photoUrl = photoUrl;
    this._displayName = displayName;
    this._bio = bio;
    this._timeJoined = timeJoined;
    this._isOnline = isOnline;
  }

  factory MyUser.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return MyUser(
      id: documentSnapshot['id'],
      username: documentSnapshot['username'],
      email: documentSnapshot['email'],
      photoUrl: documentSnapshot['photoUrl'],
      displayName: documentSnapshot['displayName'],
      bio: documentSnapshot['bio'],
      timeJoined: documentSnapshot['timeJoined'].toDate(),
      isOnline: documentSnapshot['isOnline'],
    );
  }

  factory MyUser.fromSignedInAccount(SignedAccount signedAccount) {
    return MyUser(
      id: signedAccount.id,
      username: signedAccount.username,
      email: signedAccount.email,
      photoUrl: signedAccount.photoUrl,
      displayName: signedAccount.displayName,
      bio: signedAccount.bio,
      timeJoined: signedAccount.timeJoined,
      isOnline: signedAccount.isOnline,
    );
  }

  bool? get isOnline => _isOnline;

  set isOnline(bool? value) {
    FirebaseFirestore.instance.collection('users').doc(this.id).update({
      'isOnline': value!,
    });
    _isOnline = value;
  }

  DateTime? get timeJoined => _timeJoined;

  set timeJoined(DateTime? value) {
    _timeJoined = value;
  }

  String? get bio => _bio;

  set bio(String? value) {
    _bio = value;
  }

  String? get displayName => _displayName;

  set displayName(String? value) {
    _displayName = value;
  }

  String? get photoUrl => _photoUrl;

  set photoUrl(String? value) {
    _photoUrl = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  @override
  String toString() {
    return 'User( id: ${_id}, username: ${_username} email: ${_email} \n '
        'photoUrl: ${photoUrl} displayName: ${displayName} bio: ${bio} \n'
        'timeJoined: ${timeJoined} )';
  }
}
