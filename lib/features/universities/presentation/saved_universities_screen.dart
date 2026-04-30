import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/university.dart';
import 'university_detail_screen.dart';

class SavedUniversitiesScreen extends StatelessWidget {
  const SavedUniversitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = 'test_user';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Universities'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('saved_universities')
            .orderBy('savedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No saved universities yet'),
            );
          }

          final docs = snapshot.data!.docs;

          final universities = docs.map((doc) {
            return University.fromMap(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: universities.length,
            itemBuilder: (context, index) {
              final u = universities[index];

                return Dismissible(
                  key: ValueKey(u.name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),

                  onDismissed: (_) async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc('test_user')
                        .collection('saved_universities')
                        .doc(u.name)
                        .delete();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${u.name} removed from your plan'),
                      ),
                    );
                  },
                  
                  child: GestureDetector(

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                            UniversityDetailScreen(
                              university: u,
                              userProfile: UserProfile(
                                country: 'USA',
                                goal: 'CS',
                                academicLevel: 'Not selected',
                                level: 'Not selected',
                                exams: ['IELTS', 'SAT'],
                              ),
                            )
                        ),
                      );
                    },

                    child: Card(
                      elevation: 1.5,
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                u.imageUrl,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              u.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              u.city,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Wrap(
                              spacing: 8,
                              children: [
                                _Chip(label: 'IELTS ${u.ielts}'),
                                _Chip(label: 'TOEFL ${u.toefl}'),
                                _Chip(label: 'Duolingo ${u.duolingo}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  )
                );
            },
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}