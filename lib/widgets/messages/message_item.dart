import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/messages/message.dart';
import 'package:rental_apartments_finder/screens/messages/conversation_detail_screen.dart';

import 'group_avatar.dart';

class MessageItem extends StatefulWidget {
  Message message;

  MessageItem(this.message, {Key? key}) : super(key: key);

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ConversationDetailScreen(
                  MyUser.fromSignedInAccount(SignedAccount.instance),
                  widget.message)));
        },
        child: ListTile(
          title: Text(
            widget.message.displayName!,
            style: TextStyle(fontSize: 17),
          ),
          subtitle: Text(
            widget.message.lastMessageContent!,
            style: TextStyle(fontSize: 15),
          ),
          leading: Container(
            child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('conversations')
                    .doc(widget.message.conversationID)
                    .get(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot documentSnapshot = snapshot.data;

                    if (documentSnapshot['members'].length > 2) {
                      return GroupAvatar();
                    } else {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(widget.message.photoUrl!),
                      );
                    }
                  } else {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(widget.message.photoUrl!),
                    );
                  }
                }),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateTime.now().difference(widget.message.sentTime!).inDays > 0
                    ? DateFormat('EEE, H:m', 'en_US')
                        .format(widget.message.sentTime!)
                    : DateFormat('Hm').format(widget.message.sentTime!),
                style: TextStyle(fontSize: 15),
              ),
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(100),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
