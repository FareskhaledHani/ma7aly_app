import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'customer_entity.dart';
import 'customer_movement_entity.dart';

class CustomerAccountEntity extends Equatable {
  const CustomerAccountEntity({
    required this.customer,
    required this.movements,
  });
  final CustomerEntity customer;
  final List<CustomerMovementEntity> movements;

  int get balanceMinor =>
      customer.openingBalanceMinor +
      movements
          .where((m) => !m.deleted)
          .fold(0, (sum, m) => sum + m.balanceDelta);

  int monthlyTotal(CustomerMovementKind kind, DateTime today) => movements
      .where(
        (m) =>
            !m.deleted &&
            m.kind == kind &&
            m.date.year == today.year &&
            m.date.month == today.month,
      )
      .fold(0, (sum, m) => sum + m.amountMinor);

  CustomerEntity summaryAt(DateTime today) {
    final withdrawals = monthlyTotal(CustomerMovementKind.withdrawal, today);
    final payments = monthlyTotal(CustomerMovementKind.payment, today);
    final cycleStart = customer.cycleStartAt(today);
    final cycleEnd = customer.frequency == RepaymentFrequency.weekly
        ? cycleStart.add(const Duration(days: 7))
        : DateTime.utc(today.year, today.month + 1, 1);
    DateTime dayOf(CustomerMovementEntity m) =>
        DateTime.utc(m.date.year, m.date.month, m.date.day);
    int balanceBefore(DateTime start) =>
        customer.openingBalanceMinor +
        movements
            .where((m) => !m.deleted && dayOf(m).isBefore(start))
            .fold(0, (sum, m) => sum + m.balanceDelta);
    final cyclePayments = movements
        .where(
          (m) =>
              !m.deleted &&
              m.kind == CustomerMovementKind.payment &&
              !dayOf(m).isBefore(cycleStart) &&
              dayOf(m).isBefore(cycleEnd),
        )
        .fold(0, (sum, m) => sum + m.amountMinor);
    final carried = math.max(0, balanceBefore(cycleStart) - cyclePayments);
    final firstDue = DateTime.utc(
      customer.dueDate.year,
      customer.dueDate.month,
      customer.dueDate.day,
    );
    final oldMonthlyDebt = math.max(
      0,
      balanceBefore(DateTime.utc(today.year, today.month, 1)),
    );
    return CustomerEntity(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      description: customer.description,
      openingBalanceMinor: customer.openingBalanceMinor,
      dueDate: customer.dueDate,
      frequency: customer.frequency,
      repaymentDay: customer.repaymentDay,
      currentBalanceMinor: balanceMinor,
      monthlyWithdrawalsMinor: withdrawals,
      monthlyPaymentsMinor: payments,
      carriedDebtMinor: carried,
      overdueCarriedDebtMinor:
          customer.frequency != RepaymentFrequency.once &&
              firstDue.isBefore(cycleStart)
          ? carried
          : 0,
      monthlyAppliedPaymentsMinor: math.max(0, payments - oldMonthlyDebt),
      minimumPaymentPercent: customer.minimumPaymentPercent,
      warningDays: customer.warningDays,
    );
  }

  @override
  List<Object?> get props => [customer, movements];
}
