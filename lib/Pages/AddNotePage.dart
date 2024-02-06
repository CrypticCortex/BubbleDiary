import 'package:bubblediary/Services/notes_provider.dart';
import 'package:bubblediary/models/notes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _category = '';

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var newDocRef =
          FirebaseFirestore.instance.collection('your_collection_name').doc();

      Note newNote = Note(
        id: newDocRef.id,
        title: _title,
        content: _content,
        category: _category,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
      );

      Provider.of<NotesProvider>(context, listen: false).addNote(newNote);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (input) =>
                      input!.trim().isEmpty ? 'Please enter a title' : null,
                  onSaved: (input) => _title = input!,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (input) => input!.trim().isEmpty
                      ? 'Please enter some content'
                      : null,
                  onSaved: (input) => _content = input!,
                  maxLines: 8,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onSaved: (input) => _category = input!,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text('Add Note', style: TextStyle(fontSize: 18.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
