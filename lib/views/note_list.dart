// import 'package:crud_app/main.dart';
import 'package:crud_app/models/api_response.dart';
import 'package:crud_app/models/note_for_listing.dart';
import 'package:crud_app/services/notes_service.dart';
import 'package:crud_app/views/note_delete.dart';
import 'package:crud_app/views/note_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  // final service = NotesService(); create object in this way is not recommended
  NotesService get service => GetIt.I<NotesService>();

  bool _isLoading = false;
  late APIResponse<List<NoteForListing>> _apiResponse;

  @override
  void initState() {
    super.initState();

    _fetchNotes();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNotesList();
    print("_apiResponse=${_apiResponse.data.length}");

    setState(() {
      _isLoading = false;
    });
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    print('counter=${counter++}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of Notes using CRUD',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_apiResponse.error) {
            return Center(
              child: Text('${_apiResponse.errorMessage}'),
            );
          }

          return ListView.builder(
              itemBuilder: (_, index) {
                return Card(
                  elevation: 8.0,
                  margin: const EdgeInsets.all(6.0),
                  color: Colors.amber,
                  child: Dismissible(
                    key: ValueKey(_apiResponse.data[index].noteID),
                    // key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                    ),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      final result = await showDialog(
                          context: context, builder: (_) => const NoteDelete());

                      print(result.runtimeType); // print data type
                      print('my ID=${_apiResponse.data[index].noteID}');
                      print("my result=$result");

                      if (result == true) {
                        setState(() {
                          _isLoading = true;
                        });

                        print('my ID=${_apiResponse.data[index].noteID}');
                        APIResponse<bool> deleteResult = await service
                            .deleteNote(_apiResponse.data[index].noteID);
                        print('deleteResult=$deleteResult');

                        String? message;
                        if (deleteResult != false &&
                            deleteResult.data == true) {
                          message = 'The note was deleted successfully!';
                        } else {
                          // message = 'An error occurred';
                          message =
                              deleteResult.errorMessage ?? 'An error occurred';
                          // deleteResult.errorMessage ?? 'An error occurred';
                        }

                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text('Done!'),
                                  content: Text(message!),
                                  actions: [
                                    TextButton(
                                        child: const Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                ));

                        _fetchNotes(); // refresh
                        return deleteResult.data;
                      }

                      print(result);
                      return result;
                    },
                    child: ListTile(
                      title: Text(
                        _apiResponse.data[index].noteTitle,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0),
                      ),
                      // DateFormat.yMEd().add_jms().format(DateTime.now());
                      // ==> 'Thu, 5/23/2013 10:21:47 AM'
                      subtitle: Text(
                          'Last edited on ${DateFormat.yMEd().add_jms().format(_apiResponse.data[index].latestEditDateTime)}'),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (_) => NoteModify(
                                    noteID: _apiResponse.data[index].noteID)))
                            .then((_) {
                          // To refresh the list of notes
                          // then() method execute when we pop()
                          _fetchNotes();
                        });
                      },
                    ),
                  ),
                );
              },
              itemCount: _apiResponse.data.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (_) => const NoteModify(noteID: "0")))
              .then((_) {
            // To refresh the list of notes
            // then() method execute when we pop()
            _fetchNotes();
          });
        },
      ),
    );
  }
}
