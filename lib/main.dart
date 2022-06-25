import 'package:crud_app/services/notes_service.dart';
import 'package:crud_app/views/note_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// This method for initialization
void setupLocator() {
  // Service locator library
  // It creates the instance only on the first call on the object
  // GetIt.instance or GetIt.I
  GetIt.I.registerLazySingleton(() => NotesService());
}

// Internet permission
// <uses-permission android:name="android.permission.INTERNET" />
void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   textTheme: const TextTheme(
      //     bodyText1: TextStyle(fontSize: 20.0),
      //     bodyText2: TextStyle(fontSize: 24.0),
      //   ),
      // ),
      home: NoteList(),
    );
  }
}
