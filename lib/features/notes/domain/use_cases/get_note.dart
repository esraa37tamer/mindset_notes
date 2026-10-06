import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetNote {
  final NotesRepository repository;

  GetNote(this.repository);

  Future<Note?> call(String id) {
    return repository.getById(id);
  }
}