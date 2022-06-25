import 'dart:convert';

import 'package:crud_app/models/api_response.dart';
import 'package:crud_app/models/note.dart';
import 'package:crud_app/models/note_for_listing.dart';
import 'package:crud_app/models/note_manipulation.dart';
import 'package:http/http.dart' as http;

class NotesService {
  // static const api = 'http://api.notes.programmingaddict.com';
  static const api = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  // apiKey used for authentication
  static const headers = {
    'apiKey': '8b036077-e32a-42a9-a568-980c18e9a19c',
    'Content-Type': 'application/json', // necessary for post() request
  };
  // final notes = <NoteForListing>[];
  // final List<NoteForListing> notes = [];

  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    final List<NoteForListing> notes = [];
    return http.get(Uri.parse('$api/notes'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        // json.decode ==> import 'dart:convert';
        final jsonData = json.decode(data.body); // Data here is a list of map

        // print(jsonData);
        // for (Map<String, dynamic> item in jsonData)
        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(data: [], error: true);
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        data: [], errorMessage: 'An error occurred', error: true));
  }

  // =====================================================
  Future<APIResponse<Note>> getNote(String noteID) {
    Note note2 = Note(
        noteID: 'Empty',
        noteTitle: 'Empty',
        noteContent: 'Empty',
        createDateTime: DateTime.now(),
        latestEditDateTime: DateTime.now());

    return http
        .get(Uri.parse('$api/notes/$noteID'), headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        // json.decode ==> import 'dart:convert';
        final jsonData = json.decode(data.body); // Data here is a single map
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(data: note2, error: true);
    }).catchError((_) => APIResponse<Note>(
            data: note2, errorMessage: 'An error occurred', error: true));
  }

  // =====================================================
  // post() request for sending data to api
  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http
        .post(Uri.parse('$api/notes'),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        // When we want to create a resource => statusCode=201
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false, errorMessage: 'An error occurred', error: true);
    }).catchError((_) => APIResponse<bool>(
            data: false, errorMessage: 'An error occurred', error: true));
  }

  // =====================================================
  // put() request for updating data from api
  Future<APIResponse<bool>> updateNote(String noteID, NoteManipulation item) {
    return http
        .put(Uri.parse('$api/notes/$noteID'),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        // When we want to update a resource => statusCode=204
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: true, errorMessage: 'An error occurred', error: true);
    }).catchError((_) => APIResponse<bool>(
            data: false, errorMessage: 'An error occurred', error: true));
  }

  // =====================================================
  // delete() request for deleting data from api
  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http
        .delete(Uri.parse('$api/notes/$noteID'), headers: headers)
        .then((data) {
      if (data.statusCode == 204) {
        // When we want to delete a resource => statusCode=204
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false, errorMessage: 'An error occurred', error: true);
    }).catchError((_) => APIResponse<bool>(
            data: false, errorMessage: 'An error occurred', error: true));
  }
}
