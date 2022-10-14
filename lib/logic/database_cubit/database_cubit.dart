// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/logic/database_cubit/database_states.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitial());

  late Database database;

  List<Map> notes = [];

  static DatabaseCubit get(context) => BlocProvider.of(context);

  List<Color> colors = [
    Color.fromARGB(255, 142, 78, 124),
    Color.fromARGB(255, 234, 149, 149),
    Color.fromARGB(255, 71, 201, 188),
    Color.fromARGB(255, 15, 122, 136),
    Color.fromARGB(255, 71, 94, 105),
    Color.fromARGB(255, 119, 4, 177),
    Color.fromARGB(255, 122, 177, 4),
    Color.fromARGB(255, 236, 98, 29),
  ];

  bool isAddingButtonEnabled = false;

  bool isUpdatingButtonEnabled = false;

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();

    //'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, day TEXT)'

    database = await openDatabase(join(path, 'tasks.db'), version: 1,
        onCreate: (db, version) {
      db
          .execute(
              'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, day TEXT)')
          .then((value) => print('table created'));
    }, onOpen: (db) async {
      notes = await getNotes(db);
      emit(DatabaseCreated());
      if (notes.isEmpty) {
        emit(DatabaseEmpty());
      }
    });

    return database;
  }

  Future<void> insert(
      {required String title,
      required String content,
      required String day}) async {
    await database.transaction((txn) async {
      txn.insert('notes',
          {'title': title, 'content': content, 'day': day}).then((value) async {
        print('$value is inserted');
        notes = await getNotes(database);
        emit(DatabaseInserted());
      });
    });
  }

  void enableUpdate(String? text) {
    if (text == null || text.isEmpty) {
      isUpdatingButtonEnabled = false;
      emit(CannotUpdate());
      return;
    }
    isUpdatingButtonEnabled = true;
    emit(CanUpdate());
  }

  void enableInsert(String? text) {
    if (text == null || text.isEmpty) {
      isAddingButtonEnabled = false;
      emit(CannotInsert());
      return;
    }
    isAddingButtonEnabled = true;
    emit(CanInsert());
  }

  void update(
      {required int id, required String title, required String content}) async {
    try {
      await database.update('notes', {'title': title, 'content': content},
          where: 'id = ?',
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.replace);
      notes = await getNotes(database);
      emit(NoteUpdated());
    } catch (e) {
      print('update error : ${e.toString()}');
    }
  }

  Future<void> delete(int id) async {
    try {
      await database.delete('notes', where: 'id = ?', whereArgs: [id]);
      notes = await getNotes(database);

      emit(NoteDeleted());
      if (notes.isEmpty) {
        emit(DatabaseEmpty());
      }
    } catch (e) {
      print('deletion error : ${e.toString()}');
    }
  }

  Future getNotes(Database db) async {
    return await db.query('notes');
  }
}
