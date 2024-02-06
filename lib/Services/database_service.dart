import 'package:bubblediary/models/notes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'notes';

  DatabaseService(this._firestore);

  Future<void> addNote(Note note) async {
    await _firestore.collection(_collectionName).add(note.toMap());
  }

  Future<void> updateNote(Note note) async {
    await _firestore
        .collection(_collectionName)
        .doc(note.id)
        .update(note.toMap());
  }

  Future<void> deleteNote(Note note) async {
    await _firestore.collection(_collectionName).doc(note.id).delete();
  }

  Stream<List<Note>> notesStream() {
    return _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
    });
  }

  Future<void> deleteAllNotes() async {
    final batch = _firestore.batch();
    final querySnapshot = await _firestore.collection(_collectionName).get();
    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });
    await batch.commit();
  }
}
