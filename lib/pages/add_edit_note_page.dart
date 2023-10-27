import 'package:flutter/material.dart';
import 'package:note_keeper/database/note_database.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/widgets/note_form_widgets.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButtonSave()],
        title: const Text("Add"),
      ),
      body: Form(
          key: _formKey,
          child: NoteFormWidget(
              isImportant: isImportant,
              number: number,
              title: title,
              description: description,
              onChangeIsImportant: (value) {
                setState(() {
                  isImportant = value;
                });
              },
              onChangeNumber: (value) {
                setState(() {
                  number = value;
                });
              },
              onChangeTitle: (value) {
                title = value;
              },
              onChangeDescription: (value) {
                description = value;
              })),
    );
  }

  buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: addEditNote,
        child: const Text("Save"),
      ),
    );
  }

  void addEditNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      // add data
      final isUpdate = widget.note != null;
      if (isUpdate) {
        // update data
        await updateNote();
      } else {
        // tambah data
        await addNote();
      }
      Navigator.pop(context);
    }
  }

  Future addNote() async {
    final note = Note(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );
    await NoteDatabase.instance.create(note);
  }

  Future updateNote() async {
    final note = widget.note?.copy(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());
    await NoteDatabase.instance.updateNoteById(note!);
  }
}
