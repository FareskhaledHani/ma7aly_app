import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/customer_entity.dart';
part 'customers_state.freezed.dart';

@freezed
abstract class CustomersState with _$CustomersState {
  const factory CustomersState({
    @Default('') String query,
    @Default(CustomerFilter.all) CustomerFilter filter,
    @Default(0) int totalCount,
  }) = _CustomersState;
}
