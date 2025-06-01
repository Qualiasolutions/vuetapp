// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_completion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskCompletionFormRepositoryHash() =>
    r'9b5f27fe98f2fa4570c7b08a508e80c823021002';

/// Provider for task completion form repository
///
/// Copied from [taskCompletionFormRepository].
@ProviderFor(taskCompletionFormRepository)
final taskCompletionFormRepositoryProvider =
    AutoDisposeProvider<TaskCompletionFormRepository>.internal(
  taskCompletionFormRepository,
  name: r'taskCompletionFormRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskCompletionFormRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskCompletionFormRepositoryRef
    = AutoDisposeProviderRef<TaskCompletionFormRepository>;
String _$taskCompletionFormsHash() =>
    r'dace90cc6cfaa795692aa39138a0ce4df62bfa57';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for completion forms for a specific task
///
/// Copied from [taskCompletionForms].
@ProviderFor(taskCompletionForms)
const taskCompletionFormsProvider = TaskCompletionFormsFamily();

/// Provider for completion forms for a specific task
///
/// Copied from [taskCompletionForms].
class TaskCompletionFormsFamily
    extends Family<AsyncValue<List<TaskCompletionFormModel>>> {
  /// Provider for completion forms for a specific task
  ///
  /// Copied from [taskCompletionForms].
  const TaskCompletionFormsFamily();

  /// Provider for completion forms for a specific task
  ///
  /// Copied from [taskCompletionForms].
  TaskCompletionFormsProvider call(
    String taskId,
  ) {
    return TaskCompletionFormsProvider(
      taskId,
    );
  }

  @override
  TaskCompletionFormsProvider getProviderOverride(
    covariant TaskCompletionFormsProvider provider,
  ) {
    return call(
      provider.taskId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskCompletionFormsProvider';
}

/// Provider for completion forms for a specific task
///
/// Copied from [taskCompletionForms].
class TaskCompletionFormsProvider
    extends AutoDisposeFutureProvider<List<TaskCompletionFormModel>> {
  /// Provider for completion forms for a specific task
  ///
  /// Copied from [taskCompletionForms].
  TaskCompletionFormsProvider(
    String taskId,
  ) : this._internal(
          (ref) => taskCompletionForms(
            ref as TaskCompletionFormsRef,
            taskId,
          ),
          from: taskCompletionFormsProvider,
          name: r'taskCompletionFormsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskCompletionFormsHash,
          dependencies: TaskCompletionFormsFamily._dependencies,
          allTransitiveDependencies:
              TaskCompletionFormsFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  TaskCompletionFormsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  Override overrideWith(
    FutureOr<List<TaskCompletionFormModel>> Function(
            TaskCompletionFormsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskCompletionFormsProvider._internal(
        (ref) => create(ref as TaskCompletionFormsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskCompletionFormModel>>
      createElement() {
    return _TaskCompletionFormsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskCompletionFormsProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskCompletionFormsRef
    on AutoDisposeFutureProviderRef<List<TaskCompletionFormModel>> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskCompletionFormsProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskCompletionFormModel>>
    with TaskCompletionFormsRef {
  _TaskCompletionFormsProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskCompletionFormsProvider).taskId;
}

String _$completionFormByIdHash() =>
    r'531b4e525f59c216378721144397ae84233be15f';

/// Provider for a specific completion form by ID
///
/// Copied from [completionFormById].
@ProviderFor(completionFormById)
const completionFormByIdProvider = CompletionFormByIdFamily();

/// Provider for a specific completion form by ID
///
/// Copied from [completionFormById].
class CompletionFormByIdFamily
    extends Family<AsyncValue<TaskCompletionFormModel?>> {
  /// Provider for a specific completion form by ID
  ///
  /// Copied from [completionFormById].
  const CompletionFormByIdFamily();

  /// Provider for a specific completion form by ID
  ///
  /// Copied from [completionFormById].
  CompletionFormByIdProvider call(
    String id,
  ) {
    return CompletionFormByIdProvider(
      id,
    );
  }

  @override
  CompletionFormByIdProvider getProviderOverride(
    covariant CompletionFormByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'completionFormByIdProvider';
}

/// Provider for a specific completion form by ID
///
/// Copied from [completionFormById].
class CompletionFormByIdProvider
    extends AutoDisposeFutureProvider<TaskCompletionFormModel?> {
  /// Provider for a specific completion form by ID
  ///
  /// Copied from [completionFormById].
  CompletionFormByIdProvider(
    String id,
  ) : this._internal(
          (ref) => completionFormById(
            ref as CompletionFormByIdRef,
            id,
          ),
          from: completionFormByIdProvider,
          name: r'completionFormByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$completionFormByIdHash,
          dependencies: CompletionFormByIdFamily._dependencies,
          allTransitiveDependencies:
              CompletionFormByIdFamily._allTransitiveDependencies,
          id: id,
        );

  CompletionFormByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<TaskCompletionFormModel?> Function(CompletionFormByIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompletionFormByIdProvider._internal(
        (ref) => create(ref as CompletionFormByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskCompletionFormModel?> createElement() {
    return _CompletionFormByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletionFormByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompletionFormByIdRef
    on AutoDisposeFutureProviderRef<TaskCompletionFormModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CompletionFormByIdProviderElement
    extends AutoDisposeFutureProviderElement<TaskCompletionFormModel?>
    with CompletionFormByIdRef {
  _CompletionFormByIdProviderElement(super.provider);

  @override
  String get id => (origin as CompletionFormByIdProvider).id;
}

String _$taskOccurrenceCompletionHash() =>
    r'cbd5a1d3c587432115bf1f9228aa75739d8c603e';

/// Provider for completion form for a specific task occurrence
///
/// Copied from [taskOccurrenceCompletion].
@ProviderFor(taskOccurrenceCompletion)
const taskOccurrenceCompletionProvider = TaskOccurrenceCompletionFamily();

/// Provider for completion form for a specific task occurrence
///
/// Copied from [taskOccurrenceCompletion].
class TaskOccurrenceCompletionFamily
    extends Family<AsyncValue<TaskCompletionFormModel?>> {
  /// Provider for completion form for a specific task occurrence
  ///
  /// Copied from [taskOccurrenceCompletion].
  const TaskOccurrenceCompletionFamily();

  /// Provider for completion form for a specific task occurrence
  ///
  /// Copied from [taskOccurrenceCompletion].
  TaskOccurrenceCompletionProvider call(
    String taskId,
    int recurrenceIndex,
  ) {
    return TaskOccurrenceCompletionProvider(
      taskId,
      recurrenceIndex,
    );
  }

  @override
  TaskOccurrenceCompletionProvider getProviderOverride(
    covariant TaskOccurrenceCompletionProvider provider,
  ) {
    return call(
      provider.taskId,
      provider.recurrenceIndex,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskOccurrenceCompletionProvider';
}

/// Provider for completion form for a specific task occurrence
///
/// Copied from [taskOccurrenceCompletion].
class TaskOccurrenceCompletionProvider
    extends AutoDisposeFutureProvider<TaskCompletionFormModel?> {
  /// Provider for completion form for a specific task occurrence
  ///
  /// Copied from [taskOccurrenceCompletion].
  TaskOccurrenceCompletionProvider(
    String taskId,
    int recurrenceIndex,
  ) : this._internal(
          (ref) => taskOccurrenceCompletion(
            ref as TaskOccurrenceCompletionRef,
            taskId,
            recurrenceIndex,
          ),
          from: taskOccurrenceCompletionProvider,
          name: r'taskOccurrenceCompletionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskOccurrenceCompletionHash,
          dependencies: TaskOccurrenceCompletionFamily._dependencies,
          allTransitiveDependencies:
              TaskOccurrenceCompletionFamily._allTransitiveDependencies,
          taskId: taskId,
          recurrenceIndex: recurrenceIndex,
        );

  TaskOccurrenceCompletionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
    required this.recurrenceIndex,
  }) : super.internal();

  final String taskId;
  final int recurrenceIndex;

  @override
  Override overrideWith(
    FutureOr<TaskCompletionFormModel?> Function(
            TaskOccurrenceCompletionRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskOccurrenceCompletionProvider._internal(
        (ref) => create(ref as TaskOccurrenceCompletionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
        recurrenceIndex: recurrenceIndex,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskCompletionFormModel?> createElement() {
    return _TaskOccurrenceCompletionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskOccurrenceCompletionProvider &&
        other.taskId == taskId &&
        other.recurrenceIndex == recurrenceIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);
    hash = _SystemHash.combine(hash, recurrenceIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskOccurrenceCompletionRef
    on AutoDisposeFutureProviderRef<TaskCompletionFormModel?> {
  /// The parameter `taskId` of this provider.
  String get taskId;

  /// The parameter `recurrenceIndex` of this provider.
  int get recurrenceIndex;
}

class _TaskOccurrenceCompletionProviderElement
    extends AutoDisposeFutureProviderElement<TaskCompletionFormModel?>
    with TaskOccurrenceCompletionRef {
  _TaskOccurrenceCompletionProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskOccurrenceCompletionProvider).taskId;
  @override
  int get recurrenceIndex =>
      (origin as TaskOccurrenceCompletionProvider).recurrenceIndex;
}

String _$isTaskCompletedHash() => r'67422c4d24a6b669b7703bc34e65d51c73ffff9b';

/// Provider to check if a task is completed
///
/// Copied from [isTaskCompleted].
@ProviderFor(isTaskCompleted)
const isTaskCompletedProvider = IsTaskCompletedFamily();

/// Provider to check if a task is completed
///
/// Copied from [isTaskCompleted].
class IsTaskCompletedFamily extends Family<AsyncValue<bool>> {
  /// Provider to check if a task is completed
  ///
  /// Copied from [isTaskCompleted].
  const IsTaskCompletedFamily();

  /// Provider to check if a task is completed
  ///
  /// Copied from [isTaskCompleted].
  IsTaskCompletedProvider call(
    String taskId, {
    int? recurrenceIndex,
  }) {
    return IsTaskCompletedProvider(
      taskId,
      recurrenceIndex: recurrenceIndex,
    );
  }

  @override
  IsTaskCompletedProvider getProviderOverride(
    covariant IsTaskCompletedProvider provider,
  ) {
    return call(
      provider.taskId,
      recurrenceIndex: provider.recurrenceIndex,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isTaskCompletedProvider';
}

/// Provider to check if a task is completed
///
/// Copied from [isTaskCompleted].
class IsTaskCompletedProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider to check if a task is completed
  ///
  /// Copied from [isTaskCompleted].
  IsTaskCompletedProvider(
    String taskId, {
    int? recurrenceIndex,
  }) : this._internal(
          (ref) => isTaskCompleted(
            ref as IsTaskCompletedRef,
            taskId,
            recurrenceIndex: recurrenceIndex,
          ),
          from: isTaskCompletedProvider,
          name: r'isTaskCompletedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isTaskCompletedHash,
          dependencies: IsTaskCompletedFamily._dependencies,
          allTransitiveDependencies:
              IsTaskCompletedFamily._allTransitiveDependencies,
          taskId: taskId,
          recurrenceIndex: recurrenceIndex,
        );

  IsTaskCompletedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
    required this.recurrenceIndex,
  }) : super.internal();

  final String taskId;
  final int? recurrenceIndex;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsTaskCompletedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsTaskCompletedProvider._internal(
        (ref) => create(ref as IsTaskCompletedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
        recurrenceIndex: recurrenceIndex,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsTaskCompletedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsTaskCompletedProvider &&
        other.taskId == taskId &&
        other.recurrenceIndex == recurrenceIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);
    hash = _SystemHash.combine(hash, recurrenceIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsTaskCompletedRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `taskId` of this provider.
  String get taskId;

  /// The parameter `recurrenceIndex` of this provider.
  int? get recurrenceIndex;
}

class _IsTaskCompletedProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsTaskCompletedRef {
  _IsTaskCompletedProviderElement(super.provider);

  @override
  String get taskId => (origin as IsTaskCompletedProvider).taskId;
  @override
  int? get recurrenceIndex =>
      (origin as IsTaskCompletedProvider).recurrenceIndex;
}

String _$userCompletionFormsHash() =>
    r'928c0f1071574a065bf980ffefbf262d30945c46';

/// Provider for all user completion forms
///
/// Copied from [userCompletionForms].
@ProviderFor(userCompletionForms)
final userCompletionFormsProvider =
    AutoDisposeFutureProvider<List<TaskCompletionFormModel>>.internal(
  userCompletionForms,
  name: r'userCompletionFormsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userCompletionFormsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserCompletionFormsRef
    = AutoDisposeFutureProviderRef<List<TaskCompletionFormModel>>;
String _$completionStatisticsHash() =>
    r'313379df49ef307cd389fcd6fc83fff922e621e1';

/// Provider for completion statistics
///
/// Copied from [completionStatistics].
@ProviderFor(completionStatistics)
final completionStatisticsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  completionStatistics,
  name: r'completionStatisticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completionStatisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletionStatisticsRef
    = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$taskCompleterHash() => r'dd9cd22fcc6541804a06337b92c794f688d60436';

/// Provider for completing a task
///
/// Copied from [TaskCompleter].
@ProviderFor(TaskCompleter)
final taskCompleterProvider = AutoDisposeNotifierProvider<TaskCompleter,
    AsyncValue<TaskCompletionFormModel?>>.internal(
  TaskCompleter.new,
  name: r'taskCompleterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskCompleterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskCompleter
    = AutoDisposeNotifier<AsyncValue<TaskCompletionFormModel?>>;
String _$completionFormManagerHash() =>
    r'bf2c1b9424098ee538f7808b9c147ea77c3e1090';

/// Provider for managing completion form operations
///
/// Copied from [CompletionFormManager].
@ProviderFor(CompletionFormManager)
final completionFormManagerProvider = AutoDisposeNotifierProvider<
    CompletionFormManager, AsyncValue<TaskCompletionFormModel?>>.internal(
  CompletionFormManager.new,
  name: r'completionFormManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completionFormManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CompletionFormManager
    = AutoDisposeNotifier<AsyncValue<TaskCompletionFormModel?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
