import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/note.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/providers/note_provider.dart';
import 'package:rental_apartments_finder/screens/notes/note_edit_screen.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';

class NoteViewScreen extends StatefulWidget {
  Note note;

  NoteViewScreen({required this.note, Key? key}) : super(key: key);

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  Size? size;

  late NoteProvider noteProvider;

  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    scrollController = new ScrollController();
    noteProvider = Provider.of<NoteProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  elevation: 3,
                  pinned: true,
                  backgroundColor: Colors.blue,
                  flexibleSpace: Container(
                    padding: MediaQuery.of(context).padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 50.0),
                          child: Container(
                            height: kToolbarHeight / 1.5,
                            width: kToolbarHeight / 1.5,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.white, blurRadius: 1.0),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    SignedAccount.instance.photoUrl!),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NoteEditScreen(
                                      note: widget.note,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.WARNING,
                                  body: Center(
                                    child: Text(
                                      'Delete this note?',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                  btnOkOnPress: () async {
                                    await noteProvider.deleteNote(widget.note);
                                    Navigator.of(context).pop();
                                  },
                                  btnCancelOnPress: () {},
                                )..show();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 5,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Text(
                            widget.note.title!,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                        if (widget.note.referencesPropertyID != null)
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('products')
                                .doc(widget.note.referencesPropertyID)
                                .get(),
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                Property property =
                                    Property.fromDocument(snapshot.data!);
                                widget.note.referencesProperty = property;
                                return buildReferencesPropertySection(property);
                              } else {
                                return CircularProgress();
                              }
                            },
                          ),
                        if (widget.note.imageUrl != null)
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text("Your image",
                                      style: TextStyle(color: Colors.blue)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              File(widget.note.imageUrl!)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 15, right: 10, bottom: 50),
                          child: Text(
                            widget.note.content!,
                            style: TextStyle(fontSize: 17),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReferencesPropertySection(Property referencesProperty) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(top: 10, bottom: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.deepPurple.withOpacity(1),
          Colors.redAccent.withOpacity(1)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0,
                  spreadRadius: 0.025,
                  offset: Offset(0.5, 0.5),
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(referencesProperty.imageUrl![0]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildRatingWidget('cleanness'),
          buildRatingWidget('stability'),
          buildRatingWidget('affordable'),
        ],
      ),
    );
  }

  Widget buildRatingWidget(String ratingType) {
    late String ratingTypeText;
    late double ratingTypeValue;

    switch (ratingType) {
      case 'cleanness':
        ratingTypeText = 'Cleanness';
        ratingTypeValue = widget.note.cleanness == null
            ? 0
            : (widget.note.cleanness!).toDouble();
        break;
      case 'stability':
        ratingTypeText = 'Stability';
        ratingTypeValue = widget.note.stability == null
            ? 0
            : (widget.note.stability!).toDouble();
        break;
      case 'affordable':
        ratingTypeText = 'Affordable';
        ratingTypeValue = widget.note.affordable == null
            ? 0
            : (widget.note.affordable!).toDouble();
        break;
      default:
        ratingTypeValue = 0;
    }

    return Container(
      padding: EdgeInsets.only(left: 15, top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ratingTypeText,
              style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(height: 7),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 7, bottom: 7, left: 12, right: 12),
              child: RatingBar.builder(
                initialRating: ratingTypeValue,
                unratedColor: Colors.white,
                itemCount: 5,
                ignoreGestures: true,
                itemSize: size!.width * 0.075,
                itemPadding: EdgeInsets.only(right: 3),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.orange,
                      );
                    case 2:
                      return Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                    default:
                      return Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                  }
                },
                onRatingUpdate: (rating) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
