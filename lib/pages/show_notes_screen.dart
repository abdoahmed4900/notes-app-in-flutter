// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/logic/database_cubit/database_cubit.dart';
import 'package:notes_app/logic/database_cubit/database_states.dart';
import 'package:notes_app/pages/show_note.dart';

import 'create_note_screen.dart';

class NotesScreen extends StatelessWidget {
  final String title;

  NotesScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body:
          BlocBuilder<DatabaseCubit, DatabaseState>(builder: (context, state) {
        final cubit = DatabaseCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlignedGridView.count(
            itemCount: cubit.notes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowNoteScreen(
                          index: index,
                          title: cubit.notes[index]['title'],
                          content: cubit.notes[index]['content'],
                          day: cubit.notes[index]['day'],
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: cubit.colors[
                        math.Random().nextInt(cubit.colors.length - 1) + 0],
                  ),
                  width: math.Random().nextInt(
                          (MediaQuery.of(context).size.width * 0.382).toInt()) +
                      MediaQuery.of(context).size.width * 0.255,
                  height: math.Random().nextInt(
                          (MediaQuery.of(context).size.height * 0.135)
                              .toInt()) +
                      MediaQuery.of(context).size.height * 0.09,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cubit.notes[index]['day']),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Expanded(child: Text(cubit.notes[index]['title'])),
                      ],
                    ),
                  ),
                ),
              );
            },
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateNoteScreen(),
          ));
        },
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
