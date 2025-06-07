import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/education_entities.dart';
import 'package:vuet_app/models/school_terms_models.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // For supabaseClientProvider
import 'package:vuet_app/state/auto_task_engine.dart'; // For EntityChangeType
import 'package:vuet_app/providers/task_providers.dart'; // For autoTaskEngineProvider, taskServiceProvider
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/repositories/school_terms_repository.dart'; // Import the abstract class


// --- School Repository ---
abstract class SchoolRepository {
  Future<List<School>> getAllSchools();
  Future<School?> getSchoolById(String id);
  Future<School> saveSchool(School school);
  Future<void> deleteSchool(String id);
}

class SupabaseSchoolRepository implements SchoolRepository {
  final SupabaseClient _supabase;

  SupabaseSchoolRepository(Ref ref) : _supabase = ref.read(supabaseClientProvider);

  static const String _entityType = 'School';
  static const String _specificTableName = 'school_entities';
  
  Future<String> _getEducationCategoryId() async {
    final catResponse = await _supabase.from('entity_categories').select('id').eq('name', 'Education').single();
    return catResponse['id'] as String;
  }


  @override
  Future<List<School>> getAllSchools() async {
    final response = await _supabase
        .from('entities')
        .select('*, $_specificTableName!inner(*)')
        .eq('entity_type', _entityType);

    return response.map((data) {
      final entityData = data;
      final specificData = entityData[_specificTableName] as Map<String, dynamic>? ?? {};
      return School.fromJson({
        ...entityData, 
        ...specificData, 
        'id': entityData['id'], 
      });
    }).toList();
  }

  @override
  Future<School?> getSchoolById(String id) async {
    final response = await _supabase
        .from('entities')
        .select('*, $_specificTableName!inner(*)')
        .eq('id', id)
        .eq('entity_type', _entityType)
        .maybeSingle();

    if (response == null) return null;
    final entityData = response;
    final specificData = entityData[_specificTableName] as Map<String, dynamic>? ?? {};
    return School.fromJson({
      ...entityData,
      ...specificData,
      'id': entityData['id'],
    });
  }

  @override
  Future<School> saveSchool(School school) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    final educationCategoryId = await _getEducationCategoryId();

    Map<String, dynamic> entityData = {
      'name': school.name,
      'notes': school.notes,
      'entity_type': _entityType,
      'owner_id': userId,
      'category_id': educationCategoryId, 
    };

    Map<String, dynamic> specificData = {
      'address': school.address,
      'phone_number': school.phoneNumber,
      'email': school.email,
      'website': school.website,
    };

    if (school.id.isEmpty || school.id.startsWith('temp_')) { 
      // Create new
      final newEntityRes = await _supabase.from('entities').insert(entityData).select().single();
      final newEntityId = newEntityRes['id'] as String;
      
      specificData['id'] = newEntityId; 
      await _supabase.from(_specificTableName).insert(specificData);
      
      return school.copyWith(
        id: newEntityId,
        createdAt: DateTime.parse(newEntityRes['created_at']),
        updatedAt: DateTime.parse(newEntityRes['updated_at']),
        ownerId: userId
      );
    } else {
      // Update existing
      entityData['updated_at'] = DateTime.now().toIso8601String();
      await _supabase.from('entities').update(entityData).eq('id', school.id);
      
      // Assuming specific table also has updated_at, if not, remove this line for specificData
      // specificData['updated_at'] = DateTime.now().toIso8601String(); 
      await _supabase.from(_specificTableName).update(specificData).eq('id', school.id);
      return school.copyWith(updatedAt: DateTime.now());
    }
  }

  @override
  Future<void> deleteSchool(String id) async {
    await _supabase.from('entities').delete().eq('id', id);
  }
}

// --- Student Repository ---
abstract class StudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<Student> saveStudent(Student student);
  Future<void> deleteStudent(String id);
}

