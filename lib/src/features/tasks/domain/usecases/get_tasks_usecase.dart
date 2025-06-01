import 'package:vuet_app/src/features/tasks/domain/entities/task_entity.dart';
import 'package:vuet_app/src/features/tasks/domain/repositories_abstract/task_repository.dart';

class GetTasksUsecase {
  final TaskRepository _repository;

  GetTasksUsecase(this._repository);

  Future<List<TaskEntity>> call() async {
    // In a real app, you might pass parameters for filtering, sorting, etc.
    return await _repository.getTasks();
  }
}
