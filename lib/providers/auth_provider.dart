import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_apartments_finder/screens/home_screen.dart';
import 'package:rental_apartments_finder/screens/users/create_account_screen.dart';

import '../services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  BuildContext context;
  late FirebaseUserService _firebaseHelper;

  /*  Email Auth  */
  static late FirebaseAuth firebaseAuth;
  User? _currentEmailUser;

  /*  Google Auth  */
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentGoogleUser;

  MyUser? _myUser;
  late SignedAccount signedAccount;

  /* ____________________________ Constructor ____________________________ */

  AuthProvider(this.context) {
    _firebaseHelper = new FirebaseUserService();
    firebaseAuth = FirebaseAuth.instance;
    signedAccount = SignedAccount.instance;

    FirebaseAuth.instance.userChanges().listen(
      (User? user) {
        if (user != null) {
          setUpEmailAccount();
        }
      },
      onError: (error) => error.toString(),
    );
  }

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      if (email == "admin@gmail.com" && password == "admin123") {
        setUpTestAccount();
      } else {
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.disconnect();
        }
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> loginWithGoogle() async {
    User? user;
    googleSignIn.disconnect();
    GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    _currentGoogleUser = googleSignIn.currentUser;
    print(_currentGoogleUser!.id);

    if (googleAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleAccount.authentication;

      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential googleUserCredential =
            await FirebaseAuth.instance.signInWithCredential(googleCredential);
        user = googleUserCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
        } else if (e.code == 'invalid-credential') {}
      } catch (e) {}
    }
  }

  static Future<Null> signOutWithGoogle() async {
    await googleSignIn.signOut();
    // Sign out with firebase
    await firebaseAuth.signOut();
    // Sign out with google
  }

  Future<Null> setUpGoogleAccount() async {
    DocumentSnapshot? documentSnapshot =
        await _firebaseHelper.getUserById(_currentGoogleUser!.id);

    if (documentSnapshot.data() == null) {
      final username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccountScreen(),
        ),
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(_currentGoogleUser!.id)
          .set(
        {
          'id': _currentGoogleUser!.id,
          'username': username,
          'email': _currentGoogleUser!.email,
          'photoUrl': _currentGoogleUser!.photoUrl,
          'displayName': _currentGoogleUser!.displayName,
          'bio': '',
          'timeJoined': DateTime.now(),
          'isOnline': true,
        },
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(_currentGoogleUser!.id)
          .collection('Conversations');

      FirebaseFirestore.instance
          .collection('stores')
          .doc(_currentGoogleUser!.id)
          .set({'addressBook': [], 'myOrders': []});

      _myUser = MyUser(
        id: _currentGoogleUser!.id,
        username: username,
        email: _currentGoogleUser!.email,
        photoUrl: _currentGoogleUser!.photoUrl,
        displayName: _currentGoogleUser!.displayName,
        bio: '',
        timeJoined: DateTime.now(),
        isOnline: true,
      );
      signedAccount.id = _myUser!.id;
      signedAccount.username = _myUser!.username;
      signedAccount.email = _myUser!.email;
      signedAccount.photoUrl = _myUser!.photoUrl;
      signedAccount.displayName = _myUser!.displayName;
      signedAccount.bio = _myUser!.bio;
      signedAccount.timeJoined = _myUser!.timeJoined;
      signedAccount.isOnline = true;
    } else {
      _myUser = MyUser.fromDocumentSnapshot(documentSnapshot);
      _myUser!.isOnline = true;
      signedAccount.id = _myUser!.id;
      signedAccount.username = _myUser!.username;
      signedAccount.email = _myUser!.email;
      signedAccount.photoUrl = _myUser!.photoUrl;
      signedAccount.displayName = _myUser!.displayName;
      signedAccount.bio = _myUser!.bio;
      signedAccount.timeJoined = _myUser!.timeJoined;
      signedAccount.isOnline = true;
      print(_myUser);
    }
    HomeScreen.isLoggedIn.value = true;
  }

  void setUpEmailAccount() async {
    _currentEmailUser = firebaseAuth.currentUser;
    DocumentSnapshot? documentSnapshot =
        await _firebaseHelper.getUserById(_currentEmailUser!.uid);

    if (documentSnapshot.data() == null) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountScreen()));

      FirebaseFirestore.instance
          .collection('users')
          .doc(_currentEmailUser!.uid)
          .set(
        {
          'id': _currentEmailUser!.uid,
          'username': username,
          'email': _currentEmailUser!.email,
          'photoUrl': _currentEmailUser!.photoURL == null
              ? 'https://firebasestorage.googleapis.com/v0/b/flutter-social-media-7fb3e.appspot.com/o/images%2Fimage_2021-09-03_154109.png?alt=media&token=3ec93a85-a926-483b-b722-588b371d58a0'
              : _currentEmailUser!.photoURL,
          'displayName': _currentEmailUser!.displayName == null
              ? username
              : _currentEmailUser!.displayName,
          'bio': '',
          'timeJoined': DateTime.now(),
          'isOnline': true,
        },
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(_currentEmailUser!.uid)
          .collection('Conversations');

      FirebaseFirestore.instance
          .collection('stores')
          .doc(_currentEmailUser!.uid)
          .set({'addressBook': [], 'myOrders': []});

      _myUser = MyUser(
        id: _currentEmailUser!.uid,
        username: username,
        email: _currentEmailUser!.email,
        photoUrl: _currentEmailUser!.photoURL == null
            ? 'https://firebasestorage.googleapis.com/v0/b/flutter-social-media-7fb3e.appspot.com/o/images%2Fimage_2021-09-03_154109.png?alt=media&token=3ec93a85-a926-483b-b722-588b371d58a0'
            : _currentEmailUser!.photoURL,
        displayName: _currentEmailUser!.displayName == null
            ? username
            : _currentEmailUser!.displayName,
        bio: '',
        timeJoined: DateTime.now(),
        isOnline: true,
      );
      signedAccount.id = _myUser!.id;
      signedAccount.username = _myUser!.username;
      signedAccount.email = _myUser!.email;
      signedAccount.photoUrl = _myUser!.photoUrl;
      signedAccount.displayName = _myUser!.displayName;
      signedAccount.bio = _myUser!.bio;
      signedAccount.timeJoined = _myUser!.timeJoined;
      signedAccount.isOnline = _myUser!.isOnline;
    } else {
      _myUser = MyUser.fromDocumentSnapshot(documentSnapshot);
      signedAccount.id = _myUser!.id;
      signedAccount.username = _myUser!.username;
      signedAccount.email = _myUser!.email;
      signedAccount.photoUrl = _myUser!.photoUrl;
      signedAccount.displayName = _myUser!.displayName;
      signedAccount.bio = _myUser!.bio;
      signedAccount.timeJoined = _myUser!.timeJoined;
      signedAccount.isOnline = _myUser!.isOnline;
      print(_myUser);
    }

    HomeScreen.isLoggedIn.value = true;
  }

  void setUpTestAccount() async {
    FirebaseFirestore.instance.collection('users').doc('testerid').set(
      {
        'id': 'testerid',
        'username': 'tester',
        'email': 'tester@gmail.com',
        'photoUrl':
            'https://firebasestorage.googleapis.com/v0/b/flutter-social-media-7fb3e.appspot.com/o/images%2Fimage_2021-09-03_154109.png?alt=media&token=3ec93a85-a926-483b-b722-588b371d58a0',
        'displayName': 'tester',
        'bio': '',
        'timeJoined': DateTime.now(),
        'isOnline': true,
      },
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc('testerid')
        .collection('Conversations');

    FirebaseFirestore.instance
        .collection('stores')
        .doc('testerid')
        .set({'addressBook': [], 'myOrders': []});

    _myUser = MyUser(
      id: 'testerid',
      username: 'tester',
      email: 'tester@gmail.com',
      photoUrl:
          'https://firebasestorage.googleapis.com/v0/b/flutter-social-media-7fb3e.appspot.com/o/images%2Fimage_2021-09-03_154109.png?alt=media&token=3ec93a85-a926-483b-b722-588b371d58a0',
      displayName: 'tester',
      bio: '',
      timeJoined: DateTime.now(),
      isOnline: true,
    );
    signedAccount.id = _myUser!.id;
    signedAccount.username = _myUser!.username;
    signedAccount.email = _myUser!.email;
    signedAccount.photoUrl = _myUser!.photoUrl;
    signedAccount.displayName = _myUser!.displayName;
    signedAccount.bio = _myUser!.bio;
    signedAccount.timeJoined = _myUser!.timeJoined;
    signedAccount.isOnline = _myUser!.isOnline;

    HomeScreen.isLoggedIn.value = true;
  }
}
