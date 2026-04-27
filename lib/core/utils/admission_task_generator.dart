import '../models/admission_task.dart';
import '../models/user_profile.dart';

class AdmissionTaskGenerator {
  static List<AdmissionTask> generate(UserProfile userProfile) {
    final country = userProfile.country;
    final level = userProfile.level;

    if (country == 'USA') {

      if (level == 'beginner') {
        return [
          AdmissionTask(
            title: 'Understand admission process',
            description: 'Learn how US applications work (Common App, deadlines, requirements).',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Start English preparation',
            description: 'Begin IELTS / TOEFL / Duolingo preparation from basics.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Explore universities',
            description: 'Find universities that match your level and interests.',
            isCompleted: false,
          ),
        ];
      }

      if (level == 'intermediate') {
        return [
          AdmissionTask(
            title: 'Prepare for English exam',
            description: 'Reach IELTS 6.5+, TOEFL 80+, or Duolingo 105+.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Build project portfolio',
            description: 'Add 1–2 strong projects with GitHub.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Shortlist universities',
            description: 'Select 5–10 universities to apply.',
            isCompleted: false,
          ),
        ];
      }

      if (level == 'advanced') {
        return [
          AdmissionTask(
            title: 'Write strong application essays',
            description: 'Finalize Common App essay and supplements.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Collect all documents',
            description: 'Transcript, recommendations, certificates.',
            isCompleted: false,
          ),
          AdmissionTask(
            title: 'Submit applications',
            description: 'Apply before deadlines.',
            isCompleted: false,
          ),
        ];
      }

      return [
        AdmissionTask(
          title: 'Prepare for English exam',
          description: 'IELTS / TOEFL required.',
          isCompleted: false,
        ),
      ];
    }

    if (country == 'China') {
      return const [
        AdmissionTask(
          title: 'Prepare for HSK',
          description: 'Reach HSK 4–5 level.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Research scholarships',
          description: 'CSC and university scholarships.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Prepare documents',
          description: 'Transcripts, passport, recommendation.',
          isCompleted: false,
        ),
      ];
    }

    if (country == 'Germany') {
      return const [
        AdmissionTask(
          title: 'Learn German / English',
          description: 'B2–C1 level required.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Prepare blocked account',
          description: 'Financial proof for visa.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Apply via UniAssist',
          description: 'Submit documents to universities.',
          isCompleted: false,
        ),
      ];
    }

    // default fallback
    return const [
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