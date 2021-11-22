import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_apartments_finder/models/messages/conversation.dart';
import 'package:rental_apartments_finder/models/messages/message.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/services/message_service.dart';
import 'package:rental_apartments_finder/widgets/messages/message_items/image_message_item.dart';
import 'package:rental_apartments_finder/widgets/messages/message_items/text_message_item.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';

import 'package:timeago/timeago.dart' as timeago;

class ConversationDetailScreen extends StatefulWidget {
  Message message;
  MyUser user;

  ConversationDetailScreen(this.user, this.message, {Key? key})
      : super(key: key);

  @override
  _ConversationDetailScreenState createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  /* Responsive Design */
  double deviceWidth = 0;
  double deviceHeight = 0;

  void setNewConversation(String id) {
    setState(() {
      widget.message.conversationID = id;
    });
  }

  late MessageService messageService;
  late TextEditingController messageTextController;
  late GlobalKey<FormState> inputMessageFormKey;
  late ScrollController scrollController;
  String? messageContent;
  File? imageFile;
  String? imageFileUrl;
  late ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    messageTextController = new TextEditingController();
    messageService = new MessageService();
    inputMessageFormKey = GlobalKey<FormState>();
    messageContent = '';
    _imagePicker = ImagePicker();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      backgroundColor: Colors.blueAccent,
      title: Text(
        this.widget.message.displayName!,
        style: TextStyle(color: Colors.white),
      ),
    );

    deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar,
      body: StreamBuilder<Object>(
          stream: FirebaseFirestore.instance
              .collection('conversations')
              .doc(widget.message.conversationID)
              .snapshots(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot = snapshot.data;
              return SizedBox(
                height: deviceHeight,
                width: deviceWidth,
                child: Column(
                  children: [
                    if (documentSnapshot.data() != null)
                      Flexible(
                          flex: 10,
                          fit: FlexFit.tight,
                          child: buildMessageList(snapshot.data))
                    else
                      Flexible(
                          flex: 10, fit: FlexFit.tight, child: Text('say hi')),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: buildMessageInputField(context)),
                    if (imageFile != null)
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: deviceWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: FileImage(imageFile!),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return LinearProgress();
            }
          }),
    );
  }

  Widget buildMessageList(DocumentSnapshot documentSnapshot) {
    Conversation conversation = Conversation.fromDocument(documentSnapshot);
    List messagesList = conversation.messages;
    bool isSender = widget.message.senderID == SignedAccount.instance.id;

    Timer(
      Duration(milliseconds: 50),
      () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      },
    );

    return Container(
      height: deviceHeight * 0.85,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        controller: scrollController,
        itemCount: messagesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (messagesList[index].messageType == MessageType.Image)
                  ImageMessageItem(messagesList[index])
                else if (messagesList[index].messageType == MessageType.Text)
                  TextMessageItem(messagesList[index])
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildMessageInputField(BuildContext context) {
    return Container(
      height: deviceHeight * 0.08,
      width: deviceWidth,
      child: Form(
        key: inputMessageFormKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: deviceWidth * 0.1,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.image,
                  color: Colors.lightBlue,
                ),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.1,
              child: IconButton(
                onPressed: () async {
                  XFile? file =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    setState(() {
                      imageFile = File(file.path);
                    });
                  }
                },
                icon: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.lightBlue,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(232, 234, 235, 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  SizedBox(
                    child: Container(
                      width: deviceWidth * 0.55,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        controller: messageTextController,
                        onChanged: (value) {
                          inputMessageFormKey.currentState!.save();
                        },
                        onSaved: (value) {
                          setState(() {
                            messageContent = value!;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Type message"),
                        cursorColor: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () async {
                      if (inputMessageFormKey.currentState!.validate()) {
                        if (widget.message.conversationID == null) {
                          if (imageFile == null) {
                            messageService.sendNewMessage(widget.user.id!, null,
                                messageTextController.text, setNewConversation);
                          } else {
                            imageFileUrl = await messageService.sendImage(
                                SignedAccount.instance.id!, imageFile!);
                            messageService.sendNewMessage(widget.user.id!,
                                imageFileUrl, null, setNewConversation);
                          }
                        } else {
                          late Message newMessage;
                          if (imageFile == null) {
                            newMessage = new Message(
                              messageType: MessageType.Text,
                              lastMessageContent: messageTextController.text,
                              senderID: SignedAccount.instance.id,
                              sentTime: DateTime.now(),
                            );
                          } else if (imageFile != null) {
                            imageFileUrl = await messageService.sendImage(
                                SignedAccount.instance.id!, imageFile!);
                            newMessage = new Message(
                              messageType: MessageType.Image,
                              lastMessageContent: imageFileUrl,
                              senderID: SignedAccount.instance.id,
                              sentTime: DateTime.now(),
                            );
                          }
                          messageService.sendMessage(
                            widget.message.conversationID!,
                            newMessage,
                          );
                        }

                        setState(() {
                          messageTextController.clear();
                          FocusScope.of(context).unfocus();
                          imageFile = null;
                          imageFileUrl = null;
                        });
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
}
