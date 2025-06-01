import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/constants/setup_content.dart';
import 'package:vuet_app/services/setup_service.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

class CategorySetupScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;
  final VoidCallback? onSetupComplete;

  const CategorySetupScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.onSetupComplete,
  });

  @override
  ConsumerState<CategorySetupScreen> createState() => _CategorySetupScreenState();
}

class _CategorySetupScreenState extends ConsumerState<CategorySetupScreen> {
  final PageController _pageController = PageController();
  final SetupService _setupService = SetupService();
  
  int _currentPage = 0;
  bool _isLoading = false;
  List<String> _setupPages = [];

  @override
  void initState() {
    super.initState();
    _setupPages = SetupContent.getCategorySetupPages(widget.categoryId) ?? [];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _setupService.markCategorySetupCompleted(widget.categoryId);
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.categoryName} setup completed!'),
            backgroundColor: Colors.green,
          ),
        );

        // Call completion callback or navigate back
        if (widget.onSetupComplete != null) {
          widget.onSetupComplete!();
        } else {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing setup: $e'),
            backgroundColor: Colors.red,
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_setupPages.isEmpty) {
      // No setup content available, mark as completed immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _completeSetup();
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Setup'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentPage + 1} of ${_setupPages.length}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${((_currentPage + 1) / _setupPages.length * 100).round()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentPage + 1) / _setupPages.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Setup content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _setupPages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category icon and title
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getCategoryIcon(widget.categoryId),
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.categoryName,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Getting Started',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Setup content
                      Expanded(
                        child: SingleChildScrollView(
                          child: ModernComponents.modernCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                _setupPages[index],
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: ModernComponents.modernButton(
                      text: 'Previous',
                      onPressed: _previousPage,
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: ModernComponents.modernButton(
                    text: _currentPage < _setupPages.length - 1 
                        ? 'Continue' 
                        : 'Complete Setup',
                    onPressed: _isLoading ? () {} : _nextPage,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
