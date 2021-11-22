import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/note.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:image/image.dart' as imagePackage;
import 'package:rental_apartments_finder/providers/note_provider.dart';
import 'package:rental_apartments_finder/screens/notes/note_list_screen.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:uuid/uuid.dart';

class NoteEditScreen extends StatefulWidget {
  Note? note;
  Property? referencesProperty;

  NoteEditScreen({this.referencesProperty, this.note, Key? key})
      : super(key: key);

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  Size? size;

  File? imageFile;
  ImagePicker _imagePicker = ImagePicker();
  ScrollController scrollController = new ScrollController();

  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();

  /* Search Property */
  FirebasePropertyService propertyService = FirebasePropertyService();
  TextEditingController destinationController = new TextEditingController();
  List<Property> predictedPlacesList = [];
  Property? referencesProperty;

  @override
  void initState() {
    scrollController = new ScrollController();
    if (widget.note != null) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
      imageFile =
          (widget.note!.imageUrl != null) ? File(widget.note!.imageUrl!) : null;
      referencesProperty = (widget.note!.referencesProperty != null)
          ? widget.note!.referencesProperty
          : null;
    } else {
      widget.note = Note(
          id: null,
          title: null,
          imageUrl: null,
          content: null,
          referencesPropertyID: widget.referencesProperty == null
              ? null
              : widget.referencesProperty!.id);

      if (widget.referencesProperty != null) {
        referencesProperty = widget.referencesProperty!;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
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
                  automaticallyImplyLeading: false,
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
                          padding: EdgeInsets.only(left: 15.0),
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
                              icon: Icon(Icons.clear, color: Colors.white),
                              onPressed: () {},
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 5,
                            top: 5,
                            bottom: 5,
                          ),
                          child: TextField(
                            controller: titleController,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).backgroundColor,
                              hintText: 'Note Title',
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0),
                            ),
                            cursorColor: Colors.indigo,
                          ),
                        ),
                        if (referencesProperty == null)
                          buildReferencesPropertyDialog()
                        else
                          buildReferencesPropertySection(),
                        Container(
                          width: size!.width,
                          margin: EdgeInsets.only(top: 10.0, left: 15),
                          child: Text("Your images",
                              style: TextStyle(color: Colors.blue)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: imageFile != null
                              ? MediaQuery.of(context).size.height * 0.2
                              : MediaQuery.of(context).size.height * 0.07,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: imageFile == null
                                ? GestureDetector(
                                    onTap: selectImage,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: imageFile != null
                                          ? MediaQuery.of(context).size.height *
                                              0.2
                                          : MediaQuery.of(context).size.height *
                                              0.1,
                                      child: Icon(Icons.add_box,
                                          size: 30, color: Colors.blue),
                                    ),
                                  )
                                : Container(
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(imageFile!),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                imageFile = null;
                                              });
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              child: Icon(Icons.remove_circle,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 15, right: 10, bottom: 50),
                          child: TextField(
                            controller: contentController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Type your thought...",
                              border: InputBorder.none,
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.isEmpty ||
              titleController.text.trim() == "") {
            titleController.text = "Untitled";
          }
          saveNote();
        },
        child: Icon(Icons.save),
      ),
    );
  }

