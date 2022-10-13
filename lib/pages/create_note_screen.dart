// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_literals_to_create_immutables, must_be_immutable
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/logic/database_cubit/database_cubit.dart';
import 'package:notes_app/widgets/widgets.dart';

import '../logic/database_cubit/database_states.dart';

class CreateNoteScreen extends StatelessWidget {
  CreateNoteScreen({
    Key? key,
  }) : super(key: key);

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                      onPressed: state is CanInsert
                          ? () {
                              cubit.insert(
                                  content: contentController.text,
                                  day: DateFormat.yMMMMd()
                                      .format(DateTime.now()),
                                  title: titleController.text);
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text('Add')),
                )
              ]),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            NoteField(
              controller: titleController,
              label: 'title',
              onChanged: (value) {
                cubit.enableInsert(value);
              },
            ),
            Expanded(
              child: NoteField(
                controller: contentController,
                label: 'Type something....',
                maxLines: 12,
              ),
            ),
          ]),
        );
      },
    );
  }
}
