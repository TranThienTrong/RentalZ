import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/messages/message.dart';
import 'package:rental_apartments_finder/screens/messages/conversation_detail_screen.dart';
import 'package:rental_apartments_finder/services/message_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactUserItem extends StatefulWidget {
  late MyUser user;

  ContactUserItem(this.user);

  @override
  _ContactUserItemState createState() => _ContactUserItemState();
}

class _ContactUserItemState extends State<ContactUserItem> {
  MessageService messageService = new MessageService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isOnline = widget.user.isOnline!;

    return GestureDetector(
      onTap: () async {
        String? conversationID = await messageService.createOrGetConversation(
            SignedAccount.instance.id!, widget.user.id!);

        late Message message;
        if (conversationID == null) {
          message = Message(
            displayName: widget.user.displayName,
            photoUrl: widget.user.photoUrl,
          );
        } else {
          message = Message.fromDocumentSnapshot(await FirebaseFirestore
              .instance
              .collection('users')
              .doc(SignedAccount.instance.id)
              .collection('Conversations')
              .doc(widget.user.id)
              .get());
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConversationDetailScreen(widget.user, message),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                foregroundImage: NetworkImage(widget.user.photoUrl!),
              ),
              title: Text(
                widget.user.displayName!,
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.user.username!,
                style: TextStyle(color: Colors.black),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FutureBuilder(
                    future: getLastTimeOnline(),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        if (isOnline)
                          return Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.lightGreenAccent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          );
                        else
                          return Text(
                            timeago.format(snapshot.data),
                            style: TextStyle(fontSize: 15),
                          );
                      } else {
                        return Text(
                          "Offline",
                          style: TextStyle(fontSize: 15),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getLastTimeOnline() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.id)
        .get();
    return documentSnapshot['lastOnline'].toDate();
  }
}
