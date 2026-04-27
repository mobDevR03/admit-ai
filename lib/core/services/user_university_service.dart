import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/university.dart';

class UserUniversityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUniversity({
    required String userId,
    required University university,
  }) async {
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
  }

  Future<void> removeUniversity({
    required String userId,
    required University university,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_universities')
        .doc(university.name)
        .delete();
  }

  Future<bool> isUniversitySaved({
    required String userId,
    required University university,
  }) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_universities')
        .doc(university.name)
        .get();

    return doc.exists;
  }
}