import '../domain/entities/note.dart';

class NotesState {
  const NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Note> notes;
  final bool isLoading;
  final String? errorMessage;

  NotesState copyWith({
    List<Note>? notes,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
      clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}