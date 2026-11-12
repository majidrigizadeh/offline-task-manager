// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskActionError {

 String get message; int get occurrence;
/// Create a copy of TaskActionError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskActionErrorCopyWith<TaskActionError> get copyWith => _$TaskActionErrorCopyWithImpl<TaskActionError>(this as TaskActionError, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskActionError;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskActionError&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.occurrence, _this.occurrence) || other.occurrence == _this.occurrence));
}


@override
int get hashCode {
  final _this = this as TaskActionError;
  return Object.hash(runtimeType,_this.message,_this.occurrence);
}

@override
String toString() {
  final _this = this as TaskActionError;
  return 'TaskActionError(message: ${_this.message}, occurrence: ${_this.occurrence})';
}


}

/// @nodoc
abstract mixin class $TaskActionErrorCopyWith<$Res>  {
  factory $TaskActionErrorCopyWith(TaskActionError value, $Res Function(TaskActionError) _then) = _$TaskActionErrorCopyWithImpl;
@useResult
$Res call({
 String message, int occurrence
});




}
/// @nodoc
class _$TaskActionErrorCopyWithImpl<$Res>
    implements $TaskActionErrorCopyWith<$Res> {
  _$TaskActionErrorCopyWithImpl(this._self, this._then);

  final TaskActionError _self;
  final $Res Function(TaskActionError) _then;

/// Create a copy of TaskActionError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? occurrence = null,}) {
  return _then(TaskActionError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,occurrence: null == occurrence ? _self.occurrence : occurrence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskActionError].
extension TaskActionErrorPatterns on TaskActionError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskActionError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskActionError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskActionError value)  $default,){
final _that = this;
switch (_that) {
case _TaskActionError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskActionError value)?  $default,){
final _that = this;
switch (_that) {
case _TaskActionError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  int occurrence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskActionError() when $default != null:
return $default(_that.message,_that.occurrence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  int occurrence)  $default,) {final _that = this;
switch (_that) {
case _TaskActionError():
return $default(_that.message,_that.occurrence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  int occurrence)?  $default,) {final _that = this;
switch (_that) {
case _TaskActionError() when $default != null:
return $default(_that.message,_that.occurrence);case _:
  return null;

}
}

}

/// @nodoc


class _TaskActionError implements TaskActionError {
  const _TaskActionError({required this.message, required this.occurrence});
  

@override final  String message;
@override final  int occurrence;

/// Create a copy of TaskActionError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskActionErrorCopyWith<_TaskActionError> get copyWith => __$TaskActionErrorCopyWithImpl<_TaskActionError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskActionError&&(identical(other.message, message) || other.message == message)&&(identical(other.occurrence, occurrence) || other.occurrence == occurrence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,occurrence);
}

@override
String toString() {
    return 'TaskActionError(message: $message, occurrence: $occurrence)';
}


}

/// @nodoc
abstract mixin class _$TaskActionErrorCopyWith<$Res> implements $TaskActionErrorCopyWith<$Res> {
  factory _$TaskActionErrorCopyWith(_TaskActionError value, $Res Function(_TaskActionError) _then) = __$TaskActionErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, int occurrence
});




}
/// @nodoc
class __$TaskActionErrorCopyWithImpl<$Res>
    implements _$TaskActionErrorCopyWith<$Res> {
  __$TaskActionErrorCopyWithImpl(this._self, this._then);

  final _TaskActionError _self;
  final $Res Function(_TaskActionError) _then;

/// Create a copy of TaskActionError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? occurrence = null,}) {
  return _then(_TaskActionError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,occurrence: null == occurrence ? _self.occurrence : occurrence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TaskListState {

 TaskListStatus get status;/// Always the last list successfully read from the database: every page
/// loaded so far for the current query.
 List<TaskEntity> get tasks;/// More tasks match the query beyond [tasks].
 bool get hasMore;/// A next-page read is in flight (the list itself stays interactive).
 bool get isLoadingMore;/// The last next-page read failed; [tasks] is unchanged.
 String? get loadMoreError;/// Latest search/filter intent. Survives mutations and reloads.
 TaskQuery get query;/// Tasks with a mutation in flight (UI affordance only; correctness is
/// enforced in the persistence layer).
 Set<String> get pendingTaskIds; String? get loadError; TaskActionError? get actionError;
/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListStateCopyWith<TaskListState> get copyWith => _$TaskListStateCopyWithImpl<TaskListState>(this as TaskListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.tasks, _this.tasks)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.loadMoreError, _this.loadMoreError) || other.loadMoreError == _this.loadMoreError)&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.pendingTaskIds, _this.pendingTaskIds)&&(identical(other.loadError, _this.loadError) || other.loadError == _this.loadError)&&(identical(other.actionError, _this.actionError) || other.actionError == _this.actionError));
}


