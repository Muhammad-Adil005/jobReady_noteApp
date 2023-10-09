import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // This Function is for inserting a new Note to a Home Screen
  Future insertNote(
      String title, String description, String image, String userId) async {
    try {
      await firestore.collection('notes').add({
        "title": title,
        "description": description,
        "image": image,
        "date": DateTime.now(),
        "userId": userId
      });
    } catch (e) {
      print('This error occur during the creating or insertion of Note : ${e}');
    }
  }

  // This Function is for Updating a Note in Edit Note Screen

  Future updateNote(String docId, String title, String description) async {
    try {
      await firestore.collection('notes').doc(docId).update({
        'title': title,
        'description': description,
      });
    } catch (e) {
      print('This error occur during the updation of Note : ${e}');
    }
  }

// This Function is for Deleting a  Note.

  Future deleteNote(String docId) async {
    try {
      await firestore.collection('notes').doc(docId).delete();
    } catch (e) {
      print('This error occur during the deletion of Note : ${e}');
    }
  }
}
