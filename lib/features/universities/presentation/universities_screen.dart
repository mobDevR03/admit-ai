import 'package:flutter/material.dart';
import 'university_detail_screen.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/university.dart';
import '../../../../core/services/university_service.dart';

class UniversitiesScreen extends StatefulWidget {
  final UserProfile userProfile;

  const UniversitiesScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities'),
      ),
      
      body: FutureBuilder<List<University>>(
        future: UniversityService().getUniversities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final allUniversities = snapshot.data ?? [];

          final filtered = allUniversities.where((u) {
            if (widget.userProfile.country == null) return true;
            if (widget.userProfile.country == 'Europe') {
              return u.country != 'USA';
            }
            return u.country == widget.userProfile.country;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Recommended for ${widget.userProfile.country ?? 'you'}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              if (filtered.isEmpty)
                const Text('No universities found')
              else ...[
                ...filtered.map((university) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _UniversityCard(university: university),
                  );
                }),
              ],
            ],
          );
        },
      ),

    );
  }
}

class _UniversityCard extends StatelessWidget {
  final University university;

  const _UniversityCard({
    required this.university,
  });

  String getCurrencySymbol(String country) {
    switch (country) {
      case 'USA':
        return '\$';
      case 'UK':
        return '£';
      case 'Netherlands':
      case 'Germany':
      case 'France':
      case 'Spain':
        return '€';
      case 'Switzerland':
        return 'CHF ';
      default:
        return '\$';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UniversityDetailScreen(
              university: university,
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

      child: Container(
        height: 260,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
  
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  university.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      university.country,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 6,
                      children: [
                        if (university.duolingo > 0)
                          _InfoChip(label: "Duolingo ${university.duolingo}"),

                        if (university.ielts > 0)
                          _InfoChip(label: "IELTS ${university.ielts}"),

                        if (university.toefl > 0)
                          _InfoChip(label: "TOEFL ${university.toefl}"),

                        _InfoChip(
                          label: "💰 ${getCurrencySymbol(university.country)}${university.tuition}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({
    required this.label,
  });

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
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
      ),
    );
  }
}