@override
int get hashCode {
  final _this = this as TaskListState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.tasks),_this.hasMore,_this.isLoadingMore,_this.loadMoreError,_this.query,const DeepCollectionEquality().hash(_this.pendingTaskIds),_this.loadError,_this.actionError);
}

@override
String toString() {
  final _this = this as TaskListState;
  return 'TaskListState(status: ${_this.status}, tasks: ${_this.tasks}, hasMore: ${_this.hasMore}, isLoadingMore: ${_this.isLoadingMore}, loadMoreError: ${_this.loadMoreError}, query: ${_this.query}, pendingTaskIds: ${_this.pendingTaskIds}, loadError: ${_this.loadError}, actionError: ${_this.actionError})';
}


}

/// @nodoc
abstract mixin class $TaskListStateCopyWith<$Res>  {
  factory $TaskListStateCopyWith(TaskListState value, $Res Function(TaskListState) _then) = _$TaskListStateCopyWithImpl;
@useResult
$Res call({
 TaskListStatus status, List<TaskEntity> tasks, bool hasMore, bool isLoadingMore, String? loadMoreError, TaskQuery query, Set<String> pendingTaskIds, String? loadError, TaskActionError? actionError
});


$TaskQueryCopyWith<$Res> get query;$TaskActionErrorCopyWith<$Res>? get actionError;

}
/// @nodoc
class _$TaskListStateCopyWithImpl<$Res>
    implements $TaskListStateCopyWith<$Res> {
  _$TaskListStateCopyWithImpl(this._self, this._then);

  final TaskListState _self;
  final $Res Function(TaskListState) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? tasks = null,Object? hasMore = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,Object? query = null,Object? pendingTaskIds = null,Object? loadError = freezed,Object? actionError = freezed,}) {
  return _then(TaskListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskListStatus,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as TaskQuery,pendingTaskIds: null == pendingTaskIds ? _self.pendingTaskIds : pendingTaskIds // ignore: cast_nullable_to_non_nullable
as Set<String>,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as TaskActionError?,
  ));
}
/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskQueryCopyWith<$Res> get query {
  
  return $TaskQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskActionErrorCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $TaskActionErrorCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskListState].
extension TaskListStatePatterns on TaskListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskListState value)  $default,){
final _that = this;
switch (_that) {
case _TaskListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskListState value)?  $default,){
final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskListStatus status,  List<TaskEntity> tasks,  bool hasMore,  bool isLoadingMore,  String? loadMoreError,  TaskQuery query,  Set<String> pendingTaskIds,  String? loadError,  TaskActionError? actionError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
return $default(_that.status,_that.tasks,_that.hasMore,_that.isLoadingMore,_that.loadMoreError,_that.query,_that.pendingTaskIds,_that.loadError,_that.actionError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskListStatus status,  List<TaskEntity> tasks,  bool hasMore,  bool isLoadingMore,  String? loadMoreError,  TaskQuery query,  Set<String> pendingTaskIds,  String? loadError,  TaskActionError? actionError)  $default,) {final _that = this;
switch (_that) {
case _TaskListState():
return $default(_that.status,_that.tasks,_that.hasMore,_that.isLoadingMore,_that.loadMoreError,_that.query,_that.pendingTaskIds,_that.loadError,_that.actionError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskListStatus status,  List<TaskEntity> tasks,  bool hasMore,  bool isLoadingMore,  String? loadMoreError,  TaskQuery query,  Set<String> pendingTaskIds,  String? loadError,  TaskActionError? actionError)?  $default,) {final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
return $default(_that.status,_that.tasks,_that.hasMore,_that.isLoadingMore,_that.loadMoreError,_that.query,_that.pendingTaskIds,_that.loadError,_that.actionError);case _:
  return null;

}
}

}

