// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_terms_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolYearModelImpl _$$SchoolYearModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SchoolYearModelImpl(
      id: json['id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      schoolId: json['school_id'] as String,
      year: json['year'] as String,
      showOnCalendars: json['show_on_calendars'] as bool? ?? false,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SchoolYearModelImplToJson(
        _$SchoolYearModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'school_id': instance.schoolId,
      'year': instance.year,
      'show_on_calendars': instance.showOnCalendars,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$SchoolTermModelImpl _$$SchoolTermModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SchoolTermModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      schoolYearId: json['school_year_id'] as String,
      showOnCalendars: json['show_on_calendars'] as bool? ?? false,
      showOnlyStartAndEnd: json['show_only_start_and_end'] as bool? ?? true,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SchoolTermModelImplToJson(
        _$SchoolTermModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'school_year_id': instance.schoolYearId,
      'show_on_calendars': instance.showOnCalendars,
      'show_only_start_and_end': instance.showOnlyStartAndEnd,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$SchoolBreakModelImpl _$$SchoolBreakModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SchoolBreakModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      schoolYearId: json['school_year_id'] as String,
      showOnCalendars: json['show_on_calendars'] as bool? ?? false,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SchoolBreakModelImplToJson(
        _$SchoolBreakModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'school_year_id': instance.schoolYearId,
      'show_on_calendars': instance.showOnCalendars,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$SchoolTermsDataImpl _$$SchoolTermsDataImplFromJson(
        Map<String, dynamic> json) =>
    _$SchoolTermsDataImpl(
      schoolYearsById: (json['schoolYearsById'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, SchoolYearModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      termsByYearId: (json['termsByYearId'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) =>
                        SchoolTermModel.fromJson(e as Map<String, dynamic>))
                    .toList()),
          ) ??
          const {},
      breaksByYearId: (json['breaksByYearId'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) =>
                        SchoolBreakModel.fromJson(e as Map<String, dynamic>))
                    .toList()),
          ) ??
          const {},
      termsById: (json['termsById'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, SchoolTermModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      breaksById: (json['breaksById'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, SchoolBreakModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$SchoolTermsDataImplToJson(
        _$SchoolTermsDataImpl instance) =>
    <String, dynamic>{
      'schoolYearsById': instance.schoolYearsById,
      'termsByYearId': instance.termsByYearId,
      'breaksByYearId': instance.breaksByYearId,
      'termsById': instance.termsById,
      'breaksById': instance.breaksById,
    };
