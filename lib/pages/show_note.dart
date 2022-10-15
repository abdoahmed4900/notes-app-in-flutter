// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors_in_immutables, must_be_immutable
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes_app/logic/database_cubit/database_cubit.dart';
import 'package:notes_app/pages/update_note_screen.dart';

import '../logic/database_cubit/database_states.dart';

class ShowNoteScreen extends StatelessWidget {
  final int index;

  String title, content, day;

  ShowNoteScreen({
    Key? key,
    required this.index,
    required this.title,
    required this.content,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, DatabaseState>(
      builder: (context, state) {
        final cubit = DatabaseCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateScreen(
                            id: cubit.notes[index]['id'],
                            index: index,
                          ),
                        ));
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    cubit.delete(cubit.notes[index]['id']);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete)),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  state is NoteDeleted || state is DatabaseEmpty
                      ? title
                      : cubit.notes[index]['title'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  state is NoteDeleted || state is DatabaseEmpty
                      ? day
                      : cubit.notes[index]['day'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  state is NoteDeleted || state is DatabaseEmpty
                      ? content
                      : cubit.notes[index]['content'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
