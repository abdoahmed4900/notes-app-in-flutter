// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/logic/database_cubit/database_cubit.dart';

import '../logic/database_cubit/database_states.dart';
import '../widgets/widgets.dart';

class UpdateScreen extends StatelessWidget {
  final int id, index;

  UpdateScreen({super.key, required this.id, required this.index});

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, DatabaseState>(
      builder: (context, state) {
        final cubit = DatabaseCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                    onPressed: () {
                      cubit.update(
                          id: id,
                          title: titleController.text.isNotEmpty
                              ? titleController.text
                              : cubit.notes[index]['title'],
                          content: contentController.text.isNotEmpty
                              ? contentController.text
                              : cubit.notes[index]['content']);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.edit)),
              ),
            ],
          ),
          body: Column(
            children: [
              NoteField(
                controller: titleController..text = cubit.notes[index]['title'],
                label: 'title',
              ),
              Expanded(
                child: NoteField(
                  controller: contentController
                    ..text = cubit.notes[index]['content'],
                  label: 'Type something....',
                  maxLines: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
