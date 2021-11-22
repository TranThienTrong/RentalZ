import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/messages/message.dart';

class ImageMessageItem extends StatefulWidget {
  Message message;

  ImageMessageItem(this.message, {Key? key}) : super(key: key);

  @override
  _ImageMessageItemState createState() => _ImageMessageItemState();
}

class _ImageMessageItemState extends State<ImageMessageItem> {
  /* Responsive Design */
  double deviceWidth = 0;
  double deviceHeight = 0;

  @override
  Widget build(BuildContext context) {
    bool isSender = widget.message.senderID == SignedAccount.instance.id;
    deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    deviceWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.message.senderID)
          .snapshots(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;
          widget.message.displayName = documentSnapshot['displayName'];
          widget.message.photoUrl = documentSnapshot['photoUrl'];

          return Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isSender)
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.message.photoUrl!),
                ),
              Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: isSender
                      ? Border.all(width: 0, color: Colors.white)
                      : Border.all(width: 0.5, color: Colors.black),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isSender
                        ? [Colors.redAccent, Colors.deepPurpleAccent]
                        : [Colors.white, Colors.white],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: deviceHeight * 0.25,
                      width: deviceWidth * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.message.lastMessageContent!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text('');
        }
      },
    );
  }
}
