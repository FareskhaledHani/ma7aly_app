// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_customer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddCustomerState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCustomerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AddCustomerState()';
}


}

/// @nodoc
class $AddCustomerStateCopyWith<$Res>  {
$AddCustomerStateCopyWith(AddCustomerState _, $Res Function(AddCustomerState) __);
}


/// Adds pattern-matching-related methods to [AddCustomerState].
extension AddCustomerStatePatterns on AddCustomerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddCustomerInitial value)?  initial,TResult Function( AddCustomerLoading value)?  loading,TResult Function( AddCustomerSuccess value)?  success,TResult Function( AddCustomerFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddCustomerInitial() when initial != null:
return initial(_that);case AddCustomerLoading() when loading != null:
return loading(_that);case AddCustomerSuccess() when success != null:
return success(_that);case AddCustomerFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddCustomerInitial value)  initial,required TResult Function( AddCustomerLoading value)  loading,required TResult Function( AddCustomerSuccess value)  success,required TResult Function( AddCustomerFailure value)  failure,}){
final _that = this;
switch (_that) {
case AddCustomerInitial():
return initial(_that);case AddCustomerLoading():
return loading(_that);case AddCustomerSuccess():
return success(_that);case AddCustomerFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddCustomerInitial value)?  initial,TResult? Function( AddCustomerLoading value)?  loading,TResult? Function( AddCustomerSuccess value)?  success,TResult? Function( AddCustomerFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AddCustomerInitial() when initial != null:
return initial(_that);case AddCustomerLoading() when loading != null:
return loading(_that);case AddCustomerSuccess() when success != null:
return success(_that);case AddCustomerFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String id)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddCustomerInitial() when initial != null:
return initial();case AddCustomerLoading() when loading != null:
return loading();case AddCustomerSuccess() when success != null:
return success(_that.id);case AddCustomerFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String id)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AddCustomerInitial():
return initial();case AddCustomerLoading():
return loading();case AddCustomerSuccess():
return success(_that.id);case AddCustomerFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String id)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AddCustomerInitial() when initial != null:
return initial();case AddCustomerLoading() when loading != null:
return loading();case AddCustomerSuccess() when success != null:
return success(_that.id);case AddCustomerFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AddCustomerInitial implements AddCustomerState {
  const AddCustomerInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCustomerInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AddCustomerState.initial()';
}


}




/// @nodoc


class AddCustomerLoading implements AddCustomerState {
  const AddCustomerLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCustomerLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AddCustomerState.loading()';
}


}




/// @nodoc


class AddCustomerSuccess implements AddCustomerState {
  const AddCustomerSuccess(this.id);
  

 final  String id;

/// Create a copy of AddCustomerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddCustomerSuccessCopyWith<AddCustomerSuccess> get copyWith => _$AddCustomerSuccessCopyWithImpl<AddCustomerSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCustomerSuccess&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'AddCustomerState.success(id: $id)';
}


}

/// @nodoc
abstract mixin class $AddCustomerSuccessCopyWith<$Res> implements $AddCustomerStateCopyWith<$Res> {
  factory $AddCustomerSuccessCopyWith(AddCustomerSuccess value, $Res Function(AddCustomerSuccess) _then) = _$AddCustomerSuccessCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$AddCustomerSuccessCopyWithImpl<$Res>
    implements $AddCustomerSuccessCopyWith<$Res> {
  _$AddCustomerSuccessCopyWithImpl(this._self, this._then);

  final AddCustomerSuccess _self;
  final $Res Function(AddCustomerSuccess) _then;

/// Create a copy of AddCustomerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(AddCustomerSuccess(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AddCustomerFailure implements AddCustomerState {
  const AddCustomerFailure(this.message);
  

 final  String message;

/// Create a copy of AddCustomerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddCustomerFailureCopyWith<AddCustomerFailure> get copyWith => _$AddCustomerFailureCopyWithImpl<AddCustomerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCustomerFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AddCustomerState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AddCustomerFailureCopyWith<$Res> implements $AddCustomerStateCopyWith<$Res> {
  factory $AddCustomerFailureCopyWith(AddCustomerFailure value, $Res Function(AddCustomerFailure) _then) = _$AddCustomerFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AddCustomerFailureCopyWithImpl<$Res>
    implements $AddCustomerFailureCopyWith<$Res> {
  _$AddCustomerFailureCopyWithImpl(this._self, this._then);

  final AddCustomerFailure _self;
  final $Res Function(AddCustomerFailure) _then;

/// Create a copy of AddCustomerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AddCustomerFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
