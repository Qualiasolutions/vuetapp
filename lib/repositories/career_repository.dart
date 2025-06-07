import 'package:vuet_app/models/career_entities.dart';

abstract class CareerRepository {
  // CareerGoal methods
  Future<List<CareerGoal>> getCareerGoalsByUserId(String userId);
  Future<CareerGoal?> getCareerGoalById(String id);
  Future<CareerGoal> createCareerGoal(CareerGoal careerGoal);
  Future<CareerGoal> updateCareerGoal(CareerGoal careerGoal);
  Future<void> deleteCareerGoal(String id);

  // Employee methods
  Future<List<Employee>> getEmployeesByUserId(String userId);
  Future<Employee?> getEmployeeById(String id);
  Future<Employee> createEmployee(Employee employee);
  Future<Employee> updateEmployee(Employee employee);
  Future<void> deleteEmployee(String id);
}
