class Note {
  final String id;
  final String title;
  final String content;
  final DateTime dateCreated;
  final DateTime dateLastEdited;
  final String? category;

  Note(
      {required this.id,
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
      'category': category
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
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
