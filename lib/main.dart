import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_notes/features/notes/data/repository/online_notes_repository.dart';
import 'package:mindset_notes/features/profile/cubit/user_cubit.dart';
import 'package:mindset_notes/firebase_options.dart';

import 'core/routes/routes.dart';
import 'features/notes/cubit/notes_cubit.dart';
import 'package:mindset_notes/features/notes/domain/use_cases/add_note.dart';
import 'package:mindset_notes/features/notes/domain/use_cases/delete_note.dart';
import 'package:mindset_notes/features/notes/domain/use_cases/get_note.dart';
import 'package:mindset_notes/features/notes/domain/use_cases/get_notes.dart';
import 'package:mindset_notes/features/notes/domain/use_cases/update_note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          final repository = OnlineNotesRepository();

          return NotesCubit(
            getNotes: GetNotes(repository),
            getNote: GetNote(repository),
            addNoteUseCase: AddNote(repository),
            updateNoteUseCase: UpdateNote(repository),
            deleteNoteUseCase: DeleteNote(repository),
          )..getAllNotes();
        },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,

        builder: (context, child) {
          return BlocProvider(create: (context) => UserCubit(), child: child);
        },
      ),
    );
  }
}
