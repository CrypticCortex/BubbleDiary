import 'dart:io';
import 'package:bubblediary/Services/note_search.dart';
import 'package:bubblediary/Services/notes_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bubble_lens/bubble_lens.dart';
import 'package:provider/provider.dart';

import '../Utils/Themenotifier.dart';

class BubbleLensNotes extends StatelessWidget {
  init() async {
    print("Reached BubbleLensNotes");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          final notes = notesProvider.notes;

          final brightness = Theme.of(context).brightness;
          final themeNotifier = Provider.of<ThemeNotifier>(context);

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text(
                'Your Personal Bubble Diary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: NotesSearch(notes: notes));
                  },
                ),
                Consumer<ThemeNotifier>(
                  builder: (_, themeNotifier, __) => IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.wb_sunny
                          : Icons.nights_stay,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    onPressed: () {
                      themeNotifier.setTheme(
                        themeNotifier.getTheme().brightness == Brightness.dark
                            ? ThemeData.light()
                            : ThemeData.dark(),
                      );
                    },
                  ),
                ),
              ],
            ),

            //appBar: AppBar(
            //  automaticallyImplyLeading: false,
            //  centerTitle: true,
            //  title: const Text('Your Personal Bubble Diary',
            //      style: TextStyle(fontWeight: FontWeight.bold)),
            //  actions: <Widget>[
            //    IconButton(
            //      icon: Icon(Icons.search),
            //      onPressed: () {
            //        showSearch(
            //            context: context, delegate: NotesSearch(notes: notes));
            //      },
            //    ),
            //    //PopupMenuButton<String>(
            //    //  color: Theme.of(context).cardColor,
            //    //  onSelected: (value) async {
            //    //    if (value == 'Clear All') {
            //    //      final confirm = await showDialog(
            //    //        context: context,
            //    //        builder: (BuildContext context) {
            //    //          return AlertDialog(
            //    //            title: const Text(
            //    //                'Are you sure you want to delete all notes?'),
            //    //            actions: <Widget>[
            //    //              TextButton(
            //    //                child: const Text("Cancel"),
            //    //                onPressed: () {
            //    //                  Navigator.of(context).pop(false);
            //    //                },
            //    //              ),
            //    //              TextButton(
            //    //                child: const Text("Yes"),
            //    //                onPressed: () {
            //    //                  Navigator.of(context).pop(true);
            //    //                },
            //    //              ),
            //    //            ],
            //    //          );
            //    //        },
            //    //      );
            //    //      if (confirm) {
            //    //        notesProvider.deleteAllNotes();
            //    //      }
            //    //    }
            //    //    if (value == 'Settings') {
            //    //      Navigator.pushNamed(context, '/settings');
            //    //    }
            //    //    if (value == 'Logout') {
            //    //      Navigator.pushReplacementNamed(context, '/');
            //    //    }
            //    //  },
            //    //  itemBuilder: (BuildContext context) =>
            //    //      <PopupMenuEntry<String>>[
            //    //    const PopupMenuItem<String>(
            //    //      value: 'Clear All',
            //    //      child: Text('Clear All'),
            //    //    ),
            //    //    const PopupMenuItem<String>(
            //    //      value: 'Settings',
            //    //      child: Text('Settings'),
            //    //    ),
            //    //  ],
            //    //),
            //  ],
            //),
            body: Container(
              padding: const EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: BubbleLens(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                widgets: notes.map((note) {
                  String noteId = note.id;
                  User? user = FirebaseAuth.instance.currentUser;
                  String userID = user!.uid;
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            surfaceTintColor: Theme.of(context).focusColor,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        fontFamily: 'Poppins')),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(note.dateCreated),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            content: Text(note.content,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    fontFamily: 'Poppins')),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "Close",
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      width: 500,
                      height: 500,
                      child: Card(
                        color: Theme.of(context).secondaryHeaderColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  note.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  note.content,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            floatingActionButton: Consumer<ThemeNotifier>(
                builder: (context, ThemeNotifier notifier, child) {
              return Container(
                decoration: BoxDecoration(
                  color: notifier
                      .getTheme()
                      .primaryColorLight, // this is your backgroundColor
                  shape: BoxShape.circle, // this line make it circular
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 50,
                    color: notifier.getTheme().primaryColorDark,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addNote');
                  },
                  color: notifier
                      .getTheme()
                      .secondaryHeaderColor, // color for IconButton itself
                  // modify the color for splash, highlight and hover as per your requirement
                  splashColor: notifier.getTheme().splashColor,
                  highlightColor: notifier.getTheme().hoverColor,
                  hoverColor: notifier.getTheme().highlightColor,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
