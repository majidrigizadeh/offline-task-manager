// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskPage {

 List<TaskEntity> get tasks;/// Whether at least one more task matches the query after this slice.
 bool get hasMore;
/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskPageCopyWith<TaskPage> get copyWith => _$TaskPageCopyWithImpl<TaskPage>(this as TaskPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskPage&&const DeepCollectionEquality().equals(other.tasks, _this.tasks)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore));
}


@override
int get hashCode {
  final _this = this as TaskPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.tasks),_this.hasMore);
}

@override
String toString() {
  final _this = this as TaskPage;
  return 'TaskPage(tasks: ${_this.tasks}, hasMore: ${_this.hasMore})';
}


}

/// @nodoc
abstract mixin class $TaskPageCopyWith<$Res>  {
  factory $TaskPageCopyWith(TaskPage value, $Res Function(TaskPage) _then) = _$TaskPageCopyWithImpl;
@useResult
$Res call({
 List<TaskEntity> tasks, bool hasMore
});




}
/// @nodoc
class _$TaskPageCopyWithImpl<$Res>
    implements $TaskPageCopyWith<$Res> {
  _$TaskPageCopyWithImpl(this._self, this._then);

  final TaskPage _self;
  final $Res Function(TaskPage) _then;

/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? hasMore = null,}) {
  return _then(TaskPage(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskPage].
extension TaskPagePatterns on TaskPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskPage value)  $default,){
final _that = this;
switch (_that) {
case _TaskPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskPage value)?  $default,){
final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskEntity> tasks,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
return $default(_that.tasks,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskEntity> tasks,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _TaskPage():
return $default(_that.tasks,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskEntity> tasks,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
return $default(_that.tasks,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _TaskPage implements TaskPage {
  const _TaskPage({required  List<TaskEntity> tasks, required this.hasMore}): _tasks = tasks;
  

 final  List<TaskEntity> _tasks;
@override List<TaskEntity> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

/// Whether at least one more task matches the query after this slice.
@override final  bool hasMore;

/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskPageCopyWith<_TaskPage> get copyWith => __$TaskPageCopyWithImpl<_TaskPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskPage&&const DeepCollectionEquality().equals(other.tasks, _tasks)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks),hasMore);
}

@override
String toString() {
    return 'TaskPage(tasks: $tasks, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$TaskPageCopyWith<$Res> implements $TaskPageCopyWith<$Res> {
  factory _$TaskPageCopyWith(_TaskPage value, $Res Function(_TaskPage) _then) = __$TaskPageCopyWithImpl;
@override @useResult
$Res call({
 List<TaskEntity> tasks, bool hasMore
});




}
/// @nodoc
class __$TaskPageCopyWithImpl<$Res>
    implements _$TaskPageCopyWith<$Res> {
  __$TaskPageCopyWithImpl(this._self, this._then);

  final _TaskPage _self;
  final $Res Function(_TaskPage) _then;

/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? hasMore = null,}) {
  return _then(_TaskPage(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskEntity>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
