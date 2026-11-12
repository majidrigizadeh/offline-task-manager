// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskQuery {

/// Case-insensitive substring match on the title. Empty = no filter.
 String get search;/// `null` = any priority.
 TaskPriority? get priority; CompletionFilter get completion;
/// Create a copy of TaskQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskQueryCopyWith<TaskQuery> get copyWith => _$TaskQueryCopyWithImpl<TaskQuery>(this as TaskQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskQuery&&(identical(other.search, _this.search) || other.search == _this.search)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.completion, _this.completion) || other.completion == _this.completion));
}


@override
int get hashCode {
  final _this = this as TaskQuery;
  return Object.hash(runtimeType,_this.search,_this.priority,_this.completion);
}

@override
String toString() {
  final _this = this as TaskQuery;
  return 'TaskQuery(search: ${_this.search}, priority: ${_this.priority}, completion: ${_this.completion})';
}


}

/// @nodoc
abstract mixin class $TaskQueryCopyWith<$Res>  {
  factory $TaskQueryCopyWith(TaskQuery value, $Res Function(TaskQuery) _then) = _$TaskQueryCopyWithImpl;
@useResult
$Res call({
 String search, TaskPriority? priority, CompletionFilter completion
});




}
/// @nodoc
class _$TaskQueryCopyWithImpl<$Res>
    implements $TaskQueryCopyWith<$Res> {
  _$TaskQueryCopyWithImpl(this._self, this._then);

  final TaskQuery _self;
  final $Res Function(TaskQuery) _then;

/// Create a copy of TaskQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? priority = freezed,Object? completion = null,}) {
  return _then(TaskQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,completion: null == completion ? _self.completion : completion // ignore: cast_nullable_to_non_nullable
as CompletionFilter,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskQuery].
extension TaskQueryPatterns on TaskQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskQuery value)  $default,){
final _that = this;
switch (_that) {
case _TaskQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskQuery value)?  $default,){
final _that = this;
switch (_that) {
case _TaskQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  TaskPriority? priority,  CompletionFilter completion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskQuery() when $default != null:
return $default(_that.search,_that.priority,_that.completion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  TaskPriority? priority,  CompletionFilter completion)  $default,) {final _that = this;
switch (_that) {
case _TaskQuery():
return $default(_that.search,_that.priority,_that.completion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  TaskPriority? priority,  CompletionFilter completion)?  $default,) {final _that = this;
switch (_that) {
case _TaskQuery() when $default != null:
return $default(_that.search,_that.priority,_that.completion);case _:
  return null;

}
}

}

/// @nodoc


class _TaskQuery implements TaskQuery {
  const _TaskQuery({this.search = '', this.priority, this.completion = CompletionFilter.all});
  

/// Case-insensitive substring match on the title. Empty = no filter.
@override@JsonKey() final  String search;
/// `null` = any priority.
@override final  TaskPriority? priority;
@override@JsonKey() final  CompletionFilter completion;

/// Create a copy of TaskQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskQueryCopyWith<_TaskQuery> get copyWith => __$TaskQueryCopyWithImpl<_TaskQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.completion, completion) || other.completion == completion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,search,priority,completion);
}

@override
String toString() {
    return 'TaskQuery(search: $search, priority: $priority, completion: $completion)';
}


}

/// @nodoc
abstract mixin class _$TaskQueryCopyWith<$Res> implements $TaskQueryCopyWith<$Res> {
  factory _$TaskQueryCopyWith(_TaskQuery value, $Res Function(_TaskQuery) _then) = __$TaskQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, TaskPriority? priority, CompletionFilter completion
});




}
/// @nodoc
class __$TaskQueryCopyWithImpl<$Res>
    implements _$TaskQueryCopyWith<$Res> {
  __$TaskQueryCopyWithImpl(this._self, this._then);

  final _TaskQuery _self;
  final $Res Function(_TaskQuery) _then;

/// Create a copy of TaskQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? priority = freezed,Object? completion = null,}) {
  return _then(_TaskQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,completion: null == completion ? _self.completion : completion // ignore: cast_nullable_to_non_nullable
as CompletionFilter,
  ));
}


}

// dart format on