/* ------------------------------------------------ SAVE NOTE --------------------------------------- */

  void searchPlace(String placeName) async {}

  /* ------------------------------------------------ SAVE NOTE --------------------------------------- */

  Future<void> saveNote() async {
    String? imagePath = imageFile == null ? null : imageFile!.path;

    NoteProvider noteProvider =
        Provider.of<NoteProvider>(context, listen: false);

    int noteID;
    if (widget.note!.id == null) {
      noteID = noteProvider.notesList.length + 1;
    } else {
      noteID = widget.note!.id!;
    }

    widget.note!.id = noteID;
    widget.note!.title = titleController.text.trim();
    widget.note!.content = contentController.text.trim();
    widget.note!.imageUrl = imagePath;
    widget.note!.referencesPropertyID =
        referencesProperty == null ? null : referencesProperty!.id;

    await noteProvider.addOrUpdateNote(widget.note!);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => NoteListScreen()), (route) => false);
  }

  /* ------------------------------------------------ SELECT IMAGE FROM FILE --------------------------------------- */
  compressImage() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempDirPath = tempDir.path;

    imagePackage.Image decodedImage =
        imagePackage.decodeImage(imageFile!.readAsBytesSync())!;
    final compressedImage = File("${tempDirPath}/img_${Uuid().v4()}")
      ..writeAsBytesSync(imagePackage.encodeJpg(decodedImage, quality: 100));

    setState(() {
      imageFile = compressedImage;
    });
  }

  Future<dynamic> selectImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: [
            SimpleDialogOption(
              child: Text("Open Camera"),
              onPressed: handleCameraPicture,
            ),
            SimpleDialogOption(
              child: Text("Open Gallery"),
              onPressed: handleGalleryPicture,
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void handleCameraPicture() async {
    Navigator.pop(context);
    XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 650, maxWidth: 800);
    if (file != null) {
      Directory appDirectory = await getApplicationDocumentsDirectory();
      String appPath = appDirectory.path;
      String fileName = path.basename(file.path);

      File tempFile = File(file.path);

      tempFile = await tempFile.copy("$appPath/$fileName");

      setState(() {
        imageFile = File(tempFile.path);
      });
    }
  }

  void handleGalleryPicture() async {
    Navigator.pop(context);
    XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Directory appDirectory = await getApplicationDocumentsDirectory();
      String appPath = appDirectory.path;
      String fileName = path.basename(file.path);

      File tempFile = File(file.path);

      tempFile = await tempFile.copy("$appPath/$fileName");

      setState(() {
        imageFile = File(tempFile.path);
      });
    }
  }

  Widget buildReferencesPropertyDialog() {
    return Container(
      width: size!.width,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: MaterialButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_link_rounded),
            SizedBox(width: 5),
            Text("Add References Property"),
          ],
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    child: AlertDialog(
                      contentPadding: EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 20),
                      content: Container(
                        width: size!.width,
                        height: size!.height * 0.33,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: TextField(
                                controller: destinationController,
                                decoration: InputDecoration(
                                  hintText: 'References Property',
                                  fillColor: Color.fromRGBO(228, 213, 234, 0.7),
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 10, top: 7, bottom: 7),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) async {
                                  if (value.trim().isNotEmpty) {
                                    QuerySnapshot querySnapshot =
                                        await propertyService
                                            .getPredictedPropertyByDisplayName(
                                                value);

                                    setState(() {
                                      predictedPlacesList = List<Property>.from(
                                          querySnapshot.docs.map((document) {
                                        return Property.fromDocument(document);
                                      }).toList());
                                    });
                                  } else {
                                    setState(() {
                                      predictedPlacesList = [];
                                    });
                                  }
                                },
                              ),
                            ),
                            Container(
                              height: size!.height * 0.25,
                              child: ListView.builder(
                                itemCount: predictedPlacesList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: ListTile(
                                        leading: Container(
                                          height: (size!.height * 0.09),
                                          width: (size!.height * 0.09),
                                          child: Image.network(
                                            predictedPlacesList[index]
                                                .imageUrl![0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        minLeadingWidth: 0,
                                        title: Text(
                                            predictedPlacesList[index].name!),
                                        subtitle: Text(
                                            predictedPlacesList[index].desc!),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(
                                        () {
                                          referencesProperty =
                                              predictedPlacesList[index];
                                          predictedPlacesList.clear();
                                          destinationController.clear();

                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildReferencesPropertySection() {
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
            margin: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(referencesProperty!.name!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.highlight_remove_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2),
                      Text("Unreferences",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      referencesProperty = null;
                    });
                  },
                )
              ],
            ),
          ),
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
                                NetworkImage(referencesProperty!.imageUrl![0]),
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
        ratingTypeValue = widget.note!.cleanness == null
            ? 0
            : (widget.note!.cleanness!).toDouble();
        break;
      case 'stability':
        ratingTypeText = 'Stability';
        ratingTypeValue = widget.note!.stability == null
            ? 0
            : (widget.note!.stability!).toDouble();
        break;
      case 'affordable':
        ratingTypeText = 'Affordable';
        ratingTypeValue = widget.note!.affordable == null
            ? 0
            : (widget.note!.affordable!).toDouble();
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
                unratedColor: Colors.grey,
                itemCount: 5,
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
                onRatingUpdate: (rating) {
                  switch (ratingType) {
                    case 'cleanness':
                      widget.note!.cleanness = rating.ceil();
                      break;
                    case 'stability':
                      widget.note!.stability = rating.ceil();
                      break;
                    case 'affordable':
                      widget.note!.affordable = rating.ceil();
                      break;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