/// @nodoc


class _TaskListState implements TaskListState {
  const _TaskListState({this.status = TaskListStatus.initial,  List<TaskEntity> tasks = const <TaskEntity>[], this.hasMore = false, this.isLoadingMore = false, this.loadMoreError, this.query = const TaskQuery(),  Set<String> pendingTaskIds = const <String>{}, this.loadError, this.actionError}): _tasks = tasks,_pendingTaskIds = pendingTaskIds;
  

@override@JsonKey() final  TaskListStatus status;
/// Always the last list successfully read from the database: every page
/// loaded so far for the current query.
 final  List<TaskEntity> _tasks;
/// Always the last list successfully read from the database: every page
/// loaded so far for the current query.
@override@JsonKey() List<TaskEntity> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

/// More tasks match the query beyond [tasks].
@override@JsonKey() final  bool hasMore;
/// A next-page read is in flight (the list itself stays interactive).
@override@JsonKey() final  bool isLoadingMore;
/// The last next-page read failed; [tasks] is unchanged.
@override final  String? loadMoreError;
/// Latest search/filter intent. Survives mutations and reloads.
@override@JsonKey() final  TaskQuery query;
/// Tasks with a mutation in flight (UI affordance only; correctness is
/// enforced in the persistence layer).
 final  Set<String> _pendingTaskIds;
/// Tasks with a mutation in flight (UI affordance only; correctness is
/// enforced in the persistence layer).
@override@JsonKey() Set<String> get pendingTaskIds {
  if (_pendingTaskIds is EqualUnmodifiableSetView) return _pendingTaskIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingTaskIds);
}

@override final  String? loadError;
@override final  TaskActionError? actionError;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskListStateCopyWith<_TaskListState> get copyWith => __$TaskListStateCopyWithImpl<_TaskListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.tasks, _tasks)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.pendingTaskIds, _pendingTaskIds)&&(identical(other.loadError, loadError) || other.loadError == loadError)&&(identical(other.actionError, actionError) || other.actionError == actionError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_tasks),hasMore,isLoadingMore,loadMoreError,query,const DeepCollectionEquality().hash(_pendingTaskIds),loadError,actionError);
}

@override
String toString() {
    return 'TaskListState(status: $status, tasks: $tasks, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError, query: $query, pendingTaskIds: $pendingTaskIds, loadError: $loadError, actionError: $actionError)';
}


}

/// @nodoc
abstract mixin class _$TaskListStateCopyWith<$Res> implements $TaskListStateCopyWith<$Res> {
  factory _$TaskListStateCopyWith(_TaskListState value, $Res Function(_TaskListState) _then) = __$TaskListStateCopyWithImpl;
@override @useResult
$Res call({
 TaskListStatus status, List<TaskEntity> tasks, bool hasMore, bool isLoadingMore, String? loadMoreError, TaskQuery query, Set<String> pendingTaskIds, String? loadError, TaskActionError? actionError
});


@override $TaskQueryCopyWith<$Res> get query;@override $TaskActionErrorCopyWith<$Res>? get actionError;

}
/// @nodoc
class __$TaskListStateCopyWithImpl<$Res>
    implements _$TaskListStateCopyWith<$Res> {
  __$TaskListStateCopyWithImpl(this._self, this._then);

  final _TaskListState _self;
  final $Res Function(_TaskListState) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? tasks = null,Object? hasMore = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,Object? query = null,Object? pendingTaskIds = null,Object? loadError = freezed,Object? actionError = freezed,}) {
  return _then(_TaskListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskListStatus,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as TaskQuery,pendingTaskIds: null == pendingTaskIds ? _self._pendingTaskIds : pendingTaskIds // ignore: cast_nullable_to_non_nullable
as Set<String>,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as TaskActionError?,
  ));
}

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskQueryCopyWith<$Res> get query {
  
  return $TaskQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskActionErrorCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $TaskActionErrorCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}

// dart format on
