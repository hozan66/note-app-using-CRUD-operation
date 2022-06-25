class NoteForListing {
  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  NoteForListing({
    required this.noteID,
    required this.noteTitle,
    required this.createDateTime,
    required this.latestEditDateTime,
  });

  // Using factory that's mean we don't need to create an object
  factory NoteForListing.fromJson(Map<String, dynamic> item) {
    return NoteForListing(
        noteID: item['noteID'],
        noteTitle: item['noteTitle'],
        createDateTime: DateTime.parse(item['createDateTime']),
        latestEditDateTime: DateTime.now());
  }
}
