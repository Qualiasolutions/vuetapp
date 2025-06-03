import 'package:flutter/material.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart';

class CategoryIntroductionScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final List<CategoryIntroPage> introPages;
  final List<String>? subCategoryKeys;

  const CategoryIntroductionScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.introPages,
    this.subCategoryKeys,
  });

  @override
  State<CategoryIntroductionScreen> createState() => _CategoryIntroductionScreenState();
}

class _CategoryIntroductionScreenState extends State<CategoryIntroductionScreen> {
  int _currentPageIndex = 0;

  void _nextPage() {
    if (_currentPageIndex < widget.introPages.length - 1) {
      setState(() {
        _currentPageIndex++;
      });
    } else {
      // On last page, navigate to subcategory screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategoryScreen(
            categoryId: widget.categoryId,
            categoryName: widget.categoryName,
            subCategoryKeys: widget.subCategoryKeys ?? [widget.categoryId],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = widget.introPages[_currentPageIndex];

    return Scaffold(
      body: Column(
        children: [
          // Header with image and title
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(currentPage.backgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Dark overlay for better text visibility
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.black.withAlpha((0.4 * 255).round()),
              ),
              // Back button and title
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content area
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentPage.content,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB23B00),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIntroPage {
  final String content;
  final String backgroundImage;

  const CategoryIntroPage({
    required this.content,
    required this.backgroundImage,
  });
}

// Helper to create intro screens for different categories
class CategoryIntroFactory {
  static CategoryIntroductionScreen createPetsIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'pets',
      categoryName: 'Pets',
      subCategoryKeys: ['pets'],
      introPages: const [
        CategoryIntroPage(
          content: "The Pets Category allows users to keep up with their pets individually or as a group. The first step is to enter the pets as an Entity.",
          backgroundImage: 'assets/images/categories/pets.png',
        ),
        CategoryIntroPage(
          content: "Once Pets are added, users can set up feeding, grooming/cleaning, exercise and health schedules individually or as a group by choosing from the subcategories.",
          backgroundImage: 'assets/images/categories/pets.png',
        ),
      ],
    );
  }

  static CategoryIntroductionScreen createSocialIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'social_interests',
      categoryName: 'Social & Interests',
      subCategoryKeys: ['social_interests'],
      introPages: const [
        CategoryIntroPage(
          content: "The Social & Interests category helps you manage your social activities, events, and hobbies.",
          backgroundImage: 'assets/images/categories/social.png',
        ),
        CategoryIntroPage(
          content: "You can track social plans, events, anniversaries, and hobbies all in one place.",
          backgroundImage: 'assets/images/categories/social.png',
        ),
      ],
    );
  }

  static CategoryIntroductionScreen createEducationIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'education_career',
      categoryName: 'Education & Career',
      subCategoryKeys: ['education', 'career'],
      introPages: const [
        CategoryIntroPage(
          content: "The Education & Career category helps you manage your educational and professional goals.",
          backgroundImage: 'assets/images/categories/education.png',
        ),
        CategoryIntroPage(
          content: "You can track courses, educational goals, career paths, and professional development all in one place.",
          backgroundImage: 'assets/images/categories/education.png',
        ),
      ],
    );
  }

  static CategoryIntroductionScreen createTravelIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'travel',
      categoryName: 'Travel',
      subCategoryKeys: ['travel'],
      introPages: const [
        CategoryIntroPage(
          content: "The Travel category helps you plan and manage your trips and vacations.",
          backgroundImage: 'assets/images/categories/travel.png',
        ),
        CategoryIntroPage(
          content: "You can organize trips, accommodations, and attractions for all your travel needs.",
          backgroundImage: 'assets/images/categories/travel.png',
        ),
      ],
    );
  }

  static CategoryIntroductionScreen createHealthBeautyIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'health_beauty',
      categoryName: 'Health & Beauty',
      subCategoryKeys: ['health_beauty'],
      introPages: const [
        CategoryIntroPage(
          content: "The Health & Beauty category helps you manage your health and wellness routines.",
          backgroundImage: 'assets/images/categories/health.png',
        ),
        CategoryIntroPage(
          content: "Track fitness activities, medical appointments, and beauty routines all in one place.",
          backgroundImage: 'assets/images/categories/health.png',
        ),
      ],
    );
  }

  static CategoryIntroductionScreen createHomeGardenIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'home_garden',
      categoryName: 'Home & Garden',
      subCategoryKeys: ['home', 'garden', 'food', 'laundry'],
      introPages: const [
        CategoryIntroPage(
          content: "The Home & Garden category helps you manage your household tasks and maintenance.",
          backgroundImage: 'assets/images/categories/home.png',
        ),
        CategoryIntroPage(
          content: "Organize home maintenance, gardening tasks, cooking, and laundry all in one convenient place.",
          backgroundImage: 'assets/images/categories/home.png',
        ),
      ],
    );
  }

  static CategoryIntroductionScreen createFinanceIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'finance',
      categoryName: 'Finance',
      subCategoryKeys: ['finance'],
      introPages: const [
        CategoryIntroPage(
          content: "The Finance category helps you manage your financial accounts and budgeting.",
          backgroundImage: 'assets/images/categories/finance.png',
        ),
        CategoryIntroPage(
          content: "Track accounts, budgets, and investments to stay on top of your financial goals.",
          backgroundImage: 'assets/images/categories/finance.png',
        ),
      ],
    );
  }

  static CategoryIntroductionScreen createTransportIntro({required VoidCallback onComplete}) {
    return CategoryIntroductionScreen(
      categoryId: 'transport',
      categoryName: 'Transport',
      subCategoryKeys: ['transport'],
      introPages: const [
        CategoryIntroPage(
          content: "The Transport category helps you manage your vehicles and transportation needs.",
          backgroundImage: 'assets/images/categories/transport.png',
        ),
        CategoryIntroPage(
          content: "Track vehicle maintenance, public transportation options, and other transport-related tasks.",
          backgroundImage: 'assets/images/categories/transport.png',
        ),
      ],
    );
  }

  // Add factory methods for other categories as needed
} 