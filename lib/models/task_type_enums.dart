enum TaskType {
  task('task', 'Tasks', true),
  appointment('appointment', 'Appointment', false),
  dueDate('due_date', 'Due date', false),
  activity('activity', 'Going out', false),
  transport('transport', 'Getting there', false),
  accommodation('accommodation', 'Staying overnight', false),
  anniversary('anniversary', 'Birthday/anniversary', false);

  const TaskType(this.name, this.displayName, this.isDynamic);

  final String name;
  final String displayName;
  final bool isDynamic;
}

enum TaskPriority {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High');

  const TaskPriority(this.value, this.label);

  final String value;
  final String label;
}

enum TaskUrgency {
  low('LOW', 'Low'),
  medium('MEDIUM', 'Medium'),
  high('HIGH', 'High'),
  urgent('URGENT', 'Urgent');

  const TaskUrgency(this.value, this.label);

  final String value;
  final String label;
}

enum SchedulingType {
  flexible('FLEXIBLE', 'Flexible'),
  fixed('FIXED', 'Fixed');

  const SchedulingType(this.value, this.label);

  final String value;
  final String label;
}

enum TaskStatus {
  pending('pending', 'Pending'),
  inProgress('in_progress', 'In Progress'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const TaskStatus(this.value, this.label);

  final String value;
  final String label;
}
