import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added
import '../../../models/lana/lana_onboarding_question_model.dart';
import '../../../providers/lana_providers.dart'; // Added

class OnboardingQuestionCard extends ConsumerWidget { // Changed to ConsumerWidget
  final LanaOnboardingQuestion question;
  final Function(String questionId, dynamic answer) onAnswered;

  const OnboardingQuestionCard({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef ref
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.instructionText != null) ...[
              Text(
                question.instructionText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8.0),
            ],
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16.0),
            _buildAnswerWidget(context, ref), // Added ref
            if (question.logicNote != null) ...[
              const SizedBox(height: 8.0),
              Text(
                "Logic: ${question.logicNote!}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget(BuildContext context, WidgetRef ref) { // Added ref
    switch (question.type) {
      case OnboardingQuestionType.singleChoice:
        return _buildSingleChoiceOptions(context, ref); // Added ref
      case OnboardingQuestionType.multipleChoice:
        return _buildMultipleChoiceOptions(context, ref); // Added
      case OnboardingQuestionType.textInput:
        // For text input, we might want to prefill if an answer exists,
        // but onSubmitted is usually enough. For simplicity, not prefilling yet.
        // Consider using a TextEditingController initialized with the current answer for prefill.
        final initialText = ref.watch(lanaOnboardingProvider.select((state) => state.answers[question.id] as String?)) ?? '';
        return TextFormField( // Changed to TextFormField for potential initialValue
          initialValue: initialText,
          decoration: InputDecoration(
            hintText: 'Your answer here',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (value) => onAnswered(question.id, value),
        );
      case OnboardingQuestionType.numberInput:
        final initialNumber = ref.watch(lanaOnboardingProvider.select((state) => state.answers[question.id]?.toString())) ?? '';
        return TextFormField( // Changed to TextFormField for potential initialValue
          initialValue: initialNumber,
          decoration: InputDecoration(
            hintText: 'Enter a number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (value) => onAnswered(question.id, int.tryParse(value)),
        );
      case OnboardingQuestionType.ratingScale:
        // TODO: Implement rating scale UI (e.g., for PERS8: 1-10 scale or "I don't care" per category)
        return _buildRatingScaleOptions(context, ref);
      case OnboardingQuestionType.priorityRanking:
        return _buildPriorityRankingOptions(context, ref);
    }
  }

  Widget _buildSingleChoiceOptions(BuildContext context, WidgetRef ref) { // Added ref
    if (question.options == null || question.options!.isEmpty) {
      return const Text('No options provided.');
    }
    // Get the current answer for this question from the provider to set groupValue
    final String? currentAnswer = ref.watch(lanaOnboardingProvider.select((state) => state.answers[question.id] as String?));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.options!.map((option) {
        return RadioListTile<String>(
          title: Text(option.text),
          value: option.value ?? option.text,
          groupValue: currentAnswer, // Set groupValue from provider state
          onChanged: (String? value) {
            if (value != null) {
              onAnswered(question.id, value);
              // Navigation logic is now handled by the provider/screen after onAnswered
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceOptions(BuildContext context, WidgetRef ref) {
    if (question.options == null || question.options!.isEmpty) {
      return const Text('No options provided.');
    }
    // Get the current answers for this question (expected to be a List<String> or Set<String>)
    final List<String> currentAnswers = (ref.watch(lanaOnboardingProvider.select((state) => state.answers[question.id] as List<dynamic>?)) ?? []).map((e) => e.toString()).toList();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.options!.map((option) {
        final optionValue = option.value ?? option.text;
        return CheckboxListTile(
          title: Text(option.text),
          value: currentAnswers.contains(optionValue),
          onChanged: (bool? newValue) {
            if (newValue != null) {
              List<String> updatedAnswers = List<String>.from(currentAnswers);
              if (newValue) {
                if (!updatedAnswers.contains(optionValue)) {
                  updatedAnswers.add(optionValue);
                }
              } else {
                updatedAnswers.remove(optionValue);
              }
              onAnswered(question.id, updatedAnswers);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildRatingScaleOptions(BuildContext context, WidgetRef ref) {
    final categories = question.categoriesToRateOrRank;
    if (categories == null || categories.isEmpty) {
      return const Text('No categories provided for rating.');
    }

    // Current answers for this rating question (expected to be Map<String, dynamic>)
    // where key is categoryName and value is score (int) or "idc" (string for "I don't care")
    final Map<String, dynamic> currentCategoryAnswers = 
        Map<String, dynamic>.from(ref.watch(lanaOnboardingProvider.select((state) => state.answers[question.id] as Map<dynamic, dynamic>?)) ?? {});

    List<Widget> categoryRatingWidgets = [];

    for (String categoryName in categories) {
      dynamic currentCategoryScore = currentCategoryAnswers[categoryName];
      bool isIdc = currentCategoryScore == "idc";
      int? currentScoreValue = (currentCategoryScore is int) ? currentCategoryScore : null;

      List<Widget> scoreRadios = [];
      for (int i = 1; i <= 5; i++) { // Simplified to 1-5 for now
        scoreRadios.add(
          Expanded( // Use Expanded to make them share space
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(i.toString(), style: Theme.of(context).textTheme.bodySmall),
                Radio<int>(
                  value: i,
                  groupValue: isIdc ? null : currentScoreValue,
                  onChanged: (int? value) {
                    Map<String, dynamic> updatedAnswers = Map.from(currentCategoryAnswers);
                    updatedAnswers[categoryName] = value;
                    onAnswered(question.id, updatedAnswers);
                  },
                ),
              ],
            ),
          )
        );
      }
      
      categoryRatingWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(categoryName, style: Theme.of(context).textTheme.titleSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: scoreRadios,
              ),
              CheckboxListTile(
                title: const Text("I don't care"),
                value: isIdc,
                dense: true,
                onChanged: (bool? newValue) {
                  Map<String, dynamic> updatedAnswers = Map.from(currentCategoryAnswers);
                  if (newValue == true) {
                    updatedAnswers[categoryName] = "idc";
                  } else {
                    // If unchecking "idc", remove the entry or set to a default score if desired
                    updatedAnswers.remove(categoryName); 
                  }
                  onAnswered(question.id, updatedAnswers);
                },
              ),
              const Divider(),
            ],
          ),
        )
      );
    }

    return Column(children: categoryRatingWidgets);
  }

  Widget _buildPriorityRankingOptions(BuildContext context, WidgetRef ref) {
    final List<String>? categoriesToRank = question.categoriesToRateOrRank;
    if (categoriesToRank == null || categoriesToRank.isEmpty) {
      return const Text('No categories provided for ranking.');
    }

    // Get the current ranked order from the provider.
    // The answer is expected to be a List<String> representing the ordered category names.
    final List<String> currentRankedCategories = 
        (ref.watch(lanaOnboardingProvider.select((state) => state.answers[question.id] as List<dynamic>?)) ?? [])
        .map((e) => e.toString())
        .toList();

    // Ensure all categoriesToRank are present in currentRankedCategories, preserving existing order
    // and adding any missing ones at the end. This handles initial state or new categories.
    List<String> displayCategories = List.from(currentRankedCategories);
    for (String category in categoriesToRank) {
      if (!displayCategories.contains(category)) {
        displayCategories.add(category);
      }
    }
    // Filter out any categories in currentRankedCategories that are no longer in question.categoriesToRateOrRank
    displayCategories.retainWhere((category) => categoriesToRank.contains(category));


    // If currentRankedCategories is empty or doesn't match categoriesToRank, initialize with categoriesToRank
    if (displayCategories.isEmpty || displayCategories.length != categoriesToRank.length) {
       //This ensures if the stored answer is stale or incomplete, we reset to the definitive list.
      displayCategories = List.from(categoriesToRank);
    }


    return SizedBox(
      // It's good practice to give ReorderableListView a constrained height.
      // This might need adjustment based on the number of items or overall card layout.
      height: categoriesToRank.length * 60.0, // Estimate height: 60px per item
      child: ReorderableListView(
        children: displayCategories.map((categoryName) {
          return ListTile(
            key: ValueKey(categoryName),
            title: Text(categoryName),
            trailing: const Icon(Icons.drag_handle),
          );
        }).toList(),
        onReorder: (int oldIndex, int newIndex) {
          // This logic handles the reordering correctly.
          // If an item is moved to a position after its original position in the list,
          // the newIndex needs to be adjusted because the item is removed before being inserted.
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final List<String> reorderedCategories = List.from(displayCategories);
          final String item = reorderedCategories.removeAt(oldIndex);
          reorderedCategories.insert(newIndex, item);
          onAnswered(question.id, reorderedCategories);
        },
      ),
    );
  }
}
