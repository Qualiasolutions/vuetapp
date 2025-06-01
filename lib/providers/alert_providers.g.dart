// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$alertRepositoryHash() => r'afde56d0bcb4667493afd76887ebd222482d58c4';

/// Provider for alert repository
///
/// Copied from [alertRepository].
@ProviderFor(alertRepository)
final alertRepositoryProvider = AutoDisposeProvider<AlertRepository>.internal(
  alertRepository,
  name: r'alertRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$alertRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertRepositoryRef = AutoDisposeProviderRef<AlertRepository>;
String _$userAlertsHash() => r'3aac0175ed2468b822328180738cbcc5bd5e1461';

/// Provider for all user alerts
///
/// Copied from [userAlerts].
@ProviderFor(userAlerts)
final userAlertsProvider = AutoDisposeFutureProvider<List<AlertModel>>.internal(
  userAlerts,
  name: r'userAlertsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserAlertsRef = AutoDisposeFutureProviderRef<List<AlertModel>>;
String _$userActionAlertsHash() => r'f1832aa8a629d0afaf79e9c9d20c1ff44d58a661';

/// Provider for all user action alerts
///
/// Copied from [userActionAlerts].
@ProviderFor(userActionAlerts)
final userActionAlertsProvider =
    AutoDisposeFutureProvider<List<ActionAlertModel>>.internal(
  userActionAlerts,
  name: r'userActionAlertsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userActionAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserActionAlertsRef
    = AutoDisposeFutureProviderRef<List<ActionAlertModel>>;
String _$alertsDataHash() => r'054b343b35ec4593a6dda7d97dd2d8a2577aa0f8';

/// Provider for organized alerts data
///
/// Copied from [alertsData].
@ProviderFor(alertsData)
final alertsDataProvider = AutoDisposeFutureProvider<AlertsData>.internal(
  alertsData,
  name: r'alertsDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$alertsDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertsDataRef = AutoDisposeFutureProviderRef<AlertsData>;
String _$alertsForTaskHash() => r'95c58e4b9c46f96f6eb5ea3242ecca9a55760b84';

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

/// Provider for alerts for a specific task
///
/// Copied from [alertsForTask].
@ProviderFor(alertsForTask)
const alertsForTaskProvider = AlertsForTaskFamily();

/// Provider for alerts for a specific task
///
/// Copied from [alertsForTask].
class AlertsForTaskFamily extends Family<AsyncValue<List<AlertModel>>> {
  /// Provider for alerts for a specific task
  ///
  /// Copied from [alertsForTask].
  const AlertsForTaskFamily();

  /// Provider for alerts for a specific task
  ///
  /// Copied from [alertsForTask].
  AlertsForTaskProvider call(
    String taskId,
  ) {
    return AlertsForTaskProvider(
      taskId,
    );
  }

  @override
  AlertsForTaskProvider getProviderOverride(
    covariant AlertsForTaskProvider provider,
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
  String? get name => r'alertsForTaskProvider';
}

/// Provider for alerts for a specific task
///
/// Copied from [alertsForTask].
class AlertsForTaskProvider
    extends AutoDisposeFutureProvider<List<AlertModel>> {
  /// Provider for alerts for a specific task
  ///
  /// Copied from [alertsForTask].
  AlertsForTaskProvider(
    String taskId,
  ) : this._internal(
          (ref) => alertsForTask(
            ref as AlertsForTaskRef,
            taskId,
          ),
          from: alertsForTaskProvider,
          name: r'alertsForTaskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$alertsForTaskHash,
          dependencies: AlertsForTaskFamily._dependencies,
          allTransitiveDependencies:
              AlertsForTaskFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  AlertsForTaskProvider._internal(
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
    FutureOr<List<AlertModel>> Function(AlertsForTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlertsForTaskProvider._internal(
        (ref) => create(ref as AlertsForTaskRef),
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
  AutoDisposeFutureProviderElement<List<AlertModel>> createElement() {
    return _AlertsForTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlertsForTaskProvider && other.taskId == taskId;
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
mixin AlertsForTaskRef on AutoDisposeFutureProviderRef<List<AlertModel>> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _AlertsForTaskProviderElement
    extends AutoDisposeFutureProviderElement<List<AlertModel>>
    with AlertsForTaskRef {
  _AlertsForTaskProviderElement(super.provider);

  @override
  String get taskId => (origin as AlertsForTaskProvider).taskId;
}

String _$actionAlertsForActionHash() =>
    r'5638df4d67f6780e7a477032cfe8930b8a12eacc';

/// Provider for action alerts for a specific action
///
/// Copied from [actionAlertsForAction].
@ProviderFor(actionAlertsForAction)
const actionAlertsForActionProvider = ActionAlertsForActionFamily();

/// Provider for action alerts for a specific action
///
/// Copied from [actionAlertsForAction].
class ActionAlertsForActionFamily
    extends Family<AsyncValue<List<ActionAlertModel>>> {
  /// Provider for action alerts for a specific action
  ///
  /// Copied from [actionAlertsForAction].
  const ActionAlertsForActionFamily();

  /// Provider for action alerts for a specific action
  ///
  /// Copied from [actionAlertsForAction].
  ActionAlertsForActionProvider call(
    String actionId,
  ) {
    return ActionAlertsForActionProvider(
      actionId,
    );
  }

  @override
  ActionAlertsForActionProvider getProviderOverride(
    covariant ActionAlertsForActionProvider provider,
  ) {
    return call(
      provider.actionId,
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
  String? get name => r'actionAlertsForActionProvider';
}

/// Provider for action alerts for a specific action
///
/// Copied from [actionAlertsForAction].
class ActionAlertsForActionProvider
    extends AutoDisposeFutureProvider<List<ActionAlertModel>> {
  /// Provider for action alerts for a specific action
  ///
  /// Copied from [actionAlertsForAction].
  ActionAlertsForActionProvider(
    String actionId,
  ) : this._internal(
          (ref) => actionAlertsForAction(
            ref as ActionAlertsForActionRef,
            actionId,
          ),
          from: actionAlertsForActionProvider,
          name: r'actionAlertsForActionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$actionAlertsForActionHash,
          dependencies: ActionAlertsForActionFamily._dependencies,
          allTransitiveDependencies:
              ActionAlertsForActionFamily._allTransitiveDependencies,
          actionId: actionId,
        );

  ActionAlertsForActionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.actionId,
  }) : super.internal();

  final String actionId;

  @override
  Override overrideWith(
    FutureOr<List<ActionAlertModel>> Function(ActionAlertsForActionRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActionAlertsForActionProvider._internal(
        (ref) => create(ref as ActionAlertsForActionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        actionId: actionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ActionAlertModel>> createElement() {
    return _ActionAlertsForActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActionAlertsForActionProvider && other.actionId == actionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, actionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActionAlertsForActionRef
    on AutoDisposeFutureProviderRef<List<ActionAlertModel>> {
  /// The parameter `actionId` of this provider.
  String get actionId;
}

class _ActionAlertsForActionProviderElement
    extends AutoDisposeFutureProviderElement<List<ActionAlertModel>>
    with ActionAlertsForActionRef {
  _ActionAlertsForActionProviderElement(super.provider);

  @override
  String get actionId => (origin as ActionAlertsForActionProvider).actionId;
}

String _$hasUnreadAlertsHash() => r'3e1cd957d3a298d1c6146a81a7589e61911e3653';

/// Provider to check if user has unread alerts
///
/// Copied from [hasUnreadAlerts].
@ProviderFor(hasUnreadAlerts)
final hasUnreadAlertsProvider = AutoDisposeFutureProvider<bool>.internal(
  hasUnreadAlerts,
  name: r'hasUnreadAlertsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasUnreadAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasUnreadAlertsRef = AutoDisposeFutureProviderRef<bool>;
String _$unreadAlertCountHash() => r'bffa4d03a752aafef9e31e1ad1648e9c12a2d42b';

/// Provider for unread alert count
///
/// Copied from [unreadAlertCount].
@ProviderFor(unreadAlertCount)
final unreadAlertCountProvider = AutoDisposeFutureProvider<int>.internal(
  unreadAlertCount,
  name: r'unreadAlertCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadAlertCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadAlertCountRef = AutoDisposeFutureProviderRef<int>;
String _$alertsStreamHash() => r'54e3e290ae8b0025b4f7efc9401eb675d2638f44';

/// Provider to watch for alert changes and auto-refresh
///
/// Copied from [alertsStream].
@ProviderFor(alertsStream)
final alertsStreamProvider = AutoDisposeStreamProvider<AlertsData>.internal(
  alertsStream,
  name: r'alertsStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$alertsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertsStreamRef = AutoDisposeStreamProviderRef<AlertsData>;
String _$alertManagerHash() => r'405ac34bb7fe9466a966f99b6c81cc394ced8fc6';

/// Provider for managing alert operations
///
/// Copied from [AlertManager].
@ProviderFor(AlertManager)
final alertManagerProvider =
    AutoDisposeNotifierProvider<AlertManager, AsyncValue<AlertModel?>>.internal(
  AlertManager.new,
  name: r'alertManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$alertManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AlertManager = AutoDisposeNotifier<AsyncValue<AlertModel?>>;
String _$actionAlertManagerHash() =>
    r'd72bbf7062ca81d04925b70a37fc5cc95dd6934d';

/// Provider for managing action alert operations
///
/// Copied from [ActionAlertManager].
@ProviderFor(ActionAlertManager)
final actionAlertManagerProvider = AutoDisposeNotifierProvider<
    ActionAlertManager, AsyncValue<ActionAlertModel?>>.internal(
  ActionAlertManager.new,
  name: r'actionAlertManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$actionAlertManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActionAlertManager
    = AutoDisposeNotifier<AsyncValue<ActionAlertModel?>>;
String _$globalAlertManagerHash() =>
    r'd8767c55032da72ebfa81820f0632695d8fd3b8c';

/// Provider for global alert operations
///
/// Copied from [GlobalAlertManager].
@ProviderFor(GlobalAlertManager)
final globalAlertManagerProvider =
    AutoDisposeNotifierProvider<GlobalAlertManager, AsyncValue<bool>>.internal(
  GlobalAlertManager.new,
  name: r'globalAlertManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalAlertManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalAlertManager = AutoDisposeNotifier<AsyncValue<bool>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
