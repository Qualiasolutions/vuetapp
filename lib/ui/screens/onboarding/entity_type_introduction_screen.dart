import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/constants/setup_content.dart';
import 'package:vuet_app/services/setup_service.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/providers/family_providers.dart';

/// Modern entity type introduction screen with interactive guidance
class EntityTypeIntroductionScreen extends ConsumerStatefulWidget {
  final String entityTypeName;
  final String categoryId;
  final String categoryName;
  final VoidCallback? onComplete;

  const EntityTypeIntroductionScreen({
    super.key,
    required this.entityTypeName,
    required this.categoryId,
    required this.categoryName,
    this.onComplete,
  });

  @override
  ConsumerState<EntityTypeIntroductionScreen> createState() => _EntityTypeIntroductionScreenState();
}

class _EntityTypeIntroductionScreenState extends ConsumerState<EntityTypeIntroductionScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _contentAnimationController;
  late AnimationController _progressAnimationController;
  
  late Animation<double> _heroScaleAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _progressAnimation;

  final PageController _pageController = PageController();
  final SetupService _setupService = SetupService();
  
  int _currentPage = 0;
  bool _isLoading = false;
  List<String> _setupPages = [];
  bool _hasStartedReading = false;

  @override
  void initState() {
    super.initState();
    _setupPages = SetupContent.getEntityTypeSetupPages(widget.entityTypeName) ?? [];
    _initAnimations();
    _startIntroAnimation();
  }

  void _initAnimations() {
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: Curves.elasticOut,
    ));

    _heroSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: Curves.easeOutBack,
    ));

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOut,
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeOut,
    ));
  }

  void _startIntroAnimation() {
    _heroAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _contentAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _contentAnimationController.dispose();
    _progressAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeIntroduction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _setupService.markEntityTypeSetupCompleted(widget.entityTypeName);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text('${widget.entityTypeName} introduction completed!'),
              ],
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

        widget.onComplete?.call();
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing introduction: $e'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _nextPage() {
    if (_currentPage < _setupPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeIntroduction();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      if (!_hasStartedReading) {
        _hasStartedReading = true;
      }
    });
    
    _progressAnimationController.reset();
    _progressAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_setupPages.isEmpty) {
      return _buildNoContentView();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0 || _hasStartedReading
            ? IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                ),
                onPressed: _currentPage > 0 ? _previousPage : () => Navigator.pop(context),
              )
            : null,
        actions: [
          if (_hasStartedReading)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.close, color: AppTheme.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
        ],
      ),
      body: Column(
        children: [
          // Hero section
          _buildHeroSection(),
          
          // Progress indicator
          if (_hasStartedReading) _buildProgressIndicator(),
          
          // Content section
          Expanded(
            child: _hasStartedReading ? _buildContentPages() : _buildWelcomeView(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoContentView() {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.entityTypeName} Introduction')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No introduction content available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getEntityTypeColor(widget.entityTypeName),
            _getEntityTypeColor(widget.entityTypeName).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _heroAnimationController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _heroSlideAnimation,
                    child: ScaleTransition(
                      scale: _heroScaleAnimation,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getEntityTypeIcon(widget.entityTypeName),
                          size: 45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _contentAnimationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: SlideTransition(
                      position: _contentSlideAnimation,
                      child: Column(
                        children: [
                          Text(
                            'Get started with',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.entityTypeName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'in ${widget.categoryName}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentPage + 1} of ${_setupPages.length}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Text(
                    '${((_currentPage + 1) / _setupPages.length * 100).round()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getEntityTypeColor(widget.entityTypeName),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.grey.shade200,
                ),
                child: FractionallySizedBox(
                  widthFactor: (_currentPage + 1) / _setupPages.length * _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        colors: [
                          _getEntityTypeColor(widget.entityTypeName),
                          _getEntityTypeColor(widget.entityTypeName).withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeView() {
    final familyAsync = ref.watch(currentUserFamilyProvider);
    
    return AnimatedBuilder(
      animation: _contentAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _contentFadeAnimation,
          child: SlideTransition(
            position: _contentSlideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 64,
                                color: _getEntityTypeColor(widget.entityTypeName),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Learn About ${widget.entityTypeName}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Discover how to make the most of ${widget.entityTypeName} in your ${widget.categoryName} organization.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              familyAsync.when(
                                data: (family) {
                                  if (family != null) {
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppTheme.secondary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.family_restroom,
                                            color: AppTheme.secondary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Learning for ${family.name}',
                                            style: TextStyle(
                                              color: AppTheme.secondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                                loading: () => const SizedBox(),
                                error: (_, __) => const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildEntityTypeFeatures(),
                      ],
                    ),
                  ),
                  _buildWelcomeActions(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEntityTypeFeatures() {
    final features = _getEntityTypeFeatures(widget.entityTypeName);
    
    return Column(
      children: [
        Text(
          'What you\'ll discover:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...features.take(3).map((feature) => _buildFeatureItem(feature)),
      ],
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getEntityTypeColor(widget.entityTypeName).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: _getEntityTypeColor(widget.entityTypeName),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature['description'] as String,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _hasStartedReading = true;
              });
              _onPageChanged(0);
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Learning'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getEntityTypeColor(widget.entityTypeName),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => _completeIntroduction(),
          child: const Text('Skip Introduction'),
        ),
      ],
    );
  }

  Widget _buildContentPages() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: _setupPages.length,
      itemBuilder: (context, index) {
        return _buildContentPage(index);
      },
    );
  }

  Widget _buildContentPage(int index) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _getEntityTypeColor(widget.entityTypeName).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getEntityTypeIcon(widget.entityTypeName),
                            color: _getEntityTypeColor(widget.entityTypeName),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Step ${index + 1}',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.entityTypeName,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _setupPages[index],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (index == _setupPages.length - 1) _buildCompletionReward(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildCompletionReward() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.success.withValues(alpha: 0.1),
            AppTheme.success.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.celebration,
            color: AppTheme.success,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Well done!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re now ready to create and manage ${widget.entityTypeName} effectively!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentPage > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (_currentPage > 0) const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _nextPage,
            icon: _isLoading 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_currentPage < _setupPages.length - 1 
                    ? Icons.arrow_forward 
                    : Icons.check),
            label: Text(_currentPage < _setupPages.length - 1 
                ? 'Continue' 
                : 'Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getEntityTypeColor(widget.entityTypeName),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods for entity type-specific content
  Color _getEntityTypeColor(String entityTypeName) {
    switch (entityTypeName.toLowerCase()) {
      case 'socialplan':
        return AppTheme.secondary;
      case 'socialmedia':
        return const Color(0xFF9C27B0);
      case 'event':
        return AppTheme.accent;
      case 'hobby':
        return AppTheme.info;
      default:
        return AppTheme.primary;
    }
  }

  IconData _getEntityTypeIcon(String entityTypeName) {
    switch (entityTypeName.toLowerCase()) {
      case 'socialplan':
        return Icons.people;
      case 'socialmedia':
        return Icons.share;
      case 'event':
        return Icons.event;
      case 'hobby':
        return Icons.interests;
      default:
        return Icons.extension;
    }
  }

  List<Map<String, dynamic>> _getEntityTypeFeatures(String entityTypeName) {
    switch (entityTypeName.toLowerCase()) {
      case 'socialplan':
        return [
          {'icon': Icons.family_restroom, 'title': 'Family Time', 'description': 'Schedule quality time with family members'},
          {'icon': Icons.calendar_today, 'title': 'Activity Planning', 'description': 'Plan and organize social activities'},
          {'icon': Icons.list_alt, 'title': 'Task Management', 'description': 'Create lists and tasks for social events'},
        ];
      case 'socialmedia':
        return [
          {'icon': Icons.post_add, 'title': 'Content Planning', 'description': 'Plan and schedule social media posts'},
          {'icon': Icons.analytics, 'title': 'Platform Management', 'description': 'Organize content for different platforms'},
          {'icon': Icons.schedule, 'title': 'Posting Schedule', 'description': 'Create consistent posting schedules'},
        ];
      case 'event':
        return [
          {'icon': Icons.event_note, 'title': 'Event Planning', 'description': 'Comprehensive event organization'},
          {'icon': Icons.people_outline, 'title': 'Guest Management', 'description': 'Manage invitations and RSVPs'},
          {'icon': Icons.restaurant, 'title': 'Catering & Venues', 'description': 'Plan food, activities, and locations'},
        ];
      case 'hobby':
        return [
          {'icon': Icons.schedule, 'title': 'Time Management', 'description': 'Set aside dedicated time for hobbies'},
          {'icon': Icons.track_changes, 'title': 'Progress Tracking', 'description': 'Monitor your hobby development'},
          {'icon': Icons.group, 'title': 'Community', 'description': 'Connect with others who share your interests'},
        ];
      default:
        return [
          {'icon': Icons.star, 'title': 'Get Organized', 'description': 'Learn best practices for this entity type'},
          {'icon': Icons.track_changes, 'title': 'Track Progress', 'description': 'Monitor your goals and achievements'},
          {'icon': Icons.share, 'title': 'Share with Family', 'description': 'Collaborate with family members'},
        ];
    }
  }
} 