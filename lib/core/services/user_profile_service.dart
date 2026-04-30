import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateLevel({
    required String userId,
    required String level,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set(
        {
          'academicLevel': level,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error updating user level: $e');
    }
  }

  Future<void> saveCompletedTasks({
    required String userId,
    required List<String> completedTasks,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set(
        {
          'completedTasks': completedTasks,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error saving completed tasks: $e');
    }
  }

  Future<List<String>> loadCompletedTasks({
    required String userId,
  }) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();

      if (data == null) return [];

      final completedTasks = data['completedTasks'];

      if (completedTasks is List) {
        return completedTasks.map((task) => task.toString()).toList();
      }

      return [];
    } catch (e) {
      print('Error loading completed tasks: $e');
      return [];
    }
  }
}