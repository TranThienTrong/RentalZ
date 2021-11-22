import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/providers/dark_theme_provider.dart';
import 'package:rental_apartments_finder/screens/lessor/lessor_main_screen.dart';
import 'package:rental_apartments_finder/screens/notes/note_list_screen.dart';
import 'package:rental_apartments_finder/screens/stores/order_screen.dart';
import 'package:rental_apartments_finder/screens/stores/wishlist_screen.dart';

import '../home_screen.dart';

class UserPreferenceScreen extends StatefulWidget {
  const UserPreferenceScreen({Key? key}) : super(key: key);

  @override
  _UserPreferenceScreenState createState() => _UserPreferenceScreenState();
}

class _UserPreferenceScreenState extends State<UserPreferenceScreen> {
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;
    DarkThemeProvider darkThemeProvider =
        Provider.of<DarkThemeProvider>(context);
    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 4,
              pinned: true,
              centerTitle: true,
              expandedHeight: 150,
              backgroundColor: Colors.redAccent,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: [
                              Container(
                                height: kToolbarHeight / 1.5,
                                width: kToolbarHeight / 1.5,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white, blurRadius: 1.0),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        SignedAccount.instance.photoUrl!),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  SignedAccount.instance.displayName!,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Current Order',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.2,
                      width: deviceWidth,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.02,
                            offset: Offset(0.25, 0.25),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: deviceHeight * 0.08,
                            width: deviceWidth * 0.45,
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  spreadRadius: 0.02,
                                  offset: Offset(0.25, 0.25),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.my_library_books_outlined,
                                        color: Colors.pinkAccent),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => OrderScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    child: Text(
                                      'my order',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: deviceHeight * 0.08,
                            width: deviceWidth * 0.45,
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  spreadRadius: 0.02,
                                  offset: Offset(0.25, 0.25),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.favorite,
                                        color: Colors.pinkAccent),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WishlistScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    child: Text(
                                      'my wishlist',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NoteListScreen()));
                      },
                      child: Container(
                        height: deviceHeight * 0.08,
                        width: deviceWidth,
                        margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1,
                              spreadRadius: 0.02,
                              offset: Offset(0.25, 0.25),
                            ),
                          ],
                        ),
                        child: Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.sticky_note_2,
                                    color: Colors.orange),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LessorMainScreen(),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                child: Text(
                                  'my notes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.08,
                      width: deviceWidth,
                      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.7),
                              Colors.deepPurpleAccent.withOpacity(1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.02,
                            offset: Offset(0.25, 0.25),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.house, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LessorMainScreen(),
                                  ),
                                );
                              },
                            ),
                            Container(
                              child: Text(
                                'my properties',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTileSwitch(
                      value: darkThemeProvider.isDarkTheme,
                      leading: Icon(Icons.dark_mode_rounded),
                      onChanged: (value) {
                        setState(() {
                          darkThemeProvider.setDarkTheme(value);
                        });
                      },
                      visualDensity: VisualDensity.comfortable,
                      switchType: SwitchType.cupertino,
                      switchActiveColor: Colors.indigo,
                      title: Text('Theme'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 25,
          right: 5,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(),
            child: IconButton(
              icon: Icon(Icons.exit_to_app, size: 27, color: Colors.white),
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(SignedAccount.instance.id)
                      .update({'isOnline': false});
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(SignedAccount.instance.id)
                      .update({'lastOnline': DateTime.now()});
                  await FirebaseAuth.instance.signOut();
                } else {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(SignedAccount.instance.id)
                      .update({'isOnline': false});
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(SignedAccount.instance.id)
                      .update({'lastOnline': DateTime.now()});
                  await GoogleSignIn().signOut();
                }
                HomeScreen.isLoggedIn.value = false;
              },
            ),
          ),
        ),
      ],
    );
  }
}
