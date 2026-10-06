import '../repositories/notes_repository.dart';

class AddNote {
  final NotesRepository repository;

  AddNote(this.repository);

  Future<void> call({
    required String title,
    required String content,
  }) {
    return repository.add(
      title: title,
      content: content,
    );
  }
}