class SupabaseStudentRepository implements StudentRepository {
  final SupabaseClient _supabase;

  SupabaseStudentRepository(Ref ref) : _supabase = ref.read(supabaseClientProvider);

  static const String _entityType = 'Student';
  static const String _specificTableName = 'student_entities';
  
  Future<String> _getEducationCategoryId() async {
    final catResponse = await _supabase.from('entity_categories').select('id').eq('name', 'Education').single();
    return catResponse['id'] as String;
  }

  @override
  Future<List<Student>> getAllStudents() async {
     final response = await _supabase
        .from('entities')
        .select('*, $_specificTableName!inner(*)')
        .eq('entity_type', _entityType);
    return response.map((data) {
      final entityData = data;
      final specificData = entityData[_specificTableName] as Map<String, dynamic>? ?? {};
      return Student.fromJson({
        ...entityData,
        ...specificData,
        'id': entityData['id'],
        'firstName': entityData['name'], 
      });
    }).toList();
  }

  @override
  Future<Student?> getStudentById(String id) async {
    final response = await _supabase
        .from('entities')
        .select('*, $_specificTableName!inner(*)')
        .eq('id', id)
        .eq('entity_type', _entityType)
        .maybeSingle();

    if (response == null) return null;
    final entityData = response;
    final specificData = entityData[_specificTableName] as Map<String, dynamic>? ?? {};
    return Student.fromJson({
      ...entityData,
      ...specificData,
      'id': entityData['id'],
      'firstName': entityData['name'],
    });
  }

  @override
  Future<Student> saveStudent(Student student) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    final educationCategoryId = await _getEducationCategoryId();

    Map<String, dynamic> entityData = {
      'name': student.firstName, 
      'notes': student.notes,
      'entity_type': _entityType,
      'owner_id': userId,
      'category_id': educationCategoryId,
    };

    Map<String, dynamic> specificData = {
      'last_name': student.lastName,
      'date_of_birth': student.dateOfBirth?.toIso8601String(),
      'school_id': student.schoolId,
      'grade_level': student.gradeLevel,
      'student_id_number': student.studentIdNumber,
    };

    if (student.id.isEmpty || student.id.startsWith('temp_')) {
      final newEntityRes = await _supabase.from('entities').insert(entityData).select().single();
      final newEntityId = newEntityRes['id'] as String;
      specificData['id'] = newEntityId;
      await _supabase.from(_specificTableName).insert(specificData);
      return student.copyWith(
        id: newEntityId,
        createdAt: DateTime.parse(newEntityRes['created_at']),
        updatedAt: DateTime.parse(newEntityRes['updated_at']),
        ownerId: userId
      );
    } else {
      entityData['updated_at'] = DateTime.now().toIso8601String();
      await _supabase.from('entities').update(entityData).eq('id', student.id);
      await _supabase.from(_specificTableName).update(specificData).eq('id', student.id);
      return student.copyWith(updatedAt: DateTime.now());
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    await _supabase.from('entities').delete().eq('id', id);
  }
}


// --- AcademicPlan Repository ---
abstract class AcademicPlanRepository {
  Future<List<AcademicPlan>> getAllAcademicPlans();
  Future<List<AcademicPlan>> getAcademicPlansForStudent(String studentId);
  Future<AcademicPlan?> getAcademicPlanById(String id);
  Future<AcademicPlan> saveAcademicPlan(AcademicPlan academicPlan);
  Future<void> deleteAcademicPlan(String id);
}

class SupabaseAcademicPlanRepository implements AcademicPlanRepository {
  final SupabaseClient _supabase;
  final Ref _ref;

  SupabaseAcademicPlanRepository(this._ref) : _supabase = _ref.read(supabaseClientProvider);

  static const String _entityType = 'AcademicPlan';
  static const String _specificTableName = 'academic_plan_entities';

