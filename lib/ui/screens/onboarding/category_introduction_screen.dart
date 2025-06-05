import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/constants/setup_content.dart';
import 'package:vuet_app/services/setup_service.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/providers/family_providers.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart';

/// Modern, interactive category introduction screen with beautiful animations
class CategoryIntroductionScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;
  final VoidCallback? onComplete;

  const CategoryIntroductionScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.onComplete,
  });

  @override
  ConsumerState<CategoryIntroductionScreen> createState() => _CategoryIntroductionScreenState();
}

class _CategoryIntroductionScreenState extends ConsumerState<CategoryIntroductionScreen>
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
    _setupPages = SetupContent.getCategorySetupPages(widget.categoryId) ?? [];
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
      await _setupService.markCategorySetupCompleted(widget.categoryId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text('${widget.categoryName} introduction completed!'),
              ],
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

        widget.onComplete?.call();
        
        // Navigate to the appropriate subcategory screen
        _navigateToSubcategoryScreen();
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

  void _navigateToSubcategoryScreen() {
    // Import required for navigation
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => _buildSubcategoryScreen(),
      ),
    );
  }

  Widget _buildSubcategoryScreen() {
    // Import the SubCategoryScreen and related classes
    final subCategoryScreen = (() {
      // Import statement will be needed at the top
      switch (widget.categoryId.toLowerCase()) {
        case 'transport':
          return const SubCategoryScreen(
            categoryId: 'transport',
            categoryName: 'Transport',
            subCategoryKeys: ['transport'], // Will load transport subcategories
          );
        case 'pets':
          return const SubCategoryScreen(
            categoryId: 'pets',
            categoryName: 'Pets',
            subCategoryKeys: ['pets'],
          );
        case 'social_interests':
          return const SubCategoryScreen(
            categoryId: 'social_interests',
            categoryName: 'Social Interests', 
            subCategoryKeys: ['social_interests'],
          );
        case 'education':
          return const SubCategoryScreen(
            categoryId: 'education',
            categoryName: 'Education',
            subCategoryKeys: ['education'],
          );
        case 'career':
          return const SubCategoryScreen(
            categoryId: 'career',
            categoryName: 'Career',
            subCategoryKeys: ['career'],
          );
        case 'travel':
          return const SubCategoryScreen(
            categoryId: 'travel',
            categoryName: 'Travel',
            subCategoryKeys: ['travel'],
          );
        case 'health_beauty':
          return const SubCategoryScreen(
            categoryId: 'health_beauty',
            categoryName: 'Health & Beauty',
            subCategoryKeys: ['health_beauty'],
          );
        case 'home':
          return const SubCategoryScreen(
            categoryId: 'home',
            categoryName: 'Home',
            subCategoryKeys: ['home'],
          );
        case 'garden':
          return const SubCategoryScreen(
            categoryId: 'garden',
            categoryName: 'Garden',
            subCategoryKeys: ['garden'],
          );
        case 'food':
          return const SubCategoryScreen(
            categoryId: 'food',
            categoryName: 'Food',
            subCategoryKeys: ['food'],
          );
        case 'laundry':
          return const SubCategoryScreen(
            categoryId: 'laundry',
            categoryName: 'Laundry',
            subCategoryKeys: ['laundry'],
          );
        case 'finance':
          return const SubCategoryScreen(
            categoryId: 'finance',
            categoryName: 'Finance',
            subCategoryKeys: ['finance'],
          );
        default:
          // Fallback - just pop the current screen
          Navigator.of(context).pop(true);
          return Container(); // This won't be used due to the pop
      }
    })();
    
    return subCategoryScreen;
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
      appBar: AppBar(title: Text('${widget.categoryName} Introduction')),
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
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor(widget.categoryId),
            _getCategoryColor(widget.categoryId).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getCategoryIcon(widget.categoryId),
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
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
                            'Welcome to',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.categoryName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                      color: AppTheme.primary,
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
                          _getCategoryColor(widget.categoryId),
                          _getCategoryColor(widget.categoryId).withValues(alpha: 0.8),
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
                                Icons.auto_awesome,
                                size: 64,
                                color: _getCategoryColor(widget.categoryId),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Let\'s Get Started!',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'We\'ll guide you through setting up ${widget.categoryName} to help you stay organized and productive.',
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
                                            'Setting up for ${family.name}',
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
                        const SizedBox(height: 32),
                        _buildFeaturePreview(),
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

  Widget _buildFeaturePreview() {
    final features = _getCategoryFeatures(widget.categoryId);
    
    return Column(
      children: [
        Text(
          'What you\'ll learn:',
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
              color: _getCategoryColor(widget.categoryId).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: _getCategoryColor(widget.categoryId),
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
            label: const Text('Start Introduction'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getCategoryColor(widget.categoryId),
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
                            color: _getCategoryColor(widget.categoryId).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(widget.categoryId),
                            color: _getCategoryColor(widget.categoryId),
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
                                widget.categoryName,
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
            'Great job!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re now ready to make the most of ${widget.categoryName}!',
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
              backgroundColor: _getCategoryColor(widget.categoryId),
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

  // Helper methods for category-specific content
  Color _getCategoryColor(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'pets':
        return AppTheme.accent;
      case 'social_interests':
        return AppTheme.secondary;
      case 'education':
        return AppTheme.info;
      case 'career':
        return AppTheme.primary;
      case 'travel':
        return const Color(0xFF9C27B0);
      case 'health_beauty':
        return const Color(0xFFE91E63);
      case 'home':
        return const Color(0xFF795548);
      case 'garden':
        return const Color(0xFF4CAF50);
      case 'food':
        return const Color(0xFFFF9800);
      case 'laundry':
        return const Color(0xFF607D8B);
      case 'finance':
        return const Color(0xFF3F51B5);
      case 'transport':
        return const Color(0xFF9E9E9E);
      default:
        return AppTheme.primary;
    }
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'pets':
        return Icons.pets;
      case 'social_interests':
        return Icons.people;
      case 'education':
        return Icons.school;
      case 'career':
        return Icons.work;
      case 'travel':
        return Icons.flight;
      case 'health_beauty':
        return Icons.favorite;
      case 'home':
        return Icons.home;
      case 'garden':
        return Icons.local_florist;
      case 'food':
        return Icons.restaurant;
      case 'laundry':
        return Icons.local_laundry_service;
      case 'finance':
        return Icons.account_balance;
      case 'transport':
        return Icons.directions_car;
      default:
        return Icons.category;
    }
  }

  List<Map<String, dynamic>> _getCategoryFeatures(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'pets':
        return [
          {'icon': Icons.pets, 'title': 'Pet Profiles', 'description': 'Set up individual profiles for each pet'},
          {'icon': Icons.schedule, 'title': 'Care Schedules', 'description': 'Track feeding, grooming, and health schedules'},
          {'icon': Icons.medical_services, 'title': 'Health Records', 'description': 'Keep track of vet visits and medications'},
        ];
      case 'social_interests':
        return [
          {'icon': Icons.cake, 'title': 'Special Dates', 'description': 'Remember birthdays and anniversaries'},
          {'icon': Icons.event, 'title': 'Event Planning', 'description': 'Organize social gatherings and activities'},
          {'icon': Icons.interests, 'title': 'Hobby Tracking', 'description': 'Manage your interests and hobbies'},
        ];
      case 'education':
        return [
          {'icon': Icons.school, 'title': 'Academic Tracking', 'description': 'Organize assignments and due dates'},
          {'icon': Icons.calendar_today, 'title': 'School Terms', 'description': 'Set up academic calendar and terms'},
          {'icon': Icons.sports, 'title': 'Extracurriculars', 'description': 'Track activities and commitments'},
        ];
      default:
        return [
          {'icon': Icons.star, 'title': 'Get Organized', 'description': 'Learn the best practices for this category'},
          {'icon': Icons.track_changes, 'title': 'Track Progress', 'description': 'Monitor your goals and achievements'},
          {'icon': Icons.family_restroom, 'title': 'Share with Family', 'description': 'Collaborate with family members'},
        ];
    }
  }
}
