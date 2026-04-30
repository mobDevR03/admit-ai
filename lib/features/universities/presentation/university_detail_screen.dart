import 'package:flutter/material.dart';

import '../../../core/models/university.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/services/user_university_service.dart';
import '../../../core/utils/currency_utils.dart';

class UniversityDetailScreen extends StatefulWidget {
  final UserProfile userProfile;
  final University university;

  const UniversityDetailScreen({
    super.key,
    required this.university,
    required this.userProfile,
  });

  @override
  State<UniversityDetailScreen> createState() =>
      _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  final _service = UserUniversityService();
  final String _userId = 'test_user';

  bool _isSaved = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final isSaved = await _service.isUniversitySaved(
      userId: _userId,
      university: widget.university,
    );

    if (!mounted) return;

    setState(() {
      _isSaved = isSaved;
      _isLoading = false;
    });
  }

  String _buildSmartDescription() {
    final exams = widget.userProfile.exams;

    final hasDuolingo = exams.contains('Duolingo');
    final hasIelts = exams.contains('IELTS');
    final hasToefl = exams.contains('TOEFL');

    if (hasDuolingo && widget.university.duolingo <= 105) {
      return '${widget.university.name} is a strong match because its Duolingo requirement is realistic for your profile.';
    }

    if (hasIelts && widget.university.ielts <= 6.5) {
      return '${widget.university.name} is a good option with a moderate IELTS requirement.';
    }

    if (hasToefl && widget.university.toefl <= 80) {
      return '${widget.university.name} fits your TOEFL plan well.';
    }

    return 'You can consider ${widget.university.name}, but compare requirements carefully.';
  }

  Future<void> _toggleSave() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (_isSaved) {
      await _service.removeUniversity(
        userId: _userId,
        university: widget.university,
      );
    } else {
      await _service.saveUniversity(
        userId: _userId,
        university: widget.university,
      );
    }

    if (!mounted) return;

    setState(() {
      _isSaved = !_isSaved;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved ? 'Saved to your plan' : 'Removed from your plan',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tuition = CurrencyUtils.formatTuition(
      country: widget.university.country,
      tuition: widget.university.tuition,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.university.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Image.network(
                    widget.university.imageUrl,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Text(
                      widget.university.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.university.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Requirements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoChip(label: 'IELTS ${widget.university.ielts}'),
                _InfoChip(label: 'TOEFL ${widget.university.toefl}'),
                _InfoChip(label: 'Duolingo ${widget.university.duolingo}'),
              ],
            ),

            const SizedBox(height: 30),

            _InfoRow(title: 'City', value: widget.university.city),
            _InfoRow(title: 'Tuition', value: tuition),
            _InfoRow(
              title: 'Acceptance rate',
              value:
                  '${(widget.university.acceptanceRate * 100).toStringAsFixed(0)}%',
            ),

            const SizedBox(height: 20),

            const Text(
              'AI Insight',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            Text(
              _buildSmartDescription(),
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleSave,
                child: _isLoading
                    ? const Text('Loading...')
                    : Text(_isSaved ? 'Saved' : 'Save to plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
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

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}