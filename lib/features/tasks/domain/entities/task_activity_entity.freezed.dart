// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_activity_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskActivityEntity {

 String get id; String get taskId; ActivityType get type;/// For [ActivityType.priorityChanged]: the previous `TaskPriority.name`.
 String? get oldValue;/// For [ActivityType.priorityChanged]: the new `TaskPriority.name`.
 String? get newValue; DateTime get createdAt;
/// Create a copy of TaskActivityEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskActivityEntityCopyWith<TaskActivityEntity> get copyWith => _$TaskActivityEntityCopyWithImpl<TaskActivityEntity>(this as TaskActivityEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskActivityEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskActivityEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.taskId, _this.taskId) || other.taskId == _this.taskId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.oldValue, _this.oldValue) || other.oldValue == _this.oldValue)&&(identical(other.newValue, _this.newValue) || other.newValue == _this.newValue)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as TaskActivityEntity;
  return Object.hash(runtimeType,_this.id,_this.taskId,_this.type,_this.oldValue,_this.newValue,_this.createdAt);
}

@override
String toString() {
  final _this = this as TaskActivityEntity;
  return 'TaskActivityEntity(id: ${_this.id}, taskId: ${_this.taskId}, type: ${_this.type}, oldValue: ${_this.oldValue}, newValue: ${_this.newValue}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $TaskActivityEntityCopyWith<$Res>  {
  factory $TaskActivityEntityCopyWith(TaskActivityEntity value, $Res Function(TaskActivityEntity) _then) = _$TaskActivityEntityCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, ActivityType type, String? oldValue, String? newValue, DateTime createdAt
});




}
/// @nodoc
class _$TaskActivityEntityCopyWithImpl<$Res>
    implements $TaskActivityEntityCopyWith<$Res> {
  _$TaskActivityEntityCopyWithImpl(this._self, this._then);

  final TaskActivityEntity _self;
  final $Res Function(TaskActivityEntity) _then;

/// Create a copy of TaskActivityEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? type = null,Object? oldValue = freezed,Object? newValue = freezed,Object? createdAt = null,}) {
  return _then(TaskActivityEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,oldValue: freezed == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as String?,newValue: freezed == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskActivityEntity].
extension TaskActivityEntityPatterns on TaskActivityEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskActivityEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskActivityEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskActivityEntity value)  $default,){
final _that = this;
switch (_that) {
case _TaskActivityEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskActivityEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TaskActivityEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  ActivityType type,  String? oldValue,  String? newValue,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskActivityEntity() when $default != null:
return $default(_that.id,_that.taskId,_that.type,_that.oldValue,_that.newValue,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  ActivityType type,  String? oldValue,  String? newValue,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TaskActivityEntity():
return $default(_that.id,_that.taskId,_that.type,_that.oldValue,_that.newValue,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  ActivityType type,  String? oldValue,  String? newValue,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskActivityEntity() when $default != null:
return $default(_that.id,_that.taskId,_that.type,_that.oldValue,_that.newValue,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TaskActivityEntity implements TaskActivityEntity {
  const _TaskActivityEntity({required this.id, required this.taskId, required this.type, this.oldValue, this.newValue, required this.createdAt});
  

@override final  String id;
@override final  String taskId;
@override final  ActivityType type;
/// For [ActivityType.priorityChanged]: the previous `TaskPriority.name`.
@override final  String? oldValue;
/// For [ActivityType.priorityChanged]: the new `TaskPriority.name`.
@override final  String? newValue;
@override final  DateTime createdAt;

/// Create a copy of TaskActivityEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskActivityEntityCopyWith<_TaskActivityEntity> get copyWith => __$TaskActivityEntityCopyWithImpl<_TaskActivityEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskActivityEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.oldValue, oldValue) || other.oldValue == oldValue)&&(identical(other.newValue, newValue) || other.newValue == newValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,taskId,type,oldValue,newValue,createdAt);
}

@override
String toString() {
    return 'TaskActivityEntity(id: $id, taskId: $taskId, type: $type, oldValue: $oldValue, newValue: $newValue, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TaskActivityEntityCopyWith<$Res> implements $TaskActivityEntityCopyWith<$Res> {
  factory _$TaskActivityEntityCopyWith(_TaskActivityEntity value, $Res Function(_TaskActivityEntity) _then) = __$TaskActivityEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, ActivityType type, String? oldValue, String? newValue, DateTime createdAt
});




}
/// @nodoc
class __$TaskActivityEntityCopyWithImpl<$Res>
    implements _$TaskActivityEntityCopyWith<$Res> {
  __$TaskActivityEntityCopyWithImpl(this._self, this._then);

  final _TaskActivityEntity _self;
  final $Res Function(_TaskActivityEntity) _then;

/// Create a copy of TaskActivityEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? type = null,Object? oldValue = freezed,Object? newValue = freezed,Object? createdAt = null,}) {
  return _then(_TaskActivityEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,oldValue: freezed == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as String?,newValue: freezed == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
