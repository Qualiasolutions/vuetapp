import 'package:vuet_app/models/school_terms_models.dart';

/// Abstract repository for school terms operations
abstract class SchoolTermsRepository {
  // School Year operations
  Future<SchoolYearModel> createSchoolYear(SchoolYearModel schoolYear);
  Future<List<SchoolYearModel>> getSchoolYears();
  Future<SchoolYearModel?> getSchoolYearById(String id);
  Future<SchoolYearModel> updateSchoolYear(SchoolYearModel schoolYear);
  Future<void> deleteSchoolYear(String id);
  
  // School Term operations
  Future<SchoolTermModel> createSchoolTerm(SchoolTermModel schoolTerm);
  Future<List<SchoolTermModel>> getSchoolTermsForYear(String schoolYearId);
  Future<SchoolTermModel?> getSchoolTermById(String id);
  Future<SchoolTermModel> updateSchoolTerm(SchoolTermModel schoolTerm);
  Future<void> deleteSchoolTerm(String id);
  
  // School Break operations
  Future<SchoolBreakModel> createSchoolBreak(SchoolBreakModel schoolBreak);
  Future<List<SchoolBreakModel>> getSchoolBreaksForYear(String schoolYearId);
  Future<SchoolBreakModel?> getSchoolBreakById(String id);
  Future<SchoolBreakModel> updateSchoolBreak(SchoolBreakModel schoolBreak);
  Future<void> deleteSchoolBreak(String id);
  
  // Combined operations
  Future<SchoolTermsData> getAllSchoolTermsData();
  Future<List<SchoolYearModel>> getSchoolYearsWithTermsAndBreaks();
  
  // Calendar-related operations
  Future<List<SchoolYearModel>> getSchoolYearsForCalendar();
  Future<List<SchoolTermModel>> getSchoolTermsForCalendar(DateTime startDate, DateTime endDate);
  Future<List<SchoolBreakModel>> getSchoolBreaksForCalendar(DateTime startDate, DateTime endDate);
} 