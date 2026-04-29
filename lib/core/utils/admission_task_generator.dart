import '../models/admission_task.dart';
import '../models/user_profile.dart';

class AdmissionTaskGenerator {
  static List<AdmissionTask> generate(UserProfile userProfile) {
    final country = userProfile.country ?? '';
    final level = userProfile.academicLevel ?? '';
    final exams = userProfile.exams;
    final goal = userProfile.goal ?? '';

    List<AdmissionTask> tasks = [];

    // ================== LEVEL LOGIC ==================

    if (level == 'A1' || level == 'A2') {
      tasks.addAll([
        AdmissionTask(
          title: 'Build English foundation',
          description: 'Focus on grammar, vocabulary, and basic communication.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Reach B1 level',
          description: 'Move from beginner to intermediate English.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Reach B2 level',
          description: 'Target Upper-Intermediate for university admission.',
          isCompleted: false,
        ),
      ]);
    }

    if (level == 'B1') {
      tasks.add(
        AdmissionTask(
          title: 'Reach B2 level',
          description: 'Improve grammar, speaking, and academic vocabulary.',
          isCompleted: false,
        ),
      );
    }

    if (level == 'B2' || level == 'C1' || level == 'C2') {
      tasks.add(
        AdmissionTask(
          title: 'Prepare for English exam',
          description: 'Target IELTS 6.5+ / TOEFL 80+ / Duolingo 105+.',
          isCompleted: false,
        ),
      );
    }

    // ================== EXAMS ==================

    if (exams.contains('SAT')) {
      tasks.add(
        AdmissionTask(
          title: 'Prepare for SAT',
          description: 'Focus on Math and Evidence-Based Reading.',
          isCompleted: false,
        ),
      );
    }

    // ================== COUNTRY-BASED APPLICATION SYSTEM ==================

    if (country == 'USA') {
      tasks.addAll([
        AdmissionTask(
          title: 'Create Common App account',
          description: 'Register on Common App and add your target universities.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Fill Common App profile',
          description: 'Complete personal info, education history, activities, and essays.',
          isCompleted: false,
        ),
      ]);
    } else if (country == 'UK') {
      tasks.addAll([
        AdmissionTask(
          title: 'Create UCAS account',
          description: 'Register on UCAS and choose your course options.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Prepare UCAS application',
          description: 'Complete your personal statement, education history, and references.',
          isCompleted: false,
        ),
      ]);
    } else if (country == 'Europe') {
      tasks.addAll([
        AdmissionTask(
          title: 'Choose application portal',
          description: 'Check whether your universities use national portals or direct applications.',
          isCompleted: false,
        ),
        AdmissionTask(
          title: 'Check country-specific requirements',
          description: 'Review language, visa, document, and deadline rules for each country.',
          isCompleted: false,
        ),
      ]);
    }

    // ================== CORE ADMISSION ==================

    tasks.addAll([
      AdmissionTask(
        title: 'Research universities',
        description: 'Find programs that match your goals.',
        isCompleted: false,
      ),
      AdmissionTask(
        title: 'Build university shortlist',
        description: 'Select 5–10 universities to apply.',
        isCompleted: false,
      ),
      AdmissionTask(
        title: 'Prepare documents',
        description: 'Transcripts, certificates, CV.',
        isCompleted: false,
      ),
      AdmissionTask(
        title: 'Write motivation letter',
        description: 'Prepare a strong personal statement.',
        isCompleted: false,
      ),
      AdmissionTask(
        title: 'Submit applications',
        description: 'Apply before deadlines.',
        isCompleted: false,
      ),
    ]);

    // ================== GOAL-BASED ==================

    if (goal == 'Engineering' || goal == 'CS') {
      tasks.insert(
        0,
        AdmissionTask(
          title: 'Build portfolio',
          description: 'Create 1–2 strong projects (GitHub).',
          isCompleted: false,
        ),
      );
    }

    if (goal == 'Business') {
      tasks.insert(
        0,
        AdmissionTask(
          title: 'Build profile',
          description: 'Participate in activities, internships, leadership.',
          isCompleted: false,
        ),
      );
    }

    return tasks;
  }
}