import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/lana/lana_feature_model.dart';
import '../../models/lana/lana_onboarding_question_model.dart';
import '../../providers/lana_providers.dart';
import '../../theme/app_colors.dart';

class LanaAiAssistantScreen extends ConsumerStatefulWidget {
  const LanaAiAssistantScreen({super.key});

  @override
  ConsumerState<LanaAiAssistantScreen> createState() =>
      _LanaAiAssistantScreenState();
}

class _LanaAiAssistantScreenState extends ConsumerState<LanaAiAssistantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define Overlay Features based on lana.html
  final List<LanaFeature> _overlayFeatures = [
    LanaFeature(
      title: 'Smart Text Analysis',
      description:
          'LANA analyzes text and adds events to the correct category automatically.',
      icon: Icons.text_fields_rounded,
    ),
    LanaFeature(
      title: 'Bulk Event Processing',
      description:
          'Process multiple events at once with automatic categorization.',
      icon: Icons.list_alt_rounded,
    ),
    LanaFeature(
      title: 'Microsoft To-Do Integration',
      description: 'Import and categorize tasks from Microsoft To-Do.',
      icon: Icons.check_circle_outline,
    ),
    LanaFeature(
      title: 'Google Tasks Integration',
      description: 'Convert Google Tasks into properly categorized Vuet tasks.',
      icon: Icons.task_alt,
    ),
    LanaFeature(
      title: 'Camera Input',
      description:
          'Capture text from documents and convert to tasks and events.',
      icon: Icons.camera_alt_outlined,
    ),
    LanaFeature(
      title: 'Calendar Integration',
      description:
          'Enforce category tags for events imported from external calendars.',
      icon: Icons.calendar_today_outlined,
    ),
  ];

  // Define Integration Features
  final List<LanaFeature> _integrationFeatures = [
    LanaFeature(
      title: 'Microsoft To-Do',
      description: 'Import tasks and lists with proper categorization.',
      icon: Icons.checklist_rounded,
    ),
    LanaFeature(
      title: 'Google Tasks',
      description: 'Transfer tasks into appropriate entities and categories.',
      icon: Icons.task_alt,
    ),
    LanaFeature(
      title: 'Calendar Apps',
      description:
          'Sync with external calendars while enforcing category structure.',
      icon: Icons.calendar_month_outlined,
    ),
    LanaFeature(
      title: 'Image to Task',
      description: 'Process images of written lists into categorized tasks.',
      icon: Icons.image_search_outlined,
    ),
  ];

  // Define sample Onboarding Questions
  final List<LanaOnboardingQuestion> _onboardingQuestions = [
    LanaOnboardingQuestion(
      id: 'PERS1',
      screenTitle: 'PERS1',
      questionText:
          'Are you setting this up as yourself or as a Personal Assistant?',
      type: OnboardingQuestionType.singleChoice,
      options: [
        OnboardingOption(text: 'Self', value: 'self', nextScreenId: 'PERS2A'),
        OnboardingOption(
            text: 'Personal Assistant', value: 'pa', nextScreenId: 'PERS2B'),
      ],
      logicNote: 'If "Self" → PERS2A, If "Personal Assistant" → PERS2B',
    ),
    // Other questions remain the same
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(lanaOnboardingProvider.notifier)
            .loadQuestions(_onboardingQuestions);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: const Icon(
                Icons.assistant,
                size: 20,
                color: AppColors.mediumTurquoise,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'LANA AI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'ASSISTANT'),
            Tab(text: 'ONBOARDING'),
            Tab(text: 'INTEGRATIONS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAssistantTab(),
          _buildOnboardingTab(),
          _buildIntegrationsTab(),
        ],
      ),
    );
  }

  Widget _buildAssistantTab() {
    return Column(
      children: [
        _buildWelcomeCard(),
        Expanded(
          child: _buildFeatureList(_overlayFeatures),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.mediumTurquoise, Color(0xFF7BD9E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.assistant,
              size: 40,
              color: AppColors.mediumTurquoise,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello, I\'m LANA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your AI assistant for task management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lana-chat');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.mediumTurquoise,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Chat with LANA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList(List<LanaFeature> features) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(feature);
      },
    );
  }

  Widget _buildFeatureCard(LanaFeature feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${feature.title} tapped')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature.icon,
                  color: AppColors.mediumTurquoise,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingTab() {
    final onboardingState = ref.watch(lanaOnboardingProvider);
    final currentQuestion =
        ref.read(lanaOnboardingProvider.notifier).getCurrentQuestion();

    if (currentQuestion == null) {
      return const Center(
        child: Text('Loading onboarding questions or onboarding complete.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personalize Your Experience',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Answer a few questions to help LANA create a personalized experience for you.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          _buildOnboardingQuestion(currentQuestion),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: onboardingState.currentQuestionIndex > 0
                    ? () {
                        ref
                            .read(lanaOnboardingProvider.notifier)
                            .previousQuestion();
                      }
                    : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.mediumTurquoise,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(lanaOnboardingProvider.notifier).nextQuestion();
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mediumTurquoise,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildProgressIndicator(
            currentIndex: onboardingState.currentQuestionIndex,
            totalQuestions: onboardingState.questions.length,
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingQuestion(LanaOnboardingQuestion question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.screenTitle,
            style: TextStyle(
              color: AppColors.mediumTurquoise,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (question.instructionText != null) ...[
            const SizedBox(height: 8),
            Text(
              question.instructionText!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 20),
          _buildQuestionOptions(question),
        ],
      ),
    );
  }

  Widget _buildQuestionOptions(LanaOnboardingQuestion question) {
    switch (question.type) {
      case OnboardingQuestionType.singleChoice:
        return _buildSingleChoiceOptions(question);
      case OnboardingQuestionType.multipleChoice:
        return _buildMultipleChoiceOptions(question);
      case OnboardingQuestionType.textInput:
        return _buildTextInput(question);
      case OnboardingQuestionType.numberInput:
        return _buildNumberInput(question);
      case OnboardingQuestionType.ratingScale:
        return _buildRatingScale(question);
      default: // handles OnboardingQuestionType.priorityRanking
        return _buildPriorityRanking(question);
    }
  }

  Widget _buildSingleChoiceOptions(LanaOnboardingQuestion question) {
    if (question.options == null || question.options!.isEmpty) {
      return const Text('No options provided.');
    }

    final String? currentAnswer = ref.watch(
      lanaOnboardingProvider
          .select((state) => state.answers[question.id] as String?),
    );

    return Column(
      children: question.options!.map((option) {
        final isSelected = currentAnswer == (option.value ?? option.text);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? AppColors.mediumTurquoise : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? AppColors.mediumTurquoise.withValues(alpha: 0.1)
                : Colors.white,
          ),
          child: InkWell(
            onTap: () {
              ref.read(lanaOnboardingProvider.notifier).answerQuestion(
                    question.id,
                    option.value ?? option.text,
                  );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? AppColors.darkJungleGreen
                        : Colors.grey.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? AppColors.darkJungleGreen
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceOptions(LanaOnboardingQuestion question) {
    // Simplified implementation for now
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Multiple choice options coming soon'),
      ),
    );
  }

  Widget _buildTextInput(LanaOnboardingQuestion question) {
    // Simplified implementation for now
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Text input coming soon'),
      ),
    );
  }

  Widget _buildNumberInput(LanaOnboardingQuestion question) {
    // Simplified implementation for now
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Number input coming soon'),
      ),
    );
  }

  Widget _buildRatingScale(LanaOnboardingQuestion question) {
    // Simplified implementation for now
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Rating scale coming soon'),
      ),
    );
  }

  Widget _buildPriorityRanking(LanaOnboardingQuestion question) {
    // Simplified implementation for now
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Priority ranking coming soon'),
      ),
    );
  }

  Widget _buildProgressIndicator(
      {required int currentIndex, required int totalQuestions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentIndex + 1} of $totalQuestions',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            Text(
              '${((currentIndex + 1) / totalQuestions * 100).toInt()}% Complete',
              style: const TextStyle(
                color: AppColors.mediumTurquoise,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (currentIndex + 1) / totalQuestions,
          backgroundColor: Colors.grey.shade200,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.mediumTurquoise),
          borderRadius: BorderRadius.circular(4),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildIntegrationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connect Your Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'LANA can integrate with your favorite apps and services to make task management seamless.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ..._integrationFeatures
              .map((feature) => _buildIntegrationCard(feature)),
        ],
      ),
    );
  }

  Widget _buildIntegrationCard(LanaFeature feature) {
    final bool isConnected = false; // This would be dynamic in a real app

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature.icon,
                color: AppColors.mediumTurquoise,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Integration connection logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected
                    ? Colors.grey.shade200
                    : AppColors.mediumTurquoise,
                foregroundColor:
                    isConnected ? Colors.grey.shade700 : Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(isConnected ? 'Disconnect' : 'Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
