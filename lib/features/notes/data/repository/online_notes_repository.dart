import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../models/online_note.dart';

const noteCollection = 'Notes';

class OnlineNotesRepository implements NotesRepository {
  final db = FirebaseFirestore.instance;

  @override
  Future<void> add({
    required String title,
    required String content,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (isUserSignedIn()) {
      final now = DateTime.now();

      final doc = await db.collection(noteCollection).add({
        'title': title,
        'content': content,
        'userId': user!.uid,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      final contentAdded = await doc.get();

      log(contentAdded.data().toString());
    } else {
      log('unable to add note');
    }
  }

  @override
  Future<List<Note>> getAll() async {
    final user = FirebaseAuth.instance.currentUser;

    log('user?.uid ${user?.uid}');

    final res = (await db.collection(noteCollection).get()).docs
        .where((element) => element['userId'] == user?.uid)
        .map((e) {
      final data = {
        ...e.data(),
        'id': e.id,
      };

      return FirebaseNote.fromJson(data);
    })
        .toList();

    log(res.length.toString());

    // convert data models to domain entities
    return res.map((firebaseNote) {
      return Note(
        id: firebaseNote.id,
        title: firebaseNote.title,
        content: firebaseNote.content,
        createdAt: firebaseNote.createdAt,
        updatedAt: firebaseNote.updatedAt,
      );
    }).toList();
  }

  @override
  Future<Note?> getById(String id) async {
    final doc = await db
        .collection(noteCollection)
        .doc(id)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    final data = {
      ...doc.data()!,
      'id': doc.id,
    };

    final firebaseNote = FirebaseNote.fromJson(data);

    return Note(
      id: firebaseNote.id,
      title: firebaseNote.title,
      content: firebaseNote.content,
      createdAt: firebaseNote.createdAt,
      updatedAt: firebaseNote.updatedAt,
    );
  }

  @override
  Future<void> update(Note note) async {
    await db
        .collection(noteCollection)
        .doc(note.id)
        .update({
      'title': note.title,
      'content': note.content,
      'createdAt': Timestamp.fromDate(note.createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  @override
  Future<void> delete(String id) async {
    await db
        .collection(noteCollection)
        .doc(id)
        .delete();
  }

  bool isUserSignedIn() {
    final user = FirebaseAuth.instance.currentUser;

    return user != null;
  }
}