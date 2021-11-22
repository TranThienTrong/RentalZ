import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/messages/message.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/services/message_service.dart';
import 'package:rental_apartments_finder/widgets/messages/message_item.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';

class RecentMessageScreen extends StatefulWidget {
  RecentMessageScreen({Key? key}) : super(key: key);

  @override
  _RecentMessageScreenState createState() => _RecentMessageScreenState();
}

class _RecentMessageScreenState extends State<RecentMessageScreen> {
  MessageService messageService = new MessageService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(SignedAccount.instance.id)
              .collection('Conversations')
              .snapshots(),
          builder: (context, AsyncSnapshot<dynamic> snapshotConversations) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(SignedAccount.instance.id)
                  .collection('GroupConversations')
                  .snapshots(),
              builder:
                  (context, AsyncSnapshot<dynamic> snapshotGroupConversations) {
                if (snapshotConversations.hasData) {
                  QuerySnapshot conversationSnapshot =
                      snapshotConversations.data;
                  List<Message> listMessage = conversationSnapshot.docs
                      .map((document) => Message.fromDocumentSnapshot(document))
                      .toList();

                  if (snapshotGroupConversations.hasData) {
                    QuerySnapshot groupSnapshot =
                        snapshotGroupConversations.data;
                    List<Message> listGroupMessage = groupSnapshot.docs
                        .map((document) =>
                            Message.fromDocumentSnapshot(document))
                        .toList();

                    listMessage.addAll(listGroupMessage);
                  }

                  return ListView.builder(
                      itemCount: listMessage.length,
                      itemBuilder: (context, index) {
                        return MessageItem(listMessage[index]);
                      });
                } else {
                  return LinearProgress();
                }
              },
            );
          }),
    );
  }
}