  Future<String> _getEducationCategoryId() async {
    final catResponse = await _supabase.from('entity_categories').select('id').eq('name', 'Education').single();
    return catResponse['id'] as String;
  }
  
  Future<void> _saveTasks(List<TaskModel> tasks) async {
    if (tasks.isEmpty) return;
    final taskService = _ref.read(taskServiceProvider);
    for (final task in tasks) {
      await taskService.createTask(
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        categoryId: task.categoryId, 
        entityId: task.entityId,
        taskType: task.taskType,
        taskSubtype: task.taskSubtype,
        startDateTime: task.startDateTime,
        endDateTime: task.endDateTime,
        location: task.location,
        typeSpecificData: task.typeSpecificData,
        urgency: task.urgency,
        taskBehavior: task.taskBehavior,
        tags: task.tags,
        parentTaskId: task.parentTaskId,
      );
    }
  }

  @override
  Future<List<AcademicPlan>> getAllAcademicPlans() async {
    final response = await _supabase
        .from('entities')
        .select('*, $_specificTableName!inner(*)')
        .eq('entity_type', _entityType);
    return response.map((data) {
      final entityData = data;
      final specificData = entityData[_specificTableName] as Map<String, dynamic>? ?? {};
      return AcademicPlan.fromJson({
        ...entityData,
        ...specificData,
        'id': entityData['id'],
        'planName': entityData['name'], 
        'goals': (specificData['goals'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      });
    }).toList();
  }
  
  @override
  Future<List<AcademicPlan>> getAcademicPlansForStudent(String studentId) async {
    final response = await _supabase
        .from('entities')
        .select('*, $_specificTableName!inner(*)')
        .eq('entity_type', _entityType)
        .eq('$_specificTableName.student_id', studentId); 
    return response.map((data) {
      final entityData = data;
      final specificData = entityData[_specificTableName] as Map<String, dynamic>? ?? {};
      return AcademicPlan.fromJson({
        ...entityData,
        ...specificData,
        'id': entityData['id'],
        'planName': entityData['name'],
        'goals': (specificData['goals'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      });
    }).toList();
  }


  @override
  Future<AcademicPlan?> getAcademicPlanById(String id) async {
    final response = await _supabase
        .from('entities')
        .select('*, $_specificTableName!inner(*)')
        .eq('id', id)
        .eq('entity_type', _entityType)
        .maybeSingle();

    if (response == null) return null;
    final entityData = response;
    final specificData = entityData[_specificTableName] as Map<String, dynamic>? ?? {};
    return AcademicPlan.fromJson({
      ...entityData,
      ...specificData,
      'id': entityData['id'],
      'planName': entityData['name'],
      'goals': (specificData['goals'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    });
  }

  @override
  Future<AcademicPlan> saveAcademicPlan(AcademicPlan academicPlan) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    final educationCategoryId = await _getEducationCategoryId();
    
    final autoTaskEngine = _ref.read(autoTaskEngineProvider);

    Map<String, dynamic> entityData = {
      'name': academicPlan.planName,
      'notes': academicPlan.notes,
      'entity_type': _entityType,
      'owner_id': userId,
      'category_id': educationCategoryId,
    };

    Map<String, dynamic> specificData = {
      'student_id': academicPlan.studentId,
      'start_date': academicPlan.startDate?.toIso8601String(),
      'end_date': academicPlan.endDate?.toIso8601String(),
      'description': academicPlan.description,
      'goals': academicPlan.goals, 
    };
    
    AcademicPlan savedPlan;

    if (academicPlan.id.isEmpty || academicPlan.id.startsWith('temp_')) {
      final newEntityRes = await _supabase.from('entities').insert(entityData).select().single();
      final newEntityId = newEntityRes['id'] as String;
      specificData['id'] = newEntityId;
      await _supabase.from(_specificTableName).insert(specificData);
      savedPlan = academicPlan.copyWith(
        id: newEntityId,
        createdAt: DateTime.parse(newEntityRes['created_at']),
        updatedAt: DateTime.parse(newEntityRes['updated_at']),
        ownerId: userId
      );
      final newTasks = autoTaskEngine.processEntityChange(savedPlan, EntityChangeType.created);
      await _saveTasks(newTasks);

    } else {
      entityData['updated_at'] = DateTime.now().toIso8601String();
      await _supabase.from('entities').update(entityData).eq('id', academicPlan.id);
      await _supabase.from(_specificTableName).update(specificData).eq('id', academicPlan.id);
      savedPlan = academicPlan.copyWith(updatedAt: DateTime.now());
      final updatedTasks = autoTaskEngine.processEntityChange(savedPlan, EntityChangeType.updated);
      await _saveTasks(updatedTasks);
    }
    return savedPlan;
  }

  @override
  Future<void> deleteAcademicPlan(String id) async {
    await _supabase.from('entities').delete().eq('id', id);
  }
}

// --- SupabaseSchoolTermsRepository Implementation ---
class SupabaseSchoolTermsRepository implements SchoolTermsRepository {
  final SupabaseClient _supabase;
  final Ref _ref; 

  SupabaseSchoolTermsRepository(this._ref) : _supabase = _ref.read(supabaseClientProvider);
  
  // Assuming SchoolYear, SchoolTerm, SchoolBreak are NOT polymorphic entities linked to 'entities' table
  // but are standalone tables as per their model structure (no entityType field).
  // If they ARE polymorphic, their repositories would be similar to SupabaseSchoolRepository.
  static const String _schoolYearsTable = 'school_years'; 
  static const String _schoolTermsTable = 'school_terms';
  static const String _schoolBreaksTable = 'school_breaks';
  
  // Helper to save auto-generated tasks, if SchoolTerm/Break rules are added
  Future<void> _saveTasks(List<TaskModel> tasks) async {
    if (tasks.isEmpty) return;
    final taskService = _ref.read(taskServiceProvider);
    for (final task in tasks) {
      await taskService.createTask(
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        categoryId: task.categoryId,
        entityId: task.entityId,
        taskType: task.taskType,
        taskSubtype: task.taskSubtype,
        startDateTime: task.startDateTime,
        endDateTime: task.endDateTime,
        location: task.location,
        typeSpecificData: task.typeSpecificData,
        urgency: task.urgency,
        taskBehavior: task.taskBehavior,
        tags: task.tags,
        parentTaskId: task.parentTaskId,
      );
    }
  }

  @override
  Future<SchoolYearModel> createSchoolYear(SchoolYearModel schoolYear) async {
    final Map<String, dynamic> dataToSave = schoolYear.toJson();
    // Ensure user_id is set if not already, and timestamps are handled by DB or here
    dataToSave['user_id'] = _supabase.auth.currentUser?.id ?? dataToSave['user_id'];
    dataToSave.remove('id'); // Assuming DB generates ID

    final response = await _supabase.from(_schoolYearsTable).insert(dataToSave).select().single();
    return SchoolYearModel.fromJson(response);
  }

  @override
  Future<List<SchoolYearModel>> getSchoolYears() async {
    final response = await _supabase.from(_schoolYearsTable).select().eq('user_id', _supabase.auth.currentUser!.id);
    return response.map((data) => SchoolYearModel.fromJson(data)).toList();
  }
  
  @override
  Future<SchoolYearModel?> getSchoolYearById(String id) async {
    final response = await _supabase.from(_schoolYearsTable).select().eq('id', id).eq('user_id', _supabase.auth.currentUser!.id).maybeSingle();
    return response == null ? null : SchoolYearModel.fromJson(response);
  }

  @override
  Future<SchoolYearModel> updateSchoolYear(SchoolYearModel schoolYear) async {
    final dataToUpdate = schoolYear.toJson();
    dataToUpdate.remove('id'); // Don't update PK
    dataToUpdate.remove('created_at'); 
    dataToUpdate['updated_at'] = DateTime.now().toIso8601String();

    final response = await _supabase.from(_schoolYearsTable).update(dataToUpdate).eq('id', schoolYear.id).eq('user_id', _supabase.auth.currentUser!.id).select().single();
    return SchoolYearModel.fromJson(response);
  }

  @override
  Future<void> deleteSchoolYear(String id) async {
    await _supabase.from(_schoolYearsTable).delete().eq('id', id).eq('user_id', _supabase.auth.currentUser!.id);
  }

  @override
  Future<SchoolTermModel> createSchoolTerm(SchoolTermModel schoolTerm) async {
    final Map<String, dynamic> dataToSave = schoolTerm.toJson();
    dataToSave['user_id'] = _supabase.auth.currentUser?.id ?? dataToSave['user_id'];
    dataToSave.remove('id');

    final response = await _supabase.from(_schoolTermsTable).insert(dataToSave).select().single();
    final newTerm = SchoolTermModel.fromJson(response);

    // Auto-task for academic year start/end (based on term)
    final autoTaskEngine = _ref.read(autoTaskEngineProvider);
    final newTasks = autoTaskEngine.processEntityChange(newTerm, EntityChangeType.created);
    await _saveTasks(newTasks);
    
    return newTerm;
  }

  @override
  Future<List<SchoolTermModel>> getSchoolTermsForYear(String schoolYearId) async {
    final response = await _supabase.from(_schoolTermsTable).select().eq('school_year_id', schoolYearId).eq('user_id', _supabase.auth.currentUser!.id);
    return response.map((data) => SchoolTermModel.fromJson(data)).toList();
  }
  
   @override
  Future<SchoolTermModel?> getSchoolTermById(String id) async {
    final response = await _supabase.from(_schoolTermsTable).select().eq('id', id).eq('user_id', _supabase.auth.currentUser!.id).maybeSingle();
    return response == null ? null : SchoolTermModel.fromJson(response);
  }

  @override
  Future<SchoolTermModel> updateSchoolTerm(SchoolTermModel schoolTerm) async {
    final dataToUpdate = schoolTerm.toJson();
    dataToUpdate.remove('id');
    dataToUpdate.remove('created_at');
    dataToUpdate['updated_at'] = DateTime.now().toIso8601String();

    final response = await _supabase.from(_schoolTermsTable).update(dataToUpdate).eq('id', schoolTerm.id).eq('user_id', _supabase.auth.currentUser!.id).select().single();
    final updatedTerm = SchoolTermModel.fromJson(response);

    final autoTaskEngine = _ref.read(autoTaskEngineProvider);
    final updatedTasks = autoTaskEngine.processEntityChange(updatedTerm, EntityChangeType.updated);
    await _saveTasks(updatedTasks);

    return updatedTerm;
  }

  @override
  Future<void> deleteSchoolTerm(String id) async {
    await _supabase.from(_schoolTermsTable).delete().eq('id', id).eq('user_id', _supabase.auth.currentUser!.id);
  }

  @override
  Future<SchoolBreakModel> createSchoolBreak(SchoolBreakModel schoolBreak) async {
     final Map<String, dynamic> dataToSave = schoolBreak.toJson();
    dataToSave['user_id'] = _supabase.auth.currentUser?.id ?? dataToSave['user_id'];
    dataToSave.remove('id');
    final response = await _supabase.from(_schoolBreaksTable).insert(dataToSave).select().single();
    return SchoolBreakModel.fromJson(response);
  }

  @override
  Future<List<SchoolBreakModel>> getSchoolBreaksForYear(String schoolYearId) async {
    final response = await _supabase.from(_schoolBreaksTable).select().eq('school_year_id', schoolYearId).eq('user_id', _supabase.auth.currentUser!.id);
    return response.map((data) => SchoolBreakModel.fromJson(data)).toList();
  }
  
  @override
  Future<SchoolBreakModel?> getSchoolBreakById(String id) async {
    final response = await _supabase.from(_schoolBreaksTable).select().eq('id', id).eq('user_id', _supabase.auth.currentUser!.id).maybeSingle();
    return response == null ? null : SchoolBreakModel.fromJson(response);
  }

  @override
  Future<SchoolBreakModel> updateSchoolBreak(SchoolBreakModel schoolBreak) async {
    final dataToUpdate = schoolBreak.toJson();
    dataToUpdate.remove('id');
    dataToUpdate.remove('created_at');
    dataToUpdate['updated_at'] = DateTime.now().toIso8601String();
    final response = await _supabase.from(_schoolBreaksTable).update(dataToUpdate).eq('id', schoolBreak.id).eq('user_id', _supabase.auth.currentUser!.id).select().single();
    return SchoolBreakModel.fromJson(response);
  }

  @override
  Future<void> deleteSchoolBreak(String id) async {
    await _supabase.from(_schoolBreaksTable).delete().eq('id', id).eq('user_id', _supabase.auth.currentUser!.id);
  }

  @override
  Future<SchoolTermsData> getAllSchoolTermsData() async {
    final years = await getSchoolYears();
    final Map<String, SchoolYearModel> schoolYearsById = { for (var y in years) y.id : y };
    final Map<String, List<SchoolTermModel>> termsByYearId = {};
    final Map<String, List<SchoolBreakModel>> breaksByYearId = {};
    final Map<String, SchoolTermModel> termsById = {};
    final Map<String, SchoolBreakModel> breaksById = {};

    for (final year in years) {
      final terms = await getSchoolTermsForYear(year.id);
      termsByYearId[year.id] = terms;
      for (var term in terms) { termsById[term.id] = term; }
      
      final breaks = await getSchoolBreaksForYear(year.id);
      breaksByYearId[year.id] = breaks;
      for (var br in breaks) { breaksById[br.id] = br; }
    }
    return SchoolTermsData(
      schoolYearsById: schoolYearsById,
      termsByYearId: termsByYearId,
      breaksByYearId: breaksByYearId,
      termsById: termsById,
      breaksById: breaksById,
    );
  }

  @override
  Future<List<SchoolYearModel>> getSchoolYearsWithTermsAndBreaks() async {
    // This is a simplified version. A real implementation might involve more complex queries or data shaping.
    final years = await getSchoolYears();
    // For a full implementation, you'd iterate years and populate their terms/breaks.
    return years; 
  }
  
  @override
  Future<List<SchoolYearModel>> getSchoolYearsForCalendar() async {
    final response = await _supabase.from(_schoolYearsTable).select().eq('show_on_calendars', true).eq('user_id', _supabase.auth.currentUser!.id);
    return response.map((data) => SchoolYearModel.fromJson(data)).toList();
  }

  @override
  Future<List<SchoolTermModel>> getSchoolTermsForCalendar(DateTime startDate, DateTime endDate) async {
    final response = await _supabase.from(_schoolTermsTable).select()
      .gte('end_date', startDate.toIso8601String())
      .lte('start_date', endDate.toIso8601String())
      .eq('show_on_calendars', true)
      .eq('user_id', _supabase.auth.currentUser!.id);
    return response.map((data) => SchoolTermModel.fromJson(data)).toList();
  }

  @override
  Future<List<SchoolBreakModel>> getSchoolBreaksForCalendar(DateTime startDate, DateTime endDate) async {
    final response = await _supabase.from(_schoolBreaksTable).select()
      .gte('end_date', startDate.toIso8601String())
      .lte('start_date', endDate.toIso8601String())
      .eq('show_on_calendars', true)
      .eq('user_id', _supabase.auth.currentUser!.id);
    return response.map((data) => SchoolBreakModel.fromJson(data)).toList();
  }
}
