import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/education/student_form_screen.dart'; // Assuming this exists
import 'package:vuet_app/ui/screens/education/student_detail_screen.dart'; // Assuming this exists
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/models/entity_model.dart'; // For EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart'; // For entity service

// --- Temporary Student Model (will be moved to lib/models/education_models.dart) ---
// This is a placeholder. In a real scenario, this would be in a separate file.
@immutable
class Student extends BaseEntityModel {
  final String? schoolName;
  final String? gradeYear; // e.g., "10th Grade", "Freshman", "Year 7"

  const Student({
    String? id,
    required String name,
    String? description,
    String? userId,
    String? categoryId,
    String? subcategoryId,
    String? categoryName,
    String? subcategoryName,
    String? imageUrl,
    bool? isHidden,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.schoolName,
    this.gradeYear,
  }) : super(
          id: id,
          name: name,
          description: description,
          userId: userId,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          categoryName: categoryName,
          subcategoryName: subcategoryName,
          imageUrl: imageUrl,
          isHidden: isHidden,
          createdAt: createdAt,
          updatedAt: updatedAt,
          subtype: EntitySubtype.student, // Crucial for IWantToMenu
        );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userId,
        categoryId,
        subcategoryId,
        categoryName,
        subcategoryName,
        imageUrl,
        isHidden,
        createdAt,
        updatedAt,
        schoolName,
        gradeYear,
        subtype,
      ];

  // Dummy fromJson for now, replace with actual Freezed/json_serializable
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String?,
      categoryId: json['category_id'] as String?,
      subcategoryId: json['subcategory_id'] as String?,
      categoryName: json['category_name'] as String?,
      subcategoryName: json['subcategory_name'] as String?,
      imageUrl: json['image_url'] as String?,
      isHidden: json['is_hidden'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      schoolName: json['school_name'] as String?,
      gradeYear: json['grade_year'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user_id': userId,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'image_url': imageUrl,
      'is_hidden': isHidden,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'school_name': schoolName,
      'grade_year': gradeYear,
      'subtype': subtype.toShortString(),
    };
  }
}

// --- End Temporary Student Model ---

// Provider for the search query for students
final studentSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered students
final filteredStudentsProvider =
    FutureProvider.family<List<Student>, String>((ref, searchQuery) async {
  final entityService = ref.watch(entityServiceProvider);
  final allEntities = await entityService.listEntities(
    // Assuming 'EDUCATION' is the category name for students
    categoryName: 'EDUCATION',
    subtype: EntitySubtype.student,
  );

  // Cast BaseEntityModel to Student
  final allStudents = allEntities.map((e) => Student.fromJson(e.toJson())).toList();

  if (searchQuery.isEmpty) {
    return allStudents;
  } else {
    return allStudents.where((student) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return student.name.toLowerCase().contains(lowerCaseQuery) ||
          (student.schoolName?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (student.gradeYear?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (student.description?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }
});

// Provider for refreshing student list
final studentListRefreshProvider = StateProvider<bool>((ref) => false);

class StudentListScreen extends ConsumerStatefulWidget {
  const StudentListScreen({super.key});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshStudents() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to force a refresh
    ref.invalidate(studentListRefreshProvider);
    ref.invalidate(filteredStudentsProvider(ref.read(studentSearchQueryProvider)));

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    ref.read(studentSearchQueryProvider.notifier).state = query;
  }

  void _navigateToCreateStudent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentFormScreen()),
    ).then((value) {
      if (value == true) {
        _refreshStudents();
      }
    });
  }

  void _navigateToEditStudent(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentFormScreen(student: student)),
    ).then((value) {
      if (value == true) {
        _refreshStudents();
      }
    });
  }

  Future<void> _deleteStudent(BuildContext context, String studentId) async {
    try {
      await ref.read(entityServiceProvider).deleteEntity(studentId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student deleted successfully')),
        );
        _refreshStudents();
      }
    } catch (e, st) {
      log('Error deleting student: $e', name: 'StudentListScreen', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete student: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(studentSearchQueryProvider);
    final studentsAsync = ref.watch(filteredStudentsProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkJungleGreen,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStudents,
            tooltip: 'Refresh students',
          ),
        ],
      ),
      body: studentsAsync.when(
        data: (students) {
          if (students.isEmpty) {
            return _buildEmptyState(context, searchQuery.isNotEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refreshStudents,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentCard(
                  student: student,
                  onTap: () => context.go('/education/students/${student.id}'), // Navigate to detail
                  onEdit: () => _navigateToEditStudent(context, student),
                  onDelete: () => _confirmDelete(context, student.id!),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          log('Error loading students: $error', name: 'StudentListScreen', error: error, stackTrace: stackTrace);
          return ModernComponents.modernErrorState(
            title: 'Error Loading Students',
            subtitle: 'Could not load student list. Please try again.',
            onButtonPressed: _refreshStudents,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateStudent(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.school,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              isSearching ? 'No matching students found' : 'No students yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'Try adjusting your search query.'
                  : 'Create your first student to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: () => _navigateToCreateStudent(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Student'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteStudent(context, studentId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.student,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      } else if (value == 'assignment') {
                        // Navigate to create task with EDUCATION__ASSIGNMENT tag
                        context.go('/tasks/create', extra: {
                          'initialTagCode': 'EDUCATION__ASSIGNMENT',
                          'initialCategoryName': 'Education',
                          'initialEntityId': student.id,
                        });
                      } else if (value == 'exam') {
                        // Navigate to create task with EDUCATION__EXAM tag
                        context.go('/tasks/create', extra: {
                          'initialTagCode': 'EDUCATION__EXAM',
                          'initialCategoryName': 'Education',
                          'initialEntityId': student.id,
                        });
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'assignment',
                        child: ListTile(
                          leading: Icon(Icons.assignment),
                          title: Text('Add Assignment'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'exam',
                        child: ListTile(
                          leading: Icon(Icons.quiz),
                          title: Text('Add Exam'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit Student'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete Student', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (student.description != null && student.description!.isNotEmpty)
                Text(
                  student.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (student.schoolName != null && student.schoolName!.isNotEmpty) ...[
                    Icon(
                      Icons.school,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        student.schoolName!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const SizedBox(width: 16),
                  if (student.gradeYear != null && student.gradeYear!.isNotEmpty) ...[
                    Icon(
                      Icons.class_,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      student.gradeYear!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
