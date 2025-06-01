import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/school_terms_models.dart';
import 'package:vuet_app/repositories/implementations/supabase_school_terms_repository.dart';

part 'school_terms_providers.g.dart';

// School Terms Data Provider
@riverpod
Future<SchoolTermsData> schoolTermsData(Ref ref) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getAllSchoolTermsData();
}

// School Years Provider
@riverpod
Future<List<SchoolYearModel>> schoolYears(Ref ref) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolYears();
}

// School Terms for Year Provider
@riverpod
Future<List<SchoolTermModel>> schoolTermsForYear(
  Ref ref,
  String schoolYearId,
) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolTermsForYear(schoolYearId);
}

// School Breaks for Year Provider
@riverpod
Future<List<SchoolBreakModel>> schoolBreaksForYear(
  Ref ref,
  String schoolYearId,
) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolBreaksForYear(schoolYearId);
}

// Calendar School Years Provider
@riverpod
Future<List<SchoolYearModel>> calendarSchoolYears(Ref ref) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolYearsForCalendar();
}

// Calendar School Terms Provider
@riverpod
Future<List<SchoolTermModel>> calendarSchoolTerms(
  Ref ref,
  DateTime startDate,
  DateTime endDate,
) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolTermsForCalendar(startDate, endDate);
}

// Calendar School Breaks Provider
@riverpod
Future<List<SchoolBreakModel>> calendarSchoolBreaks(
  Ref ref,
  DateTime startDate,
  DateTime endDate,
) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolBreaksForCalendar(startDate, endDate);
}

// School Year by ID Provider
@riverpod
Future<SchoolYearModel?> schoolYearById(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolYearById(id);
}

// School Term by ID Provider
@riverpod
Future<SchoolTermModel?> schoolTermById(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolTermById(id);
}

// School Break by ID Provider
@riverpod
Future<SchoolBreakModel?> schoolBreakById(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolBreakById(id);
} 