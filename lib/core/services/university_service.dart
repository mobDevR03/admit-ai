import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/university.dart';

class UniversityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<University>> getUniversities() async {
    try {
      final snapshot = await _firestore.collection('universities').get();

      return snapshot.docs
          .map((doc) => University.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching universities: $e');
      return [];
    }
  }
}