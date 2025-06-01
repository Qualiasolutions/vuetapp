import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/school_terms_models.dart';
import 'package:vuet_app/repositories/school_terms_repository.dart';

part 'supabase_school_terms_repository.g.dart';

@riverpod
SchoolTermsRepository schoolTermsRepository(Ref ref) {
  return SupabaseSchoolTermsRepository();
}

/// Supabase implementation of SchoolTermsRepository
class SupabaseSchoolTermsRepository implements SchoolTermsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  static const String _schoolYearsTable = 'school_years';
  static const String _schoolTermsTable = 'school_terms';
  static const String _schoolBreaksTable = 'school_breaks';

  /// Get current user ID
  String get _currentUserId {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return userId;
  }

  // School Year operations
  @override
  Future<SchoolYearModel> createSchoolYear(SchoolYearModel schoolYear) async {
    try {
      final data = schoolYear.toJson()
        ..remove('id')
        ..['user_id'] = _currentUserId;
      
      final response = await _supabase
          .from(_schoolYearsTable)
          .insert(data)
          .select()
          .single();
      
      return SchoolYearModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create school year: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating school year: $e');
    }
  }

  @override
  Future<List<SchoolYearModel>> getSchoolYears() async {
    try {
      final response = await _supabase
          .from(_schoolYearsTable)
          .select()
          .eq('user_id', _currentUserId)
          .order('start_date', ascending: false);
      
      return response.map((json) => SchoolYearModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch school years: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching school years: $e');
    }
  }

  @override
  Future<SchoolYearModel?> getSchoolYearById(String id) async {
    try {
      final response = await _supabase
          .from(_schoolYearsTable)
          .select()
          .eq('id', id)
          .eq('user_id', _currentUserId)
          .maybeSingle();
      
      return response != null ? SchoolYearModel.fromJson(response) : null;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch school year: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching school year: $e');
    }
  }

  @override
  Future<SchoolYearModel> updateSchoolYear(SchoolYearModel schoolYear) async {
    try {
      final updateData = schoolYear.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('user_id'); // Don't allow changing user_id
      
      final response = await _supabase
          .from(_schoolYearsTable)
          .update(updateData)
          .eq('id', schoolYear.id)
          .eq('user_id', _currentUserId)
          .select()
          .single();
      
      return SchoolYearModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update school year: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating school year: $e');
    }
  }

  @override
  Future<void> deleteSchoolYear(String id) async {
    try {
      await _supabase
          .from(_schoolYearsTable)
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete school year: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting school year: $e');
    }
  }

  // School Term operations
  @override
  Future<SchoolTermModel> createSchoolTerm(SchoolTermModel schoolTerm) async {
    try {
      final data = schoolTerm.toJson()
        ..remove('id')
        ..['user_id'] = _currentUserId;
      
      final response = await _supabase
          .from(_schoolTermsTable)
          .insert(data)
          .select()
          .single();
      
      return SchoolTermModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create school term: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating school term: $e');
    }
  }

  @override
  Future<List<SchoolTermModel>> getSchoolTermsForYear(String schoolYearId) async {
    try {
      final response = await _supabase
          .from(_schoolTermsTable)
          .select()
          .eq('school_year_id', schoolYearId)
          .eq('user_id', _currentUserId)
          .order('start_date', ascending: true);
      
      return response.map((json) => SchoolTermModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch school terms: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching school terms: $e');
    }
  }

  @override
  Future<SchoolTermModel?> getSchoolTermById(String id) async {
    try {
      final response = await _supabase
          .from(_schoolTermsTable)
          .select()
          .eq('id', id)
          .eq('user_id', _currentUserId)
          .maybeSingle();
      
      return response != null ? SchoolTermModel.fromJson(response) : null;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch school term: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching school term: $e');
    }
  }

  @override
  Future<SchoolTermModel> updateSchoolTerm(SchoolTermModel schoolTerm) async {
    try {
      final updateData = schoolTerm.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('user_id'); // Don't allow changing user_id
      
      final response = await _supabase
          .from(_schoolTermsTable)
          .update(updateData)
          .eq('id', schoolTerm.id)
          .eq('user_id', _currentUserId)
          .select()
          .single();
      
      return SchoolTermModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update school term: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating school term: $e');
    }
  }

  @override
  Future<void> deleteSchoolTerm(String id) async {
    try {
      await _supabase
          .from(_schoolTermsTable)
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete school term: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting school term: $e');
    }
  }

  // School Break operations
  @override
  Future<SchoolBreakModel> createSchoolBreak(SchoolBreakModel schoolBreak) async {
    try {
      final data = schoolBreak.toJson()
        ..remove('id')
        ..['user_id'] = _currentUserId;
      
      final response = await _supabase
          .from(_schoolBreaksTable)
          .insert(data)
          .select()
          .single();
      
      return SchoolBreakModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create school break: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating school break: $e');
    }
  }

  @override
  Future<List<SchoolBreakModel>> getSchoolBreaksForYear(String schoolYearId) async {
    try {
      final response = await _supabase
          .from(_schoolBreaksTable)
          .select()
          .eq('school_year_id', schoolYearId)
          .eq('user_id', _currentUserId)
          .order('start_date', ascending: true);
      
      return response.map((json) => SchoolBreakModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch school breaks: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching school breaks: $e');
    }
  }

  @override
  Future<SchoolBreakModel?> getSchoolBreakById(String id) async {
    try {
      final response = await _supabase
          .from(_schoolBreaksTable)
          .select()
          .eq('id', id)
          .eq('user_id', _currentUserId)
          .maybeSingle();
      
      return response != null ? SchoolBreakModel.fromJson(response) : null;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch school break: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching school break: $e');
    }
  }

  @override
  Future<SchoolBreakModel> updateSchoolBreak(SchoolBreakModel schoolBreak) async {
    try {
      final updateData = schoolBreak.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('user_id'); // Don't allow changing user_id
      
      final response = await _supabase
          .from(_schoolBreaksTable)
          .update(updateData)
          .eq('id', schoolBreak.id)
          .eq('user_id', _currentUserId)
          .select()
          .single();
      
      return SchoolBreakModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update school break: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating school break: $e');
    }
  }

  @override
  Future<void> deleteSchoolBreak(String id) async {
    try {
      await _supabase
          .from(_schoolBreaksTable)
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete school break: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting school break: $e');
    }
  }

  // Combined operations - updated for user filtering
  @override
  Future<SchoolTermsData> getAllSchoolTermsData() async {
    try {
      // Fetch all data concurrently
      final futures = await Future.wait([
        getSchoolYears(),
        _getAllSchoolTerms(),
        _getAllSchoolBreaks(),
      ]);
      
      final schoolYears = futures[0] as List<SchoolYearModel>;
      final schoolTerms = futures[1] as List<SchoolTermModel>;
      final schoolBreaks = futures[2] as List<SchoolBreakModel>;
      
      // Organize data by ID and relationships
      final schoolYearsById = <String, SchoolYearModel>{};
      final termsByYearId = <String, List<SchoolTermModel>>{};
      final breaksByYearId = <String, List<SchoolBreakModel>>{};
      final termsById = <String, SchoolTermModel>{};
      final breaksById = <String, SchoolBreakModel>{};
      
      // Process school years
      for (final year in schoolYears) {
        schoolYearsById[year.id] = year;
        termsByYearId[year.id] = [];
        breaksByYearId[year.id] = [];
      }
      
      // Process school terms
      for (final term in schoolTerms) {
        termsById[term.id] = term;
        if (termsByYearId.containsKey(term.schoolYearId)) {
          termsByYearId[term.schoolYearId]!.add(term);
        }
      }
      
      // Process school breaks
      for (final schoolBreak in schoolBreaks) {
        breaksById[schoolBreak.id] = schoolBreak;
        if (breaksByYearId.containsKey(schoolBreak.schoolYearId)) {
          breaksByYearId[schoolBreak.schoolYearId]!.add(schoolBreak);
        }
      }
      
      return SchoolTermsData(
        schoolYearsById: schoolYearsById,
        termsByYearId: termsByYearId,
        breaksByYearId: breaksByYearId,
        termsById: termsById,
        breaksById: breaksById,
      );
    } catch (e) {
      throw Exception('Failed to fetch all school terms data: $e');
    }
  }

  Future<List<SchoolTermModel>> _getAllSchoolTerms() async {
    final response = await _supabase
        .from(_schoolTermsTable)
        .select()
        .eq('user_id', _currentUserId)
        .order('start_date', ascending: true);
    
    return response.map((json) => SchoolTermModel.fromJson(json)).toList();
  }

  Future<List<SchoolBreakModel>> _getAllSchoolBreaks() async {
    final response = await _supabase
        .from(_schoolBreaksTable)
        .select()
        .eq('user_id', _currentUserId)
        .order('start_date', ascending: true);
    
    return response.map((json) => SchoolBreakModel.fromJson(json)).toList();
  }

  @override
  Future<List<SchoolYearModel>> getSchoolYearsWithTermsAndBreaks() async {
    // This could be optimized with joins, but for simplicity we'll use the combined data
    final data = await getAllSchoolTermsData();
    return data.schoolYearsById.values.toList();
  }

  // Calendar-related operations
  @override
  Future<List<SchoolYearModel>> getSchoolYearsForCalendar() async {
    try {
      final response = await _supabase
          .from(_schoolYearsTable)
          .select()
          .eq('show_on_calendars', true)
          .eq('user_id', _currentUserId)
          .order('start_date', ascending: true);
      
      return response.map((json) => SchoolYearModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch school years for calendar: $e');
    }
  }

  @override
  Future<List<SchoolTermModel>> getSchoolTermsForCalendar(DateTime startDate, DateTime endDate) async {
    try {
      final response = await _supabase
          .from(_schoolTermsTable)
          .select()
          .eq('show_on_calendars', true)
          .eq('user_id', _currentUserId)
          .lte('start_date', endDate.toIso8601String())
          .gte('end_date', startDate.toIso8601String())
          .order('start_date', ascending: true);
      
      return response.map((json) => SchoolTermModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch school terms for calendar: $e');
    }
  }

  @override
  Future<List<SchoolBreakModel>> getSchoolBreaksForCalendar(DateTime startDate, DateTime endDate) async {
    try {
      final response = await _supabase
          .from(_schoolBreaksTable)
          .select()
          .eq('show_on_calendars', true)
          .eq('user_id', _currentUserId)
          .lte('start_date', endDate.toIso8601String())
          .gte('end_date', startDate.toIso8601String())
          .order('start_date', ascending: true);
      
      return response.map((json) => SchoolBreakModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch school breaks for calendar: $e');
    }
  }
} 