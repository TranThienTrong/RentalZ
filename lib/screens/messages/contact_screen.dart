import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/services/user_service.dart';
import 'package:rental_apartments_finder/widgets/messages/contact_user_item.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';

class ContactScreen extends StatefulWidget {
  double deviceHeight;

  ContactScreen(this.deviceHeight);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String? searchName;
  FirebaseUserService userService = new FirebaseUserService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Container(
      child: Column(
        children: [
          contactSearchBar(),
          (searchName == null || searchName!.isEmpty)
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(SignedAccount.instance.id)
                      .collection('Conversations')
                      .get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot = snapshot.data;
                      if (querySnapshot.docs.length > 0) {
                        List<String> idList = [];

                        querySnapshot.docs
                            .forEach((doc) => idList.add(doc.reference.id));

                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('id', whereIn: idList)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              QuerySnapshot querySnapshot = snapshot.data;
                              List<MyUser> allUserList = querySnapshot.docs
                                  .map((document) =>
                                      MyUser.fromDocumentSnapshot(document))
                                  .toList();
                              return usersContactListView(allUserList);
                            } else {
                              return CircularProgress();
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return CircularProgress();
                    }
                  },
                )
              : StreamBuilder(
                  stream: userService.getUserByDisplayName(searchName!),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot = snapshot.data;
                      List<MyUser> searchedUserList = querySnapshot.docs
                          .map((document) =>
                              MyUser.fromDocumentSnapshot(document))
                          .toList();
                      return usersContactListView(searchedUserList);
                    } else {
                      return CircularProgress();
                    }
                  },
                ),
        ],
      ),
    );
  }

  Widget contactSearchBar() {
    return Container(
      height: widget.deviceHeight * 0.08,
      padding: EdgeInsets.symmetric(vertical: widget.deviceHeight * 0.02),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.blue),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blue,
          ),
          labelText: "Search",
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        onSubmitted: (value) {
          setState(() {
            searchName = value;
          });
        },
      ),
    );
  }

  Widget usersContactListView(List<MyUser> userList) {
    return Container(
      height: widget.deviceHeight - (widget.deviceHeight * 0.08),
      child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return ContactUserItem(userList[index]);
        },
      ),
    );
  }
}
