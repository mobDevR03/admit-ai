import 'package:flutter/material.dart';

import '../../../core/models/university.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/services/university_service.dart';
import '../../../core/utils/currency_utils.dart';
import 'university_detail_screen.dart';

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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final allUniversities = snapshot.data ?? [];

          final filtered = allUniversities.where((university) {
            final country = widget.userProfile.country;

            if (country == null) return true;

            if (country == 'Europe') {
              return university.country != 'USA';
            }

            return university.country == country;
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
              else
                ...filtered.map(
                  (university) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _UniversityCard(
                      university: university,
                      userProfile: widget.userProfile,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _UniversityCard extends StatelessWidget {
  final University university;
  final UserProfile userProfile;

  const _UniversityCard({
    required this.university,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final tuition = CurrencyUtils.formatTuition(
      country: university.country,
      tuition: university.tuition,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UniversityDetailScreen(
              university: university,
              userProfile: userProfile,
            ),
          ),
        );
      },
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.9),
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
                      runSpacing: 6,
                      children: [
                        if (university.duolingo > 0)
                          _InfoChip(label: 'Duolingo ${university.duolingo}'),
                        if (university.ielts > 0)
                          _InfoChip(label: 'IELTS ${university.ielts}'),
                        if (university.toefl > 0)
                          _InfoChip(label: 'TOEFL ${university.toefl}'),
                        _InfoChip(label: tuition),
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
        color: Colors.blue.withValues(alpha: 0.08),
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