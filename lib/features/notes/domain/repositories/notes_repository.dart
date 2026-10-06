import '../entities/note.dart';

abstract interface class NotesRepository {
  // instead of => Future<List<FirebaseNote>> getAll();
  // obviously wrong because domain must not see firebase

  Future<List<Note>> getAll();

  Future<Note?> getById(String id);

  Future<void> add({
    required String title,
    required String content,
  });

  Future<void> update(Note note);

  Future<void> delete(String id);
}