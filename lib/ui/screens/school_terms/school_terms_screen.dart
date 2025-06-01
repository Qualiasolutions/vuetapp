import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/school_terms_models.dart';
import 'package:vuet_app/providers/school_terms_providers.dart';
import 'package:vuet_app/repositories/implementations/supabase_school_terms_repository.dart';
import 'package:vuet_app/ui/screens/school_terms/components/school_year_card.dart';
import 'package:vuet_app/ui/screens/school_terms/components/school_year_form.dart';
import 'package:vuet_app/ui/screens/school_terms/components/school_term_form.dart';

/// Main school terms management screen
class SchoolTermsScreen extends ConsumerStatefulWidget {
  const SchoolTermsScreen({super.key});

  @override
  ConsumerState<SchoolTermsScreen> createState() => _SchoolTermsScreenState();
}

class _SchoolTermsScreenState extends ConsumerState<SchoolTermsScreen> {
  bool _isAddingSchoolYear = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final schoolTermsAsync = ref.watch(schoolTermsDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('School Terms'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: schoolTermsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorView(error),
        data: (schoolTermsData) => _buildContent(schoolTermsData),
      ),
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading school terms',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(schoolTermsDataProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SchoolTermsData schoolTermsData) {
    if (_isAddingSchoolYear) {
      return _buildAddSchoolYearForm();
    }

    return Column(
      children: [
        // Error message
        if (_errorMessage != null) _buildErrorBanner(),
        
        // Content
        Expanded(
          child: _buildSchoolYearsList(schoolTermsData),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.red.shade50,
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade600),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _errorMessage = null),
            icon: Icon(Icons.close, color: Colors.red.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolYearsList(SchoolTermsData schoolTermsData) {
    final schoolYears = schoolTermsData.schoolYearsById.values.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (schoolYears.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Add school year button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _isAddingSchoolYear = true),
              icon: const Icon(Icons.add),
              label: const Text('Add School Year'),
            ),
          ),
        ),
        
        // School years list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: schoolYears.length,
            itemBuilder: (context, index) {
              final schoolYear = schoolYears[index];
              final terms = schoolTermsData.termsByYearId[schoolYear.id] ?? [];
              final breaks = schoolTermsData.breaksByYearId[schoolYear.id] ?? [];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SchoolYearCard(
                  schoolYear: schoolYear,
                  terms: terms,
                  breaks: breaks,
                  onEditYear: () => _editSchoolYear(schoolYear),
                  onDeleteYear: () => _deleteSchoolYear(schoolYear),
                  onAddTerm: () => _addTerm(schoolYear),
                  onEditTerm: (term) => _editTerm(term),
                  onDeleteTerm: (term) => _deleteTerm(term),
                  onAddBreak: () => _addBreak(schoolYear),
                  onEditBreak: (break_) => _editBreak(break_),
                  onDeleteBreak: (break_) => _deleteBreak(break_),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No School Years',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first school year to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => setState(() => _isAddingSchoolYear = true),
            icon: const Icon(Icons.add),
            label: const Text('Add School Year'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSchoolYearForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _isAddingSchoolYear = false),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              Text(
                'Add School Year',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Form
          Expanded(
            child: SchoolYearForm(
              onSave: _createSchoolYear,
              onCancel: () => setState(() => _isAddingSchoolYear = false),
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  Future<void> _createSchoolYear(SchoolYearModel schoolYear) async {
    try {
      final repository = ref.read(schoolTermsRepositoryProvider);
      await repository.createSchoolYear(schoolYear);
      
      // Refresh data
      ref.invalidate(schoolTermsDataProvider);
      
      setState(() {
        _isAddingSchoolYear = false;
        _errorMessage = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School year created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create school year: $e';
      });
    }
  }

  Future<void> _editSchoolYear(SchoolYearModel schoolYear) async {
    final result = await showDialog<SchoolYearModel>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: SchoolYearForm(
            initialSchoolYear: schoolYear,
            onSave: (updatedSchoolYear) => Navigator.of(context).pop(updatedSchoolYear),
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );

    if (result != null) {
      await _updateSchoolYear(result);
    }
  }

  Future<void> _updateSchoolYear(SchoolYearModel schoolYear) async {
    try {
      final repository = ref.read(schoolTermsRepositoryProvider);
      await repository.updateSchoolYear(schoolYear);
      
      ref.invalidate(schoolTermsDataProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School year updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update school year: $e';
      });
    }
  }

  Future<void> _deleteSchoolYear(SchoolYearModel schoolYear) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete School Year'),
        content: Text(
          'Are you sure you want to delete "${schoolYear.year}"? This will also delete all associated terms and breaks.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(schoolTermsRepositoryProvider);
        await repository.deleteSchoolYear(schoolYear.id);
        
        ref.invalidate(schoolTermsDataProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('School year deleted successfully')),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to delete school year: $e';
        });
      }
    }
  }

  Future<void> _addTerm(SchoolYearModel schoolYear) async {
    final result = await showDialog<SchoolTermModel>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: SchoolTermForm(
            schoolYearId: schoolYear.id,
            isBreak: false,
            onSave: (term) => Navigator.of(context).pop(term),
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );

    if (result != null) {
      await _createTerm(result);
    }
  }

  Future<void> _createTerm(SchoolTermModel term) async {
    try {
      final repository = ref.read(schoolTermsRepositoryProvider);
      await repository.createSchoolTerm(term);
      
      ref.invalidate(schoolTermsDataProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Term created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create term: $e';
      });
    }
  }

