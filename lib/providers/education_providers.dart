import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/education_entities.dart';
import 'package:vuet_app/models/school_terms_models.dart';
import 'package:vuet_app/repositories/education_repository.dart';
import 'package:vuet_app/repositories/school_terms_repository.dart'; // Abstract class

// Repository Providers
final schoolRepositoryProvider = Provider<SchoolRepository>((ref) {
  return SupabaseSchoolRepository(ref);
});

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return SupabaseStudentRepository(ref);
});

final academicPlanRepositoryProvider = Provider<AcademicPlanRepository>((ref) {
  return SupabaseAcademicPlanRepository(ref);
});

final schoolTermsRepositoryProvider = Provider<SchoolTermsRepository>((ref) {
  return SupabaseSchoolTermsRepository(ref); // The concrete implementation
});

// Data Fetching Providers

// Schools
final allSchoolsProvider = FutureProvider<List<School>>((ref) async {
  final repository = ref.watch(schoolRepositoryProvider);
  return repository.getAllSchools();
});

final schoolByIdProvider = FutureProvider.family<School?, String>((ref, id) async {
  final repository = ref.watch(schoolRepositoryProvider);
  return repository.getSchoolById(id);
});

// Students
final allStudentsProvider = FutureProvider<List<Student>>((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getAllStudents();
});

final studentByIdProvider = FutureProvider.family<Student?, String>((ref, id) async {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getStudentById(id);
});

// Academic Plans
final allAcademicPlansProvider = FutureProvider<List<AcademicPlan>>((ref) async {
  final repository = ref.watch(academicPlanRepositoryProvider);
  return repository.getAllAcademicPlans();
});

final academicPlansForStudentProvider = FutureProvider.family<List<AcademicPlan>, String>((ref, studentId) async {
  final repository = ref.watch(academicPlanRepositoryProvider);
  return repository.getAcademicPlansForStudent(studentId);
});

final academicPlanByIdProvider = FutureProvider.family<AcademicPlan?, String>((ref, id) async {
  final repository = ref.watch(academicPlanRepositoryProvider);
  return repository.getAcademicPlanById(id);
});

// School Years, Terms, Breaks (using SchoolTermsRepository)
final allSchoolYearsProvider = FutureProvider<List<SchoolYearModel>>((ref) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolYears();
});

final schoolYearByIdProvider = FutureProvider.family<SchoolYearModel?, String>((ref, id) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolYearById(id);
});

final schoolTermsForYearProvider = FutureProvider.family<List<SchoolTermModel>, String>((ref, schoolYearId) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolTermsForYear(schoolYearId);
});

final schoolTermByIdProvider = FutureProvider.family<SchoolTermModel?, String>((ref, id) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolTermById(id);
});

final schoolBreaksForYearProvider = FutureProvider.family<List<SchoolBreakModel>, String>((ref, schoolYearId) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolBreaksForYear(schoolYearId);
});

final schoolBreakByIdProvider = FutureProvider.family<SchoolBreakModel?, String>((ref, id) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolBreakById(id);
});

final allSchoolTermsDataProvider = FutureProvider<SchoolTermsData>((ref) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getAllSchoolTermsData();
});

// Calendar specific providers
final schoolYearsForCalendarProvider = FutureProvider<List<SchoolYearModel>>((ref) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolYearsForCalendar();
});

final schoolTermsForCalendarProvider = FutureProvider.family<List<SchoolTermModel>, ({DateTime startDate, DateTime endDate})>((ref, params) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolTermsForCalendar(params.startDate, params.endDate);
});

final schoolBreaksForCalendarProvider = FutureProvider.family<List<SchoolBreakModel>, ({DateTime startDate, DateTime endDate})>((ref, params) async {
  final repository = ref.watch(schoolTermsRepositoryProvider);
  return repository.getSchoolBreaksForCalendar(params.startDate, params.endDate);
});
