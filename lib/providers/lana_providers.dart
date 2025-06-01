import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lana/lana_onboarding_question_model.dart';

// Manages the overall state of the LANA onboarding process
class LanaOnboardingState {
  final int currentQuestionIndex;
  final Map<String, dynamic> answers;
  final List<LanaOnboardingQuestion> questions; // To hold the loaded questions

  const LanaOnboardingState({
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.questions = const [], // Initialize with an empty list
  });

  LanaOnboardingState copyWith({
    int? currentQuestionIndex,
    Map<String, dynamic>? answers,
    List<LanaOnboardingQuestion>? questions,
  }) {
    return LanaOnboardingState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      questions: questions ?? this.questions,
    );
  }
}

class LanaOnboardingNotifier extends StateNotifier<LanaOnboardingState> {
  LanaOnboardingNotifier(List<LanaOnboardingQuestion> initialQuestions) 
      : super(LanaOnboardingState(questions: initialQuestions));

  void answerQuestion(String questionId, dynamic answer) {
    final newAnswers = Map<String, dynamic>.from(state.answers);
    newAnswers[questionId] = answer;
    state = state.copyWith(answers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      // TODO: Implement conditional navigation based on answer and nextScreenId from LanaOnboardingQuestion.options
      // For now, simple linear progression
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    } else {
      // Onboarding complete or end of current question set
      debugPrint("Onboarding questions finished. Answers: ${state.answers}");
      // TODO: Trigger 7-day plan generation or next step
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }

  // Method to load questions (e.g., from a static list or service)
  // This is called externally when initializing the provider
  void loadQuestions(List<LanaOnboardingQuestion> questions) {
    state = state.copyWith(questions: questions, currentQuestionIndex: 0, answers: {});
  }

  LanaOnboardingQuestion? getCurrentQuestion() {
    if (state.questions.isNotEmpty && state.currentQuestionIndex < state.questions.length) {
      return state.questions[state.currentQuestionIndex];
    }
    return null;
  }

  dynamic getAnswerForQuestion(String questionId) {
    return state.answers[questionId];
  }
}

// Provider definition
// The initial questions will be passed from where this provider is first used/overridden.
// For now, we expect it to be initialized with questions from LanaAiAssistantScreen.
final lanaOnboardingProvider = StateNotifierProvider.autoDispose<LanaOnboardingNotifier, LanaOnboardingState>((ref) {
  // This default setup assumes questions are loaded via a method or passed during override.
  // If questions are static and known at startup, they could be initialized here.
  // For dynamic loading (e.g. from LanaAiAssistantScreen's local list),
  // the screen will need to call ref.read(lanaOnboardingProvider.notifier).loadQuestions(...);
  // Or, the provider can be overridden with the initial list.
  // For simplicity, we'll assume loadQuestions is called.
  return LanaOnboardingNotifier([]); 
});


// Provider for the TabController index, if needed globally or across LANA sections
final lanaAssistantTabControllerProvider = StateProvider.autoDispose<int>((ref) {
  return 0; // Default to the first tab
});
