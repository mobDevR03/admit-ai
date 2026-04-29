import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> updateLevel({
    required String userId,
    required String level,
  }) async {
    await _firestore.collection('users').doc(userId).set(
      {
        'academicLevel': level,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> saveCompletedTasks({
    required String userId,
    required List<String> completedTasks,
  }) async {
    await _firestore.collection('users').doc(userId).set(
      {
        'completedTasks': completedTasks,
      },
      SetOptions(merge: true),
    );
  }

  Future<List<String>> loadCompletedTasks({
    required String userId,
  }) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    final data = doc.data();

    if (data == null) return [];

    final completedTasks = data['completedTasks'];

    if (completedTasks is List) {
      return completedTasks.map((task) => task.toString()).toList();
    }

    return [];
  }
}