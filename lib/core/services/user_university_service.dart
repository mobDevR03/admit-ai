import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/university.dart';

class UserUniversityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUniversity({
    required String userId,
    required University university,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_universities')
          .doc(university.name)
          .set({
        'name': university.name,
        'country': university.country,
        'city': university.city,
        'description': university.description,
        'imageURL': university.imageUrl,
        'Duolingo': university.duolingo,
        'IELTS': university.ielts,
        'TOEFL': university.toefl,
        'tuition': university.tuition,
        'acceptanceRate': university.acceptanceRate,
        'savedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving university: $e');
    }
  }

  Future<void> removeUniversity({
    required String userId,
    required University university,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_universities')
          .doc(university.name)
          .delete();
    } catch (e) {
      print('Error removing university: $e');
    }
  }

  Future<bool> isUniversitySaved({
    required String userId,
    required University university,
  }) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_universities')
          .doc(university.name)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking saved university: $e');
      return false;
    }
  }
}