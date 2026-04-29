import '../models/admission_task.dart';
import '../models/user_profile.dart';

class AdmissionTaskGenerator {
  static List<AdmissionTask> generate(UserProfile userProfile) {
    final country = userProfile.country;
    final level = userProfile.level ?? 'beginner';
    final exams = userProfile.exams;
    final goal = userProfile.goal ?? '';

    List<AdmissionTask> tasks = [];

    // ================= USA =================
    if (country == 'USA') {
      // English exam logic
      if (!exams.contains('IELTS') &&
          !exams.contains('TOEFL') &&
          !exams.contains('Duolingo')) {
        tasks.add(
          AdmissionTask(
            title: 'Choose English exam',
            description: 'Select IELTS, TOEFL, or Duolingo for admission.',
            isCompleted: false,
          ),
        );
      } else {
        tasks.add(
          AdmissionTask(
            title: 'Prepare for English exam',
            description: 'Reach IELTS 6.5+ / TOEFL 80+ / Duolingo 105+.',
            isCompleted: false,
          ),
        );
      }

      // SAT logic
      if (exams.contains('SAT')) {
        tasks.add(
          AdmissionTask(
            title: 'Prepare for SAT',
            description: 'Focus on Math and Evidence-Based Reading.',
            isCompleted: false,
          ),
        );
      }

      // Level-based tasks
      if (level == 'beginner') {
        tasks.addAll([
          AdmissionTask(
            title: 'Understand US admissions',
            description: 'Learn Common App, deadlines, requirements.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Explore universities',
            description: 'Find programs that match your goals.',
            isCompleted: false,
          ),
        ]);
      }

      if (level == 'intermediate') {
        tasks.addAll([
          AdmissionTask(
            title: 'Build portfolio',
            description: goal == 'Engineering'
                ? 'Create 1–2 technical projects (GitHub).'
                : 'Build relevant projects or activities.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Shortlist universities',
            description: 'Select 5–10 universities to apply.',
            isCompleted: false,
          ),
        ]);
      }

      if (level == 'advanced') {
        tasks.addAll([
          AdmissionTask(
            title: 'Write essays',
            description: 'Prepare Common App personal statement.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Collect documents',
            description: 'Transcripts, recommendations, certificates.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Submit applications',
            description: 'Apply before deadlines.',
            isCompleted: false,
          ),
        ]);
      }

      return tasks;
    }

    // ================= CHINA =================
    if (country == 'China') {
      tasks.addAll([
        AdmissionTask(
          title: 'Prepare for HSK',
          description: 'Reach HSK 4–5 level.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Choose universities',
          description: 'Focus on CSC scholarship programs.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Prepare documents',
          description: 'Passport, transcripts, recommendation letters.',
          isCompleted: false,
        ),
      ]);

      return tasks;
    }

    // ================= DEFAULT =================
    return [
      AdmissionTask(
        title: 'Research universities',
        description: 'Find programs that match your goals.',
        isCompleted: false,
      ),
      AdmissionTask(
        title: 'Prepare English exam',
        description: 'IELTS or TOEFL required.',
        isCompleted: false,
      ),
    ];
  }
}