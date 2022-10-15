import 'package:flutter/material.dart';
import 'package:flutter_architecture/domain/entities/question.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../shared/custom_button.dart';
import '../viewsmodel/quiz_state.dart';
import '../viewsmodel/quiz_view_model.dart';
import '../widgets/quiz_question.dart';
import '../widgets/quiz_result.dart';
import '../../shared/error.dart';

class QuizScreen extends HookWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final viewModelState = useProvider(quizViewModelProvider);
    final questionsFuture = useProvider(questionsProvider);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF22293E),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: questionsFuture.when(
            data: (questions) =>
                _buildBody(context, viewModelState, pageController, questions),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Error(
                  message: error.toString(),
                  callback: () => refreshAll(context),
                )),
        bottomSheet: questionsFuture.maybeWhen(
            data: (questions) {
              if (!viewModelState.answered) return const SizedBox.shrink();
              var currentIndex = pageController.page?.toInt() ?? 0;
              return CustomButton(
                  title: currentIndex + 1 < questions.length
                      ? 'Next Question'
                      : 'See results',
                  onTap: () {
                    context
                        .read(quizViewModelProvider.notifier)
                        .nextQuestion(questions, currentIndex);
                    if (currentIndex + 1 < questions.length) {
                      pageController.nextPage(
                          duration: const Duration(microseconds: 250),
                          curve: Curves.linear);
                    }
                  });
            },
            orElse: () => const SizedBox.shrink()),
      ),
    );
  }

  void refreshAll(BuildContext context) {
    context.refresh(questionsProvider);
    context.read(quizViewModelProvider.notifier).reset();
  }

  Widget _buildBody(
    BuildContext context,
    QuizState state,
    PageController pageController,
    List<Question> questions,
  ) {
    if (questions.isEmpty) {
      return Error(
          message: 'No questions found', callback: () => refreshAll(context));
    }

    return state.status == QuizStatus.complete
        ? QuizResults(state: state, nbQuestions: questions.length)
        : QuizQuestions(
            pageController: pageController, state: state, questions: questions);
  }
}
