import 'package:equatable/equatable.dart';

import 'dart:math' as math;

enum CustomerStatus { regular, upcoming, overdue }

enum CustomerFilter { all, overdue, regular }

enum RepaymentFrequency { monthly, weekly, once }

class CustomerEntity extends Equatable {
  const CustomerEntity({
    required this.id,
    required this.name,
    this.phone,
    this.description,
    required this.openingBalanceMinor,
    required this.dueDate,
    required this.frequency,
    this.repaymentDay,
    this.currentBalanceMinor,
    this.monthlyWithdrawalsMinor = 0,
    this.monthlyPaymentsMinor = 0,
    this.carriedDebtMinor,
    this.minimumPaymentPercent = 50,
    this.warningDays = 3,
    this.overdueCarriedDebtMinor = 0,
    this.monthlyAppliedPaymentsMinor,
  });
  final String id;
  final String name;
  final String? phone;
  final String? description;
  final int openingBalanceMinor;
  final DateTime dueDate;
  final RepaymentFrequency frequency;
  final int? repaymentDay;
  final int? currentBalanceMinor;
  final int monthlyWithdrawalsMinor;
  final int monthlyPaymentsMinor;
  final int? carriedDebtMinor;
  final int minimumPaymentPercent;
  final int warningDays;
  final int overdueCarriedDebtMinor;
  final int? monthlyAppliedPaymentsMinor;
  int get balanceMinor => currentBalanceMinor ?? openingBalanceMinor;

  DateTime cycleStartAt(DateTime today) {
    final day = DateTime.utc(today.year, today.month, today.day);
    return frequency == RepaymentFrequency.weekly
        ? day.subtract(Duration(days: day.weekday - 1))
        : DateTime.utc(today.year, today.month, 1);
  }

  DateTime dueDateAt(DateTime today) {
    final first = DateTime.utc(dueDate.year, dueDate.month, dueDate.day);
    final day = DateTime.utc(today.year, today.month, today.day);
    if (frequency == RepaymentFrequency.once || day.isBefore(first)) {
      return first;
    }
    final candidate = frequency == RepaymentFrequency.monthly
        ? DateTime.utc(
            today.year,
            today.month,
            math.min(
              repaymentDay ?? first.day,
              DateTime.utc(today.year, today.month + 1, 0).day,
            ),
          )
        : cycleStartAt(today)
              .add(Duration(days: (repaymentDay ?? first.weekday) - 1));
    return candidate.isBefore(first) ? first : candidate;
  }

  CustomerStatus statusAt(DateTime today) {
    if (balanceMinor <= 0) return CustomerStatus.regular;
    if (overdueCarriedDebtMinor > 0) return CustomerStatus.overdue;
    return CustomerFollowUpPolicy.evaluate(
      today: today,
      dueDate: dueDateAt(today),
      outstandingMinor: balanceMinor,
      carriedDebtMinor: carriedDebtMinor ?? openingBalanceMinor,
      monthlyWithdrawalsMinor: monthlyWithdrawalsMinor,
      monthlyPaymentsMinor: monthlyAppliedPaymentsMinor ?? monthlyPaymentsMinor,
      minimumPaymentPercent: minimumPaymentPercent,
      warningDays: warningDays,
    );
  }

  CustomerEntity withFollowUp({
    required int minimumPaymentPercent,
    required int warningDays,
  }) => CustomerEntity(
    id: id,
    name: name,
    phone: phone,
    description: description,
    openingBalanceMinor: openingBalanceMinor,
    dueDate: dueDate,
    frequency: frequency,
    repaymentDay: repaymentDay,
    currentBalanceMinor: currentBalanceMinor,
    monthlyWithdrawalsMinor: monthlyWithdrawalsMinor,
    monthlyPaymentsMinor: monthlyPaymentsMinor,
    carriedDebtMinor: carriedDebtMinor,
    minimumPaymentPercent: minimumPaymentPercent,
    warningDays: warningDays,
    overdueCarriedDebtMinor: overdueCarriedDebtMinor,
    monthlyAppliedPaymentsMinor: monthlyAppliedPaymentsMinor,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    description,
    openingBalanceMinor,
    dueDate,
    frequency,
    repaymentDay,
    currentBalanceMinor,
    monthlyWithdrawalsMinor,
    monthlyPaymentsMinor,
    carriedDebtMinor,
    minimumPaymentPercent,
    warningDays,
    overdueCarriedDebtMinor,
    monthlyAppliedPaymentsMinor,
  ];
}

abstract final class CustomerFollowUpPolicy {
  static CustomerStatus evaluate({
    required DateTime today,
    required DateTime dueDate,
    required int outstandingMinor,
    required int carriedDebtMinor,
    required int monthlyWithdrawalsMinor,
    required int monthlyPaymentsMinor,
    int minimumPaymentPercent = 50,
    int warningDays = 3,
  }) {
    if (outstandingMinor <= 0) return CustomerStatus.regular;
    final nowDay = DateTime.utc(today.year, today.month, today.day);
    final dueDay = DateTime.utc(dueDate.year, dueDate.month, dueDate.day);
    final days = dueDay.difference(nowDay).inDays;
    final lowPayment = monthlyWithdrawalsMinor > 0
        ? monthlyPaymentsMinor * 100 <
              monthlyWithdrawalsMinor * minimumPaymentPercent
        : carriedDebtMinor > 0;
    if (days < 0 && (lowPayment || carriedDebtMinor > 0)) {
      return CustomerStatus.overdue;
    }
    if (days >= 0 && days <= warningDays && lowPayment) {
      return CustomerStatus.upcoming;
    }
    return CustomerStatus.regular;
  }
}
