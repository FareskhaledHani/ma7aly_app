// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_reset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PasswordResetState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PasswordResetState()';
}


}

/// @nodoc
class $PasswordResetStateCopyWith<$Res>  {
$PasswordResetStateCopyWith(PasswordResetState _, $Res Function(PasswordResetState) __);
}


/// Adds pattern-matching-related methods to [PasswordResetState].
extension PasswordResetStatePatterns on PasswordResetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PasswordResetInitial value)?  initial,TResult Function( PasswordResetLoading value)?  loading,TResult Function( PasswordResetSuccess value)?  success,TResult Function( PasswordResetFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PasswordResetInitial() when initial != null:
return initial(_that);case PasswordResetLoading() when loading != null:
return loading(_that);case PasswordResetSuccess() when success != null:
return success(_that);case PasswordResetFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PasswordResetInitial value)  initial,required TResult Function( PasswordResetLoading value)  loading,required TResult Function( PasswordResetSuccess value)  success,required TResult Function( PasswordResetFailure value)  failure,}){
final _that = this;
switch (_that) {
case PasswordResetInitial():
return initial(_that);case PasswordResetLoading():
return loading(_that);case PasswordResetSuccess():
return success(_that);case PasswordResetFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PasswordResetInitial value)?  initial,TResult? Function( PasswordResetLoading value)?  loading,TResult? Function( PasswordResetSuccess value)?  success,TResult? Function( PasswordResetFailure value)?  failure,}){
final _that = this;
switch (_that) {
case PasswordResetInitial() when initial != null:
return initial(_that);case PasswordResetLoading() when loading != null:
return loading(_that);case PasswordResetSuccess() when success != null:
return success(_that);case PasswordResetFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PasswordResetInitial() when initial != null:
return initial();case PasswordResetLoading() when loading != null:
return loading();case PasswordResetSuccess() when success != null:
return success();case PasswordResetFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case PasswordResetInitial():
return initial();case PasswordResetLoading():
return loading();case PasswordResetSuccess():
return success();case PasswordResetFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case PasswordResetInitial() when initial != null:
return initial();case PasswordResetLoading() when loading != null:
return loading();case PasswordResetSuccess() when success != null:
return success();case PasswordResetFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PasswordResetInitial implements PasswordResetState {
  const PasswordResetInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PasswordResetState.initial()';
}


}




/// @nodoc


class PasswordResetLoading implements PasswordResetState {
  const PasswordResetLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PasswordResetState.loading()';
}


}




/// @nodoc


class PasswordResetSuccess implements PasswordResetState {
  const PasswordResetSuccess();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PasswordResetState.success()';
}


}




/// @nodoc


class PasswordResetFailure implements PasswordResetState {
  const PasswordResetFailure(this.message);
  

 final  String message;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetFailureCopyWith<PasswordResetFailure> get copyWith => _$PasswordResetFailureCopyWithImpl<PasswordResetFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'PasswordResetState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $PasswordResetFailureCopyWith<$Res> implements $PasswordResetStateCopyWith<$Res> {
  factory $PasswordResetFailureCopyWith(PasswordResetFailure value, $Res Function(PasswordResetFailure) _then) = _$PasswordResetFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PasswordResetFailureCopyWithImpl<$Res>
    implements $PasswordResetFailureCopyWith<$Res> {
  _$PasswordResetFailureCopyWithImpl(this._self, this._then);

  final PasswordResetFailure _self;
  final $Res Function(PasswordResetFailure) _then;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PasswordResetFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
