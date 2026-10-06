import '../repositories/notes_repository.dart';

class DeleteNote {
  final NotesRepository repository;

  DeleteNote(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}