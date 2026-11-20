// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerAccountState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAccountState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomerAccountState()';
}


}

/// @nodoc
class $CustomerAccountStateCopyWith<$Res>  {
$CustomerAccountStateCopyWith(CustomerAccountState _, $Res Function(CustomerAccountState) __);
}


/// Adds pattern-matching-related methods to [CustomerAccountState].
extension CustomerAccountStatePatterns on CustomerAccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CustomerAccountInitial value)?  initial,TResult Function( CustomerAccountLoading value)?  loading,TResult Function( CustomerAccountSuccess value)?  success,TResult Function( CustomerAccountFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CustomerAccountInitial() when initial != null:
return initial(_that);case CustomerAccountLoading() when loading != null:
return loading(_that);case CustomerAccountSuccess() when success != null:
return success(_that);case CustomerAccountFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CustomerAccountInitial value)  initial,required TResult Function( CustomerAccountLoading value)  loading,required TResult Function( CustomerAccountSuccess value)  success,required TResult Function( CustomerAccountFailure value)  failure,}){
final _that = this;
switch (_that) {
case CustomerAccountInitial():
return initial(_that);case CustomerAccountLoading():
return loading(_that);case CustomerAccountSuccess():
return success(_that);case CustomerAccountFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CustomerAccountInitial value)?  initial,TResult? Function( CustomerAccountLoading value)?  loading,TResult? Function( CustomerAccountSuccess value)?  success,TResult? Function( CustomerAccountFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CustomerAccountInitial() when initial != null:
return initial(_that);case CustomerAccountLoading() when loading != null:
return loading(_that);case CustomerAccountSuccess() when success != null:
return success(_that);case CustomerAccountFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( CustomerAccountEntity account)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CustomerAccountInitial() when initial != null:
return initial();case CustomerAccountLoading() when loading != null:
return loading();case CustomerAccountSuccess() when success != null:
return success(_that.account);case CustomerAccountFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( CustomerAccountEntity account)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case CustomerAccountInitial():
return initial();case CustomerAccountLoading():
return loading();case CustomerAccountSuccess():
return success(_that.account);case CustomerAccountFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( CustomerAccountEntity account)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case CustomerAccountInitial() when initial != null:
return initial();case CustomerAccountLoading() when loading != null:
return loading();case CustomerAccountSuccess() when success != null:
return success(_that.account);case CustomerAccountFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CustomerAccountInitial implements CustomerAccountState {
  const CustomerAccountInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAccountInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomerAccountState.initial()';
}


}




/// @nodoc


class CustomerAccountLoading implements CustomerAccountState {
  const CustomerAccountLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAccountLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomerAccountState.loading()';
}


}




/// @nodoc


class CustomerAccountSuccess implements CustomerAccountState {
  const CustomerAccountSuccess(this.account);
  

 final  CustomerAccountEntity account;

/// Create a copy of CustomerAccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerAccountSuccessCopyWith<CustomerAccountSuccess> get copyWith => _$CustomerAccountSuccessCopyWithImpl<CustomerAccountSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAccountSuccess&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode {
    return Object.hash(runtimeType,account);
}

@override
String toString() {
    return 'CustomerAccountState.success(account: $account)';
}


}

/// @nodoc
abstract mixin class $CustomerAccountSuccessCopyWith<$Res> implements $CustomerAccountStateCopyWith<$Res> {
  factory $CustomerAccountSuccessCopyWith(CustomerAccountSuccess value, $Res Function(CustomerAccountSuccess) _then) = _$CustomerAccountSuccessCopyWithImpl;
@useResult
$Res call({
 CustomerAccountEntity account
});




}
/// @nodoc
class _$CustomerAccountSuccessCopyWithImpl<$Res>
    implements $CustomerAccountSuccessCopyWith<$Res> {
  _$CustomerAccountSuccessCopyWithImpl(this._self, this._then);

  final CustomerAccountSuccess _self;
  final $Res Function(CustomerAccountSuccess) _then;

/// Create a copy of CustomerAccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? account = null,}) {
  return _then(CustomerAccountSuccess(
null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as CustomerAccountEntity,
  ));
}


}

/// @nodoc


class CustomerAccountFailure implements CustomerAccountState {
  const CustomerAccountFailure(this.message);
  

 final  String message;

/// Create a copy of CustomerAccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerAccountFailureCopyWith<CustomerAccountFailure> get copyWith => _$CustomerAccountFailureCopyWithImpl<CustomerAccountFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAccountFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CustomerAccountState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $CustomerAccountFailureCopyWith<$Res> implements $CustomerAccountStateCopyWith<$Res> {
  factory $CustomerAccountFailureCopyWith(CustomerAccountFailure value, $Res Function(CustomerAccountFailure) _then) = _$CustomerAccountFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CustomerAccountFailureCopyWithImpl<$Res>
    implements $CustomerAccountFailureCopyWith<$Res> {
  _$CustomerAccountFailureCopyWithImpl(this._self, this._then);

  final CustomerAccountFailure _self;
  final $Res Function(CustomerAccountFailure) _then;

/// Create a copy of CustomerAccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CustomerAccountFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
