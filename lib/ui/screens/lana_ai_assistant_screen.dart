import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added
import '../../models/lana/lana_feature_model.dart';
import '../../models/lana/lana_onboarding_question_model.dart';
import '../../ui/widgets/lana/feature_card.dart';
import '../../ui/widgets/lana/onboarding_question_card.dart';
import '../../providers/lana_providers.dart'; // Added

class LanaAiAssistantScreen extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  const LanaAiAssistantScreen({super.key});

  @override
  ConsumerState<LanaAiAssistantScreen> createState() => _LanaAiAssistantScreenState(); // Changed to ConsumerState
}

class _LanaAiAssistantScreenState extends ConsumerState<LanaAiAssistantScreen> // Changed to ConsumerState
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define Overlay Features based on lana.html
  final List<LanaFeature> _overlayFeatures = [
    LanaFeature(
      title: 'Smart Text Analysis',
      description: 'LANA can analyze text inputs and add individual events into the correct category. User will tell her the event type and category tags – LANA will guess if not specified and the user will see each event screen individually and confirm by hitting create. This may be an entity if school term or work days.',
      icon: Icons.text_fields_rounded,
    ),
    LanaFeature(
      title: 'Bulk Event Processing',
      description: 'LANA repeats the text analysis process when the user provides a list of events. She will guess category tags if not explicitly provided, and the user will see each event screen individually to confirm by hitting create.',
      icon: Icons.list_alt_rounded,
    ),
    LanaFeature(
      title: 'Microsoft To-Do Integration',
      description: 'LANA automatically imports and categorizes tasks from Microsoft To-Do, analyzing images of to-do lists and transforming them into properly categorized Vuet tasks.',
      icon: Icons.integration_instructions_outlined, // Placeholder, consider a Microsoft logo
    ),
    LanaFeature(
      title: 'Google Tasks Integration',
      description: 'Similar to Microsoft To-Do integration, LANA can process images of Google Tasks and convert them into appropriate Vuet tasks with categories.',
      icon: Icons.integration_instructions_outlined, // Placeholder, consider a Google logo
    ),
    LanaFeature(
      title: 'Camera Input',
      description: 'LANA can use the device camera to capture and process text from physical documents, handwritten notes, or printed lists, converting them into properly categorized events and tasks.',
      icon: Icons.camera_alt_outlined,
    ),
    LanaFeature(
      title: 'Calendar Integration Tagging',
      description: 'LANA enforces category tags for events imported from integrated calendars, ensuring consistency in the organization system even with external data sources.',
      icon: Icons.calendar_today_outlined,
    ),
  ];

  // Define Integration Features based on lana.html
  final List<LanaFeature> _integrationFeatures = [
    LanaFeature(
      title: 'Microsoft To-Do',
      description: 'Imports tasks and lists from Microsoft To-Do with proper categorization.',
      icon: Icons.article_outlined, // Placeholder, consider a Microsoft logo or specific icon
    ),
    LanaFeature(
      title: 'Google Tasks',
      description: 'Transfers tasks from Google Tasks into the appropriate entities and categories.',
      icon: Icons.task_alt_outlined, // Placeholder, consider a Google logo or specific icon
    ),
    LanaFeature(
      title: 'Calendar Apps',
      description: 'Syncs with external calendars while enforcing Vuet\'s category structure.',
      icon: Icons.calendar_month_outlined,
    ),
    LanaFeature(
      title: 'Image to Task',
      description: 'Processes images of written lists into properly categorized tasks.',
      icon: Icons.image_search_outlined,
    ),
  ];

  // Define sample Onboarding Questions based on lana.html (PERS1, PERS2A)
  final List<LanaOnboardingQuestion> _onboardingQuestions = [
    LanaOnboardingQuestion(
      id: 'PERS1',
      screenTitle: 'PERS1',
      questionText: 'Are you setting this up as yourself or as a Personal Assistant?',
      type: OnboardingQuestionType.singleChoice,
      options: [
        OnboardingOption(text: 'Self', value: 'self', nextScreenId: 'PERS2A'),
        OnboardingOption(text: 'Personal Assistant', value: 'pa', nextScreenId: 'PERS2B'),
      ],
      logicNote: 'If "Self" → PERS2A, If "Personal Assistant" → PERS2B',
    ),
    LanaOnboardingQuestion(
      id: 'PERS2A_Q1',
      screenTitle: 'PERS2A (Self)',
      instructionText: 'Please answer the following for yourself:',
      questionText: 'Do you live in a Shared Household?',
      type: OnboardingQuestionType.singleChoice,
      options: [
        OnboardingOption(text: 'Yes - Family'),
        OnboardingOption(text: 'Yes - Friends'),
        OnboardingOption(text: 'Yes - Shared'),
        OnboardingOption(text: 'No - I live alone'),
      ],
    ),
    LanaOnboardingQuestion(
      id: 'PERS8',
      screenTitle: 'PERS8',
      questionText: 'Score how well you feel you have each category organised for you, friends and family from 1-10 with 10 being the best, no suggestions needed and 0 I haven\'t even thought about it. Or Choose "I don\'t care"',
      type: OnboardingQuestionType.ratingScale,
      categoriesToRateOrRank: [
        "Social, Birthdays, Anniversaries and Holidays",
        "Education and Extracurricular Activities",
        "Career Goals and Breaks",
        "Travel Planning",
        "Health & Beauty",
        "Home & Garden",
        // Add more categories from lana.html PERS8 as needed
      ],
      instructionText: "Rate each category (1-5 for now, or 'I don't care').",
    ),
    LanaOnboardingQuestion(
      id: 'PERS9',
      screenTitle: 'PERS9',
      questionText: 'Prioritise from 1-16 in order of how important these are to you for better visibility to you and/or collaboration with friends and family.',
      type: OnboardingQuestionType.priorityRanking,
      categoriesToRateOrRank: [
        "Social, Birthdays, Anniversaries and Holidays",
        "Education and Extracurricular Activities",
        "Career Goals and Breaks",
        "Travel Planning",
        "Health & Beauty",
        "Home & Garden",
        // Add more categories from lana.html PERS8/9 as needed
      ],
      instructionText: "Drag and drop to rank the categories by importance.",
    ),
    // Add more questions as needed
  ];

  // int _currentOnboardingQuestionIndex = 0; // Will be managed by provider

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load initial questions into the provider
    // Ensure this happens after the first frame when ref is available, or use a Consumer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(lanaOnboardingProvider.notifier).loadQuestions(_onboardingQuestions);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOverlayFeaturesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _overlayFeatures.length,
      itemBuilder: (context, index) {
        final feature = _overlayFeatures[index];
        return FeatureCard(
          feature: feature,
          onTap: () {
            // TODO: Implement navigation or action for this feature
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${feature.title} tapped')),
            );
          },
        );
      },
    );
  }

  Widget _buildOnboardingTab() {
    if (_onboardingQuestions.isEmpty) {
      return const Center(child: Text('No onboarding questions defined yet.'));
    }
    // For now, just show the current question.
    // A real implementation would use a PageView or similar for a multi-step flow.
    
    final onboardingState = ref.watch(lanaOnboardingProvider);
    final LanaOnboardingQuestion? currentQuestion = ref.read(lanaOnboardingProvider.notifier).getCurrentQuestion();

    if (currentQuestion == null) {
      // This might happen if questions are not loaded yet, or onboarding is complete.
      return const Center(child: Text('Loading onboarding questions or onboarding complete.'));
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          OnboardingQuestionCard(
            question: currentQuestion,
            onAnswered: (questionId, answer) {
              final notifier = ref.read(lanaOnboardingProvider.notifier);
              notifier.answerQuestion(questionId, answer);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Answered ${currentQuestion.id}: $answer')),
              );
              notifier.nextQuestion(); // Provider handles navigation logic
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (onboardingState.currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: () => ref.read(lanaOnboardingProvider.notifier).previousQuestion(),
                  child: const Text('Previous'),
                ),
              if (onboardingState.currentQuestionIndex < onboardingState.questions.length - 1)
                 ElevatedButton(
                  onPressed: () => ref.read(lanaOnboardingProvider.notifier).nextQuestion(),
                  child: const Text('Next (Skip)'), // Or just 'Next' if answering is mandatory
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Placeholder for 7-day plan, intro screens, videos
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Personalized 7-Day Onboarding Plan", style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  const Text("Details of the 7-day plan will be displayed here based on your answers.", style: TextStyle(fontStyle: FontStyle.italic)),
                  // TODO: Implement UI to display the 7-day plan (e.g., a list of daily tasks/focus areas)
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Intro Screens & Tutorial Videos", style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  const Text("Access to intro screens (A1, A2) and tutorial videos (B1-B9) will be available here.", style: TextStyle(fontStyle: FontStyle.italic)),
                  // TODO: Implement UI to list/link to intro screens and videos (e.g., expandable list, carousel)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _integrationFeatures.length,
      itemBuilder: (context, index) {
        final feature = _integrationFeatures[index];
        return FeatureCard(
          feature: feature,
          onTap: () {
            // TODO: Implement navigation or action for this integration
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${feature.title} integration tapped')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LANA AI Assistant'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.assistant_outlined), text: 'Assistant'),
            Tab(icon: Icon(Icons.school_outlined), text: 'Onboarding'),
            Tab(icon: Icon(Icons.integration_instructions_outlined), text: 'Integrations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverlayFeaturesList(),
          _buildOnboardingTab(),
          _buildIntegrationsTab(),
        ],
      ),
    );
  }
}
