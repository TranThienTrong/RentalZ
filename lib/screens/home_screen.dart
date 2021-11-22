import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_apartments_finder/screens/store_main_screen.dart';
import 'package:rental_apartments_finder/screens/users/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<FirebaseApp>? firebaseApp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: HomeScreen.isLoggedIn,
      builder: (context, valueListenable, child) {
        return HomeScreen.isLoggedIn.value == true
            ? StoreMainScreen()
            : LoginScreen();
      },
      child: null,
    );
  }
}
