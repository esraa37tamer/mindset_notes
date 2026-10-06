// presentation - UI
// data layer - models + repository
// cubit -> state

// SOC sepration of concern
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/note.dart';
import '../domain/use_cases/add_note.dart';
import '../domain/use_cases/delete_note.dart';
import '../domain/use_cases/get_note.dart';
import '../domain/use_cases/get_notes.dart';
import '../domain/use_cases/update_note.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({
    required this.getNotes,
    required this.getNote,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) : super(const NotesState());

  final GetNotes getNotes;
  final GetNote getNote;
  final AddNote addNoteUseCase;
  final UpdateNote updateNoteUseCase;
  final DeleteNote deleteNoteUseCase;

  void getAllNotes() async {
    emit(state.copyWith(isLoading: true));

    try {
      final notes = await getNotes();

      emit(
        state.copyWith(
          notes: notes,
          isLoading: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    } finally {
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<Note?> getNoteById(String id) {
    return getNote(id);
  }

  void addNote({
    required String title,
    required String content,
  }) async {
    await addNoteUseCase(
      title: title,
      content: content,
    );

    getAllNotes();
  }

  void updateNote(Note note) async {
    await updateNoteUseCase(note);

    getAllNotes();
  }

  void deleteNote(String id) async {
    await deleteNoteUseCase(id);

    getAllNotes();
  }

  void clear() {
    emit(const NotesState());
  }
}