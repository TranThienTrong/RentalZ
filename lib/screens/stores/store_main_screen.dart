import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import 'package:rental_apartments_finder/providers/property_list_provider.dart';
import 'package:rental_apartments_finder/screens/stores/rent_list_screen.dart';
import 'package:rental_apartments_finder/screens/stores/search_screen.dart';
import 'package:rental_apartments_finder/screens/users/user_preference_screen.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';

import '../store_homepage_screen.dart';
import 'explore_screen.dart';

class StoreMainScreen extends StatefulWidget {
  @override
  _StoreMainScreenState createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late PageController pageController;
  int pageIndex = 0;

  late FilterProduct filter = FilterProduct.All;

  final _homepageStoreScaffoldKey = GlobalKey<ScaffoldState>();

  FirebasePropertyService productService = FirebasePropertyService();

  @override
  void initState() {
    pageController = PageController(
        initialPage: pageIndex, keepPage: true, viewportFraction: 1);
    configurePushNotification();
    super.initState();
  }

  void changePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    PropertiesListProvider productsListProvider =
        Provider.of<PropertiesListProvider>(context);

    return Scaffold(
      key: _homepageStoreScaffoldKey,
      body: FutureBuilder(
        future: Address.init(),
        builder: (context, snapshot) {
          return PageView(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            children: <Widget>[
              StoreHomepageScreen(),
              ExploreScreen(),
              SearchScreen(),
              RentListScreen(),
              UserPreferenceScreen(),
            ],
            onPageChanged: (index) {
              setState(() => pageIndex = index);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.pageIndex,
        onTap: changePage,
        elevation: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dynamic_feed), label: 'Feeds'),
          BottomNavigationBarItem(
              activeIcon: null, icon: Icon(null), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: 'Rent List'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'User'),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
        width: 55,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: FloatingActionButton(
            hoverElevation: 10,
            elevation: 4,
            child: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              changePage(2);
            },
          ),
        ),
      ),
    );
  }

  configurePushNotification() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    String? token = await FirebaseMessaging.instance.getToken();
    SignedAccount.instance.token = token;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(SignedAccount.instance.id)
        .update({'androidNotificationToken': token!});

    await FirebaseMessaging.instance.subscribeToTopic('alldriders');
    await FirebaseMessaging.instance.subscribeToTopic('allusers');

    Future<void> firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      print("Handling a background message");
    }

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print('Got 123 a message whilst in the foreground!');
        print('Message data 1: ${message.data}');
        print('Message data 2: ${message.notification}');

        RemoteNotification notification = message.notification!;
        AndroidNotification android = message.notification!.android!;

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: '@mipmap/ic_launcher',
              // other properties...
            ),
          ),
        );

        bool canVibrate = await Vibrate.canVibrate;
        if (canVibrate) {
          Vibrate.vibrate();
        }
      },
    );
  }
}
