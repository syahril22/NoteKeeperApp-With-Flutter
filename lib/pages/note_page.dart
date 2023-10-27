import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_keeper/database/note_database.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/pages/add_edit_note_page.dart';
import 'package:note_keeper/pages/note_detail_page.dart';
import 'package:note_keeper/widgets/note_card_widgets.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isLoading = false;
  late List<Note> notes;

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await NoteDatabase.instance.getAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Page'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text('notes kosong')
                : MasonryGridView.count(
                    itemCount: notes.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return GestureDetector(
                          onTap: () async {
                            final route = MaterialPageRoute(
                              builder: (context) => NoteDetailPage(
                                id: note.id!,
                              ),
                            );
                            await Navigator.push(context, route);
                            refreshNotes();
                          },
                          child: NoteCardWidget(note: note, index: index));
                    }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final note = Note(
          //     isImportant: false,
          //     number: 1,
          //     title: "Testing",
          //     description: "Desc testing",
          //     createdTime: DateTime.now());
          // await NoteDatabase.instance.create(note);
          // refreshNotes();
          final route = MaterialPageRoute(
            builder: (context) => AddEditNotePage(),
          );
          await Navigator.push(context, route);
          refreshNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
