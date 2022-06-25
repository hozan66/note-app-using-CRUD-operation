class NoteManipulation {
  // We use NoteManipulation model for create and edit the note
  String noteTitle;
  String noteContent;

  NoteManipulation({
    required this.noteTitle,
    required this.noteContent,
  });

  // toJson() method to create a map for json
  Map<String, dynamic> toJson() {
    return {
      "noteTitle": noteTitle,
      "noteContent": noteContent,
    };
  }
}
