class Note {
  final String id;
  final String title;
  final String content;
  final DateTime dateCreated;
  final DateTime dateLastEdited;
  final String? category;
  final String uid;

  Note(
      {required this.uid,
        required this.id,
      required this.title,
      required this.content,
      required this.dateCreated,
      required this.dateLastEdited,
      this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'dateLastEdited': dateLastEdited.millisecondsSinceEpoch,
      'category': category,
      'uid' : uid,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      uid: map['uid'],
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated']),
      dateLastEdited:
          DateTime.fromMillisecondsSinceEpoch(map['dateLastEdited']),
      category: map['category'],
    );
  }
}
