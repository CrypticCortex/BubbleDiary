import 'package:bubblediary/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesSearch extends SearchDelegate {
  final List<Note> notes;

  NotesSearch({required this.notes});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestionList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestionList();
  }

  Widget _buildSuggestionList() {
    final suggestionList = query.isEmpty
        ? notes
        : notes.where((note) {
            return note.title.toLowerCase().contains(query.toLowerCase()) ||
                note.content.toLowerCase().contains(query.toLowerCase()) ||
                (note.category != null
                    ? note.category!.toLowerCase().contains(query.toLowerCase())
                    : false);
          }).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        final note = suggestionList[index];
        return ListTile(
          title: Text(note.title),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 50,fontFamily: 'Poppins')),
                        Text(DateFormat('yyyy-MM-dd').format(note.dateCreated),
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20,fontFamily: 'Poppins')),
                        Text('${note.category}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 89, 151, 69)))
                      ]),
                  content: Text(note.content,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20,fontFamily: 'Poppins')),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
