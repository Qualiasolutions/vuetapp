// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_interests_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return _Contact.fromJson(json);
}

/// @nodoc
mixin _$Contact {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  DateTime? get birthday => throw _privateConstructorUsedError;
  String? get relationship =>
      throw _privateConstructorUsedError; // Friend, Family, Colleague, Acquaintance, etc.
  String? get company => throw _privateConstructorUsedError;
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Contact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? email,
      String? address,
      DateTime? birthday,
      String? relationship,
      String? company,
      String? jobTitle,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res, $Val extends Contact>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? birthday = freezed,
    Object? relationship = freezed,
    Object? company = freezed,
    Object? jobTitle = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? email,
      String? address,
      DateTime? birthday,
      String? relationship,
      String? company,
      String? jobTitle,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$ContactImplCopyWithImpl<$Res>
    extends _$ContactCopyWithImpl<$Res, _$ContactImpl>
    implements _$$ContactImplCopyWith<$Res> {
  __$$ContactImplCopyWithImpl(
      _$ContactImpl _value, $Res Function(_$ContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? birthday = freezed,
    Object? relationship = freezed,
    Object? company = freezed,
    Object? jobTitle = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$ContactImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactImpl implements _Contact {
  const _$ContactImpl(
      {this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.birthday,
      this.relationship,
      this.company,
      this.jobTitle,
      this.notes,
      this.resourceType = 'Contact'});

  factory _$ContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final DateTime? birthday;
  @override
  final String? relationship;
// Friend, Family, Colleague, Acquaintance, etc.
  @override
  final String? company;
  @override
  final String? jobTitle;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phone: $phone, email: $email, address: $address, birthday: $birthday, relationship: $relationship, company: $company, jobTitle: $jobTitle, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone, email, address,
      birthday, relationship, company, jobTitle, notes, resourceType);

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      __$$ContactImplCopyWithImpl<_$ContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactImplToJson(
      this,
    );
  }
}

abstract class _Contact implements Contact {
  const factory _Contact(
      {final int? id,
      required final String name,
      final String? phone,
      final String? email,
      final String? address,
      final DateTime? birthday,
      final String? relationship,
      final String? company,
      final String? jobTitle,
      final String? notes,
      final String resourceType}) = _$ContactImpl;

  factory _Contact.fromJson(Map<String, dynamic> json) = _$ContactImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  DateTime? get birthday;
  @override
  String? get relationship; // Friend, Family, Colleague, Acquaintance, etc.
  @override
  String? get company;
  @override
  String? get jobTitle;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get eventType =>
      throw _privateConstructorUsedError; // Party, Meeting, Conference, Wedding, etc.
  DateTime get date => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get organizer => throw _privateConstructorUsedError;
  String? get attendees => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String eventType,
      DateTime date,
      String? time,
      String? location,
      String? organizer,
      String? attendees,
      String? description,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? eventType = null,
    Object? date = null,
    Object? time = freezed,
    Object? location = freezed,
    Object? organizer = freezed,
    Object? attendees = freezed,
    Object? description = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String?,
      attendees: freezed == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String eventType,
      DateTime date,
      String? time,
      String? location,
      String? organizer,
      String? attendees,
      String? description,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? eventType = null,
    Object? date = null,
    Object? time = freezed,
    Object? location = freezed,
    Object? organizer = freezed,
    Object? attendees = freezed,
    Object? description = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$EventImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String?,
      attendees: freezed == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl(
      {this.id,
      required this.name,
      required this.eventType,
      required this.date,
      this.time,
      this.location,
      this.organizer,
      this.attendees,
      this.description,
      this.notes,
      this.resourceType = 'Event'});

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String eventType;
// Party, Meeting, Conference, Wedding, etc.
  @override
  final DateTime date;
  @override
  final String? time;
  @override
  final String? location;
  @override
  final String? organizer;
  @override
  final String? attendees;
  @override
  final String? description;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Event(id: $id, name: $name, eventType: $eventType, date: $date, time: $time, location: $location, organizer: $organizer, attendees: $attendees, description: $description, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            (identical(other.attendees, attendees) ||
                other.attendees == attendees) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, eventType, date, time,
      location, organizer, attendees, description, notes, resourceType);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {final int? id,
      required final String name,
      required final String eventType,
      required final DateTime date,
      final String? time,
      final String? location,
      final String? organizer,
      final String? attendees,
      final String? description,
      final String? notes,
      final String resourceType}) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get eventType; // Party, Meeting, Conference, Wedding, etc.
  @override
  DateTime get date;
  @override
  String? get time;
  @override
  String? get location;
  @override
  String? get organizer;
  @override
  String? get attendees;
  @override
  String? get description;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get groupType =>
      throw _privateConstructorUsedError; // Club, Society, Team, Organization, etc.
  String? get description => throw _privateConstructorUsedError;
  String? get meetingFrequency =>
      throw _privateConstructorUsedError; // Weekly, Monthly, Quarterly, etc.
  String? get meetingLocation => throw _privateConstructorUsedError;
  String? get contactPerson => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String groupType,
      String? description,
      String? meetingFrequency,
      String? meetingLocation,
      String? contactPerson,
      String? contactPhone,
      String? contactEmail,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? groupType = null,
    Object? description = freezed,
    Object? meetingFrequency = freezed,
    Object? meetingLocation = freezed,
    Object? contactPerson = freezed,
    Object? contactPhone = freezed,
    Object? contactEmail = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      groupType: null == groupType
          ? _value.groupType
          : groupType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      meetingFrequency: freezed == meetingFrequency
          ? _value.meetingFrequency
          : meetingFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      meetingLocation: freezed == meetingLocation
          ? _value.meetingLocation
          : meetingLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupImplCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$GroupImplCopyWith(
          _$GroupImpl value, $Res Function(_$GroupImpl) then) =
      __$$GroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String groupType,
      String? description,
      String? meetingFrequency,
      String? meetingLocation,
      String? contactPerson,
      String? contactPhone,
      String? contactEmail,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$GroupImplCopyWithImpl<$Res>
    extends _$GroupCopyWithImpl<$Res, _$GroupImpl>
    implements _$$GroupImplCopyWith<$Res> {
  __$$GroupImplCopyWithImpl(
      _$GroupImpl _value, $Res Function(_$GroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? groupType = null,
    Object? description = freezed,
    Object? meetingFrequency = freezed,
    Object? meetingLocation = freezed,
    Object? contactPerson = freezed,
    Object? contactPhone = freezed,
    Object? contactEmail = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$GroupImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      groupType: null == groupType
          ? _value.groupType
          : groupType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      meetingFrequency: freezed == meetingFrequency
          ? _value.meetingFrequency
          : meetingFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      meetingLocation: freezed == meetingLocation
          ? _value.meetingLocation
          : meetingLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupImpl implements _Group {
  const _$GroupImpl(
      {this.id,
      required this.name,
      required this.groupType,
      this.description,
      this.meetingFrequency,
      this.meetingLocation,
      this.contactPerson,
      this.contactPhone,
      this.contactEmail,
      this.notes,
      this.resourceType = 'Group'});

  factory _$GroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String groupType;
// Club, Society, Team, Organization, etc.
  @override
  final String? description;
  @override
  final String? meetingFrequency;
// Weekly, Monthly, Quarterly, etc.
  @override
  final String? meetingLocation;
  @override
  final String? contactPerson;
  @override
  final String? contactPhone;
  @override
  final String? contactEmail;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Group(id: $id, name: $name, groupType: $groupType, description: $description, meetingFrequency: $meetingFrequency, meetingLocation: $meetingLocation, contactPerson: $contactPerson, contactPhone: $contactPhone, contactEmail: $contactEmail, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.groupType, groupType) ||
                other.groupType == groupType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.meetingFrequency, meetingFrequency) ||
                other.meetingFrequency == meetingFrequency) &&
            (identical(other.meetingLocation, meetingLocation) ||
                other.meetingLocation == meetingLocation) &&
            (identical(other.contactPerson, contactPerson) ||
                other.contactPerson == contactPerson) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      groupType,
      description,
      meetingFrequency,
      meetingLocation,
      contactPerson,
      contactPhone,
      contactEmail,
      notes,
      resourceType);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      __$$GroupImplCopyWithImpl<_$GroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupImplToJson(
      this,
    );
  }
}

abstract class _Group implements Group {
  const factory _Group(
      {final int? id,
      required final String name,
      required final String groupType,
      final String? description,
      final String? meetingFrequency,
      final String? meetingLocation,
      final String? contactPerson,
      final String? contactPhone,
      final String? contactEmail,
      final String? notes,
      final String resourceType}) = _$GroupImpl;

  factory _Group.fromJson(Map<String, dynamic> json) = _$GroupImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get groupType; // Club, Society, Team, Organization, etc.
  @override
  String? get description;
  @override
  String? get meetingFrequency; // Weekly, Monthly, Quarterly, etc.
  @override
  String? get meetingLocation;
  @override
  String? get contactPerson;
  @override
  String? get contactPhone;
  @override
  String? get contactEmail;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialActivity _$SocialActivityFromJson(Map<String, dynamic> json) {
  return _SocialActivity.fromJson(json);
}

/// @nodoc
mixin _$SocialActivity {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get activityType =>
      throw _privateConstructorUsedError; // Hobby, Sport, Interest, etc.
  String? get description => throw _privateConstructorUsedError;
  String? get frequency =>
      throw _privateConstructorUsedError; // Daily, Weekly, Monthly, etc.
  String? get location => throw _privateConstructorUsedError;
  String? get equipment => throw _privateConstructorUsedError;
  double? get cost => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this SocialActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialActivityCopyWith<SocialActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialActivityCopyWith<$Res> {
  factory $SocialActivityCopyWith(
          SocialActivity value, $Res Function(SocialActivity) then) =
      _$SocialActivityCopyWithImpl<$Res, SocialActivity>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String activityType,
      String? description,
      String? frequency,
      String? location,
      String? equipment,
      double? cost,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$SocialActivityCopyWithImpl<$Res, $Val extends SocialActivity>
    implements $SocialActivityCopyWith<$Res> {
  _$SocialActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? activityType = null,
    Object? description = freezed,
    Object? frequency = freezed,
    Object? location = freezed,
    Object? equipment = freezed,
    Object? cost = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: freezed == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String?,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialActivityImplCopyWith<$Res>
    implements $SocialActivityCopyWith<$Res> {
  factory _$$SocialActivityImplCopyWith(_$SocialActivityImpl value,
          $Res Function(_$SocialActivityImpl) then) =
      __$$SocialActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String activityType,
      String? description,
      String? frequency,
      String? location,
      String? equipment,
      double? cost,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$SocialActivityImplCopyWithImpl<$Res>
    extends _$SocialActivityCopyWithImpl<$Res, _$SocialActivityImpl>
    implements _$$SocialActivityImplCopyWith<$Res> {
  __$$SocialActivityImplCopyWithImpl(
      _$SocialActivityImpl _value, $Res Function(_$SocialActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? activityType = null,
    Object? description = freezed,
    Object? frequency = freezed,
    Object? location = freezed,
    Object? equipment = freezed,
    Object? cost = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$SocialActivityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: freezed == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String?,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialActivityImpl implements _SocialActivity {
  const _$SocialActivityImpl(
      {this.id,
      required this.name,
      required this.activityType,
      this.description,
      this.frequency,
      this.location,
      this.equipment,
      this.cost,
      this.notes,
      this.resourceType = 'SocialActivity'});

  factory _$SocialActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialActivityImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String activityType;
// Hobby, Sport, Interest, etc.
  @override
  final String? description;
  @override
  final String? frequency;
// Daily, Weekly, Monthly, etc.
  @override
  final String? location;
  @override
  final String? equipment;
  @override
  final double? cost;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'SocialActivity(id: $id, name: $name, activityType: $activityType, description: $description, frequency: $frequency, location: $location, equipment: $equipment, cost: $cost, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, activityType,
      description, frequency, location, equipment, cost, notes, resourceType);

  /// Create a copy of SocialActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialActivityImplCopyWith<_$SocialActivityImpl> get copyWith =>
      __$$SocialActivityImplCopyWithImpl<_$SocialActivityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialActivityImplToJson(
      this,
    );
  }
}

abstract class _SocialActivity implements SocialActivity {
  const factory _SocialActivity(
      {final int? id,
      required final String name,
      required final String activityType,
      final String? description,
      final String? frequency,
      final String? location,
      final String? equipment,
      final double? cost,
      final String? notes,
      final String resourceType}) = _$SocialActivityImpl;

  factory _SocialActivity.fromJson(Map<String, dynamic> json) =
      _$SocialActivityImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get activityType; // Hobby, Sport, Interest, etc.
  @override
  String? get description;
  @override
  String? get frequency; // Daily, Weekly, Monthly, etc.
  @override
  String? get location;
  @override
  String? get equipment;
  @override
  double? get cost;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of SocialActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialActivityImplCopyWith<_$SocialActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialGathering _$SocialGatheringFromJson(Map<String, dynamic> json) {
  return _SocialGathering.fromJson(json);
}

/// @nodoc
mixin _$SocialGathering {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get gatheringType =>
      throw _privateConstructorUsedError; // Dinner, Party, Meetup, etc.
  DateTime get dateTime => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get hostName => throw _privateConstructorUsedError;
  int? get expectedAttendees => throw _privateConstructorUsedError;
  String? get theme => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this SocialGathering to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialGathering
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialGatheringCopyWith<SocialGathering> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialGatheringCopyWith<$Res> {
  factory $SocialGatheringCopyWith(
          SocialGathering value, $Res Function(SocialGathering) then) =
      _$SocialGatheringCopyWithImpl<$Res, SocialGathering>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String gatheringType,
      DateTime dateTime,
      String? location,
      String? hostName,
      int? expectedAttendees,
      String? theme,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$SocialGatheringCopyWithImpl<$Res, $Val extends SocialGathering>
    implements $SocialGatheringCopyWith<$Res> {
  _$SocialGatheringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialGathering
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? gatheringType = null,
    Object? dateTime = null,
    Object? location = freezed,
    Object? hostName = freezed,
    Object? expectedAttendees = freezed,
    Object? theme = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gatheringType: null == gatheringType
          ? _value.gatheringType
          : gatheringType // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      hostName: freezed == hostName
          ? _value.hostName
          : hostName // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedAttendees: freezed == expectedAttendees
          ? _value.expectedAttendees
          : expectedAttendees // ignore: cast_nullable_to_non_nullable
              as int?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialGatheringImplCopyWith<$Res>
    implements $SocialGatheringCopyWith<$Res> {
  factory _$$SocialGatheringImplCopyWith(_$SocialGatheringImpl value,
          $Res Function(_$SocialGatheringImpl) then) =
      __$$SocialGatheringImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String gatheringType,
      DateTime dateTime,
      String? location,
      String? hostName,
      int? expectedAttendees,
      String? theme,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$SocialGatheringImplCopyWithImpl<$Res>
    extends _$SocialGatheringCopyWithImpl<$Res, _$SocialGatheringImpl>
    implements _$$SocialGatheringImplCopyWith<$Res> {
  __$$SocialGatheringImplCopyWithImpl(
      _$SocialGatheringImpl _value, $Res Function(_$SocialGatheringImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialGathering
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? gatheringType = null,
    Object? dateTime = null,
    Object? location = freezed,
    Object? hostName = freezed,
    Object? expectedAttendees = freezed,
    Object? theme = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$SocialGatheringImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gatheringType: null == gatheringType
          ? _value.gatheringType
          : gatheringType // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      hostName: freezed == hostName
          ? _value.hostName
          : hostName // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedAttendees: freezed == expectedAttendees
          ? _value.expectedAttendees
          : expectedAttendees // ignore: cast_nullable_to_non_nullable
              as int?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialGatheringImpl implements _SocialGathering {
  const _$SocialGatheringImpl(
      {this.id,
      required this.name,
      required this.gatheringType,
      required this.dateTime,
      this.location,
      this.hostName,
      this.expectedAttendees,
      this.theme,
      this.notes,
      this.resourceType = 'SocialGathering'});

  factory _$SocialGatheringImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialGatheringImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String gatheringType;
// Dinner, Party, Meetup, etc.
  @override
  final DateTime dateTime;
  @override
  final String? location;
  @override
  final String? hostName;
  @override
  final int? expectedAttendees;
  @override
  final String? theme;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'SocialGathering(id: $id, name: $name, gatheringType: $gatheringType, dateTime: $dateTime, location: $location, hostName: $hostName, expectedAttendees: $expectedAttendees, theme: $theme, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialGatheringImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gatheringType, gatheringType) ||
                other.gatheringType == gatheringType) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.hostName, hostName) ||
                other.hostName == hostName) &&
            (identical(other.expectedAttendees, expectedAttendees) ||
                other.expectedAttendees == expectedAttendees) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      gatheringType,
      dateTime,
      location,
      hostName,
      expectedAttendees,
      theme,
      notes,
      resourceType);

  /// Create a copy of SocialGathering
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialGatheringImplCopyWith<_$SocialGatheringImpl> get copyWith =>
      __$$SocialGatheringImplCopyWithImpl<_$SocialGatheringImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialGatheringImplToJson(
      this,
    );
  }
}

abstract class _SocialGathering implements SocialGathering {
  const factory _SocialGathering(
      {final int? id,
      required final String name,
      required final String gatheringType,
      required final DateTime dateTime,
      final String? location,
      final String? hostName,
      final int? expectedAttendees,
      final String? theme,
      final String? notes,
      final String resourceType}) = _$SocialGatheringImpl;

  factory _SocialGathering.fromJson(Map<String, dynamic> json) =
      _$SocialGatheringImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get gatheringType; // Dinner, Party, Meetup, etc.
  @override
  DateTime get dateTime;
  @override
  String? get location;
  @override
  String? get hostName;
  @override
  int? get expectedAttendees;
  @override
  String? get theme;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of SocialGathering
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialGatheringImplCopyWith<_$SocialGatheringImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
