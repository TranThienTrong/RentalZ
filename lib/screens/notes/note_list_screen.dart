import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/providers/note_provider.dart';
import 'package:rental_apartments_finder/screens/notes/note_view_screen.dart';

import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  Size? size;
  late NoteProvider noteProvider;

  @override
  void initState() {
    noteProvider = Provider.of<NoteProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Note List'),
    );
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildHeader(),
            FutureBuilder(
              future: noteProvider.getAllNotes(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Consumer<NoteProvider>(
                    builder: (context, noteProvider, child) {
                      if (noteProvider.notesList.length <= 0) {
                        return child!;
                      } else {
                        return Container(
                          height: size!.height * (0.9),
                          width: size!.width,
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            itemCount: noteProvider.notesList.length,
                            padding: EdgeInsets.all(10),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2.0,
                                        spreadRadius: 0.025,
                                        offset: Offset(0.5, 0.5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        noteProvider.notesList[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (noteProvider
                                              .notesList[index].imageUrl !=
                                          null)
                                        Container(
                                          height: size!.height * 0.15,
                                          width: size!.width * 0.5,
                                          margin: EdgeInsets.only(
                                              top: size!.height * 0.007,
                                              bottom: size!.height * 0.007),
                                          child: Image.file(
                                            File(noteProvider
                                                .notesList[index].imageUrl!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      Text(
                                        noteProvider.notesList[index].content!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: noteProvider.notesList[index]
                                                    .imageUrl ==
                                                null
                                            ? 5
                                            : 4,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NoteViewScreen(
                                          note: noteProvider.notesList[index]),
                                    ),
                                  );
                                },
                              );
                            },
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.count(
                                    2,
                                    noteProvider.notesList[index].imageUrl ==
                                            null
                                        ? 2
                                        : 3),
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                          ),
                        );
                      }
                    },
                    child: buildNoNoteWidget(),
                  );
                } else {
                  return buildNoNoteWidget();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoNoteWidget() {
    return Container(
      height: size!.height * (1 - 0.1),
      width: size!.width,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: size!.height * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size!.width * 0.6,
              child: Image.asset(
                'assets/images/empty-folder.png',
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteEditScreen()));
                  },
                  icon: Icon(
                    Icons.note_add_outlined,
                    color: Colors.blue,
                  ),
                  iconSize: size!.width * 0.15,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('Add new note',
                      style: TextStyle(fontSize: 15, color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: size!.height * 0.09,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50.0),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 0),
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () async {
                  await noteProvider.deleteAllNotes();
                },
                icon: Icon(
                  Icons.cleaning_services_rounded,
                  color: Colors.white,
                ),
                iconSize: size!.width * 0.07,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 25),
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NoteEditScreen()));
                },
                icon: Icon(
                  Icons.note_add_outlined,
                  color: Colors.white,
                ),
                iconSize: size!.width * 0.07,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
