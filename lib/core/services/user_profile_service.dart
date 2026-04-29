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
}