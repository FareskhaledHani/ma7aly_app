// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 AsyncStatus get status; ShopSettingsEntity? get settings; bool get busy; String? get message; bool get signedOut; int get event; List<CustomerEntity>? get report;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.signedOut, _this.signedOut) || other.signedOut == _this.signedOut)&&(identical(other.event, _this.event) || other.event == _this.event)&&const DeepCollectionEquality().equals(other.report, _this.report));
}


@override
int get hashCode {
  final _this = this as SettingsState;
  return Object.hash(runtimeType,_this.status,_this.settings,_this.busy,_this.message,_this.signedOut,_this.event,const DeepCollectionEquality().hash(_this.report));
}

@override
String toString() {
  final _this = this as SettingsState;
  return 'SettingsState(status: ${_this.status}, settings: ${_this.settings}, busy: ${_this.busy}, message: ${_this.message}, signedOut: ${_this.signedOut}, event: ${_this.event}, report: ${_this.report})';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 AsyncStatus status, ShopSettingsEntity? settings, bool busy, String? message, bool signedOut, int event, List<CustomerEntity>? report
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? settings = freezed,Object? busy = null,Object? message = freezed,Object? signedOut = null,Object? event = null,Object? report = freezed,}) {
  return _then(SettingsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncStatus,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ShopSettingsEntity?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,signedOut: null == signedOut ? _self.signedOut : signedOut // ignore: cast_nullable_to_non_nullable
as bool,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as int,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as List<CustomerEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncStatus status,  ShopSettingsEntity? settings,  bool busy,  String? message,  bool signedOut,  int event,  List<CustomerEntity>? report)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.status,_that.settings,_that.busy,_that.message,_that.signedOut,_that.event,_that.report);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncStatus status,  ShopSettingsEntity? settings,  bool busy,  String? message,  bool signedOut,  int event,  List<CustomerEntity>? report)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.status,_that.settings,_that.busy,_that.message,_that.signedOut,_that.event,_that.report);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncStatus status,  ShopSettingsEntity? settings,  bool busy,  String? message,  bool signedOut,  int event,  List<CustomerEntity>? report)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.status,_that.settings,_that.busy,_that.message,_that.signedOut,_that.event,_that.report);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.status = AsyncStatus.initial, this.settings, this.busy = false, this.message, this.signedOut = false, this.event = 0,  List<CustomerEntity>? report}): _report = report;
  

@override@JsonKey() final  AsyncStatus status;
@override final  ShopSettingsEntity? settings;
@override@JsonKey() final  bool busy;
@override final  String? message;
@override@JsonKey() final  bool signedOut;
@override@JsonKey() final  int event;
 final  List<CustomerEntity>? _report;
@override List<CustomerEntity>? get report {
  final value = _report;
  if (value == null) return null;
  if (_report is EqualUnmodifiableListView) return _report;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.status, status) || other.status == status)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.message, message) || other.message == message)&&(identical(other.signedOut, signedOut) || other.signedOut == signedOut)&&(identical(other.event, event) || other.event == event)&&const DeepCollectionEquality().equals(other.report, _report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,settings,busy,message,signedOut,event,const DeepCollectionEquality().hash(_report));
}

@override
String toString() {
    return 'SettingsState(status: $status, settings: $settings, busy: $busy, message: $message, signedOut: $signedOut, event: $event, report: $report)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncStatus status, ShopSettingsEntity? settings, bool busy, String? message, bool signedOut, int event, List<CustomerEntity>? report
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? settings = freezed,Object? busy = null,Object? message = freezed,Object? signedOut = null,Object? event = null,Object? report = freezed,}) {
  return _then(_SettingsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncStatus,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ShopSettingsEntity?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,signedOut: null == signedOut ? _self.signedOut : signedOut // ignore: cast_nullable_to_non_nullable
as bool,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as int,report: freezed == report ? _self._report : report // ignore: cast_nullable_to_non_nullable
as List<CustomerEntity>?,
  ));
}


}

// dart format on
