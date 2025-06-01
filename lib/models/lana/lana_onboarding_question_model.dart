enum OnboardingQuestionType {
  singleChoice,
  multipleChoice,
  textInput,
  numberInput,
  ratingScale, // For PERS8
  priorityRanking, // For PERS9
}

class OnboardingOption {
  final String text;
  final String? value; // Optional value if different from text
  final String? nextScreenId; // For conditional navigation based on answer

  OnboardingOption({
    required this.text,
    this.value,
    this.nextScreenId,
  });
}

class LanaOnboardingQuestion {
  final String id; // e.g., "PERS1", "PERS2A_Q1"
  final String screenTitle; // e.g., "PERS1", "PERS2A (Self)"
  final String questionText;
  final OnboardingQuestionType type;
  final List<OnboardingOption>? options; // For singleChoice, multipleChoice
  final String? instructionText; // e.g., "Please answer all questions that follow..."
  final String? logicNote; // e.g., "If 'Self' → PERS2A, If 'Personal Assistant' → PERS2B"
  final List<String>? categoriesToRateOrRank; // For PERS8, PERS9

  LanaOnboardingQuestion({
    required this.id,
    required this.screenTitle,
    required this.questionText,
    required this.type,
    this.options,
    this.instructionText,
    this.logicNote,
    this.categoriesToRateOrRank,
  });
}
