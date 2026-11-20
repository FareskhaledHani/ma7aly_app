// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_customer_movement_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaveCustomerMovementState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveCustomerMovementState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SaveCustomerMovementState()';
}


}

/// @nodoc
class $SaveCustomerMovementStateCopyWith<$Res>  {
$SaveCustomerMovementStateCopyWith(SaveCustomerMovementState _, $Res Function(SaveCustomerMovementState) __);
}


/// Adds pattern-matching-related methods to [SaveCustomerMovementState].
extension SaveCustomerMovementStatePatterns on SaveCustomerMovementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MovementInitial value)?  initial,TResult Function( MovementLoading value)?  loading,TResult Function( MovementSuccess value)?  success,TResult Function( MovementFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MovementInitial() when initial != null:
return initial(_that);case MovementLoading() when loading != null:
return loading(_that);case MovementSuccess() when success != null:
return success(_that);case MovementFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MovementInitial value)  initial,required TResult Function( MovementLoading value)  loading,required TResult Function( MovementSuccess value)  success,required TResult Function( MovementFailure value)  failure,}){
final _that = this;
switch (_that) {
case MovementInitial():
return initial(_that);case MovementLoading():
return loading(_that);case MovementSuccess():
return success(_that);case MovementFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MovementInitial value)?  initial,TResult? Function( MovementLoading value)?  loading,TResult? Function( MovementSuccess value)?  success,TResult? Function( MovementFailure value)?  failure,}){
final _that = this;
switch (_that) {
case MovementInitial() when initial != null:
return initial(_that);case MovementLoading() when loading != null:
return loading(_that);case MovementSuccess() when success != null:
return success(_that);case MovementFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( SaveCustomerMovementParams params)?  success,TResult Function( String message,  SaveCustomerMovementParams params)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MovementInitial() when initial != null:
return initial();case MovementLoading() when loading != null:
return loading();case MovementSuccess() when success != null:
return success(_that.params);case MovementFailure() when failure != null:
return failure(_that.message,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( SaveCustomerMovementParams params)  success,required TResult Function( String message,  SaveCustomerMovementParams params)  failure,}) {final _that = this;
switch (_that) {
case MovementInitial():
return initial();case MovementLoading():
return loading();case MovementSuccess():
return success(_that.params);case MovementFailure():
return failure(_that.message,_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( SaveCustomerMovementParams params)?  success,TResult? Function( String message,  SaveCustomerMovementParams params)?  failure,}) {final _that = this;
switch (_that) {
case MovementInitial() when initial != null:
return initial();case MovementLoading() when loading != null:
return loading();case MovementSuccess() when success != null:
return success(_that.params);case MovementFailure() when failure != null:
return failure(_that.message,_that.params);case _:
  return null;

}
}

}

/// @nodoc


class MovementInitial implements SaveCustomerMovementState {
  const MovementInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SaveCustomerMovementState.initial()';
}


}




/// @nodoc


class MovementLoading implements SaveCustomerMovementState {
  const MovementLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SaveCustomerMovementState.loading()';
}


}




/// @nodoc


class MovementSuccess implements SaveCustomerMovementState {
  const MovementSuccess(this.params);
  

 final  SaveCustomerMovementParams params;

/// Create a copy of SaveCustomerMovementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovementSuccessCopyWith<MovementSuccess> get copyWith => _$MovementSuccessCopyWithImpl<MovementSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementSuccess&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode {
    return Object.hash(runtimeType,params);
}

@override
String toString() {
    return 'SaveCustomerMovementState.success(params: $params)';
}


}

/// @nodoc
abstract mixin class $MovementSuccessCopyWith<$Res> implements $SaveCustomerMovementStateCopyWith<$Res> {
  factory $MovementSuccessCopyWith(MovementSuccess value, $Res Function(MovementSuccess) _then) = _$MovementSuccessCopyWithImpl;
@useResult
$Res call({
 SaveCustomerMovementParams params
});




}
/// @nodoc
class _$MovementSuccessCopyWithImpl<$Res>
    implements $MovementSuccessCopyWith<$Res> {
  _$MovementSuccessCopyWithImpl(this._self, this._then);

  final MovementSuccess _self;
  final $Res Function(MovementSuccess) _then;

/// Create a copy of SaveCustomerMovementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? params = null,}) {
  return _then(MovementSuccess(
null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SaveCustomerMovementParams,
  ));
}


}

/// @nodoc


class MovementFailure implements SaveCustomerMovementState {
  const MovementFailure(this.message, this.params);
  

 final  String message;
 final  SaveCustomerMovementParams params;

/// Create a copy of SaveCustomerMovementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovementFailureCopyWith<MovementFailure> get copyWith => _$MovementFailureCopyWithImpl<MovementFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,params);
}

@override
String toString() {
    return 'SaveCustomerMovementState.failure(message: $message, params: $params)';
}


}

/// @nodoc
abstract mixin class $MovementFailureCopyWith<$Res> implements $SaveCustomerMovementStateCopyWith<$Res> {
  factory $MovementFailureCopyWith(MovementFailure value, $Res Function(MovementFailure) _then) = _$MovementFailureCopyWithImpl;
@useResult
$Res call({
 String message, SaveCustomerMovementParams params
});




}
/// @nodoc
class _$MovementFailureCopyWithImpl<$Res>
    implements $MovementFailureCopyWith<$Res> {
  _$MovementFailureCopyWithImpl(this._self, this._then);

  final MovementFailure _self;
  final $Res Function(MovementFailure) _then;

/// Create a copy of SaveCustomerMovementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? params = null,}) {
  return _then(MovementFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SaveCustomerMovementParams,
  ));
}


}

// dart format on
