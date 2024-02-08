import 'package:bubblediary/models/notes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'notes';
  final FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseService(this._firestore);

  Future<void> addNote(Note note) async {
    String uid = auth.currentUser!.uid;
    await _firestore
        .collection(_collectionName)
        .add(note.toMap()..addAll({"userId": uid}));
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
    String uid = auth.currentUser!.uid;
    
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
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
