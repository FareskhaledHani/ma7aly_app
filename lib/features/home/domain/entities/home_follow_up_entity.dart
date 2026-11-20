import 'package:equatable/equatable.dart';

import '../../../customers/domain/entities/customer_entity.dart';

class HomeFollowUpEntity extends Equatable {
  HomeFollowUpEntity(CustomerEntity customer, DateTime today)
    : id = customer.id,
      name = customer.name,
      balanceMinor = customer.balanceMinor,
      status = customer.statusAt(today),
      dueDate = customer.dueDateAt(today),
      oldDebt = customer.overdueCarriedDebtMinor > 0,
      paymentPercent = customer.monthlyWithdrawalsMinor > 0
          ? ((customer.monthlyAppliedPaymentsMinor ??
                    customer.monthlyPaymentsMinor) *
                100 ~/
                customer.monthlyWithdrawalsMinor)
          : null,
      days = DateTime.utc(
        customer.dueDateAt(today).year,
        customer.dueDateAt(today).month,
        customer.dueDateAt(today).day,
      ).difference(DateTime.utc(today.year, today.month, today.day)).inDays;
  final String id;
  final String name;
  final int balanceMinor;
  final CustomerStatus status;
  final DateTime dueDate;
  final bool oldDebt;
  final int? paymentPercent;
  final int days;
  @override
  List<Object?> get props => [
    id,
    name,
    balanceMinor,
    status,
    dueDate,
    oldDebt,
    paymentPercent,
    days,
  ];
}