  Future<void> _editTerm(SchoolTermModel term) async {
    final result = await showDialog<SchoolTermModel>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: SchoolTermForm(
            schoolYearId: term.schoolYearId,
            initialTerm: term,
            isBreak: false,
            onSave: (updatedTerm) => Navigator.of(context).pop(updatedTerm),
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );

    if (result != null) {
      await _updateTerm(result);
    }
  }

  Future<void> _updateTerm(SchoolTermModel term) async {
    try {
      final repository = ref.read(schoolTermsRepositoryProvider);
      await repository.updateSchoolTerm(term);
      
      ref.invalidate(schoolTermsDataProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Term updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update term: $e';
      });
    }
  }

  Future<void> _deleteTerm(SchoolTermModel term) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Term'),
        content: Text('Are you sure you want to delete "${term.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(schoolTermsRepositoryProvider);
        await repository.deleteSchoolTerm(term.id);
        
        ref.invalidate(schoolTermsDataProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Term deleted successfully')),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to delete term: $e';
        });
      }
    }
  }

  Future<void> _addBreak(SchoolYearModel schoolYear) async {
    final result = await showDialog<SchoolBreakModel>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: SchoolTermForm(
            schoolYearId: schoolYear.id,
            isBreak: true,
            onSave: (break_) => Navigator.of(context).pop(break_ as SchoolBreakModel),
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );

    if (result != null) {
      await _createBreak(result);
    }
  }

  Future<void> _createBreak(SchoolBreakModel break_) async {
    try {
      final repository = ref.read(schoolTermsRepositoryProvider);
      await repository.createSchoolBreak(break_);
      
      ref.invalidate(schoolTermsDataProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Break created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create break: $e';
      });
    }
  }

  Future<void> _editBreak(SchoolBreakModel break_) async {
    final result = await showDialog<SchoolBreakModel>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: SchoolTermForm(
            schoolYearId: break_.schoolYearId,
            initialBreak: break_,
            isBreak: true,
            onSave: (updatedBreak) => Navigator.of(context).pop(updatedBreak as SchoolBreakModel),
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );

    if (result != null) {
      await _updateBreak(result);
    }
  }

  Future<void> _updateBreak(SchoolBreakModel break_) async {
    try {
      final repository = ref.read(schoolTermsRepositoryProvider);
      await repository.updateSchoolBreak(break_);
      
      ref.invalidate(schoolTermsDataProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Break updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update break: $e';
      });
    }
  }

  Future<void> _deleteBreak(SchoolBreakModel break_) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Break'),
        content: Text('Are you sure you want to delete "${break_.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(schoolTermsRepositoryProvider);
        await repository.deleteSchoolBreak(break_.id);
        
        ref.invalidate(schoolTermsDataProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Break deleted successfully')),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to delete break: $e';
        });
      }
    }
  }
} 