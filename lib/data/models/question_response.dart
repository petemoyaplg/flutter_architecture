import 'package:equatable/equatable.dart';

class QuestionReponse extends Equatable {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  const QuestionReponse({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  @override
  List<Object?> get props => [
        category,
        difficulty,
        question,
        correctAnswer,
        incorrectAnswers,
      ];
  factory QuestionReponse.fromMap(Map<String, dynamic> map) {
    return QuestionReponse(
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
      question: map['question'] ?? '',
      correctAnswer: map['correct_answer'] ?? '',
      incorrectAnswers: List<String>.from(map['incorrect_answers'] ?? ''),
    );
  }
}
