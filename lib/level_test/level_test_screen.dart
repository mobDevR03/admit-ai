import 'package:flutter/material.dart';
import 'level_test_service.dart';

class LevelTestScreen extends StatefulWidget {
  const LevelTestScreen({super.key});

  @override
  State<LevelTestScreen> createState() => _LevelTestScreenState();
}

class _LevelTestScreenState extends State<LevelTestScreen> {
  final LevelTestService _service = LevelTestService();

  int _currentIndex = 0;
  int _correctAnswers = 0;

  final List<_Question> _questions = [
    _Question(
      text: 'She ____ to university every morning.',
      options: ['goes', 'go', 'going', 'gone']..shuffle(),
      correctAnswer: 'goes',
    ),
    _Question(
      text: 'By the time we arrived, the lecture ____.',
      options: ['had already started', 'already starts', 'has already started', 'was already start']..shuffle(),
      correctAnswer: 'had already started',
    ),
    _Question(
      text: 'If I had known about the scholarship deadline, I ____ earlier.',
      options: ['would have applied', 'will apply', 'would apply', 'apply']..shuffle(),
      correctAnswer: 'would have applied',
    ),
    _Question(
      text: 'Choose the correct reported speech: “I am preparing for IELTS,” she said.',
      options: [
        'She said that she was preparing for IELTS.',
        'She said that she is preparing for IELTS.',
        'She said that she prepares for IELTS.',
        'She said that she had prepared for IELTS.',
      ]..shuffle(),
      correctAnswer: 'She said that she was preparing for IELTS.',
    ),
    _Question(
      text: 'He ____ be at home. The lights are on and his car is outside.',
      options: ['must', 'can’t', 'shouldn’t', 'wouldn’t']..shuffle(),
      correctAnswer: 'must',
    ),
    _Question(
      text: 'You ____ have told me about the meeting earlier. I missed it completely.',
      options: ['should', 'must', 'can', 'may']..shuffle(),
      correctAnswer: 'should',
    ),
    _Question(
      text: 'He ____ have stayed at home because several people saw him at the conference.',
      options: ['can’t', 'must', 'should', 'might']..shuffle(),
      correctAnswer: 'can’t',
    ),
    _Question(
      text: 'Choose the closest meaning: “It is possible that she missed the train.”',
      options: [
        'She might have missed the train.',
        'She must have missed the train.',
        'She should have missed the train.',
        'She can’t have missed the train.',
      ]..shuffle(),
      correctAnswer: 'She might have missed the train.',
    ),
    _Question(
      text: 'Choose the best synonym for “significant”.',
      options: ['important', 'minor', 'ordinary', 'simple']..shuffle(),
      correctAnswer: 'important',
    ),
    _Question(
      text: 'Choose the best synonym for “inevitable”.',
      options: ['certain to happen', 'avoidable', 'temporary', 'unlikely']..shuffle(),
      correctAnswer: 'certain to happen',
    ),
    _Question(
      text: 'Choose the best antonym for “scarce”.',
      options: ['abundant', 'rare', 'limited', 'expensive']..shuffle(),
      correctAnswer: 'abundant',
    ),
    _Question(
      text: 'What does “to enhance” mean?',
      options: ['to improve', 'to make worse', 'to remove', 'to delay']..shuffle(),
      correctAnswer: 'to improve',
    ),
    _Question(
      text: 'Choose the correct sentence.',
      options: [
        'Despite the rain, we continued.',
        'Despite of the rain, we continued.',
        'Although the rain, we continued.',
        'In spite the rain, we continued.',
      ]..shuffle(),
      correctAnswer: 'Despite the rain, we continued.',
    ),
    _Question(
      text: 'Choose the correct passive form: “They will announce the results tomorrow.”',
      options: [
        'The results will be announced tomorrow.',
        'The results will announce tomorrow.',
        'The results are announced tomorrow.',
        'The results were announced tomorrow.',
      ]..shuffle(),
      correctAnswer: 'The results will be announced tomorrow.',
    ),
    _Question(
      text: 'Choose the best option: “Not only ____ hard, but he also managed his time well.”',
      options: ['did he study', 'he studied', 'he did study', 'studied he']..shuffle(),
      correctAnswer: 'did he study',
    ),
    _Question(
      text: 'Which sentence uses a more academic style?',
      options: [
        'Many individuals consider it problematic.',
        'Lots of people think it is bad.',
        'People are like, this is not good.',
        'It is super bad for everyone.',
      ]..shuffle(),
      correctAnswer: 'Many individuals consider it problematic.',
    ),
    _Question(
      text: 'What does the idiom “to hit the books” mean?',
      options: ['to study seriously', 'to damage books', 'to buy books', 'to finish reading forever']..shuffle(),
      correctAnswer: 'to study seriously',
    ),
    _Question(
      text: 'What does the idiom “a piece of cake” mean?',
      options: ['something very easy', 'something impossible', 'something expensive', 'something boring']..shuffle(),
      correctAnswer: 'something very easy',
    ),
    _Question(
      text: 'What does “to break the ice” mean?',
      options: ['to make people feel more comfortable', 'to start an argument', 'to cancel a meeting', 'to fail an exam']..shuffle(),
      correctAnswer: 'to make people feel more comfortable',
    ),
    _Question(
      text: 'What does “once in a blue moon” mean?',
      options: ['very rarely', 'very quickly', 'every day', 'with great effort']..shuffle(),
      correctAnswer: 'very rarely',
    ),
    _Question(
      text: 'Read the text:\n\nUrbanisation can stimulate economic growth by concentrating labour, services, and infrastructure in one area. However, rapid population movement into cities may also intensify pressure on housing, transport systems, healthcare, and public services. As a result, urban development requires careful planning rather than uncontrolled expansion.\n\nWhat is the main idea?',
      options: [
        'Urbanisation can bring economic benefits, but it also creates planning challenges.',
        'Urbanisation only creates problems.',
        'Urbanisation always improves public services.',
        'Urbanisation prevents economic growth.',
      ]..shuffle(),
      correctAnswer: 'Urbanisation can bring economic benefits, but it also creates planning challenges.',
    ),
    _Question(
      text: 'Read the text:\n\nThe evidence remains inconclusive because the available data are limited, inconsistent, and sometimes contradictory. While some studies suggest a positive effect, others show little or no measurable impact. Therefore, a firm conclusion would require more reliable data and broader research.\n\nWhat does the text suggest?',
      options: [
        'There is not enough reliable evidence to make a firm conclusion.',
        'The evidence is completely clear.',
        'All studies support the same argument.',
        'The research has no data at all.',
      ]..shuffle(),
      correctAnswer: 'There is not enough reliable evidence to make a firm conclusion.',
    ),
    _Question(
      text: 'Read the text:\n\nGovernments often invest in educational reform, but investment alone does not guarantee better outcomes. Resources must be allocated efficiently, teachers need proper training, and progress should be measured through clear indicators. Without evaluation, reform may appear impressive but produce little practical improvement.\n\nWhat is the sentence mainly about?',
      options: [
        'Educational reform requires efficient resource use, teacher support, and measurable results.',
        'Governments should spend money randomly.',
        'Education does not need reform.',
        'Resources are not important in education.',
      ]..shuffle(),
      correctAnswer: 'Educational reform requires efficient resource use, teacher support, and measurable results.',
    ),
    _Question(
      text: 'Read the text:\n\nAlthough technology can make learning more flexible, it cannot fully replace human interaction. Students may benefit from online platforms, recorded lectures, and AI tools, but motivation, feedback, and discussion often depend on teachers and peers. A balanced approach is therefore more effective than complete digital replacement.\n\nWhat is the best summary?',
      options: [
        'Technology helps education, but human interaction remains important.',
        'Technology should completely replace teachers.',
        'Online platforms make motivation unnecessary.',
        'Students learn worse when technology is used.',
      ]..shuffle(),
      correctAnswer: 'Technology helps education, but human interaction remains important.',
    ),
    _Question(
      text: 'Choose the most precise academic phrase.',
      options: [
        'This factor contributes to improved outcomes.',
        'This thing makes stuff better.',
        'This is good and helps a lot.',
        'This thing is very nice.',
      ]..shuffle(),
      correctAnswer: 'This factor contributes to improved outcomes.',
    ),
    _Question(
      text: 'Choose the correct sentence with “used to”.',
      options: [
        'I used to study at night when I was in school.',
        'I use to studied at night.',
        'I used studying at night.',
        'I was used study at night.',
      ]..shuffle(),
      correctAnswer: 'I used to study at night when I was in school.',
    ),
    _Question(
      text: 'Choose the correct sentence with “would rather”.',
      options: [
        'I would rather study abroad than stay in my hometown.',
        'I would rather to study abroad.',
        'I rather would studying abroad.',
        'I would rather studied abroad.',
      ]..shuffle(),
      correctAnswer: 'I would rather study abroad than stay in my hometown.',
    ),
    _Question(
      text: 'Choose the best connector: “The course is demanding; ____, it provides valuable skills.”',
      options: ['nevertheless', 'because', 'unless', 'instead of']..shuffle(),
      correctAnswer: 'nevertheless',
    ),
    _Question(
      text: 'Choose the correct sentence.',
      options: [
        'The more you practise, the more confident you become.',
        'More you practise, more confident you become.',
        'The more practise, the more confidence become.',
        'The most you practise, the most confident you become.',
      ]..shuffle(),
      correctAnswer: 'The more you practise, the more confident you become.',
    ),
    _Question(
      text: 'Choose the best meaning of “to keep up with”.',
      options: [
        'to stay at the same level or speed as something',
        'to ignore something completely',
        'to finish something earlier than expected',
        'to make something more expensive',
      ]..shuffle(),
      correctAnswer: 'to stay at the same level or speed as something',
    ),
  ];

  void _answer(String selectedAnswer) {
    final currentQuestion = _questions[_currentIndex];

    if (selectedAnswer == currentQuestion.correctAnswer) {
      _correctAnswers++;
    }

    final isLastQuestion = _currentIndex == _questions.length - 1;

    if (isLastQuestion) {
      final result = _service.evaluate(
        correctAnswers: _correctAnswers,
        totalQuestions: _questions.length,
      );

      Navigator.pop(context, result);
      return;
    }

    setState(() {
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
            ),
            const SizedBox(height: 32),
            Text(
              'Question ${_currentIndex + 1}/${_questions.length}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Text(
              question.text,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
            ),
            const SizedBox(height: 28),
            ...question.options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _answer(option),
                    child: Text(option),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String text;
  final List<String> options;
  final String correctAnswer;

  const _Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}