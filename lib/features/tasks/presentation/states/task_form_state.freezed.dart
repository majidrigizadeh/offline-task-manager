// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskFormState {

 bool get isEdit; String get title; String get description; TaskPriority get priority; TaskFormStatus get status; String? get titleError;/// Save error; the user's input is kept so they can retry.
 String? get errorMessage;/// Set when [status] is `saved`: whether anything was persisted.
 bool get didPersist;
/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormStateCopyWith<TaskFormState> get copyWith => _$TaskFormStateCopyWithImpl<TaskFormState>(this as TaskFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormState&&(identical(other.isEdit, _this.isEdit) || other.isEdit == _this.isEdit)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.titleError, _this.titleError) || other.titleError == _this.titleError)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.didPersist, _this.didPersist) || other.didPersist == _this.didPersist));
}


@override
int get hashCode {
  final _this = this as TaskFormState;
  return Object.hash(runtimeType,_this.isEdit,_this.title,_this.description,_this.priority,_this.status,_this.titleError,_this.errorMessage,_this.didPersist);
}

@override
String toString() {
  final _this = this as TaskFormState;
  return 'TaskFormState(isEdit: ${_this.isEdit}, title: ${_this.title}, description: ${_this.description}, priority: ${_this.priority}, status: ${_this.status}, titleError: ${_this.titleError}, errorMessage: ${_this.errorMessage}, didPersist: ${_this.didPersist})';
}


}

/// @nodoc
abstract mixin class $TaskFormStateCopyWith<$Res>  {
  factory $TaskFormStateCopyWith(TaskFormState value, $Res Function(TaskFormState) _then) = _$TaskFormStateCopyWithImpl;
@useResult
$Res call({
 bool isEdit, String title, String description, TaskPriority priority, TaskFormStatus status, String? titleError, String? errorMessage, bool didPersist
});




}
/// @nodoc
class _$TaskFormStateCopyWithImpl<$Res>
    implements $TaskFormStateCopyWith<$Res> {
  _$TaskFormStateCopyWithImpl(this._self, this._then);

  final TaskFormState _self;
  final $Res Function(TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isEdit = null,Object? title = null,Object? description = null,Object? priority = null,Object? status = null,Object? titleError = freezed,Object? errorMessage = freezed,Object? didPersist = null,}) {
  return _then(TaskFormState(
isEdit: null == isEdit ? _self.isEdit : isEdit // ignore: cast_nullable_to_non_nullable
as bool,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskFormStatus,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,didPersist: null == didPersist ? _self.didPersist : didPersist // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskFormState].
extension TaskFormStatePatterns on TaskFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskFormState value)  $default,){
final _that = this;
switch (_that) {
case _TaskFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskFormState value)?  $default,){
final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isEdit,  String title,  String description,  TaskPriority priority,  TaskFormStatus status,  String? titleError,  String? errorMessage,  bool didPersist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
return $default(_that.isEdit,_that.title,_that.description,_that.priority,_that.status,_that.titleError,_that.errorMessage,_that.didPersist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isEdit,  String title,  String description,  TaskPriority priority,  TaskFormStatus status,  String? titleError,  String? errorMessage,  bool didPersist)  $default,) {final _that = this;
switch (_that) {
case _TaskFormState():
return $default(_that.isEdit,_that.title,_that.description,_that.priority,_that.status,_that.titleError,_that.errorMessage,_that.didPersist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isEdit,  String title,  String description,  TaskPriority priority,  TaskFormStatus status,  String? titleError,  String? errorMessage,  bool didPersist)?  $default,) {final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
return $default(_that.isEdit,_that.title,_that.description,_that.priority,_that.status,_that.titleError,_that.errorMessage,_that.didPersist);case _:
  return null;

}
}

}

/// @nodoc


class _TaskFormState implements TaskFormState {
  const _TaskFormState({required this.isEdit, this.title = '', this.description = '', this.priority = TaskPriority.medium, this.status = TaskFormStatus.editing, this.titleError, this.errorMessage, this.didPersist = false});
  

@override final  bool isEdit;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  TaskPriority priority;
@override@JsonKey() final  TaskFormStatus status;
@override final  String? titleError;
/// Save error; the user's input is kept so they can retry.
@override final  String? errorMessage;
/// Set when [status] is `saved`: whether anything was persisted.
@override@JsonKey() final  bool didPersist;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFormStateCopyWith<_TaskFormState> get copyWith => __$TaskFormStateCopyWithImpl<_TaskFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFormState&&(identical(other.isEdit, isEdit) || other.isEdit == isEdit)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.didPersist, didPersist) || other.didPersist == didPersist));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isEdit,title,description,priority,status,titleError,errorMessage,didPersist);
}

@override
String toString() {
    return 'TaskFormState(isEdit: $isEdit, title: $title, description: $description, priority: $priority, status: $status, titleError: $titleError, errorMessage: $errorMessage, didPersist: $didPersist)';
}


}

/// @nodoc
abstract mixin class _$TaskFormStateCopyWith<$Res> implements $TaskFormStateCopyWith<$Res> {
  factory _$TaskFormStateCopyWith(_TaskFormState value, $Res Function(_TaskFormState) _then) = __$TaskFormStateCopyWithImpl;
@override @useResult
$Res call({
 bool isEdit, String title, String description, TaskPriority priority, TaskFormStatus status, String? titleError, String? errorMessage, bool didPersist
});




}
/// @nodoc
class __$TaskFormStateCopyWithImpl<$Res>
    implements _$TaskFormStateCopyWith<$Res> {
  __$TaskFormStateCopyWithImpl(this._self, this._then);

  final _TaskFormState _self;
  final $Res Function(_TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isEdit = null,Object? title = null,Object? description = null,Object? priority = null,Object? status = null,Object? titleError = freezed,Object? errorMessage = freezed,Object? didPersist = null,}) {
  return _then(_TaskFormState(
isEdit: null == isEdit ? _self.isEdit : isEdit // ignore: cast_nullable_to_non_nullable
as bool,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskFormStatus,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,didPersist: null == didPersist ? _self.didPersist : didPersist // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
