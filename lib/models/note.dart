class Note {
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  Note({
    required this.noteID,
    required this.noteTitle,
    required this.noteContent,
    required this.createDateTime,
    required this.latestEditDateTime,
  });

  // Using factory that's mean we don't need to create an object
  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
        noteID: item['noteID'],
        noteTitle: item['noteTitle'],
        noteContent: item['noteContent'],
        createDateTime: DateTime.parse(item['createDateTime']),
        latestEditDateTime: DateTime.now());
  }
}
