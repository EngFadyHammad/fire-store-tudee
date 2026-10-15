import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';

class FirestoreService {
  final tasks = FirebaseFirestore.instance.collection('tasks');
  final settings = FirebaseFirestore.instance.collection('settings');

  Future<void> addTask(String title) async {
    Task task = Task(title: title);
    await tasks.add(task.toMap());
  }
  Stream<List<Task>> getTasks() {
    return tasks.orderBy('createdAt').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> updateTitle(String id, String newTitle) async {
    await tasks.doc(id).update({'title': newTitle});
  }

  Future<void> updateStatus(String id, bool isDone) async {
    await tasks.doc(id).update({'isDone': isDone});
  }

  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }

  Future<void> saveUserName(String name) async {
    await settings.doc('user').set({'name': name});
  }

  Future<String?> getUserName() async {
    try {
      var doc = await settings.doc('user').get();
      if (!doc.exists) return null;
      return doc.data()?['name'];
    } catch (_) {
      return null;
    }
  }
}
